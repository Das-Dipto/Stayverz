import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/features/auth/models/get_referral_code_response.dart';

import '../../../services/network/api_client.dart';
import '../../../services/network/api_response.dart';
import '../models/otp_get_controller.dart';
import '../models/otp_validation_public_model.dart';
import '../models/reset_password_model.dart';
import '../models/user_model.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;
  AuthRepository(this._apiClient);

  Future<ApiResponse<UserModel>> login(
    String phone,
    String password,
    String role,
  ) async {
    final response = await _apiClient.post(
      '/accounts/public/login-with-create/',
      data: {'u_type': role, 'phone_number': phone, 'password': password},
    );
    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return ApiResponse.success(UserModel.fromJson(data['data']));
    } else {
      String errorMessage = data['message']?.toString() ?? 'Login failed';
      // Handle field errors if present
      // if (data['errors'] != null && data['errors'] is Map) {
      //   final fieldErrors = data['errors'];
      //   if (fieldErrors.isNotEmpty) {
      //     errorMessage = '$errorMessage (${fieldErrors.toString()})';
      //   }
      // }
      return ApiResponse.error(errorMessage);
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      // Use the full API path including version
      final response = await _apiClient.post(
        '/accounts/public/refresh-token/',
        data: {'refresh_token': refreshToken},
      );


      // Debug the full response

      final data = response.data;

      // Handle different response formats
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Format 1: Direct token in response
        if (data is Map<String, dynamic> && data['access_token'] != null) {
          return {
            'access_token': data['access_token'],
            'refresh_token':
                data['refresh_token'] ??
                refreshToken, // Use existing if not returned
          };
        }

        // Format 2: Nested in data field
        if (data is Map<String, dynamic> &&
            data['data'] != null &&
            data['data'] is Map) {
          final tokenData = data['data'] as Map<String, dynamic>;
          if (tokenData['access_token'] != null) {
            return {
              'access_token': tokenData['access_token'],
              'refresh_token': tokenData['refresh_token'] ?? refreshToken,
            };
          }
        }

        // Format 3: Nested in other structure
        if (data is Map<String, dynamic>) {
          // Try to find tokens anywhere in the response
          final Map<String, dynamic> extracted = {};
          _extractTokens(data, extracted);

          if (extracted.isNotEmpty) {
            return extracted;
          }
        }
      }

      // If we reach here, we couldn't parse the response
      if (data is Map<String, dynamic>) {
      } else {
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // Helper method to extract access_token and refresh_token from nested structures
  void _extractTokens(Map<String, dynamic> data, Map<String, dynamic> result) {
    for (final key in data.keys) {
      if (key == 'access_token' && data[key] is String) {
        result['access_token'] = data[key];
      } else if (key == 'refresh_token' && data[key] is String) {
        result['refresh_token'] = data[key];
      } else if (data[key] is Map<String, dynamic>) {
        _extractTokens(data[key] as Map<String, dynamic>, result);
      }
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber, String scope, String uType) async {
    try {
      final response = await _apiClient.post(
        '/otp/public/otp-request/',
        data: {
          'phone_number': phoneNumber,
          'scope': scope,
          'u_type': uType
        },
      );
      
      print("Following are the response payload- ${response}");
      final data = response.data;
      if (data['success'] == true && data['status_code'] == 200) {
        return ApiResponse.success(data['data'] ?? {'message': 'OTP sent successfully'});
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      return ApiResponse.error('Failed to send OTP: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> register(
    String fullName,
    String phoneNumber,
    String uType,
    String password,
    String otp,
    {String? referCode}
  ) async {
    try {
      final response = await _apiClient.post(
        '/accounts/public/register/ref/',
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
          'u_type': uType,
          'password': password,
          'otp': otp,
          if((referCode ?? '').isNotEmpty)...{'referral_code': referCode}
        },
      );
      
      final data = response.data;
      if (data['success'] == true && (data['status_code'] == 201 || data['status_code'] == 200)) {
        return ApiResponse.success(data['data'] ?? {'message': 'Registration successful'});
      } else {
        String errorMessage = data['message']?.toString() ?? 'Registration failed';
        // Handle field errors if present
        if (data['errors'] != null && data['errors'] is Map) {
          final fieldErrors = data['errors'];
          if (fieldErrors.isNotEmpty) {
            errorMessage = '$errorMessage (${fieldErrors.toString()})';
          }
        }
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      return ApiResponse.error('Registration failed: $e');
    }
  }


  @override
  Future<OtpModel> requestOtpFiled({
    required String phone,
    required String scope,
    required String type,
  }) async {
    try {
      final payload = {
        "phone_number": phone,
        "u_type": type,
        "scope": scope, // ✅ fixed from 'type' to 'scope'
        "email":""
      };

print("This is the request payload- ${phone}, ${type}, ${scope}");
      final response = await _apiClient.post(
        '/otp/public/otp-request/',
        data: payload,
      );
  print("Following are the response payload- ${response}");
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return OtpModel.fromJson(data); // ✅ returns correct model
      } else {
        throw Exception('Failed to request OTP.');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }


  @override
  Future<ResetPasswordResponse> resetPassword({
    required String phone,
    required String otp,
    required String password,
    required String type,
  }) async {
    try {
      final payload = {
        "phone_number": phone,
        "otp": otp,
        "password": password,
        "u_type": type,
      };

      final response = await _apiClient.post(
        '/accounts/public/reset-password-dual-user/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return ResetPasswordResponse.fromJson(data);
      } else {
        throw Exception('Failed to reset password.');
      }
    } on dio.DioException catch (e) {
      if (e.response?.data != null) {
        return ResetPasswordResponse.fromJson(e.response!.data);
      } else {
        throw Exception('Dio error: ${e.message}');
      }
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }



  @override
  Future<OtpValidationResponse> verifyOtp({
    required String phone,
    required String type,
    required String otp,
    required String scope,
  }) async {
    try {
      final payload = {
        "phone_number": phone,
        "u_type": type,
        "otp": otp,
        "otp_verify": true,
        "scope": scope,
      };

      final response = await _apiClient.post(
        '/otp/public/otp-validate/',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        return OtpValidationResponse.fromJson(data);
      } else {
        throw Exception('Failed to verify OTP.');
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<ApiResponse<void>> sendFcmToken({required String token}) async {
    try {
      final response = await _apiClient.post(
        '/notifications/user/fcm-tokens/',
        data: {'token': token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(null); // or use ApiResponse<void>.success(null);
      } else {
        return ApiResponse.error("Failed to send FCM token.");
      }
    } catch (e) {
      return ApiResponse.error("Exception occurred: $e");
    }
  }

  @override
  Future<GetReferralCodeResponse?> getReferralCode(String code) async {
    try {
      final response = await _apiClient.get(ApiRoutes.getReferralCode(code));

      if (response.statusCode == 200) {
        try {
          final bookingDetail = GetReferralCodeResponse.fromJson(response.data);
          return bookingDetail;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}

// Hello I am Tamim