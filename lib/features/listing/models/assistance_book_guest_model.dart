class AssistanceGuestResponse {
  final int? status;
  final String? message;
  final List<AssistanceGuestData>? data;
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  AssistanceGuestResponse({
    this.status,
    this.message,
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory AssistanceGuestResponse.fromJson(Map<String, dynamic> json) {
    final dataContainer = json['data'] as Map<String, dynamic>?;

    return AssistanceGuestResponse(
      status: json['status'],
      message: json['message'],
      data: dataContainer?['data'] != null
          ? List<AssistanceGuestData>.from(
        (dataContainer!['data'] as List)
            .map((e) => AssistanceGuestData.fromJson(e)),
      )
          : [],
      total: dataContainer?['total'],
      page: dataContainer?['page'],
      limit: dataContainer?['limit'],
      totalPages: dataContainer?['totalPages'],
    );
  }
}

class AssistanceGuestData {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? invoiceNo;
  final String? guestId;
  final String? hostId;
  final String? reservationCode;
  final int? listingId;
  final String? pgwTransactionNumber;
  final AssistanceGuestListing? listing;
  final String? checkIn;
  final String? checkOut;
  final int? nightCount;
  final int? guestCount;
  final double? price;
  final double? guestServiceCharge;
  final double? totalPrice;
  final double? paidAmount;
  final Map<String, AssistanceGuestPriceInfo>? priceInfo;
  final double? hostServiceCharge;
  final double? hostPayOut;
  final double? totalProfit;
  final List<AssistanceGuestCalendarInfo>? calendarInfo;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;
  final String? chatRoomId;
  final String? cancellationReason;
  final bool? guestReviewDone;
  final bool? hostReviewDone;
  final String? appliedCouponCode;
  final double? discountAmountApplied;
  final double? priceAfterDiscount;
  final double? refundAmount;
  final bool? isRefunded;
  final String? phoneNumber;
  final String? location;
  final int? extraGuestCount;
  final double? extraGuestCharge;
  final String? expiresAt;
  final AssistanceGuestUser? guest;

  AssistanceGuestData({
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
    this.guest,
  });

  factory AssistanceGuestData.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestData(
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
          json['listing'] != null
              ? AssistanceGuestListing.fromJson(json['listing'])
              : null,
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      nightCount: json['night_count'],
      guestCount: json['guest_count'],
      price: (json['price'] as num?)?.toDouble(),
      guestServiceCharge: (json['guest_service_charge'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      priceInfo:
          json['price_info'] != null
              ? (json['price_info'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, AssistanceGuestPriceInfo.fromJson(v)),
              )
              : {},
      hostServiceCharge: (json['host_service_charge'] as num?)?.toDouble(),
      hostPayOut: (json['host_pay_out'] as num?)?.toDouble(),
      totalProfit: (json['total_profit'] as num?)?.toDouble(),
      calendarInfo:
          json['calendar_info'] != null
              ? (json['calendar_info'] as List)
                  .map((e) => AssistanceGuestCalendarInfo.fromJson(e))
                  .toList()
              : [],
      guestPaymentStatus: json['guest_payment_status'],
      hostPaymentStatus: json['host_payment_status'],
      status: json['status'],
      chatRoomId: json['chat_room_id'],
      cancellationReason: json['cancellation_reason'],
      guestReviewDone: json['guest_review_done'] ?? false,
      hostReviewDone: json['host_review_done'] ?? false,
      appliedCouponCode: json['applied_coupon_code'],
      discountAmountApplied:
          (json['discount_amount_applied'] as num?)?.toDouble() ?? 0,
      priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
      refundAmount: (json['refund_amount'] as num?)?.toDouble() ?? 0,
      isRefunded: json['is_refunded'] ?? false,
      phoneNumber: json['phone_number'],
      location: json['location'],
      extraGuestCount: json['extra_guest_count'] ?? 0,
      extraGuestCharge: (json['extra_guest_charge'] as num?)?.toDouble() ?? 0,
      expiresAt: json['expires_at'],
      guest:
          json['guest'] != null
              ? AssistanceGuestUser.fromJson(json['guest'])
              : null,
    );
  }
}

class AssistanceGuestListing {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? uniqueId;
  final int? hostId;
  final int? categoryId;
  final int? aSubCategoryId;
  final String? title;
  final String? aboutYou;
  final String? details;
  final String? assistanceDescription;
  final int? maxPerson;
  final double? price;
  final double? extraChargePerPerson;
  final String? coverPhoto;
  final String? verifiedStatus;
  final List<String>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final GeoPoint? currentLocation;
  final GeoPoint? meetupPoint;
  final GeoPoint? coverageArea;
  final String? currentLocationName;
  final String? meetupPointName;
  final String? coverageAreaName;
  final double? avgRating;
  final double? totalRatingSum;
  final int? totalRatingCount;

  AssistanceGuestListing({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.uniqueId,
    this.hostId,
    this.categoryId,
    this.aSubCategoryId,
    this.title,
    this.aboutYou,
    this.details,
    this.assistanceDescription,
    this.maxPerson,
    this.price,
    this.extraChargePerPerson,
    this.coverPhoto,
    this.verifiedStatus,
    this.images,
    this.status,
    this.isEnableMultipleDateSelection,
    this.instantBookingAllowed,
    this.currentLocation,
    this.meetupPoint,
    this.coverageArea,
    this.currentLocationName,
    this.meetupPointName,
    this.coverageAreaName,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
  });

  factory AssistanceGuestListing.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestListing(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      uniqueId: json['uniqueId'],
      hostId: json['host_id'],
      categoryId: json['category_id'],
      aSubCategoryId: json['a_sub_category_id'],
      title: json['title'],
      aboutYou: json['about_you'],
      details: json['details'],
      assistanceDescription: json['assistance_description'],
      maxPerson: json['max_person'],
      price: (json['price'] as num?)?.toDouble(),
      extraChargePerPerson:
          (json['extra_charge_per_person'] as num?)?.toDouble(),
      coverPhoto: json['cover_photo'],
      verifiedStatus: json['verified_status'],
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'],
      isEnableMultipleDateSelection: json['is_enable_multiple_date_selection'],
      instantBookingAllowed: json['instant_booking_allowed'],
      currentLocation:
          json['current_location'] != null
              ? GeoPoint.fromJson(json['current_location'])
              : null,
      meetupPoint:
          json['meetup_point'] != null
              ? GeoPoint.fromJson(json['meetup_point'])
              : null,
      coverageArea:
          json['coverage_area'] != null
              ? GeoPoint.fromJson(json['coverage_area'])
              : null,
      currentLocationName: json['current_location_name'],
      meetupPointName: json['meetup_point_name'],
      coverageAreaName: json['coverage_area_name'],
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingSum: (json['total_rating_sum'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'],
    );
  }
}

class GeoPoint {
  final String? type;
  final List<double>? coordinates;

  GeoPoint({this.type, this.coordinates});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      type: json['type'],
      coordinates:
          (json['coordinates'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList(),
    );
  }
}

class AssistanceGuestPriceInfo {
  final int? id;
  final String? note;
  final double? price;
  final bool? isBooked;
  final bool? isBlocked;
  final List<AssistanceGuestBookingData>? bookingData;

  AssistanceGuestPriceInfo({
    this.id,
    this.note,
    this.price,
    this.isBooked,
    this.isBlocked,
    this.bookingData,
  });

  factory AssistanceGuestPriceInfo.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestPriceInfo(
      id: json['id'],
      note: json['note'],
      price: (json['price'] as num?)?.toDouble(),
      isBooked: json['isBooked'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      bookingData:
          json['bookingData'] != null
              ? (json['bookingData'] as List)
                  .map((e) => AssistanceGuestBookingData.fromJson(e))
                  .toList()
              : [],
    );
  }
}

class AssistanceGuestBookingData {
  final AssistanceGuestUser? user;
  final AssistanceGuestBooking? booking;

  AssistanceGuestBookingData({this.user, this.booking});

  factory AssistanceGuestBookingData.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestBookingData(
      user:
          json['user'] != null
              ? AssistanceGuestUser.fromJson(json['user'])
              : null,
      booking:
          json['booking'] != null
              ? AssistanceGuestBooking.fromJson(json['booking'])
              : null,
    );
  }
}

class AssistanceGuestBooking {
  final String? invoiceNo;

  AssistanceGuestBooking({this.invoiceNo});

  factory AssistanceGuestBooking.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestBooking(invoiceNo: json['invoice_no']);
  }
}

class AssistanceGuestCalendarInfo {
  final double? price;
  final String? startDate;
  final String? endDate;
  final double? basePrice;

  AssistanceGuestCalendarInfo({
    this.price,
    this.startDate,
    this.endDate,
    this.basePrice,
  });

  factory AssistanceGuestCalendarInfo.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestCalendarInfo(
      price: (json['price'] as num?)?.toDouble(),
      startDate: json['start_date'],
      endDate: json['end_date'],
      basePrice: (json['base_price'] as num?)?.toDouble(),
    );
  }
}

class AssistanceGuestUser {
  final String? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? phoneNumber;
  final bool? isActive;
  final String? status;
  final String? uType;
  final String? role;
  final double? totalSellAmount;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? countryCode;
  final double? avgRating;
  final double? totalRatingSum;
  final int? totalRatingCount;

  AssistanceGuestUser({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    this.phoneNumber,
    this.isActive,
    this.status,
    this.uType,
    this.role,
    this.totalSellAmount,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.countryCode,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
  });

  factory AssistanceGuestUser.fromJson(Map<String, dynamic> json) {
    return AssistanceGuestUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'],
      status: json['status'],
      uType: json['uType'],
      role: json['role'],
      totalSellAmount: (json['total_sell_amount'] as num?)?.toDouble(),
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      countryCode: json['countryCode'],
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingSum: (json['total_rating_sum'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'],
    );
  }
}

// Hello I am Tamim