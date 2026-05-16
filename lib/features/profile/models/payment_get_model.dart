class PaymentMethodResponse {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<PaymentMethod> data;

  PaymentMethodResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => PaymentMethod.fromJson(item))
          .toList(),
    );
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final String? next;
  final String? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      next: json['next'],
      previous: json['previous'],
    );
  }
}

class PaymentMethod {
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

  PaymentMethod({
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

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
}

// Hello I am Tamim