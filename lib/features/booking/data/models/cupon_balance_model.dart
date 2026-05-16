class UserCouponBalance {
  final bool? success;
  final int? statusCode;
  final String? message;
  final CouponBalanceData? data;

  UserCouponBalance({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory UserCouponBalance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserCouponBalance();

    return UserCouponBalance(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CouponBalanceData.fromJson(json['data'])
          : null,
    );
  }
}

class CouponBalanceData {
  final int? currentPoints;
  final int? pointsNeededForCoupon;
  final bool? canClaimCoupon;
  final String? couponValueOnClaim;

  CouponBalanceData({
    this.currentPoints,
    this.pointsNeededForCoupon,
    this.canClaimCoupon,
    this.couponValueOnClaim,
  });

  factory CouponBalanceData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CouponBalanceData();

    return CouponBalanceData(
      currentPoints: json['current_points'] as int?,
      pointsNeededForCoupon: json['points_needed_for_coupon'] as int?,
      canClaimCoupon: json['can_claim_coupon'] as bool?,
      couponValueOnClaim: json['coupon_value_on_claim'] as String?,
    );
  }
}

// Hello I am Tamim