class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
  }
}

class ChangePasswordResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PasswordData? data;

  ChangePasswordResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null ? PasswordData.fromJson(json['data']) : null,
    );
  }
}

class PasswordData {
  final String message;

  PasswordData({required this.message});

  factory PasswordData.fromJson(Map<String, dynamic> json) {
    return PasswordData(
      message: json['message'],
    );
  }
}

class ChangePasswordErrorResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ErrorDetail? errors;

  ChangePasswordErrorResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.errors,
  });

  factory ChangePasswordErrorResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordErrorResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      errors: json['errors'] != null ? ErrorDetail.fromJson(json['errors']) : null,
    );
  }
}

class ErrorDetail {
  final List<String>? nonFieldErrors;

  ErrorDetail({this.nonFieldErrors});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      nonFieldErrors: List<String>.from(json['non_field_errors'] ?? []),
    );
  }
}

// Hello I am Tamim