class CouponResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CouponData data;

  CouponResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: CouponData.fromJson(json['data'] ?? {}),
    );
  }
}

class CouponData {
  final bool isValid;
  final String message;
  final String couponCode;
  final String? couponType;
  final String? discountAmount;
  final String originalPriceForDiscountCalc;
  final String? priceAfterDiscount;
  final String? discountDisplay;

  CouponData({
    required this.isValid,
    required this.message,
    required this.couponCode,
    this.couponType,
    this.discountAmount,
    required this.originalPriceForDiscountCalc,
    this.priceAfterDiscount,
    this.discountDisplay,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      isValid: json['is_valid'] ?? false,
      message: json['message'] ?? '',
      couponCode: json['coupon_code'] ?? '',
      couponType: json['coupon_type'],
      discountAmount: json['discount_amount'],
      originalPriceForDiscountCalc: json['original_price_for_discount_calc'] ?? '0.00',
      priceAfterDiscount: json['price_after_discount'],
      discountDisplay: json['discount_display'],
    );
  }
}

// Hello I am Tamim