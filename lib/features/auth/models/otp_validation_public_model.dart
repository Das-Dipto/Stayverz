// otp_validation_model.dart

class OtpValidationRequest {
  final String phoneNumber;
  final String uType;
  final String otp;
  final bool otpVerify;
  final String scope;

  OtpValidationRequest({
    required this.phoneNumber,
    required this.uType,
    required this.otp,
    required this.otpVerify,
    required this.scope,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'u_type': uType,
      'otp': otp,
      'otp_verify': otpVerify,
      'scope': scope,
    };
  }
}

class OtpValidationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final OtpValidationData data;

  OtpValidationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpValidationResponse.fromJson(Map<String, dynamic> json) {
    return OtpValidationResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: OtpValidationData.fromJson(json['data']),
    );
  }
}

class OtpValidationData {
  final String message;

  OtpValidationData({required this.message});

  factory OtpValidationData.fromJson(Map<String, dynamic> json) {
    return OtpValidationData(
      message: json['message'],
    );
  }
}

// Hello I am Tamim