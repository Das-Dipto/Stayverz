import 'package:meta/meta.dart';

class BookingResponse {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<BookingData2> data;

  BookingResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BookingData2.fromJson(e))
          .toList(),
    );
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final int? next;
  final int? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return MetaData(
      total: parseInt(json['total']),
      pageSize: parseInt(json['page_size']),
      next: parseNullableInt(json['next']),
      previous: parseNullableInt(json['previous']),
    );
  }
}


class BookingData2 {
  final int id;
  final List<dynamic> reviews;
  final double? originalPriceBeforeDiscount;
  final double? totalDiscountAmount;
  final double? accommodationCharge;
  final double? subtotalBeforeGenericCoupon;
  final double? lengthOfStayDiscountPercent;
  final double? lengthOfStayDiscountAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String invoiceNo;
  final String pgwTransactionNumber;
  final String reservationCode;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int nightCount;
  final int childrenCount;
  final int infantCount;
  final int adultCount;
  final int guestCount;
  final double price;
  final double guestServiceCharge;
  final double totalPrice;
  final double paidAmount;
  final double hostServiceCharge;
  final double hostPayOut;
  final double totalProfit;
  final double gatewayFee;
  final double refundAmount;
  final bool isRefunded;
  final Map<String, PriceInfo>? priceInfo;
  final String guestPaymentStatus;
  final String hostPaymentStatus;
  final String status;
  final String cancellationReason;
  final bool hostReviewDone;
  final bool guestReviewDone;
  final List<CalendarInfo>? calendarInfo;
  final String chatRoomId;
  final String? appliedCouponCode;
  final String? appliedCouponType;
  final String discountAmountApplied;
  final String priceAfterDiscount;
  final String? invoicePdf;
  final DateTime? invoiceGeneratedAt;
  final Guest? guest;
  final int? host;
  final Listing? listing;
  final String? appliedReferralCoupon;
  final dynamic appliedAdminCoupon;

  BookingData2({
    required this.id,
    required this.reviews,
    this.originalPriceBeforeDiscount,
    this.totalDiscountAmount,
    this.accommodationCharge,
    this.subtotalBeforeGenericCoupon,
    this.lengthOfStayDiscountPercent,
    this.lengthOfStayDiscountAmount,
    this.createdAt,
    this.updatedAt,
    required this.invoiceNo,
    required this.pgwTransactionNumber,
    required this.reservationCode,
    this.checkIn,
    this.checkOut,
    required this.nightCount,
    required this.childrenCount,
    required this.infantCount,
    required this.adultCount,
    required this.guestCount,
    required this.price,
    required this.guestServiceCharge,
    required this.totalPrice,
    required this.paidAmount,
    required this.hostServiceCharge,
    required this.hostPayOut,
    required this.totalProfit,
    required this.gatewayFee,
    required this.refundAmount,
    required this.isRefunded,
    this.priceInfo,
    required this.guestPaymentStatus,
    required this.hostPaymentStatus,
    required this.status,
    required this.cancellationReason,
    required this.hostReviewDone,
    required this.guestReviewDone,
    this.calendarInfo,
    required this.chatRoomId,
    this.appliedCouponCode,
    this.appliedCouponType,
    required this.discountAmountApplied,
    required this.priceAfterDiscount,
    this.invoicePdf,
    this.invoiceGeneratedAt,
    this.guest,
    this.host,
    this.listing,
    this.appliedReferralCoupon,
    this.appliedAdminCoupon,
  });

  factory BookingData2.fromJson(Map<String, dynamic> json) {
    Map<String, PriceInfo> priceInfoMap = {};
    if (json['price_info'] != null) {
      json['price_info'].forEach((key, value) {
        if (value != null) {
          priceInfoMap[key] = PriceInfo.fromJson(value);
        }
      });
    }

    return BookingData2(
      id: json['id'] ?? 0,
      reviews: json['reviews'] ?? [],
      originalPriceBeforeDiscount: (json['original_price_before_discount'] as num?)?.toDouble(),
      totalDiscountAmount: (json['total_discount_amount'] as num?)?.toDouble(),
      accommodationCharge: (json['accommodation_charge'] as num?)?.toDouble(),
      subtotalBeforeGenericCoupon: (json['subtotal_before_generic_coupon'] as num?)?.toDouble(),
      lengthOfStayDiscountPercent: (json['length_of_stay_discount_percent'] as num?)?.toDouble(),
      lengthOfStayDiscountAmount: (json['length_of_stay_discount_amount'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      invoiceNo: json['invoice_no'] ?? '',
      pgwTransactionNumber: json['pgw_transaction_number'] ?? '',
      reservationCode: json['reservation_code'] ?? '',
      checkIn: json['check_in'] != null ? DateTime.tryParse(json['check_in']) : null,
      checkOut: json['check_out'] != null ? DateTime.tryParse(json['check_out']) : null,
      nightCount: json['night_count'] ?? 0,
      childrenCount: json['children_count'] ?? 0,
      infantCount: json['infant_count'] ?? 0,
      adultCount: json['adult_count'] ?? 0,
      guestCount: json['guest_count'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      guestServiceCharge: (json['guest_service_charge'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0,
      hostServiceCharge: (json['host_service_charge'] as num?)?.toDouble() ?? 0,
      hostPayOut: (json['host_pay_out'] as num?)?.toDouble() ?? 0,
      totalProfit: (json['total_profit'] as num?)?.toDouble() ?? 0,
      gatewayFee: (json['gateway_fee'] as num?)?.toDouble() ?? 0,
      refundAmount: (json['refund_amount'] as num?)?.toDouble() ?? 0,
      isRefunded: json['is_refunded'] ?? false,
      priceInfo: priceInfoMap.isNotEmpty ? priceInfoMap : null,
      guestPaymentStatus: json['guest_payment_status'] ?? '',
      hostPaymentStatus: json['host_payment_status'] ?? '',
      status: json['status'] ?? '',
      cancellationReason: json['cancellation_reason'] ?? '',
      hostReviewDone: json['host_review_done'] ?? false,
      guestReviewDone: json['guest_review_done'] ?? false,
      calendarInfo: (json['calendar_info'] as List<dynamic>?)
          ?.map((e) => CalendarInfo.fromJson(e))
          .toList(),
      chatRoomId: json['chat_room_id'] ?? '',
      appliedCouponCode: json['applied_coupon_code'],
      appliedCouponType: json['applied_coupon_type'],
      discountAmountApplied: json['discount_amount_applied'] ?? '0.00',
      priceAfterDiscount: json['price_after_discount'] ?? '0.00',
      invoicePdf: json['invoice_pdf'],
      invoiceGeneratedAt: json['invoice_generated_at'] != null
          ? DateTime.tryParse(json['invoice_generated_at'])
          : null,
      guest: json['guest'] != null ? Guest.fromJson(json['guest']) : null,
      host: json['host'],
      listing: json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      appliedReferralCoupon: json['applied_referral_coupon'],
      appliedAdminCoupon: json['applied_admin_coupon'],
    );
  }
}

class PriceInfo {
  final int id;
  final String note;
  final double price;
  final bool isBooked;
  final bool isBlocked;
  final Map<String, dynamic>? bookingData;
  final double originalCalendarPrice;

  PriceInfo({
    required this.id,
    required this.note,
    required this.price,
    required this.isBooked,
    required this.isBlocked,
    this.bookingData,
    required this.originalCalendarPrice,
  });

factory PriceInfo.fromJson(Map<String, dynamic> json) {
  return PriceInfo(
    id: json['id'] ?? 0,
    note: json['note'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0,
    isBooked: json['is_booked'] ?? false,
    isBlocked: json['is_blocked'] ?? false,
    bookingData: json['booking_data'] is Map
        ? Map<String, dynamic>.from(json['booking_data'])
        : null,
    originalCalendarPrice: (json['original_calendar_price'] as num?)?.toDouble() ?? 0,
  );
}
}

class CalendarInfo {
  final double price;
  final DateTime? endDate;
  final bool isBooked;
  final double basePrice;
  final bool isBlocked;
  final int listingId;
  final DateTime? startDate;

  CalendarInfo({
    required this.price,
    this.endDate,
    required this.isBooked,
    required this.basePrice,
    required this.isBlocked,
    required this.listingId,
    this.startDate,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
      price: (json['price'] as num?)?.toDouble() ?? 0,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isBooked: json['is_booked'] ?? false,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0,
      isBlocked: json['is_blocked'] ?? false,
      listingId: json['listing_id'] ?? 0,
      startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
    );
  }
}

class Guest {
  final int id;
  final String fullName;
  final String phoneNumber;

  Guest({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}

class Listing {
  final int id;
  final String title;
  final String coverPhoto;
  final String address;
  final CancellationPolicy? cancellationPolicy;
  final double avgRating;
  final int totalRatingCount;

  Listing({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.address,
    this.cancellationPolicy,
    required this.avgRating,
    required this.totalRatingCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      address: json['address'] ?? '',
      cancellationPolicy: json['cancellation_policy'] != null
          ? CancellationPolicy.fromJson(json['cancellation_policy'])
          : null,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      totalRatingCount: json['total_rating_count'] ?? 0,
    );
  }
}

class CancellationPolicy {
  final int id;
  final String description;
  final String policyName;
  final int refundPercentage;
  final int cancellationDeadline;

  CancellationPolicy({
    required this.id,
    required this.description,
    required this.policyName,
    required this.refundPercentage,
    required this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      policyName: json['policy_name'] ?? '',
      refundPercentage: json['refund_percentage'] ?? 0,
      cancellationDeadline: json['cancellation_deadline'] ?? 0,
    );
  }
}

// Hello I am Tamim