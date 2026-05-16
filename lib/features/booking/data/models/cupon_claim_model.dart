class CouponClaimResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final CouponCalimData? data;

  CouponClaimResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CouponClaimResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponClaimResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CouponCalimData.fromJson(json['data']) : null,
    );
  }
}

class CouponCalimData {
  final int id;
  final String code;
  final ClaimedBy? claimedBy;
  final String amount;
  final String status;
  final String statusDisplay;
  final dynamic usedBy;
  final dynamic usedOnBookingId;
  final String? usedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CouponCalimData({
    required this.id,
    required this.code,
    this.claimedBy,
    required this.amount,
    required this.status,
    required this.statusDisplay,
    this.usedBy,
    this.usedOnBookingId,
    this.usedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CouponCalimData.fromJson(Map<String, dynamic> json) {
    return CouponCalimData(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      claimedBy: json['claimed_by'] != null
          ? ClaimedBy.fromJson(json['claimed_by'])
          : null,
      amount: json['amount'] ?? '',
      status: json['status'] ?? '',
      statusDisplay: json['status_display'] ?? '',
      usedBy: json['used_by'],
      usedOnBookingId: json['used_on_booking_id'],
      usedAt: json['used_at'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class ClaimedBy {
  final int id;
  final String username;
  final String fullName;

  ClaimedBy({
    required this.id,
    required this.username,
    required this.fullName,
  });

  factory ClaimedBy.fromJson(Map<String, dynamic> json) {
    return ClaimedBy(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

// Hello I am Tamim