import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/features/profile/models/profile_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/update_payment_method_response_model.dart';
import 'package:stayverz_flutter_app/features/profile/repositories/profile_repository_interface.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

import '../models/change_password_model.dart';
import '../models/co-hsot_aviability_model.dart';
import '../models/co_host_add_permission_model.dart';
import '../models/co_host_management.dart';
import '../models/cohost_get_model.dart';
import '../models/cohost_own_data.dart';
import '../models/email_responce_model.dart';
import '../models/image_changes_payload.dart';
import '../models/live_verification_model.dart';
import '../models/my_given_review.dart';
import '../models/payment_get_model.dart';
import '../models/payment_post_data_model.dart';
import '../models/refarar_code_model.dart';
import '../models/refercode_list.dart';
import '../models/school_responce_model.dart';
import '../models/superhost_model.dart';
import '../models/user_bio_request_model.dart';
import '../models/user_email_responce_model.dart';
import '../models/user_get_review_modle.dart';
import '../models/user_language_model.dart';
import '../models/user_language_responce_model.dart';
import '../models/user_location_responce_model.dart';
import '../models/work_responce_model.dart';


class ProfileRepositoryImpl implements ProfileRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<ProfileModel> getProfile() async {
    try {
      
      final response = await _apiClient.get(ApiRoutes.getProfile);
      
      // Check if the response contains the expected data structure
      final responseData = response.data;
      if (responseData == null) {
        throw Exception('No response data received from server');
      }
      
      // Handle different response formats
      final profileData = responseData['data'] ?? responseData;
      
      if (profileData == null) {
        throw Exception('No profile data found in response');
      }
      
      return ProfileModel.fromJson(profileData);
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final url = ApiRoutes.updateUser(profile.id.toString());
      
      final response = await _apiClient.put(
        url,
        data: profile.toJson(),
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        
        if (responseData == null) {
          throw Exception('No updated profile data received');
        }
        
        return ProfileModel.fromJson(responseData);
      } else {
        throw Exception('Failed to update profile');
      }
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(imagePath),
        'type': 'profile',
      });
      
      final response = await _apiClient.post(
        '${ApiRoutes.apiBaseURL}/upload/image',
        data: formData,
      );
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data['url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadCoverImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }
      
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(imagePath),
        'type': 'cover',
      });
      
      final response = await _apiClient.post(
        '${ApiRoutes.apiBaseURL}/upload/image',
        data: formData,
      );
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data['url'];
      } else {
        throw Exception('Failed to upload cover image');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReferralData?> getReferralLink() async {
    try {

      final response = await _apiClient.get(ApiRoutes.referLInk);

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final referralResponse = ReferralResponse.fromJson(responseData);

      // Fix your condition here:
      if (referralResponse.statusCode != 200 || referralResponse.success != true) {
        throw Exception('Server error: ${referralResponse.message}');
      }

      if (referralResponse.data == null) {
        // Defensive: if data is null, throw error instead of returning null
        throw Exception('Referral data is null');
      }

      return referralResponse.data;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ReferralResponseList> getReferralLinksList({
    required int page,
    required int pageSize,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };


      final response = await _apiClient.get(
        '/referrals/my-referrals/',
        queryParameters: queryParameters,
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final referralResponseList = ReferralResponseList.fromJson(responseData);

      if (referralResponseList.statusCode != 200 || referralResponseList.success != true) {
        throw Exception('Server error: ${referralResponseList.message}');
      }


      return referralResponseList;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }


  @override
  Future<PatchUserProfileRequest> patchUserSchool(String school) async {
    try {
      final payload = {
        'school': school,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return PatchUserProfileRequest.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<UploadImageData> patchImageUpload(String imageUrl) async {
    try {
      final payload = {
        'image': imageUrl,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return UploadImageData.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<UserWorkProfileData> patchUserWork(String work) async {
    try {
      final payload = {
        'work': work,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return UserWorkProfileData.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<UserAddressLocationData> patchUserAddressLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final payload = {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return UserAddressLocationData.fromJson(data); // ✅ match interface
      } else {
        throw Exception('Failed to patch address location');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<PatchLanguagesResponse> patchUserLanguage(List<String> languages) async {
    try {
      final patchRequest = PatchLanguagesRequest(languages: languages);
      final payload = patchRequest.toJson();

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        return PatchLanguagesResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to patch languages');
      }
    } catch (e) {
      throw Exception('Error patching languages: $e');
    }
  }

  @override
  Future<BioData> patchUserBio(String bio) async {
    try {
      final payload = {
        'bio': bio,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return BioData.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<BioData> patchUserEmgContract(String emgContact) async {
    try {
      final payload = {
        'emergency_contact': emgContact,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return BioData.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<BioData> patchUserGender(String gender) async {
    try {
      final payload = {
        'gender': gender,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return BioData.fromJson(data);
      } else {
        throw Exception('Failed to patch school field');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<UserEmailUpdateResponse> requestEmailUpdate({
    required String email,
    required String scope,
  }) async {
    try {
      final payload = {
        'email': email,
        'scope': scope,
      };

      final response = await _apiClient.post(
        '/otp/user/otp-request/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return UserEmailUpdateResponse.fromJson(data);
      } else {
        throw Exception('Failed to request email verification.');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }



  @override
  Future<EmailVerificationResponseModel> requestDataEmailUpdate({
    required String email,
    required String otp,
    required bool otpVerify,
  }) async {
    try {
      final payload = {
        'email': email,
        'otp': otp,
        'otp_verify': otpVerify,
      };

      final response = await _apiClient.post(
        '/accounts/user/email-verification/',
        data: payload,
      );

      final data = response.data;

      return EmailVerificationResponseModel.fromJson(data);
    } on dio.DioException catch (e) {
      if (e.response?.data != null) {
        return EmailVerificationResponseModel.fromJson(e.response!.data);
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<GetSuperhostResponse> getSuperhostProgress(int userId) async {
    try {

      final response = await _apiClient.get(
        '/accounts/user/superhost-progress/$userId/',
      );

      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final superhostResponse = GetSuperhostResponse.fromJson(responseData);

      if (superhostResponse.statusCode != 200 || superhostResponse.success != true) {
        throw Exception('Server error: ${superhostResponse.message}');
      }

      if (superhostResponse.data == null) {
        throw Exception('Superhost data is null');
      }

      return superhostResponse;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<CoHostResponseData> getHostsInRadius({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.get(
        '/accounts/user/public/hosts-in-radius/',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final coHostResponse = CoHostResponseData.fromJson(responseData);

      if (coHostResponse.statusCode != 200 || coHostResponse.success != true) {
        throw Exception('Server error: ${coHostResponse.message}');
      }

      return coHostResponse;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<CoHostOwnResponseData> getCoHostAssignmentStatus({
    required int coHostId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/listings/host/primary-host/cohost-assignment-status/',
        queryParameters: {
          'co_host_id': coHostId,
        },
      );

      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final coHostOwnResponse = CoHostOwnResponseData.fromJson(responseData);

      if (coHostOwnResponse.statusCode != 200 || coHostOwnResponse.success != true) {
        throw Exception('Server error: ${coHostOwnResponse.message}');
      }

      return coHostOwnResponse;

    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }


  @override
  Future<ChangePasswordResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final payload = {
        'old_password': oldPassword,
        'new_password': newPassword,
      };

      final response = await _apiClient.post(
        '/accounts/user/password-change-dual/', // your actual endpoint
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return ChangePasswordResponse.fromJson(data);
      } else {
        throw Exception('Failed to change password.');
      }
    } on dio.DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData != null) {
        // You can throw the parsed model if needed
        throw ChangePasswordErrorResponse.fromJson(errorData);
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<UpdateCoHostResponseModel> patchCoHostCommission({
    required int coHostId,
    required UpdateCoHostCommissionRequest request,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/listings/host/co-hosts/manage-assignments/$coHostId/',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UpdateCoHostResponseModel.fromJson(response.data);
      } else {
        throw Exception('❌ Failed to patch co-host commission. Status code: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<UpdateCohostAvailabilityResponse> patchCohostAvailability(bool isAvailable) async {
    try {
      final payload = {
        'is_available_for_cohosting': isAvailable,
      };

      final response = await _apiClient.patch(
        '/accounts/user/profile/co-hosting/availability/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return UpdateCohostAvailabilityResponse.fromJson(data);
      } else {
        throw Exception('Failed to update co-host availability');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<ApiResponseModel> submitDocument({
    required DocumentRequestModel documentRequest,
  }) async {
    try {
      final response = await _apiClient.post(
        '/accounts/user/identity-live-verification/', // your actual endpoint
        data: documentRequest.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return ApiResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to submit document.');
      }
    } on dio.DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData != null) {
        return ApiResponseModel.fromJson(errorData);
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<CoHostAssignmentResponse> assignCoHost({
    required int coHostUserId,
    required String accessLevel,
    required List<int> listingIds,
    required String commissionPercentage,
  }) async {
    try {
      final payload = {
        'co_host_user_id': coHostUserId,
        'access_level': accessLevel,
        'listing_ids': listingIds,
        'commission_percentage': commissionPercentage,
      };

      final response = await _apiClient.post(
        '/listings/host/manage-cohosts/',  // replace with actual endpoint
        data: payload,
      );

      if ((response.statusCode == 201 || response.statusCode == 200) && response.data != null) {
        return CoHostAssignmentResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to process co-host assignments.');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<PaymentMethodResponse> getHostPaymentMethods() async {
    try {
      final response = await _apiClient.get(
        '/payments/host/pay-methods/',
      );

      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final paymentMethodResponse = PaymentMethodResponse.fromJson(responseData);

      if (paymentMethodResponse.statusCode != 200 || paymentMethodResponse.success != true) {
        throw Exception('Server error: ${paymentMethodResponse.message}');
      }

      return paymentMethodResponse;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PostResponseModel> createPaymentMethod({
    required PaymentMethodRequest paymentMethodRequest,
  }) async {
    try {
      final payload = paymentMethodRequest.toJson();

      final response = await _apiClient.post(
        '/payments/host/pay-methods/', // replace with your actual endpoint
        data: payload,
      );

      if ((response.statusCode == 201 || response.statusCode == 200) && response.data != null) {
        return PostResponseModel.fromJson(response.data);
      } else if(response.statusCode == 400 && response.data != null) {

        String errorMessage = '';

        List errors = response.data?['errors']?['field_errors'] ?? [];

        for(Map<String, dynamic> o in errors) {
          o.forEach((key, value) {
            errorMessage = "$errorMessage${errorMessage.isNotEmpty ? '.' : ''} $value";
          });
        }
        throw errorMessage;
      } else {
        Get.back();
        // Fluttertoast.showToast(msg: "Please give valid number");
        throw Exception("Invalid response while creating payment method");


      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<UpdatePaymentMethodResponseModel> updatePaymentMethod({
    required PaymentMethodRequest paymentMethodRequest,
    required String id
  }) async {
    try {
      final payload = paymentMethodRequest.toJson();

      final response = await _apiClient.patch(
        '/payments/host/pay-methods/$id/', // replace with your actual endpoint
        data: payload,
      );

      if ((response.statusCode == 201 || response.statusCode == 200) && response.data != null) {
        return UpdatePaymentMethodResponseModel.fromJson(response.data);
      } else if(response.statusCode == 400 && response.data != null) {

        String errorMessage = '';

        List errors = response.data?['errors']?['field_errors'] ?? [];

        for(Map<String, dynamic> o in errors) {
          o.forEach((key, value) {
            errorMessage = "$errorMessage${errorMessage.isNotEmpty ? '.' : ''} $value";
          });
        }
        throw errorMessage;
      } else {
        Get.back();
        // Fluttertoast.showToast(msg: "Please give valid number");
        throw Exception("Invalid response while creating payment method");


      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteGrantedListing({required String id}) async {
    try {

      final response = await _apiClient.delete(
        '/listings/host/manage-cohosts/$id/',  // replace with actual endpoint
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['success'];
      } else {
        return false;
      }
    } on dio.DioException catch (e) {
      return false;
    } catch (e, stackTrace) {
      return false;
    }
  }


  @override
  Future<String?> deleteAccount({required String password}) async {
    try {

      final response = await _apiClient.delete(
        '/accounts/user/delete/',  // replace with actual endpoint
        data: { "password" : password }
      );

      if (response.statusCode == 200 && ((response.data ?? {})['success'] == true)) {
        return response.data['message'];
      } else if (response.statusCode == 400 && ((response.data ?? {})['success'] == false)) {
        return (response.data ?? {})['message'];
      } else {
        return null;
      }
    } on dio.DioException catch (e) {
      return null;
    } catch (e, stackTrace) {
      return null;
    }
  }

  @override
  Future<List<UserReviewData>?> getUserReviews() async {
    try {

      final response = await _apiClient.get("/accounts/user/reviews/?my_reviews=true");
      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final reviewResponse = UserReviewsResponse.fromJson(responseData);

      // ✅ Check API status
      if (reviewResponse.statusCode != 200 || reviewResponse.success != true) {
        throw Exception('Server error: ${reviewResponse.message}');
      }

      // ✅ Handle null data safely
      if (reviewResponse.data == null || reviewResponse.data!.isEmpty) {
        return [];
      }

      return reviewResponse.data;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<GivenReviewData>?> getMyGivenReviews() async {
    try {

      final response = await _apiClient.get("/accounts/user/reviews/?my_reviews=false");
      final responseData = response.data;

      if (responseData == null) {
        throw Exception('No response data received from server');
      }

      final reviewResponse = GivenReviewResponse.fromJson(responseData);

      // ✅ Check API status
      if (reviewResponse.statusCode != 200 || reviewResponse.success != true) {
        throw Exception('Server error: ${reviewResponse.message}');
      }

      // ✅ Handle null or empty data
      if (reviewResponse.data == null || reviewResponse.data!.isEmpty) {
        return [];
      }

      return reviewResponse.data;
    } on dio.DioException catch (e) {
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }


}

// Hello I am Tamim