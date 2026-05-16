import 'dart:convert';

class HostReferralMyCouponsResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MetaData? metaData;
  final List<MyCouponData>? data;

  HostReferralMyCouponsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.metaData,
    this.data,
  });

  factory HostReferralMyCouponsResponseModel.fromRawJson(String str) => HostReferralMyCouponsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostReferralMyCouponsResponseModel.fromJson(Map<String, dynamic> json) => HostReferralMyCouponsResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    metaData: json["meta_data"] == null ? null : MetaData.fromJson(json["meta_data"]),
    data: json["data"] == null ? [] : List<MyCouponData>.from(json["data"]!.map((x) => MyCouponData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "meta_data": metaData?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MyCouponData {
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

  MyCouponData({
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

  factory MyCouponData.fromRawJson(String str) => MyCouponData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyCouponData.fromJson(Map<String, dynamic> json) => MyCouponData(
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

  ClaimedBy({
    this.id,
    this.username,
  });

  factory ClaimedBy.fromRawJson(String str) => ClaimedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClaimedBy.fromJson(Map<String, dynamic> json) => ClaimedBy(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}

class MetaData {
  final int? total;
  final int? pageSize;
  final dynamic next;
  final dynamic previous;

  MetaData({
    this.total,
    this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromRawJson(String str) => MetaData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
    total: json["total"],
    pageSize: json["page_size"],
    next: json["next"],
    previous: json["previous"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page_size": pageSize,
    "next": next,
    "previous": previous,
  };
}

// Hello I am Tamim