class RoomReservation {
  final int id;
  final List<Review> reviews;
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
  final String cancellationReason;
  final bool hostReviewDone;
  final bool guestReviewDone;
  final List<CalendarInfo> calendarInfo;
  final String chatRoomId;
  final String? appliedCouponCode;
  final String? appliedCouponType;
  final double discountAmountApplied;
  final String? priceAfterDiscount;
  final String? invoicePdf;
  final String? invoiceGeneratedAt;
  final Guest guest;
  final int host;
  final Listing listing;
  final dynamic appliedReferralCoupon;
  final int? appliedAdminCoupon;

  RoomReservation({
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
    required this.cancellationReason,
    required this.hostReviewDone,
    required this.guestReviewDone,
    required this.calendarInfo,
    required this.chatRoomId,
    required this.appliedCouponCode,
    required this.appliedCouponType,
    required this.discountAmountApplied,
    required this.priceAfterDiscount,
    required this.invoicePdf,
    required this.invoiceGeneratedAt,
    required this.guest,
    required this.host,
    required this.listing,
    required this.appliedReferralCoupon,
    required this.appliedAdminCoupon,
  });

  factory RoomReservation.fromJson(Map<String, dynamic> json) {
    return RoomReservation(
      id: json['id'] ?? 0,
      reviews: (json['reviews'] as List? ?? []).map((e) => Review.fromJson(e)).toList(),
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
      price: (json['price'] ?? 0).toDouble(),
      guestServiceCharge: (json['guest_service_charge'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      hostServiceCharge: (json['host_service_charge'] ?? 0).toDouble(),
      hostPayOut: (json['host_pay_out'] ?? 0).toDouble(),
      totalProfit: (json['total_profit'] ?? 0).toDouble(),
      gatewayFee: (json['gateway_fee'] ?? 0).toDouble(),
      refundAmount: (json['refund_amount'] ?? 0).toDouble(),
      isRefunded: json['is_refunded'] ?? false,
      priceInfo: (json['price_info'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, PriceInfo.fromJson(v))),
      guestPaymentStatus: json['guest_payment_status'] ?? '',
      hostPaymentStatus: json['host_payment_status'] ?? '',
      status: json['status'] ?? '',
      cancellationReason: json['cancellation_reason'] ?? '',
      hostReviewDone: json['host_review_done'] ?? false,
      guestReviewDone: json['guest_review_done'] ?? false,
      calendarInfo: (json['calendar_info'] as List? ?? [])
          .map((e) => CalendarInfo.fromJson(e))
          .toList(),
      chatRoomId: json['chat_room_id'] ?? '',
      appliedCouponCode: json['applied_coupon_code'],
      appliedCouponType: json['applied_coupon_type'],
      discountAmountApplied: double.tryParse(json['discount_amount_applied']?.toString() ?? '0.0') ?? 0.0,
      priceAfterDiscount: json['price_after_discount'],
      invoicePdf: json['invoice_pdf'],
      invoiceGeneratedAt: json['invoice_generated_at'],
      guest: Guest.fromJson(json['guest'] ?? {}),
      host: json['host'] ?? 0,
      listing: Listing.fromJson(json['my_listing'] ?? {}),
      appliedReferralCoupon: json['applied_referral_coupon'],
      appliedAdminCoupon: json['applied_admin_coupon'],
    );
  }
}

class Review {
  final int id;
  final String createdAt;
  final String updatedAt;
  final bool isHostReview;
  final bool isGuestReview;
  final int rating;
  final String review;
  final int listing;
  final int booking;
  final int reviewBy;
  final int reviewFor;

  Review({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isHostReview,
    required this.isGuestReview,
    required this.rating,
    required this.review,
    required this.listing,
    required this.booking,
    required this.reviewBy,
    required this.reviewFor,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isHostReview: json['is_host_review'] ?? false,
      isGuestReview: json['is_guest_review'] ?? false,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      listing: json['my_listing'] ?? 0,
      booking: json['booking'] ?? 0,
      reviewBy: json['review_by'] ?? 0,
      reviewFor: json['review_for'] ?? 0,
    );
  }
}

class PriceInfo {
  final String note;
  final double price;
  final Map<String, dynamic> bookingData;

  PriceInfo({
    required this.note,
    required this.price,
    required this.bookingData,
  });

factory PriceInfo.fromJson(Map<String, dynamic> json) {
  return PriceInfo(
    note: json['note'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    bookingData: json['booking_data'] is Map
        ? Map<String, dynamic>.from(json['booking_data'])
        : {},
  );
}
}

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
      price: (json['price'] ?? 0).toDouble(),
      endDate: json['end_date'] ?? '',
      isBooked: json['is_booked'] ?? false,
      basePrice: (json['base_price'] ?? 0).toDouble(),
      isBlocked: json['is_blocked'] ?? false,
      listingId: json['listing_id'] ?? 0,
      startDate: json['start_date'] ?? '',
    );
  }
}

class Guest {
  final int id;
  final String fullName;
  final String image;
  final String email;
  final String identityVerificationStatus;
  final String status;
  final String bio;
  final String dateJoined;
  final List<dynamic> languages;
  final String address;
  final String phoneNumber;
  final bool isHost;

  Guest({
    required this.id,
    required this.fullName,
    required this.image,
    required this.email,
    required this.identityVerificationStatus,
    required this.status,
    required this.bio,
    required this.dateJoined,
    required this.languages,
    required this.address,
    required this.phoneNumber,
    required this.isHost,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      identityVerificationStatus: json['identity_verification_status'] ?? '',
      status: json['status'] ?? '',
      bio: json['bio'] ?? '',
      dateJoined: json['date_joined'] ?? '',
      languages: json['languages'] ?? [],
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isHost: json['is_host'] ?? false,
    );
  }
}

class Listing {
  final int id;
  final String title;
  final String coverPhoto;
  final String address;
  final CancellationPolicy cancellationPolicy;
  final double avgRating;
  final int totalRatingCount;

  Listing({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.address,
    required this.cancellationPolicy,
    required this.avgRating,
    required this.totalRatingCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      address: json['address'] ?? '',
      cancellationPolicy: CancellationPolicy.fromJson(json['cancellation_policy'] ?? {}),
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
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