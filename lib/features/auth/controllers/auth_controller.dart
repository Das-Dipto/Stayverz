import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/auth/repositories/auth_repository_interface.dart';
import 'package:stayverz_flutter_app/features/profile/repositories/profile_repository_interface.dart';
import 'package:stayverz_flutter_app/controllers/main_controller.dart';
import 'package:stayverz_flutter_app/core/constants/app_routes.dart';
import 'package:stayverz_flutter_app/features/auth/models/user_model.dart';
import 'package:stayverz_flutter_app/main.dart';
import 'package:stayverz_flutter_app/services/cache/cache_manager.dart';

import '../../../services/notification_service.dart';
import '../../../views/home_root/host_bottom_navigation_bar_view.dart';
import '../models/get_referral_code_response.dart';

/// AuthController handles authentication logic using MVVM + GetX architecture.
/// It manages login state, error handling, and navigation based on user type.
class AuthController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  final AuthRepositoryInterface _repository;

  // Using dependency injection through constructor following MVVM pattern
  AuthController(this._repository);

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Add controllers for signup if they are specific to signup and not reused from login
  final TextEditingController fullNameController = TextEditingController(); // For signup
  final TextEditingController signupPhoneController = TextEditingController(); // For signup
  final TextEditingController signupPasswordController = TextEditingController(); // For signup
  final TextEditingController otpController = TextEditingController(); // For OTP
  final TextEditingController referCodeController = TextEditingController();
  final RxBool willShowReferField = RxBool(false);

  final _selectedRole = 'guest'.obs;
  String get selectedRole => _selectedRole.value;
  RxString referCode = RxString('');
  void setRole(String role) => _selectedRole.value = role;
  final MainController _mainController = Get.find<MainController>();
  final isLoading = false.obs;
  final passwordVisible = false.obs;
  final confirmPasswordVisible = false.obs; // Added for confirm password
  final Rxn<UserModel> user = Rxn<UserModel>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToErrorMessages();
  }

  @override
  void onClose() {
    phoneController.clear();
    passwordController.clear();
    fullNameController.clear();
    signupPhoneController.clear();
    signupPasswordController.clear();
    otpController.clear();
    super.onClose();
  }

  void fetchCode() async {
    if ((_mainController.deepLinkReferer ?? '').isEmpty) {
      return;
    }

    GetReferralCodeResponse? response = await _repository.getReferralCode(
      _mainController.deepLinkReferer!,
    );

    print("GetReferralCodeResponse ${response?.toJson()}");

    if (response != null) {
      print("refer_code by api: ${response.data?.code?.meta?.referCode}");
      print("referrer_type by api: ${response.data?.code?.meta?.referrerType}");
      referCode.value = response.data?.code?.meta?.referCode ?? '';
      referCodeController.text = referCode.value;
      _selectedRole.value = response.data?.code?.meta?.referrerType ?? '';
    }else{
      referCode.value = '';
      _selectedRole.value = '';
      referCodeController.text = '';
    }
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    // Added for confirm password
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  void _listenToErrorMessages() {
    ever(errorMessage, (String? message) {
      if (message != null && message.isNotEmpty) {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    });
  }

  void _handleSuccessfulLogin(UserModel user) {
    // Update MainController with user data
    _mainController.setUser(user);
    _mainController.setLoggedIn(true);

    // Navigate based on user role
    if (user.userType == 'host') {
      Get.offAllNamed('/host/dashboard');
    } else {
      Get.offAllNamed('/guest/dashboard');
    }
  }

  Future<void> login(String phone, String password, String role) async {
    if (phone.isEmpty || password.isEmpty) {
      isLoading.value = false;
      errorMessage.value = 'Please fill in all fields';
      return;
    }

    if (role.isEmpty) {
      isLoading.value = false;
      errorMessage.value = 'Please select a role (Host/Guest)';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    print('🔑 Attempting login with phone: $phone as $role');

    try {
      // 1. Attempt to authenticate with credentials
      print('🔄 Calling login API...');
      final result = await _repository.login(phone, password, role);

      if (result.isSuccess && result.data != null) {
        print('✅ Login successful');
        _handleSuccessfulLogin(result.data!);
        print(
          '🔑 Token received: ${result.data?.accessToken.substring(0, 20)}...',
        );

        user.value = result.data;

        // 2. Save the received tokens
        final token = result.data!.accessToken;
        final refreshToken = result.data!.refreshToken;

        await CacheManager.setToken(token);
        await CacheManager.setRefreshToken(refreshToken);
        await CacheManager.setUserName(phone);
        await CacheManager.setPassword(password);
        mainControl.username.value = phone;
        mainControl.password.value = password;

        // Verify tokens were saved correctly
        final savedToken = await CacheManager.getToken;
        final savedRefreshToken = await CacheManager.getRefreshToken();
        if (savedRefreshToken != null && savedRefreshToken.isNotEmpty) {}

        // 3. Fetch user profile with retry logic
        dev.log('🔄 [AuthController] Fetching user profile...');
        try {
          // Get the profile repository using GetX dependency injection
          final profileRepository = Get.find<ProfileRepositoryInterface>();
          final profile = await profileRepository.getProfile();

          dev.log('👤 [AuthController] Profile fetched successfully');
          dev.log('👥 [AuthController] User Type: ${profile.uType}');

          // Save user type to cache
          if (profile.uType != null) {
            await CacheManager.setRoleName(profile.uType!);
          }

          // 4. Save user data to cache
          await CacheManager.setUserId(profile.id.toString());
          await CacheManager.setRoleName(profile.uType ?? 'guest');
          await CacheManager.setProfileImageUrl(profile.image ?? '');
          await CacheManager.setMongoUserId(profile.mongoUserId ?? '');

          // 5. Update MainController with user data
          final mainController = Get.find<MainController>();
          mainController.updateUserData(
            profile.id.toString(),
            token ?? '',
            profile.uType?.toLowerCase() ?? 'guest',
            name: '${profile.firstName} ${profile.lastName}'.trim(),
            email: profile.email,
            profileImage: profile.image,
            refreshTokens: refreshToken ?? '',
            mongoUserId: profile.mongoUserId,
          );


          // Safely log a portion of the token for debugging
          if (token.isNotEmpty) {
            final previewLength = token.length > 10 ? 10 : token.length;
            dev.log(
              '   - Token: ${token.substring(0, previewLength)}...',
              level: 800,
            );
          }

          // 6. Navigate based on user type
          if (profile.uType == 'host') {
            Get.offAll(HostBottomNavigationBarView());
          } else {
            onLogin();
            Get.offAllNamed(AppRoute.guest);
          }
        } catch (e, stackTrace) {
          dev.log(
            '❌ [AuthController] Error fetching profile:',
            error: e,
            stackTrace: stackTrace,
          );
          errorMessage.value = 'Failed to load user profile: ${e.toString()}';
        }
      } else {

        Fluttertoast.showToast(msg: result.message ?? "Phone or Password not match");
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error during login:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
      dev.log('🏁 Login process completed');
    }
  }

  /// Refreshes the access token using the refresh token from cache.
  /// Returns true if refresh was successful, false otherwise.
  Future<bool> refreshToken() async {
    try {
      dev.log('🔄 [AuthController] Attempting to refresh token');

      // Get the refresh token from cache
      final refreshToken = await CacheManager.getRefreshToken();

      dev.log(
        '🔍 [AuthController] Refresh token from cache: ${refreshToken?.isNotEmpty == true ? "exists" : "missing"}',
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        dev.log(
          '❌ [AuthController] No refresh token found in cache',
          error: 'Missing refresh token',
        );
        // Try to read user ID from cache to verify session state
        final userId = CacheManager.userId;
        dev.log('👤 [AuthController] User ID in cache: $userId');
        return false;
      }

      // Log partial refresh token for debugging (safe to log first few characters)
      if (refreshToken.length > 15) {
        dev.log(
          '🔑 [AuthController] Found refresh token: ${refreshToken.substring(0, 8)}...',
        );
      } else {
        dev.log('🔑 [AuthController] Found refresh token (short token)');
      }

      // Make API request to refresh token
      dev.log('📤 [AuthController] Calling refresh token API');
      final response = await _repository.refreshToken(refreshToken);
      dev.log('📥 [AuthController] Refresh token API raw response: $response');

      // Extract tokens from response
      final accessToken = response['access_token'];
      final newRefreshToken =
          response['refresh_token'] ??
          refreshToken; // Use existing if new one not provided

      // Validate the response
      if (accessToken == null) {
        dev.log(
          '❌ [AuthController] Missing access_token in response',
          error: 'Invalid API response',
        );
        return false;
      }

      // Successfully received a new access token
      dev.log('✅ [AuthController] Successfully refreshed token');

      // Log partial tokens for debugging (safe to log first few characters)
      if (accessToken.length > 15) {
        dev.log(
          '✅ [AuthController] New access token: ${accessToken.substring(0, 8)}...',
        );
      }

      if (newRefreshToken.length > 15) {
        dev.log(
          '✅ [AuthController] New refresh token: ${newRefreshToken.substring(0, 8)}...',
        );
      }

      // Update tokens in cache
      await CacheManager.setToken(accessToken);
      await CacheManager.setRefreshToken(newRefreshToken);
      dev.log('💾 [AuthController] Updated tokens in cache');

      // Update token in MainController - this is critical for the app state
      final mainController = Get.find<MainController>();
      mainController.accessToken.value = accessToken;

      // If we also have a refresh token, update that as well
      if (newRefreshToken != refreshToken) {
        mainController.refreshToken.value = newRefreshToken;
      }

      dev.log('📢 [AuthController] Updated tokens in MainController');

      return true;
    } catch (e, stackTrace) {
      dev.log(
        '❌ [AuthController] Error refreshing token',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      // Delete the FCM token on logout
      await FirebaseMessaging.instance.deleteToken();

      // Clear all cached data
      await CacheManager.removeAll();

      // Reset controller state
      user.value = null;
      errorMessage.value = '';

      // Clear MainController state
      final mainController = Get.find<MainController>();
      await mainController.clearUserData();

      // Navigate to login screen
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      errorMessage.value = 'Error during logout: $e';
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  // New method to request OTP for registration
  Future<bool> requestOtp(String phone, String scope, String uType) async {
    if (phone.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      return false;
    }
    isLoading.value = true;
    errorMessage.value = ''; // Clear previous errors
    dev.log('📱 Requesting OTP for: $phone, scope: $scope, type: $uType');

    try {
      final result = await _repository.requestOtp(phone, scope, uType);
      if (result.isSuccess) {
        dev.log('✅ OTP sent successfully to $phone');
        Get.snackbar(
          'Success',
          'OTP sent to $phone. Valid for ${result.data?['valid_till'] ?? 120} seconds.',
        );
        errorMessage.value = ''; // Ensure error message is clear on success
        return true;
      } else {
        final error = result.message ?? 'Failed to send OTP';
        dev.log('❌ OTP request failed: $error');
        errorMessage.value = error;
        return false;
      }
    } catch (e, stackTrace) {
      dev.log('❌ Error requesting OTP:', error: e, stackTrace: stackTrace);
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestOtpFiled({
    required String phone,
    required String scope,
    required String type,
  }) async {
    try {
      isLoading.value = true;

      final updatedProfileData = await _repository.requestOtpFiled(
        phone: phone,
        scope: scope,
        type: type,
      );

      //Get.snackbar('Success', 'Address location updated successfully!');
    } catch (e) {
      final errorMsg = 'Failed to update address location: ${e.toString()}';

      debugPrint('\x1B[31m$errorMsg\x1B[0m');
      _errorDisplay.showError('Did not get any account . Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpCode({
    required String phone,
    required String scope,
    required String type,
    required String otp,
  }) async {
    try {
      isLoading.value = true;

      final otpValidationResponse = await _repository.verifyOtp(
        phone: phone,
        type: type,
        otp: otp,
        scope: scope,
      );

      if (otpValidationResponse.success) {
        debugPrint('✅ OTP Verified: ${otpValidationResponse.message}');
        Fluttertoast.showToast(
          msg: otpValidationResponse.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        // Navigate or update state as needed
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to verify OTP. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      final errorMsg = 'Failed to verify OTP: ${e.toString()}';

      debugPrint('\x1B[31m$errorMsg\x1B[0m');
      _errorDisplay.showError('Failed to verify OTP. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String password,
    required String type,
  }) async {
    try {
      isLoading.value = true;

      final response = await _repository.resetPassword(
        phone: phone,
        otp: otp,
        password: password,
        type: type,
      );

      if (response.success) {
        debugPrint('✅ Password reset successful: ${response.message}');
        Fluttertoast.showToast(
          msg: 'Password changed successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );

        // TODO: You may navigate to login or home here
        // Get.offAllNamed('/login');
      } else {
        final errorMessage =
            response.errors?.nonFieldErrors?.first ?? 'Reset password failed';
        debugPrint('❌ Reset failed: $errorMessage');
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      final errorMsg = 'Failed to reset password: ${e.toString()}';
      debugPrint('\x1B[31m$errorMsg\x1B[0m');
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // New method for user registration
  Future<void> register(
    String fullName,
    String phoneNumber,
    String uType,
    String password,
    String otp,
  ) async {
    if (fullName.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        otp.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';


    try {
      final result = await _repository.register(
        fullName,
        phoneNumber,
        uType,
        password,
        otp,
        referCode: referCode.value,
      );

      if (result.isSuccess && result.data != null) {
        dev.log(
          '✅ Registration successful for $fullName. Response data: ${result.data}',
        );

        // Extract tokens from the map
        final String? token = result.data!['access_token'] as String?;
        final String? refreshToken = result.data!['refresh_token'] as String?;

        if (token == null || refreshToken == null) {
          dev.log(
            '❌ [AuthController] Missing tokens in registration response map',
            error: 'Token(s) are null',
          );
          errorMessage.value =
              'Registration completed but failed to retrieve session tokens.';
          isLoading.value = false;
          return;
        }

        await CacheManager.setToken(token);
        await CacheManager.setRefreshToken(refreshToken);
        await CacheManager.setUserName(phoneNumber);
        await CacheManager.setPassword(password);
        mainControl.username.value = phoneNumber;
        mainControl.password.value = password;
        try {
          final profileRepository = Get.find<ProfileRepositoryInterface>();
          final userProfile =
              await profileRepository.getProfile(); // This is ProfileModel

          // Construct UserModel from ProfileModel and existing tokens
          final UserModel authUser = UserModel(
            accessToken: token, // token from registration response
            refreshToken:
                refreshToken, // refreshToken from registration response
            userType:
                userProfile.uType ??
                uType, // uType from ProfileModel or registration
          );

          // Now use authUser (which is UserModel) for _handleSuccessfulLogin and user.value
          _handleSuccessfulLogin(authUser);
          user.value = authUser;

          await CacheManager.setUserId(userProfile.id.toString());
          await CacheManager.setRoleName(
            userProfile.uType ?? uType,
          ); // Use uType from registration if profile doesn't have it yet
          await CacheManager.setProfileImageUrl(userProfile.image ?? '');

          _mainController.userName.value = phoneNumber;
          _mainController.password.value = password;
          _mainController.updateUserData(
            userProfile.id.toString(),
            token, // Use the token extracted from the map
            userProfile.uType?.toLowerCase() ?? uType.toLowerCase(),
            name:
                '${userProfile.firstName} ${userProfile.lastName}'
                    .trim(), // Name should come from profile
            email: userProfile.email,
            profileImage: userProfile.image,
            refreshTokens: refreshToken,
            mongoUserId: userProfile.mongoUserId,
          );

          referCode.value = '';
          if ((userProfile.uType?.toLowerCase() ?? uType.toLowerCase()) ==
              'host') {
            Get.offAll(HostBottomNavigationBarView());
          } else {
            Get.offAllNamed(AppRoute.guest);
          }
        } catch (e, stackTrace) {
          dev.log(
            '❌ [AuthController] Error fetching profile post-registration:',
            error: e,
            stackTrace: stackTrace,
          );
          errorMessage.value =
              'Registration successful, but failed to load profile: ${e.toString()}';
          // Navigate to a generic success page or login page as fallback
          Get.offAllNamed(AppRoute.login);
        }
      } else {
        final error = result.message ?? 'Registration failed';
        dev.log('❌ Registration failed: $error');
        errorMessage.value = error;
      }
    } catch (e, stackTrace) {
      dev.log('❌ Error during registration:', error: e, stackTrace: stackTrace);
      errorMessage.value =
          'An unexpected error occurred during registration: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFcmTokenToServer(String token) async {
    final response = await _repository.sendFcmToken(token: token);
    if (response.isSuccess) {
      debugPrint("✅ FCM token sent successfully");
    } else {
      debugPrint("⚠️ Failed to send FCM token: ${response.message}");
    }
  }

  void onLogin() async {
    String? fcmToken = await NotificationService().initFCM();
    if (fcmToken != null) {
      // Send token to your backend API
      await sendFcmTokenToServer(fcmToken);
    }
  }
}

// Make sure AuthRepositoryInterface and its implementation have requestOtp and register methods
// Example (add to AuthRepositoryInterface):
// Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber, String scope, String uType);
// Future<ApiResponse<UserModel>> register(String fullName, String phoneNumber, String uType, String password, String otp);

// Example (add to AuthRepositoryImplementation):
// @override
// Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber, String scope, String uType) async {
//   // ... your API call logic ...
// }
// @override
// Future<ApiResponse<UserModel>> register(String fullName, String phoneNumber, String uType, String password, String otp) async {
//   // ... your API call logic ...
// }

// Hello I am Tamim