class AssistanceTripResponse {
  final int? status;
  final String? message;
  final List<AssistanceTrip>? data;
  final String? timestamp;

  AssistanceTripResponse({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceTripResponse.fromJson(Map<String, dynamic> json) {
    return AssistanceTripResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => AssistanceTrip.fromJson(e))
          .toList(),
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'timestamp': timestamp,
  };
}

class AssistanceTrip {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? invoiceNo;
  final String? guestId;
  final String? hostId;
  final String? reservationCode;
  final int? listingId;
  final String? pgwTransactionNumber;
  final Listing? listing;
  final String? checkIn;
  final String? checkOut;
  final int? nightCount;
  final int? guestCount;
  final num? price;
  final num? guestServiceCharge;
  final num? totalPrice;
  final num? paidAmount;
  final Map<String, PriceInfo>? priceInfo;
  final num? hostServiceCharge;
  final num? hostPayOut;
  final num? totalProfit;
  final List<CalendarInfo>? calendarInfo;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;
  final String? chatRoomId;
  final String? cancellationReason;
  final bool? guestReviewDone;
  final bool? hostReviewDone;
  final String? appliedCouponCode;
  final num? discountAmountApplied;
  final num? priceAfterDiscount;
  final num? refundAmount;
  final bool? isRefunded;
  final String? phoneNumber;
  final String? location;
  final int? extraGuestCount;
  final num? extraGuestCharge;
  final String? expiresAt;

  AssistanceTrip({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.invoiceNo,
    this.guestId,
    this.hostId,
    this.reservationCode,
    this.listingId,
    this.pgwTransactionNumber,
    this.listing,
    this.checkIn,
    this.checkOut,
    this.nightCount,
    this.guestCount,
    this.price,
    this.guestServiceCharge,
    this.totalPrice,
    this.paidAmount,
    this.priceInfo,
    this.hostServiceCharge,
    this.hostPayOut,
    this.totalProfit,
    this.calendarInfo,
    this.guestPaymentStatus,
    this.hostPaymentStatus,
    this.status,
    this.chatRoomId,
    this.cancellationReason,
    this.guestReviewDone,
    this.hostReviewDone,
    this.appliedCouponCode,
    this.discountAmountApplied,
    this.priceAfterDiscount,
    this.refundAmount,
    this.isRefunded,
    this.phoneNumber,
    this.location,
    this.extraGuestCount,
    this.extraGuestCharge,
    this.expiresAt,
  });

  factory AssistanceTrip.fromJson(Map<String, dynamic> json) {
    return AssistanceTrip(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      invoiceNo: json['invoice_no'],
      guestId: json['guest_id'],
      hostId: json['host_id'],
      reservationCode: json['reservation_code'],
      listingId: json['listing_id'],
      pgwTransactionNumber: json['pgw_transaction_number'],
      listing:
      json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      nightCount: json['night_count'],
      guestCount: json['guest_count'],
      price: json['price'],
      guestServiceCharge: json['guest_service_charge'],
      totalPrice: json['total_price'],
      paidAmount: json['paid_amount'],
      priceInfo: (json['price_info'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, PriceInfo.fromJson(v)),
      ),
      hostServiceCharge: json['host_service_charge'],
      hostPayOut: json['host_pay_out'],
      totalProfit: json['total_profit'],
      calendarInfo: (json['calendar_info'] as List?)
          ?.map((e) => CalendarInfo.fromJson(e))
          .toList(),
      guestPaymentStatus: json['guest_payment_status'],
      hostPaymentStatus: json['host_payment_status'],
      status: json['status'],
      chatRoomId: json['chat_room_id'],
      cancellationReason: json['cancellation_reason'],
      guestReviewDone: json['guest_review_done'],
      hostReviewDone: json['host_review_done'],
      appliedCouponCode: json['applied_coupon_code'],
      discountAmountApplied: json['discount_amount_applied'],
      priceAfterDiscount: json['price_after_discount'],
      refundAmount: json['refund_amount'],
      isRefunded: json['is_refunded'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      extraGuestCount: json['extra_guest_count'],
      extraGuestCharge: json['extra_guest_charge'],
      expiresAt: json['expires_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'invoice_no': invoiceNo,
    'guest_id': guestId,
    'host_id': hostId,
    'reservation_code': reservationCode,
    'listing_id': listingId,
    'pgw_transaction_number': pgwTransactionNumber,
    'listing': listing?.toJson(),
    'check_in': checkIn,
    'check_out': checkOut,
    'night_count': nightCount,
    'guest_count': guestCount,
    'price': price,
    'guest_service_charge': guestServiceCharge,
    'total_price': totalPrice,
    'paid_amount': paidAmount,
    'price_info':
    priceInfo?.map((key, value) => MapEntry(key, value.toJson())),
    'host_service_charge': hostServiceCharge,
    'host_pay_out': hostPayOut,
    'total_profit': totalProfit,
    'calendar_info': calendarInfo?.map((e) => e.toJson()).toList(),
    'guest_payment_status': guestPaymentStatus,
    'host_payment_status': hostPaymentStatus,
    'status': status,
    'chat_room_id': chatRoomId,
    'cancellation_reason': cancellationReason,
    'guest_review_done': guestReviewDone,
    'host_review_done': hostReviewDone,
    'applied_coupon_code': appliedCouponCode,
    'discount_amount_applied': discountAmountApplied,
    'price_after_discount': priceAfterDiscount,
    'refund_amount': refundAmount,
    'is_refunded': isRefunded,
    'phone_number': phoneNumber,
    'location': location,
    'extra_guest_count': extraGuestCount,
    'extra_guest_charge': extraGuestCharge,
    'expires_at': expiresAt,
  };
}

class Listing {
  final int? id;
  final String? title;
  final int? hostId;
  final int? categoryId;
  final int? aSubCategoryId;
  final String? aboutYou;
  final String? details;
  final String? assistanceDescription;
  final int? maxPerson;
  final num? price;
  final num? extraChargePerPerson;
  final String? coverPhoto;
  final String? verifiedStatus;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final String? currentLocationName;
  final String? meetupPointName;
  final String? coverageAreaName;
  final num? avgRating;
  final num? totalRatingSum;
  final num? totalRatingCount;

  Listing({
    this.id,
    this.title,
    this.hostId,
    this.categoryId,
    this.aSubCategoryId,
    this.aboutYou,
    this.details,
    this.assistanceDescription,
    this.maxPerson,
    this.price,
    this.extraChargePerPerson,
    this.coverPhoto,
    this.verifiedStatus,
    this.status,
    this.isEnableMultipleDateSelection,
    this.instantBookingAllowed,
    this.currentLocationName,
    this.meetupPointName,
    this.coverageAreaName,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      title: json['title'],
      hostId: json['host_id'],
      categoryId: json['category_id'],
      aSubCategoryId: json['a_sub_category_id'],
      aboutYou: json['about_you'],
      details: json['details'],
      assistanceDescription: json['assistance_description'],
      maxPerson: json['max_person'],
      price: json['price'],
      extraChargePerPerson: json['extra_charge_per_person'],
      coverPhoto: json['cover_photo'],
      verifiedStatus: json['verified_status'],
      status: json['status'],
      isEnableMultipleDateSelection:
      json['is_enable_multiple_date_selection'],
      instantBookingAllowed: json['instant_booking_allowed'],
      currentLocationName: json['current_location_name'],
      meetupPointName: json['meetup_point_name'],
      coverageAreaName: json['coverage_area_name'],
      avgRating: json['avg_rating'],
      totalRatingSum: json['total_rating_sum'],
      totalRatingCount: json['total_rating_count'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'host_id': hostId,
    'category_id': categoryId,
    'a_sub_category_id': aSubCategoryId,
    'about_you': aboutYou,
    'details': details,
    'assistance_description': assistanceDescription,
    'max_person': maxPerson,
    'price': price,
    'extra_charge_per_person': extraChargePerPerson,
    'cover_photo': coverPhoto,
    'verified_status': verifiedStatus,
    'status': status,
    'is_enable_multiple_date_selection': isEnableMultipleDateSelection,
    'instant_booking_allowed': instantBookingAllowed,
    'current_location_name': currentLocationName,
    'meetup_point_name': meetupPointName,
    'coverage_area_name': coverageAreaName,
    'avg_rating': avgRating,
    'total_rating_sum': totalRatingSum,
    'total_rating_count': totalRatingCount,
  };
}

class PriceInfo {
  final int? id;
  final String? note;
  final num? price;
  final bool? isBooked;
  final bool? isBlocked;
  final List<BookingData>? bookingData;

  PriceInfo({
    this.id,
    this.note,
    this.price,
    this.isBooked,
    this.isBlocked,
    this.bookingData,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      id: json['id'],
      note: json['note'],
      price: json['price'],
      isBooked: json['isBooked'],
      isBlocked: json['isBlocked'],
      bookingData: (json['bookingData'] as List?)
          ?.map((e) => BookingData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'note': note,
    'price': price,
    'isBooked': isBooked,
    'isBlocked': isBlocked,
    'bookingData': bookingData?.map((e) => e.toJson()).toList(),
  };
}

class BookingData {
  final UserInfo? user;
  final BookingInfo? booking;

  BookingData({this.user, this.booking});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      booking:
      json['booking'] != null ? BookingInfo.fromJson(json['booking']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'booking': booking?.toJson(),
  };
}

class UserInfo {
  final String? id;
  final String? image;
  final String? fullName;

  UserInfo({this.id, this.image, this.fullName});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      image: json['image'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'full_name': fullName,
  };
}

class BookingInfo {
  final String? invoiceNo;

  BookingInfo({this.invoiceNo});

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(invoiceNo: json['invoice_no']);
  }

  Map<String, dynamic> toJson() => {'invoice_no': invoiceNo};
}

class CalendarInfo {
  final num? price;
  final String? endDate;
  final num? basePrice;
  final String? startDate;

  CalendarInfo({
    this.price,
    this.endDate,
    this.basePrice,
    this.startDate,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
      price: json['price'],
      endDate: json['end_date'],
      basePrice: json['base_price'],
      startDate: json['start_date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'end_date': endDate,
    'base_price': basePrice,
    'start_date': startDate,
  };
}

// Hello I am Tamim