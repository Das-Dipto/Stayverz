class ResetPasswordResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ResetPasswordData? data;
  final ResetPasswordError? errors;

  ResetPasswordResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ResetPasswordData.fromJson(json['data']) : null,
      errors: json['errors'] != null ? ResetPasswordError.fromJson(json['errors']) : null,
    );
  }
}

class ResetPasswordData {
  final String accessToken;
  final String refreshToken;

  ResetPasswordData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ResetPasswordData.fromJson(Map<String, dynamic> json) {
    return ResetPasswordData(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}

class ResetPasswordError {
  final List<String>? nonFieldErrors;

  ResetPasswordError({this.nonFieldErrors});

  factory ResetPasswordError.fromJson(Map<String, dynamic> json) {
    return ResetPasswordError(
      nonFieldErrors: json['non_field_errors'] != null
          ? List<String>.from(json['non_field_errors'])
          : null,
    );
  }
}

// Hello I am Tamim