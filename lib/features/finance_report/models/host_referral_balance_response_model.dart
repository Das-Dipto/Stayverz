import 'dart:convert';

class HostReferralBalanceResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ReferralBalanceData? data;

  HostReferralBalanceResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostReferralBalanceResponseModel.fromRawJson(String str) => HostReferralBalanceResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostReferralBalanceResponseModel.fromJson(Map<String, dynamic> json) => HostReferralBalanceResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : ReferralBalanceData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReferralBalanceData {
  final String? totalAvailableCredit;
  final bool? canClaimCoupon;
  final String? minimumClaimAmount;

  ReferralBalanceData({
    this.totalAvailableCredit,
    this.canClaimCoupon,
    this.minimumClaimAmount,
  });

  factory ReferralBalanceData.fromRawJson(String str) => ReferralBalanceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralBalanceData.fromJson(Map<String, dynamic> json) => ReferralBalanceData(
    totalAvailableCredit: json["total_available_credit"],
    canClaimCoupon: json["can_claim_coupon"],
    minimumClaimAmount: json["minimum_claim_amount"],
  );

  Map<String, dynamic> toJson() => {
    "total_available_credit": totalAvailableCredit,
    "can_claim_coupon": canClaimCoupon,
    "minimum_claim_amount": minimumClaimAmount,
  };
}

// Hello I am Tamim