import 'package:stayverz_flutter_app/services/network/api_response.dart';
import 'package:stayverz_flutter_app/features/auth/models/user_model.dart';

import '../models/get_referral_code_response.dart';
import '../models/otp_get_controller.dart';
import '../models/otp_validation_public_model.dart';
import '../models/reset_password_model.dart';

abstract class AuthRepositoryInterface {
  Future<ApiResponse<UserModel>> login(String phone, String password, String role);
  
  /// Refreshes the access token using the refresh token
  /// Returns a map containing the new access and refresh tokens
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  Future<GetReferralCodeResponse?> getReferralCode(String code);

  Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber, String scope, String uType);

  Future<ApiResponse<Map<String, dynamic>>> register(
    String fullName,
    String phoneNumber,
    String uType,
    String password,
    String otp,
    {String? referCode}
  );

  Future<OtpModel> requestOtpFiled({
    required String phone,
    required String scope,
    required String type,
  });


  Future<OtpValidationResponse> verifyOtp({
    required String phone,
    required String type,
    required String otp,
    required String scope,
  });

  Future<ResetPasswordResponse> resetPassword({
    required String phone,
    required String otp,
    required String password,
    required String type,
  });
  Future<ApiResponse<void>> sendFcmToken({required String token});

}

// Hello I am Tamim