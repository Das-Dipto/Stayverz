class BookingModel {
  final int id;
  final List<dynamic> reviews;
  final String createdAt;
  final String updatedAt;
  final String invoiceNo;
  final String pgwTransactionNumber;
  final String reservationCode;
  final String checkIn;
  final String checkOut;
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
  final Map<String, PriceInfo> priceInfo;
  final String guestPaymentStatus;
  final String hostPaymentStatus;
  final String status;
  final String? cancellationReason;
  final bool hostReviewDone;
  final bool guestReviewDone;
  final List<CalendarInfo> calendarInfo;
  final String chatRoomId;
  final String? appliedCouponCode;
  final String? appliedCouponType;
  final String discountAmountApplied;
  final String? priceAfterDiscount;
  final String? invoicePdf;
  final String? invoiceGeneratedAt;
  final int guest;
  final Host host;
  final Listing listing;
  final dynamic appliedReferralCoupon;
  final dynamic appliedAdminCoupon;

  BookingModel({
    required this.id,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
    required this.invoiceNo,
    required this.pgwTransactionNumber,
    required this.reservationCode,
    required this.checkIn,
    required this.checkOut,
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
    required this.priceInfo,
    required this.guestPaymentStatus,
    required this.hostPaymentStatus,
    required this.status,
    this.cancellationReason,
    required this.hostReviewDone,
    required this.guestReviewDone,
    required this.calendarInfo,
    required this.chatRoomId,
    this.appliedCouponCode,
    this.appliedCouponType,
    required this.discountAmountApplied,
    this.priceAfterDiscount,
    this.invoicePdf,
    this.invoiceGeneratedAt,
    required this.guest,
    required this.host,
    required this.listing,
    this.appliedReferralCoupon,
    this.appliedAdminCoupon,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      reviews: json['reviews'] ?? [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      pgwTransactionNumber: json['pgw_transaction_number'] ?? '',
      reservationCode: json['reservation_code'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      nightCount: json['night_count'] ?? 0,
      childrenCount: json['children_count'] ?? 0,
      infantCount: json['infant_count'] ?? 0,
      adultCount: json['adult_count'] ?? 0,
      guestCount: json['guest_count'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      guestServiceCharge: (json['guest_service_charge'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      hostServiceCharge: (json['host_service_charge'] as num?)?.toDouble() ?? 0.0,
      hostPayOut: (json['host_pay_out'] as num?)?.toDouble() ?? 0.0,
      totalProfit: (json['total_profit'] as num?)?.toDouble() ?? 0.0,
      gatewayFee: (json['gateway_fee'] as num?)?.toDouble() ?? 0.0,
      refundAmount: (json['refund_amount'] as num?)?.toDouble() ?? 0.0,
      isRefunded: json['is_refunded'] ?? false,
      priceInfo: (json['price_info'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, PriceInfo.fromJson(v as Map<String, dynamic>))),
      guestPaymentStatus: json['guest_payment_status'] ?? '',
      hostPaymentStatus: json['host_payment_status'] ?? '',
      status: json['status'] ?? '',
      cancellationReason: json['cancellation_reason'],
      hostReviewDone: json['host_review_done'] ?? false,
      guestReviewDone: json['guest_review_done'] ?? false,
      calendarInfo: (json['calendar_info'] as List<dynamic>? ?? [])
          .map((e) => CalendarInfo.fromJson(e as Map<String, dynamic>)).toList(),
      chatRoomId: json['chat_room_id'] ?? '',
      appliedCouponCode: json['applied_coupon_code'],
      appliedCouponType: json['applied_coupon_type'],
      discountAmountApplied: json['discount_amount_applied']?.toString() ?? '0.00',
      priceAfterDiscount: json['price_after_discount']?.toString(),
      invoicePdf: json['invoice_pdf'],
      invoiceGeneratedAt: json['invoice_generated_at'],
      guest: json['guest'] ?? 0,
      host: Host.fromJson(json['host'] ?? {}),
      listing: Listing.fromJson(json['listing'] ?? {}),
      appliedReferralCoupon: json['applied_referral_coupon'],
      appliedAdminCoupon: json['applied_admin_coupon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviews': reviews,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'invoice_no': invoiceNo,
        'pgw_transaction_number': pgwTransactionNumber,
        'reservation_code': reservationCode,
        'check_in': checkIn,
        'check_out': checkOut,
        'night_count': nightCount,
        'children_count': childrenCount,
        'infant_count': infantCount,
        'adult_count': adultCount,
        'guest_count': guestCount,
        'price': price,
        'guest_service_charge': guestServiceCharge,
        'total_price': totalPrice,
        'paid_amount': paidAmount,
        'host_service_charge': hostServiceCharge,
        'host_pay_out': hostPayOut,
        'total_profit': totalProfit,
        'gateway_fee': gatewayFee,
        'refund_amount': refundAmount,
        'is_refunded': isRefunded,
        'price_info': priceInfo.map((k, v) => MapEntry(k, v.toJson())),
        'guest_payment_status': guestPaymentStatus,
        'host_payment_status': hostPaymentStatus,
        'status': status,
        'cancellation_reason': cancellationReason,
        'host_review_done': hostReviewDone,
        'guest_review_done': guestReviewDone,
        'calendar_info': calendarInfo.map((e) => e.toJson()).toList(),
        'chat_room_id': chatRoomId,
        'applied_coupon_code': appliedCouponCode,
        'applied_coupon_type': appliedCouponType,
        'discount_amount_applied': discountAmountApplied,
        'price_after_discount': priceAfterDiscount,
        'invoice_pdf': invoicePdf,
        'invoice_generated_at': invoiceGeneratedAt,
        'guest': guest,
        'host': host.toJson(),
        'listing': listing.toJson(),
        'applied_referral_coupon': appliedReferralCoupon,
        'applied_admin_coupon': appliedAdminCoupon,
      };
}

// --- PriceInfo ---
class PriceInfo {
  final int? id;
  final String? note;
  final double? price;
  final bool? isBooked;
  final bool? isBlocked;
  final Map<String, dynamic>? bookingData;
  final double? originalCalendarPrice;

  PriceInfo({
    this.id,
    this.note,
    this.price,
    this.isBooked,
    this.isBlocked,
    this.bookingData,
    this.originalCalendarPrice,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      id: json['id'],
      note: json['note'],
      price: (json['price'] as num?)?.toDouble(),
      isBooked: json['is_booked'],
      isBlocked: json['is_blocked'],
      bookingData: json['booking_data'] is Map  
      ? Map<String, dynamic>.from(json['booking_data']) 
    : null,
      originalCalendarPrice: (json['original_calendar_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (note != null) 'note': note,
        if (price != null) 'price': price,
        if (isBooked != null) 'is_booked': isBooked,
        if (isBlocked != null) 'is_blocked': isBlocked,
        if (bookingData != null) 'booking_data': bookingData,
        if (originalCalendarPrice != null) 'original_calendar_price': originalCalendarPrice,
      };
}

// --- CalendarInfo ---
class CalendarInfo {
  final int id;
  final double price;
  final String endDate;
  final bool isBooked;
  final double basePrice;
  final bool isBlocked;
  final int listingId;
  final String startDate;

  CalendarInfo({
    required this.id,
    required this.price,
    required this.endDate,
    required this.isBooked,
    required this.basePrice,
    required this.isBlocked,
    required this.listingId,
    required this.startDate,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
      id: json['id'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      endDate: json['end_date'] ?? '',
      isBooked: json['is_booked'] ?? false,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      isBlocked: json['is_blocked'] ?? false,
      listingId: json['listing_id'] ?? 0,
      startDate: json['start_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'end_date': endDate,
        'is_booked': isBooked,
        'base_price': basePrice,
        'is_blocked': isBlocked,
        'listing_id': listingId,
        'start_date': startDate,
      };
}

// --- Host ---
class Host {
  final int id;
  final String fullName;
  final String phoneNumber;

  Host({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone_number': phoneNumber,
      };
}

// --- Listing ---
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
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      totalRatingCount: json['total_rating_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cover_photo': coverPhoto,
        'address': address,
        'cancellation_policy': cancellationPolicy?.toJson(),
        'avg_rating': avgRating,
        'total_rating_count': totalRatingCount,
      };
}

// --- CancellationPolicy ---
class CancellationPolicy {
  final int? id;
  final String? type;
  final String? description;
  final String? policyName;
  final int? refundPercentage;
  final int? cancellationDeadline;

  CancellationPolicy({
    this.id,
    this.type,
    this.description,
    this.policyName,
    this.refundPercentage,
    this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      policyName: json['policy_name'],
      refundPercentage: json['refund_percentage'],
      cancellationDeadline: json['cancellation_deadline'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (type != null) 'type': type,
        if (description != null) 'description': description,
        if (policyName != null) 'policy_name': policyName,
        if (refundPercentage != null) 'refund_percentage': refundPercentage,
        if (cancellationDeadline != null) 'cancellation_deadline': cancellationDeadline,
      };
}

// Hello I am Tamim