import 'dart:convert';

/// Root API response
class AssistanceReservationListResponse {
  final int status;
  final String message;
  final List<AssistanceReservationBookData> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  AssistanceReservationListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory AssistanceReservationListResponse.fromJson(Map<String, dynamic> json) {
    // Normalize data to a list even if API returns a single object
    List<AssistanceReservationBookData> dataList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List)
            .map((e) => AssistanceReservationBookData.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['data'] is Map<String, dynamic>) {
        dataList = [AssistanceReservationBookData.fromJson(json['data'] as Map<String, dynamic>)];
      }
    }

    return AssistanceReservationListResponse(
      status: (json['status'] is num) ? (json['status'] as num).toInt() : 0,
      message: json['message'] as String? ?? '',
      data: dataList,
      total: (json['total'] is num) ? (json['total'] as num).toInt() : 0,
      page: (json['page'] is num) ? (json['page'] as num).toInt() : 0,
      limit: (json['limit'] is num) ? (json['limit'] as num).toInt() : 0,
      totalPages: (json['totalPages'] is num) ? (json['totalPages'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((d) => d.toJson()).toList(),
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
  };
}

/// Single reservation
class AssistanceReservationBookData {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? invoiceNo;
  final String? guestId;
  final String? hostId;
  final String? reservationCode;
  final int? listingId;
  final String? pgwTransactionNumber;
  final Listing? listing;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? nightCount;
  final int? guestCount;
  final int? price;
  final int? guestServiceCharge;
  final int? totalPrice;
  final int? paidAmount;
  final Map<String, PriceInfoDay>? priceInfo;
  final int? hostServiceCharge;
  final int? hostPayOut;
  final int? totalProfit;
  final List<CalendarInfo>? calendarInfo;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;
  final String? chatRoomId;
  final String? cancellationReason;
  final bool? guestReviewDone;
  final bool? hostReviewDone;
  final String? appliedCouponCode;
  final int? discountAmountApplied;
  final int? priceAfterDiscount;
  final int? refundAmount;
  final bool? isRefunded;
  final String? phoneNumber;
  final String? location;
  final int? extraGuestCount;
  final int? extraGuestCharge;
  final DateTime? expiresAt;
  final Guest? guest;

  AssistanceReservationBookData({
    required this.id,
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

  factory AssistanceReservationBookData.fromJson(Map<String, dynamic> json) {
    Map<String, PriceInfoDay>? priceInfo;
    if (json['price_info'] != null && json['price_info'] is Map) {
      priceInfo = <String, PriceInfoDay>{};
      (json['price_info'] as Map<String, dynamic>).forEach((key, value) {
        priceInfo![key] = PriceInfoDay.fromJson(value as Map<String, dynamic>);
      });
    }

    return AssistanceReservationBookData(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      invoiceNo: json['invoice_no'] as String?,
      guestId: json['guest_id']?.toString(),
      hostId: json['host_id']?.toString(),
      reservationCode: json['reservation_code'] as String?,
      listingId: (json['listing_id'] is num) ? (json['listing_id'] as num).toInt() : null,
      pgwTransactionNumber: json['pgw_transaction_number'] as String?,
      listing: json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      checkIn: json['check_in'] != null ? DateTime.tryParse(json['check_in']) : null,
      checkOut: json['check_out'] != null ? DateTime.tryParse(json['check_out']) : null,
      nightCount: (json['night_count'] is num) ? (json['night_count'] as num).toInt() : null,
      guestCount: (json['guest_count'] is num) ? (json['guest_count'] as num).toInt() : null,
      price: (json['price'] is num) ? (json['price'] as num).toInt() : null,
      guestServiceCharge: (json['guest_service_charge'] is num)
          ? (json['guest_service_charge'] as num).toInt()
          : null,
      totalPrice: (json['total_price'] is num) ? (json['total_price'] as num).toInt() : null,
      paidAmount: (json['paid_amount'] is num) ? (json['paid_amount'] as num).toInt() : null,
      priceInfo: priceInfo,
      hostServiceCharge: (json['host_service_charge'] is num)
          ? (json['host_service_charge'] as num).toInt()
          : null,
      hostPayOut:
      (json['host_pay_out'] is num) ? (json['host_pay_out'] as num).toInt() : null,
      totalProfit:
      (json['total_profit'] is num) ? (json['total_profit'] as num).toInt() : null,
      calendarInfo: (json['calendar_info'] as List<dynamic>?)
          ?.map((e) => CalendarInfo.fromJson(e))
          .toList(),
      guestPaymentStatus: json['guest_payment_status'] as String?,
      hostPaymentStatus: json['host_payment_status'] as String?,
      status: json['status'] as String?,
      chatRoomId: json['chat_room_id'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      guestReviewDone: json['guest_review_done'] as bool?,
      hostReviewDone: json['host_review_done'] as bool?,
      appliedCouponCode: json['applied_coupon_code'] as String?,
      discountAmountApplied: (json['discount_amount_applied'] is num)
          ? (json['discount_amount_applied'] as num).toInt()
          : null,
      priceAfterDiscount: (json['price_after_discount'] is num)
          ? (json['price_after_discount'] as num).toInt()
          : null,
      refundAmount: (json['refund_amount'] is num) ? (json['refund_amount'] as num).toInt() : null,
      isRefunded: json['is_refunded'] as bool?,
      phoneNumber: json['phone_number'] as String?,
      location: json['location'] as String?,
      extraGuestCount: (json['extra_guest_count'] is num)
          ? (json['extra_guest_count'] as num).toInt()
          : null,
      extraGuestCharge: (json['extra_guest_charge'] is num)
          ? (json['extra_guest_charge'] as num).toInt()
          : null,
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      guest: json['guest'] != null ? Guest.fromJson(json['guest']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'invoice_no': invoiceNo,
    'guest_id': guestId,
    'host_id': hostId,
    'reservation_code': reservationCode,
    'listing_id': listingId,
    'pgw_transaction_number': pgwTransactionNumber,
    'listing': listing?.toJson(),
    'check_in': checkIn?.toIso8601String(),
    'check_out': checkOut?.toIso8601String(),
    'night_count': nightCount,
    'guest_count': guestCount,
    'price': price,
    'guest_service_charge': guestServiceCharge,
    'total_price': totalPrice,
    'paid_amount': paidAmount,
    'price_info': priceInfo?.map((k, v) => MapEntry(k, v.toJson())),
    'host_service_charge': hostServiceCharge,
    'host_pay_out': hostPayOut,
    'total_profit': totalProfit,
    'calendar_info': calendarInfo?.map((c) => c.toJson()).toList(),
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
    'expires_at': expiresAt?.toIso8601String(),
    'guest': guest?.toJson(),
  };
}

// You can keep all your nested classes (Listing, GeoPoint, PriceInfoDay, BookingDataItem, CalendarInfo, Guest) as-is from your original code


/// Listing nested object
class Listing {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uniqueId;
  final int? hostId;
  final int? categoryId;
  final int? aSubCategoryId;
  final String? title;
  final String? aboutYou;
  final String? details;
  final String? assistanceDescription;
  final int? maxPerson;
  final int? price;
  final int? extraChargePerPerson;
  final String? coverPhoto;
  final String? verifiedStatus;
  final List<dynamic>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final GeoPoint? currentLocation;
  final String? currentLocationName;
  final GeoPoint? meetupPoint;
  final String? meetupPointName;
  final GeoPoint? coverageArea;
  final String? coverageAreaName;
  final int? cancellationPolicyId;
  final DateTime? deletedAt;
  final num? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;

  Listing({
    required this.id,
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
    this.currentLocationName,
    this.meetupPoint,
    this.meetupPointName,
    this.coverageArea,
    this.coverageAreaName,
    this.cancellationPolicyId,
    this.deletedAt,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    GeoPoint? parsePoint(Map<String, dynamic>? p) {
      if (p == null) return null;
      return GeoPoint.fromJson(p);
    }

    return Listing(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      hostId: (json['host_id'] is num) ? (json['host_id'] as num).toInt() : null,
      categoryId: (json['category_id'] is num) ? (json['category_id'] as num).toInt() : null,
      aSubCategoryId: (json['a_sub_category_id'] is num)
          ? (json['a_sub_category_id'] as num).toInt()
          : null,
      title: json['title'] as String?,
      aboutYou: json['about_you'] as String?,
      details: json['details'] as String?,
      assistanceDescription: json['assistance_description'] as String?,
      maxPerson: (json['max_person'] is num) ? (json['max_person'] as num).toInt() : null,
      price: (json['price'] is num) ? (json['price'] as num).toInt() : null,
      extraChargePerPerson: (json['extra_charge_per_person'] is num)
          ? (json['extra_charge_per_person'] as num).toInt()
          : null,
      coverPhoto: json['cover_photo'] as String?,
      verifiedStatus: json['verified_status'] as String?,
      images: json['images'] as List<dynamic>?,
      status: json['status'] as String?,
      isEnableMultipleDateSelection: json['is_enable_multiple_date_selection'] as bool?,
      instantBookingAllowed: json['instant_booking_allowed'] as bool?,
      currentLocation: parsePoint(json['current_location'] as Map<String, dynamic>?),
      currentLocationName: json['current_location_name'] as String?,
      meetupPoint: parsePoint(json['meetup_point'] as Map<String, dynamic>?),
      meetupPointName: json['meetup_point_name'] as String?,
      coverageArea: parsePoint(json['coverage_area'] as Map<String, dynamic>?),
      coverageAreaName: json['coverage_area_name'] as String?,
      cancellationPolicyId: (json['cancellation_policy_id'] is num)
          ? (json['cancellation_policy_id'] as num).toInt()
          : null,
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
      avgRating: (json['avg_rating'] is num) ? (json['avg_rating'] as num).toDouble() : null,
      totalRatingSum: (json['total_rating_sum'] is num)
          ? (json['total_rating_sum'] as num).toInt()
          : null,
      totalRatingCount: (json['total_rating_count'] is num)
          ? (json['total_rating_count'] as num).toInt()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'uniqueId': uniqueId,
    'host_id': hostId,
    'category_id': categoryId,
    'a_sub_category_id': aSubCategoryId,
    'title': title,
    'about_you': aboutYou,
    'details': details,
    'assistance_description': assistanceDescription,
    'max_person': maxPerson,
    'price': price,
    'extra_charge_per_person': extraChargePerPerson,
    'cover_photo': coverPhoto,
    'verified_status': verifiedStatus,
    'images': images,
    'status': status,
    'is_enable_multiple_date_selection': isEnableMultipleDateSelection,
    'instant_booking_allowed': instantBookingAllowed,
    'current_location': currentLocation?.toJson(),
    'current_location_name': currentLocationName,
    'meetup_point': meetupPoint?.toJson(),
    'meetup_point_name': meetupPointName,
    'coverage_area': coverageArea?.toJson(),
    'coverage_area_name': coverageAreaName,
    'cancellation_policy_id': cancellationPolicyId,
    'deletedAt': deletedAt?.toIso8601String(),
    'avg_rating': avgRating,
    'total_rating_sum': totalRatingSum,
    'total_rating_count': totalRatingCount,
  };
}

class GeoPoint {
  final String? type;
  final List<num>? coordinates;

  GeoPoint({this.type, this.coordinates});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => e as num)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };
}

class PriceInfoDay {
  final int id;
  final String? note;
  final int price;
  final bool isBooked;
  final bool isBlocked;
  final List<BookingDataItem>? bookingData;

  PriceInfoDay({
    required this.id,
    this.note,
    required this.price,
    required this.isBooked,
    required this.isBlocked,
    this.bookingData,
  });

  factory PriceInfoDay.fromJson(Map<String, dynamic> json) {
    return PriceInfoDay(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      note: json['note'] as String?,
      price: (json['price'] is num) ? (json['price'] as num).toInt() : 0,
      isBooked: json['is_booked'] as bool? ?? false,
      isBlocked: json['is_blocked'] as bool? ?? false,
      bookingData: (json['booking_data'] as List<dynamic>?)
          ?.map((e) => BookingDataItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'note': note,
    'price': price,
    'is_booked': isBooked,
    'is_blocked': isBlocked,
    'booking_data': bookingData?.map((e) => e.toJson()).toList(),
  };
}

class BookingDataItem {
  final int id;
  final String? reservationCode;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;

  BookingDataItem({
    required this.id,
    this.reservationCode,
    this.guestPaymentStatus,
    this.hostPaymentStatus,
  });

  factory BookingDataItem.fromJson(Map<String, dynamic> json) {
    return BookingDataItem(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      reservationCode: json['reservation_code'] as String?,
      guestPaymentStatus: json['guest_payment_status'] as String?,
      hostPaymentStatus: json['host_payment_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'reservation_code': reservationCode,
    'guest_payment_status': guestPaymentStatus,
    'host_payment_status': hostPaymentStatus,
  };
}

class CalendarInfo {
  final String? date;
  final bool? isAvailable;
  final bool? isBlocked;

  CalendarInfo({this.date, this.isAvailable, this.isBlocked});

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
      date: json['date'] as String?,
      isAvailable: json['is_available'] as bool?,
      isBlocked: json['is_blocked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'is_available': isAvailable,
    'is_blocked': isBlocked,
  };
}

class Guest {
  final int? id;
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
  final int? totalSellAmount;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? countryCode;
  final double? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;

  Guest({
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

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] != null
          ? int.tryParse(json['id'].toString())
          : null,
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      image: json['image'] as String?,
      phoneNumber: json['phone_Number'] as String?,
      isActive: json['is_Active'] as bool?,
      status: json['status'] as String?,
      uType: json['uType'] as String?,
      role: json['role'] as String?,
      totalSellAmount: (json['total_sell_amount'] is num)
          ? (json['total_sell_amount'] as num).toInt()
          : null,
      isPhoneVerified: json['is_phone_verified'] as bool?,
      isEmailVerified: json['is_email_verified'] as bool?,
      countryCode: json['country_code'] as String?,
      avgRating: (json['avg_rating'] is num)
          ? (json['avg_rating'] as num).toDouble()
          : null,
      totalRatingSum: (json['total_rating_sum'] is num)
          ? (json['total_rating_sum'] as num).toInt()
          : null,
      totalRatingCount: (json['total_rating_count'] is num)
          ? (json['total_rating_count'] as num).toInt()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'image': image,
    'phoneNumber': phoneNumber,
    'isActive': isActive,
    'status': status,
    'uType': uType,
    'role': role,
    'total_sell_amount': totalSellAmount,
    'isPhoneVerified': isPhoneVerified,
    'isEmailVerified': isEmailVerified,
    'countryCode': countryCode,
    'avg_rating': avgRating,
    'total_rating_sum': totalRatingSum,
    'total_rating_count': totalRatingCount,
  };
}


// Hello I am Tamim