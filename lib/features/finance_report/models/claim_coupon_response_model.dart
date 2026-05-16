import 'dart:convert';

class ClaimCouponResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ClaimCouponData? data;

  ClaimCouponResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ClaimCouponResponseModel.fromRawJson(String str) => ClaimCouponResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClaimCouponResponseModel.fromJson(Map<String, dynamic> json) => ClaimCouponResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : ClaimCouponData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ClaimCouponData {
  final int? id;
  final String? code;
  final ClaimedBy? claimedBy;
  final String? amount;
  final String? status;
  final String? statusDisplay;
  final dynamic usedBy;
  final dynamic usedOnBookingId;
  final dynamic usedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClaimCouponData({
    this.id,
    this.code,
    this.claimedBy,
    this.amount,
    this.status,
    this.statusDisplay,
    this.usedBy,
    this.usedOnBookingId,
    this.usedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ClaimCouponData.fromRawJson(String str) => ClaimCouponData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClaimCouponData.fromJson(Map<String, dynamic> json) => ClaimCouponData(
    id: json["id"],
    code: json["code"],
    claimedBy: json["claimed_by"] == null ? null : ClaimedBy.fromJson(json["claimed_by"]),
    amount: json["amount"],
    status: json["status"],
    statusDisplay: json["status_display"],
    usedBy: json["used_by"],
    usedOnBookingId: json["used_on_booking_id"],
    usedAt: json["used_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "claimed_by": claimedBy?.toJson(),
    "amount": amount,
    "status": status,
    "status_display": statusDisplay,
    "used_by": usedBy,
    "used_on_booking_id": usedOnBookingId,
    "used_at": usedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ClaimedBy {
  final int? id;
  final String? username;
  final String? fullName;

  ClaimedBy({
    this.id,
    this.username,
    this.fullName,
  });

  factory ClaimedBy.fromRawJson(String str) => ClaimedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClaimedBy.fromJson(Map<String, dynamic> json) => ClaimedBy(
    id: json["id"],
    username: json["username"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "full_name": fullName,
  };
}

// Hello I am Tamim