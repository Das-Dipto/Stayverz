import 'dart:convert';

class ReferralResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ReferralData? data;

  ReferralResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ReferralResponse.fromRawJson(String str) => ReferralResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralResponse.fromJson(Map<String, dynamic> json) => ReferralResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : ReferralData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReferralData {
  final int? id;
  final Referrer? referrer;
  final String? referralCode;
  final String? referralType;
  final String? referralTypeDisplay;
  final dynamic referredUser;
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
  final String? shortLink;

  ReferralData({
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
    this.shortLink,
  });

  factory ReferralData.fromRawJson(String str) => ReferralData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
    id: json["id"],
    referrer: json["referrer"] == null ? null : Referrer.fromJson(json["referrer"]),
    referralCode: json["referral_code"],
    referralType: json["referral_type"],
    referralTypeDisplay: json["referral_type_display"],
    referredUser: json["referred_user"],
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
    shortLink: json["short_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "referrer": referrer?.toJson(),
    "referral_code": referralCode,
    "referral_type": referralType,
    "referral_type_display": referralTypeDisplay,
    "referred_user": referredUser,
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
    "short_link": shortLink,
  };
}

class Referrer {
  final int? id;
  final String? username;
  final String? fullName;
  final String? uType;

  Referrer({
    this.id,
    this.username,
    this.fullName,
    this.uType,
  });

  factory Referrer.fromRawJson(String str) => Referrer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Referrer.fromJson(Map<String, dynamic> json) => Referrer(
    id: json["id"],
    username: json["username"],
    fullName: json["full_name"],
    uType: json["u_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "full_name": fullName,
    "u_type": uType,
  };
}

// Hello I am Tamim