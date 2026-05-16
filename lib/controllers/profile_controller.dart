import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/profile/models/refercode_list.dart';
import '../../services/cache/cache_manager.dart';

import '../core/constants/api_routes.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/profile/models/change_password_model.dart';
import '../features/profile/models/co_host_management.dart';
import '../features/profile/models/cohost_get_model.dart';
import '../features/profile/models/cohost_own_data.dart';
import '../features/profile/models/live_verification_model.dart';
import '../features/profile/models/my_given_review.dart';
import '../features/profile/models/payment_get_model.dart';
import '../features/profile/models/payment_post_data_model.dart';
import '../features/profile/models/profile_model.dart';
import '../features/profile/models/refarar_code_model.dart';
import '../features/profile/models/superhost_model.dart';
import '../features/profile/models/user_get_review_modle.dart';
import '../features/profile/models/user_language_responce_model.dart';
import '../features/profile/repositories/profile_repository_interface.dart';

import '../services/network/api_client.dart';
import 'main_controller.dart';

class ProfileController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  // Dependencies
  final ProfileRepositoryInterface repository;
  final MainController mainController = Get.find<MainController>();
  final ApiClient _apiClient = Get.find<ApiClient>();
  final RxBool enableCoHost = false.obs;
  // State
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final Rx<ReferralData?> referData = Rx<ReferralData?>(null);
  final RxList<ReferralDataList> referralLinksList = <ReferralDataList>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isDeletingGrantedListing = false.obs;
  final RxBool isLoadingew = false.obs;
  final RxBool isLoadingAvailability = false.obs;
  final RxString error = ''.obs;
  final RxString errorAvailability = ''.obs;
  final RxBool isLoadingList = false.obs;
  final RxString errorList = ''.obs;
  final RxString errorMessagew = ''.obs;
  final RxString errorListf = ''.obs;
  final RxBool isGetPostData = false.obs;
  final RxBool isDeletingAccount = RxBool(false);
  final RxString deleteAccountError = RxString('');

  RxBool isLoadingListdata = false.obs;
  RxString errorListdata = ''.obs;
  Rx<GetSuperhostResponse?> superhostData = Rx<GetSuperhostResponse?>(null);
  // Text editing controllers
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController usernameController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController imageController;
  late final TextEditingController bioController;
  late final TextEditingController addressController;

  // File pickers
  final Rx<File?> pickedProfileImageFile = Rx<File?>(null);
  final Rx<File?> pickedCoverImageFile = Rx<File?>(null);

  // Constructor
  ProfileController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _initFormFields();
  }

  @override
  void onReady() {
    super.onReady();
    // Fetch profile automatically when controller is ready and user is logged in
    if(mainController.isLogin.value){
      fetchProfile();
    }
  }

  void _initFormFields() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    imageController = TextEditingController();
    bioController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    imageController.dispose();
    bioController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final profileData = await repository.getProfile();

      // Check if controller is still active before updating UI
      if (isClosed) return;

      profile.value = profileData;
      _updateFormFields(profileData);
      await _cacheProfileData(profileData);

      // Check again after async operations
      if (isClosed) return;

      enableCoHost.value = profileData.isAvailableForCohosting ?? false;

      if (profileData.id != null && profileData.uType != null) {
        mainController.updateUserData(
          profileData.id!.toString(),
          mainController.accessToken.value,
          profileData.uType!,
          name:
              '${profileData.firstName ?? ''} ${profileData.lastName ?? ''}'
                  .trim(),
          email: profileData.email,
          profileImage: profileData.image,
          mongoUserId: profileData.mongoUserId,
        );
      }
    } catch (e, stackTrace) {
      final errorMsg = 'Failed to load profile: ${e.toString()}';
      if (!isClosed) {
        error.value = errorMsg;
      }

      if (!isClosed) {
        Get.snackbar(
          'Error',
          'Failed to load profile. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }

      rethrow;
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateProfile() async {
    if (profile.value == null) return;

    try {
      isLoading.value = true;
      error.value = '';

      final updatedProfile = profile.value!.copyWith(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: usernameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        address: addressController.text.trim(),
      );

      final updatedProfileData = await repository.updateProfile(updatedProfile);
      profile.value = updatedProfileData;

      if (updatedProfileData.id != null && updatedProfileData.uType != null) {
        mainController.updateUserData(
          updatedProfileData.id!.toString(),
          mainController.accessToken.value,
          updatedProfileData.uType!,
          name:
              '${updatedProfileData.firstName ?? ''} ${updatedProfileData.lastName ?? ''}'
                  .trim(),
          email: updatedProfileData.email,
          profileImage: updatedProfileData.image,
        );
      }

      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update profile: ${e.toString()}';
      error.value = errorMsg;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage(String imagePath) async {
    try {
      isLoading.value = true;
      final imageUrl = await repository.uploadProfileImage(imagePath);

      if (profile.value != null) {
        final updatedProfile = profile.value!.copyWith(image: imageUrl);
        final updatedProfileData = await repository.updateProfile(
          updatedProfile,
        );
        profile.value = updatedProfileData;

        if (updatedProfileData.id != null && updatedProfileData.uType != null) {
          mainController.updateUserData(
            updatedProfileData.id!.toString(),
            mainController.accessToken.value,
            updatedProfileData.uType!,
            name:
                '${updatedProfileData.firstName ?? ''} ${updatedProfileData.lastName ?? ''}'
                    .trim(),
            email: updatedProfileData.email,
            profileImage: updatedProfileData.image,
            mongoUserId: updatedProfileData.mongoUserId,
          );
        }

        Get.snackbar('Success', 'Profile image uploaded successfully!');
      }
    } catch (e) {
      final errorMsg = 'Failed to upload profile image: ${e.toString()}';
      error.value = errorMsg;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFormFields(ProfileModel profileData) {
    // Add safety checks before updating controllers
    if (isClosed) return;

    firstNameController.text = profileData.firstName ?? '';
    lastNameController.text = profileData.lastName ?? '';
    usernameController.text = profileData.username ?? '';
    phoneNumberController.text = profileData.phoneNumber ?? '';
    emailController.text = profileData.email ?? '';
    imageController.text = profileData.image ?? '';
    bioController.text = profileData.bio ?? '';
    addressController.text = profileData.address ?? '';
  }

  Future<void> _cacheProfileData(ProfileModel profileData) async {
    try {
      await CacheManager.setUserId(profileData.id?.toString() ?? '');
      await CacheManager.setRoleName(profileData.uType ?? '');
    } catch (e) {
    }
  }

  String removeZero(String input) {
    return input.startsWith('0') ? input.substring(1) : input;
  }

  bool isValidBangladeshMobileNumber(String input) {
    return RegExp(r'^(?:\+8801|01)[3-9]\d{8}$').hasMatch(input);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r"^[\w.-]+@[\w.-]+\.\w{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool isValidSocialLink(String input) {
    try {
      final uri = Uri.parse(input);
      return uri.hasScheme && (uri.scheme == "http" || uri.scheme == "https");
    } catch (e) {
      return false;
    }
  }

  bool isValidLocation(String input) {
    return RegExp(r"^[a-zA-Z\s,]+$").hasMatch(input);
  }

  /// ✅ NEW: Fetch referral link
  Future<void> getReferralLink() async {
    try {

      final response = await repository.getReferralLink();

      // final responseData = response.data;
      if (response == null) {
        throw Exception('No response data received from server');
      }

      // Parse the JSON to ReferralData
      // final referralData = ReferralData.fromJson(responseData);

      // Save it to referData (assuming referData is Rx<ReferralData?> or similar)
      referData.value = response;

    } catch (e) {
      final errorMsg = 'Failed to fetch referral link: ${e.toString()}';
      rethrow;
    }
  }

  Future<void> getReferralLinksList() async {
    try {
      isLoadingList.value = true;
      errorListf.value = '';

      // Assuming you add this method in your repository to fetch the list
      final responseList = await repository.getReferralLinksList(
        page: 1,
        pageSize: 10,
      );

      // print("hit data");
      // if (responseList.data.isEmpty) {
      //   throw Exception('No referral links received from server');
      // }

      referralLinksList.value = responseList.data;
      isLoadingList.value = false;
    } catch (e) {
      final errorMsg = 'Failed to fetch referral links list: ${e.toString()}';
      errorList.value = errorMsg;
      rethrow;
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> patchUserSchool(String school) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch school.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';


      // Call the repository method that patches the school info
      final updatedProfileData = await repository.patchUserSchool(school);

      //Get.snackbar('Success', 'School updated successfully!');
      // Get.back();
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> patchImageUpload(String imageUrl) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch school.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';


      // Call the repository method that patches the school info
      final updatedProfileData = await repository.patchImageUpload(imageUrl);

      Get.snackbar('Success', 'School updated successfully!');
      // Get.back();
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> patchUserWork(String work) async {
    try {
      isLoading.value = true;
      error.value = '';


      // Call the repository method that patches the school info
      final updatedProfileData = await repository.patchUserWork(work);

      // // Update the local profile state with the updated data
      // profile.value = updatedProfileData;

      // Update form field to reflect the change if you have a controller for school (if not, add one)
      // Assuming you want to add schoolController:
      // schoolController.text = school;

      // Get.snackbar('Success', 'Work updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      // _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> patchUserAddressLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch address location.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';

      final updatedProfileData = await repository.patchUserAddressLocation(
        address: address,
        latitude: latitude,
        longitude: longitude,
      );

      // Update the local profile state
      // profile.update((val) {
      //   if (val != null) {
      //     val.address = updatedProfileData.address;
      //     val.latitude = updatedProfileData.latitude;
      //     val.longitude = updatedProfileData.longitude;
      //   }
      // });

      // Get.snackbar('Success', 'Address location updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update address location: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update address. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestEmailUpdate({
    required String email,
    required String scope,
  }) async {
    if (profile.value == null) {
      return;
    }
    try {
      isLoading.value = true;
      error.value = '';
      final updatedProfileData = await repository.requestEmailUpdate(
        email: email,
        scope: scope,
      );

      //Get.snackbar('Success', 'Address location updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update address location: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update address. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestEmailUpdateOtpSubmit({
    required String email,
    required String otp,
    required bool otpVerify,
  }) async {
    if (profile.value == null) {
      return;
    }
    try {
      isLoading.value = true;
      error.value = '';
      final updatedProfileData = await repository.requestDataEmailUpdate(
        email: email,
        otp: otp,
        otpVerify: otpVerify,
      );

      if (updatedProfileData.statusCode == 400) {
        Get.back();
        Fluttertoast.showToast(msg: updatedProfileData.message);
      }

      if (updatedProfileData.statusCode == 200) {
        Get.back(); // Close OTP dialog

        Fluttertoast.showToast(msg: updatedProfileData.message);
      }
      //Get.snackbar('Success', 'Address location updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update address location: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update address. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> patchUserBio(String bio) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch school.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';


      // Call the repository method that patches the school info
      final updatedProfileData = await repository.patchUserBio(bio);

      // // Update the local profile state with the updated data
      // profile.value = updatedProfileData;

      // Update form field to reflect the change if you have a controller for school (if not, add one)
      // Assuming you want to add schoolController:
      // schoolController.text = school;

      //  Get.snackbar('Success', 'School updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  RxList<PaymentMethod> hostPaymentMethods = <PaymentMethod>[].obs;

  Future<void> fetchHostPaymentMethods() async {
    isLoadingew.value = true;
    errorMessagew.value = '';

    try {
      final result = await repository.getHostPaymentMethods();

      // Optional: Check if data is empty
      if (result.data.isEmpty) {
      }

      // Store result somewhere in your controller
      hostPaymentMethods.value =
          result.data; // You need to declare this variable

    } catch (e, stackTrace) {
      errorMessagew.value =
          '❌ Failed to load host payment methods: ${e.toString()}';
    } finally {
      isLoadingew.value = false;
    }
  }

  Future<void> getSuperhostProgress(int userId) async {
    isLoadingListdata.value = true;
    errorListdata.value = '';
    try {
      final response = await repository.getSuperhostProgress(userId);

      if (response == null) {
        throw Exception('No superhost data received from server');
      }

      superhostData.value = response;
      isLoadingListdata.value = false;
    } catch (e) {
      final errorMsg = '❌ Failed to fetch superhost progress: ${e.toString()}';
      errorListdata.value = errorMsg;
    } finally {
      isLoadingListdata.value = false;
    }
  }

  final isLoadingHostsData = false.obs;
  final errorHostsData = ''.obs;
  final coHostData = <CoHostData>[].obs;

  Future<void> getHostsInRadius({
    required double latitude,
    required double longitude,
  }) async {
    isLoadingHostsData.value = true;
    errorHostsData.value = '';
    try {
      final response = await repository.getHostsInRadius(
        latitude: latitude,
        longitude: longitude,
      );

      if (response.data.isEmpty) {
      }

      coHostData.value = response.data;
    } catch (e) {
      final errorMsg = '❌ Failed to fetch co-hosts in radius: ${e.toString()}';
      errorHostsData.value = errorMsg;
    } finally {
      isLoadingHostsData.value = false;
    }
  }

  final isLoadinge = false.obs;
  final isLoadinged = false.obs;
  final errorMessage = ''.obs;
  final errorMessaged = ''.obs;
  final Rxn<CoHostOwnData> coHostOwnData = Rxn<CoHostOwnData>();
  final Rxn<CoHostOwnData> coHostOwnDatad = Rxn<CoHostOwnData>();

  Future<void> fetchCoHostAssignment(int coHostId) async {
    isLoadinge.value = true;
    errorMessage.value = '';
    // Clear previous data

    try {
      final result = await repository.getCoHostAssignmentStatus(
        coHostId: coHostId,
      );

      // if (result.data.grantedListings.isEmpty &&
      //     result.data.notGrantedListings.isEmpty) {
      //   debugPrint('ℹ️ No granted or not-granted listings found.');
      // }

      coHostOwnData.value = result.data;
    } catch (e, stackTrace) {
      errorMessage.value =
          '❌ Failed to load co-host assignment: ${e.toString()}';
    } finally {
      isLoadinge.value = false;
    }
  }

  Future<void> fetchCoHostAssignmentAdd(int coHostId) async {
    isLoadinged.value = true;
    errorMessaged.value = '';
    coHostOwnDatad.value = null; // Clear previous data

    try {
      final result = await repository.getCoHostAssignmentStatus(
        coHostId: coHostId,
      );

      // if (result.data.grantedListings.isEmpty &&
      //     result.data.notGrantedListings.isEmpty) {
      //   debugPrint('ℹ️ No granted or not-granted listings found.');
      // }

      coHostOwnDatad.value = result.data;
    } catch (e, stackTrace) {
      errorMessage.value =
          '❌ Failed to load co-host assignment: ${e.toString()}';
    } finally {
      isLoadinge.value = false;
    }
  }

  final RxBool isChangingPassword = false.obs;
  final RxString changePasswordError = ''.obs;
  final RxString changePasswordSuccess = ''.obs;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isChangingPassword.value = true;
    changePasswordError.value = '';
    changePasswordSuccess.value = '';

    try {
      final response = await repository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      changePasswordSuccess.value =
          response.message ?? 'Password changed successfully.';

      // Optionally show a snackbar or dialog
      Get.snackbar(
        'Success',
        response.message ?? 'Password changed successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on ChangePasswordErrorResponse catch (errorResponse) {
      final errors =
          errorResponse.errors?.nonFieldErrors?.join(', ') ??
          'Something went wrong.';
      changePasswordError.value = errors;

      Get.snackbar(
        'Error',
        errors,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      changePasswordError.value = 'Unexpected error: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(milliseconds: 800),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  final Rxn<CoHostRespoceData> coHosRestData = Rxn<CoHostRespoceData>();
  final RxBool isLoadingg = false.obs;
  final RxString errorr = ''.obs;

  Future<void> patchCoHostCommission({
    required int coHostId,
    required String commissionPercentage,
  }) async {
    try {
      isLoadingg.value = true;
      errorr.value = '';

      // Create request object
      final request = UpdateCoHostCommissionRequest(
        commissionPercentage: commissionPercentage,
      );

      // Call repository method
      final response = await repository.patchCoHostCommission(
        coHostId: coHostId,
        request: request,
      );

      // Update your state with the response data
      coHosRestData.value = response.data;

      Get.snackbar(
        'Success',
        'Commission updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      final errorMsg = 'Failed to update commission: ${e.toString()}';
      errorr.value = errorMsg;

      Get.snackbar(
        'Error',
        'Failed to update commission. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      rethrow;
    } finally {
      isLoadingg.value = false;
    }
  }

  Future<void> patchCohostAvailability(bool isAvailable) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await repository.patchCohostAvailability(isAvailable);

      // Update toggle state
      enableCoHost.value = response.data.isAvailableForCohosting;

      Get.snackbar(
        'Success',
        response.message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update co-host availability',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDocument({
    required String documentType,
    required String live,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Create the request model
      final requestModel = DocumentRequestModel(
        documentType: documentType,
        live: live,
      );

      // Call repository method
      final response = await repository.submitDocument(
        documentRequest: requestModel,
      );

      if (response.success && response.statusCode == 200) {
        Get.back();
        Get.snackbar(
          'Success',
          response.message.isNotEmpty
              ? response.message
              : 'Document submitted successfully!',
        );
      } else {
        final errMsg =
            response.message.isNotEmpty
                ? response.message
                : 'Failed to submit document';
        _errorDisplay.showError(errMsg);
        error.value = errMsg;
      }
    } catch (e) {
      final errorMsg = 'Failed to submit document: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to submit document. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  var userLanguages = Rxn<UserLanguagesData>();

  Future<void> updateUserLanguages(List<String> languages) async {
    isLoading.value = true;
    try {
      // Your patch method returns UserLanguagesData or similar
      await repository.patchUserLanguage(languages);
      Get.snackbar(
        'Success',
        'Languages updated successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update languages: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> assignCoHost({
    required int coHostUserId,
    required String accessLevel,
    required List<int> listingIds,
    required String commissionPercentage,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Call repository method
      final response = await repository.assignCoHost(
        coHostUserId: coHostUserId,
        accessLevel: accessLevel,
        listingIds: listingIds,
        commissionPercentage: commissionPercentage,
      );

      if (response.success == true &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Get.back();
        Get.snackbar(
          'Success',
          (response.message ?? '').isNotEmpty
              ? response.message ?? ''
              : 'Co-host assigned successfully!',
        );
      } else {
        final errMsg =
            (response.message ?? '').isNotEmpty
                ? response.message
                : 'Failed to assign co-host';
        _errorDisplay.showError(errMsg ?? '');
        error.value = errMsg ?? '';
      }
    } catch (e) {
      final errorMsg = 'Failed to assign co-host: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to assign co-host. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onClickDeleteGrantedListing({
    required String id,
    required String userId,
  }) async {
    try {
      isDeletingGrantedListing.value = true;

      // Call repository method
      final response = await repository.deleteGrantedListing(id: id);

      Get.back();
      if (response) {
        Get.snackbar(
          'Success',
          'Listing has been deleted from granted my_listing!',
        );
        fetchCoHostAssignment(int.parse(userId));
      } else {
        _errorDisplay.showError('Listing is not deleted from granted my_listing!');
      }
    } catch (e) {
      _errorDisplay.showError('Failed to delete. Please try again.');
      rethrow;
    } finally {
      isDeletingGrantedListing.value = false;
    }
  }

  Future<void> createPaymentMethod(
    PaymentMethodRequest paymentMethodRequest,
  ) async {
    isLoading.value = true;
    error.value = '';
    final response = await repository.createPaymentMethod(
      paymentMethodRequest: paymentMethodRequest,
    );
    // Optionally update some local state or UI after success
    // For example, you can save the new payment method data or just show a success message
    // Get.snackbar('Success', 'Payment method created successfully!');

    isLoading.value = false;
  }

  Future<void> updatePaymentMethod(PaymentMethodRequest paymentMethodRequest, String id) async {
    isLoading.value = true;
    error.value = '';
    final response = await repository.updatePaymentMethod(
      paymentMethodRequest: paymentMethodRequest,
      id: id
    );
    // Optionally update some local state or UI after success
    // For example, you can save the new payment method data or just show a success message
    // Get.snackbar('Success', 'Payment method updated successfully!');

    isLoading.value = false;
  }

  Future<void> patchUserGender(String gender) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch school.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';

      final updatedProfileData = await repository.patchUserGender(gender);

      // // Update the local profile state with the updated data
      // profile.value = updatedProfileData;

      // Update form field to reflect the change if you have a controller for school (if not, add one)
      // Assuming you want to add schoolController:
      // schoolController.text = school;

      //  Get.snackbar('Success', 'School updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> patchUserEmgContract(String emgContact) async {
    // if (profile.value == null) {
    //   debugPrint('No profile loaded to patch school.');
    //   return;
    // }

    try {
      isLoading.value = true;
      error.value = '';

      final updatedProfileData = await repository.patchUserEmgContract(
        emgContact,
      );

      // // Update the local profile state with the updated data
      // profile.value = updatedProfileData;

      // Update form field to reflect the change if you have a controller for school (if not, add one)
      // Assuming you want to add schoolController:
      // schoolController.text = school;

      //  Get.snackbar('Success', 'School updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update school: ${e.toString()}';
      error.value = errorMsg;
      _errorDisplay.showError('Failed to update school. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void deleteAccount({String password = ''}) async {
    try {
      isDeletingAccount.value = true;

      if(password.isEmpty) {
        deleteAccountError.value = 'Password field is empty';
        isDeletingAccount.value = false;
        return;
      }

      String? response = await repository.deleteAccount( password: password );

      if (response != null) {
        if(response.contains('Incorrect password')) {
          deleteAccountError.value = response;
          isDeletingAccount.value = false;
          return;
        }
        Get.back();
        final AuthController authController = Get.find<AuthController>();
        await authController.logOut();
      } else {
        deleteAccountError.value = "Failed to delete account";
      }
    } catch (e) {
      deleteAccountError.value = 'Failed to delete account: ${e.toString()}';
      rethrow;
    } finally {
      isDeletingAccount.value = false;
    }
  }

  final RxList<UserReviewData> userReviews = <UserReviewData>[].obs;

  final RxBool isLoadingReview = false.obs;

  Future<void> getUserReviews() async {
    try {
      isLoadingReview.value = true;
      final response = await repository.getUserReviews();

      if (response == null) {
        userReviews.clear();
        return;
      }

      userReviews.assignAll(response);
    } catch (e) {
      userReviews.clear();
    } finally {
      isLoadingReview.value = false;
    }
  }

  // ✅ New: given reviews (reviews written by this user)
  RxList<GivenReviewData> givenReviews = <GivenReviewData>[].obs;
  RxBool isLoadingGivenReview = false.obs;

  Future<void> getMyGivenReviews() async {
    try {
      isLoadingGivenReview.value = true;
      final response = await repository.getMyGivenReviews();

      if (response == null) {
        givenReviews.clear();
        return;
      }

      givenReviews.assignAll(response);
    } catch (e) {
      givenReviews.clear();
    } finally {
      isLoadingGivenReview.value = false;
    }
  }
}

// Hello I am Tamim