import 'dart:convert';

class MyReferralsResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MetaData? metaData;
  final List<MyReferralsData>? data;

  MyReferralsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.metaData,
    this.data,
  });

  factory MyReferralsResponseModel.fromRawJson(String str) => MyReferralsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyReferralsResponseModel.fromJson(Map<String, dynamic> json) => MyReferralsResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    metaData: json["meta_data"] == null ? null : MetaData.fromJson(json["meta_data"]),
    data: json["data"] == null ? [] : List<MyReferralsData>.from(json["data"]!.map((x) => MyReferralsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "meta_data": metaData?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MyReferralsData {
  final int? id;
  final Referre? referrer;
  final String? referralCode;
  final String? referralType;
  final String? referralTypeDisplay;
  final Referre? referredUser;
  final String? status;
  final String? statusDisplay;
  final int? rewardedBookingCount;
  final int? maxRewardableBookings;
  final String? rewardValueFromThisReferral;
  final String? rewardUnitFromThisReferral;
  final bool? isActiveForRewards;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? referralLink;

  MyReferralsData({
    this.id,
    this.referrer,
    this.referralCode,
    this.referralType,
    this.referralTypeDisplay,
    this.referredUser,
    this.status,
    this.statusDisplay,
    this.rewardedBookingCount,
    this.maxRewardableBookings,
    this.rewardValueFromThisReferral,
    this.rewardUnitFromThisReferral,
    this.isActiveForRewards,
    this.createdAt,
    this.updatedAt,
    this.referralLink,
  });

  factory MyReferralsData.fromRawJson(String str) => MyReferralsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyReferralsData.fromJson(Map<String, dynamic> json) => MyReferralsData(
    id: json["id"],
    referrer: json["referrer"] == null ? null : Referre.fromJson(json["referrer"]),
    referralCode: json["referral_code"],
    referralType: json["referral_type"],
    referralTypeDisplay: json["referral_type_display"],
    referredUser: json["referred_user"] == null ? null : Referre.fromJson(json["referred_user"]),
    status: json["status"],
    statusDisplay: json["status_display"],
    rewardedBookingCount: json["rewarded_booking_count"],
    maxRewardableBookings: json["max_rewardable_bookings"],
    rewardValueFromThisReferral: json["reward_value_from_this_referral"],
    rewardUnitFromThisReferral: json["reward_unit_from_this_referral"],
    isActiveForRewards: json["is_active_for_rewards"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    referralLink: json["referral_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "referrer": referrer?.toJson(),
    "referral_code": referralCode,
    "referral_type": referralType,
    "referral_type_display": referralTypeDisplay,
    "referred_user": referredUser?.toJson(),
    "status": status,
    "status_display": statusDisplay,
    "rewarded_booking_count": rewardedBookingCount,
    "max_rewardable_bookings": maxRewardableBookings,
    "reward_value_from_this_referral": rewardValueFromThisReferral,
    "reward_unit_from_this_referral": rewardUnitFromThisReferral,
    "is_active_for_rewards": isActiveForRewards,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "referral_link": referralLink,
  };
}

class Referre {
  final int? id;
  final String? username;
  final String? uType;
  final String? image;
  final String? full_name;

  Referre({
    this.id,
    this.username,
    this.uType,
    this.full_name,
    this.image,
  });

  factory Referre.fromRawJson(String str) => Referre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Referre.fromJson(Map<String, dynamic> json) => Referre(
    id: json["id"],
    username: json["username"],
    uType: json["u_type"],
    image: json["image"],
    full_name: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "u_type": uType,
    "image": image,
    "full_name": full_name,
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