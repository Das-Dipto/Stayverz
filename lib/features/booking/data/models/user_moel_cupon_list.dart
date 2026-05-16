class UserCouponListResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final CouponMetaData? metaData;
  final List<UserCoupon> data;

  UserCouponListResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.metaData,
    required this.data,
  });

  factory UserCouponListResponseModel.fromJson(Map<String, dynamic> json) {
    return UserCouponListResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: json['meta_data'] != null
          ? CouponMetaData.fromJson(json['meta_data'])
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => UserCoupon.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CouponMetaData {
  final int total;
  final int pageSize;
  final int? next;
  final int? previous;

  CouponMetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory CouponMetaData.fromJson(Map<String, dynamic> json) {
    // page_size in JSON is String ("10"), so parse it safely
    int parsedPageSize = 0;
    try {
      final pageSizeValue = json['page_size'];
      if (pageSizeValue is int) {
        parsedPageSize = pageSizeValue;
      } else if (pageSizeValue is String) {
        parsedPageSize = int.tryParse(pageSizeValue) ?? 0;
      }
    } catch (_) {
      parsedPageSize = 0;
    }

    // next and previous are sometimes ints, sometimes null
    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return CouponMetaData(
      total: json['total'] ?? 0,
      pageSize: parsedPageSize,
      next: parseNullableInt(json['next']),
      previous: parseNullableInt(json['previous']),
    );
  }
}

class UserCoupon {
  final int id;
  final String code;
  final ClaimedBy? claimedBy;
  final String amount;
  final String status;
  final String statusDisplay;
  final dynamic usedBy;
  final dynamic usedOnBookingId;
  final dynamic usedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserCoupon({
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

  factory UserCoupon.fromJson(Map<String, dynamic> json) {
    DateTime? tryParseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    }

    return UserCoupon(
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
      createdAt: tryParseDate(json['created_at']),
      updatedAt: tryParseDate(json['updated_at']),
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