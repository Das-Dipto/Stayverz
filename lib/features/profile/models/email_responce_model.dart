class EmailVerificationResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final EmailVerificationData? data;
  final EmailVerificationErrors? errors;

  EmailVerificationResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  factory EmailVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? EmailVerificationData.fromJson(json['data']) : null,
      errors: json['errors'] != null ? EmailVerificationErrors.fromJson(json['errors']) : null,
    );
  }
}

class EmailVerificationData {
  final String message;

  EmailVerificationData({required this.message});

  factory EmailVerificationData.fromJson(Map<String, dynamic> json) {
    return EmailVerificationData(
      message: json['message'] ?? '',
    );
  }
}

class EmailVerificationErrors {
  final List<String>? nonFieldErrors;

  EmailVerificationErrors({this.nonFieldErrors});

  factory EmailVerificationErrors.fromJson(Map<String, dynamic> json) {
    return EmailVerificationErrors(
      nonFieldErrors: (json['non_field_errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

// Hello I am Tamim