class PaymentMethodRequest {
  final String mType;
  final String bankName;
  final String branchName;
  final String routingNumber;
  final String accountNo;
  final String accountName;
  final bool isDefault;
  final String otp;

  PaymentMethodRequest({
    required this.mType,
    required this.bankName,
    required this.branchName,
    required this.routingNumber,
    required this.accountNo,
    required this.accountName,
    required this.isDefault,
    required this.otp,
  });

  factory PaymentMethodRequest.fromJson(Map<String, dynamic> json) {
    return PaymentMethodRequest(
      mType: json['m_type'] ?? '',
      bankName: json['bank_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      routingNumber: json['routing_number'] ?? '',
      accountNo: json['account_no'] ?? '',
      accountName: json['account_name'] ?? '',
      isDefault: json['is_default'] ?? false,
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'm_type': mType,
      'bank_name': bankName,
      'branch_name': branchName,
      'routing_number': routingNumber,
      'account_no': accountNo,
      'account_name': accountName,
      'is_default': isDefault,
      'otp': otp,
    };
  }
}

class PostResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;

  PostResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
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

class Data {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String mType;
  final String accountNo;
  final String accountName;
  final String bankName;
  final String branchName;
  final String routingNumber;
  final bool isDefault;
  final int host;

  Data({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.mType,
    required this.accountNo,
    required this.accountName,
    required this.bankName,
    required this.branchName,
    required this.routingNumber,
    required this.isDefault,
    required this.host,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      mType: json['m_type'] ?? '',
      accountNo: json['account_no'] ?? '',
      accountName: json['account_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      routingNumber: json['routing_number'] ?? '',
      isDefault: json['is_default'] ?? false,
      host: json['host'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'm_type': mType,
      'account_no': accountNo,
      'account_name': accountName,
      'bank_name': bankName,
      'branch_name': branchName,
      'routing_number': routingNumber,
      'is_default': isDefault,
      'host': host,
    };
  }
}

// Hello I am Tamim