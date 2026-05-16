class OtpModel {
  final bool success;
  final int statusCode;
  final String message;
  final OtpData data;

  OtpModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: OtpData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class OtpData {
  final String phoneNumber;
  final String uType;
  final String scope;
  final int validTill;

  OtpData({
    required this.phoneNumber,
    required this.uType,
    required this.scope,
    required this.validTill,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      phoneNumber: json['phone_number'],
      uType: json['u_type'],
      scope: json['scope'],
      validTill: json['valid_till'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'u_type': uType,
      'scope': scope,
      'valid_till': validTill,
    };
  }
}

// Hello I am Tamim