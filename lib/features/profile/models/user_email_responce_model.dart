class UserEmailUpdateResponse {
  final bool success;
  final int statusCode;
  final String message;
  final EmailUpdateData data;

  UserEmailUpdateResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserEmailUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserEmailUpdateResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: EmailUpdateData.fromJson(json['data']),
    );
  }
}

class EmailUpdateData {
  final String email;
  final String scope;
  final int validTill;

  EmailUpdateData({
    required this.email,
    required this.scope,
    required this.validTill,
  });

  factory EmailUpdateData.fromJson(Map<String, dynamic> json) {
    return EmailUpdateData(
      email: json['email'],
      scope: json['scope'],
      validTill: json['valid_till'],
    );
  }
}

// Hello I am Tamim