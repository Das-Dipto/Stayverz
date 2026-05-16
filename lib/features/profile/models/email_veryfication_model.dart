class EmailVerificationRequestModel {
  final String email;
  final String otp;
  final bool otpVerify;

  EmailVerificationRequestModel({
    required this.email,
    required this.otp,
    required this.otpVerify,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'otp_verify': otpVerify,
    };
  }
}

// Hello I am Tamim