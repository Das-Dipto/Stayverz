class AssistanceBook {
  final int? status;
  final String? message;
  final AssistanceBookData? data;
  final String? timestamp;

  AssistanceBook({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceBook.fromJson(Map<String, dynamic> json) => AssistanceBook(
    status: json["status"],
    message: json["message"],
    data:
    json["data"] == null ? null : AssistanceBookData.fromJson(json["data"]),
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp,
  };
}

class AssistanceBookData {
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
  final int? price;
  final int? guestServiceCharge;
  final int? totalPrice;
  final int? paidAmount;
  final Map<String, PriceInfo>? priceInfo;
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
  final String? expiresAt;
  final Guest? guest;
  final Host? host;
  final List<ReviewData>? reviewData;
  final CancellationPolicy? cancellationPolicy;

  AssistanceBookData({
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
    this.host,
    this.reviewData,
    this.cancellationPolicy,
  });

  factory AssistanceBookData.fromJson(Map<String, dynamic> json) =>
      AssistanceBookData(
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        invoiceNo: json["invoice_no"],
        guestId: json["guest_id"],
        hostId: json["host_id"],
        reservationCode: json["reservation_code"],
        listingId: json["listing_id"],
        pgwTransactionNumber: json["pgw_transaction_number"],
        listing:
        json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        checkIn: json["check_in"],
        checkOut: json["check_out"],
        nightCount: json["night_count"],
        guestCount: json["guest_count"],
        price: json["price"],
        guestServiceCharge: json["guest_service_charge"],
        totalPrice: json["total_price"],
        paidAmount: json["paid_amount"],
        priceInfo: json["price_info"] == null
            ? null
            : Map.from(json["price_info"]).map(
                (k, v) => MapEntry<String, PriceInfo>(k, PriceInfo.fromJson(v))),
        hostServiceCharge: json["host_service_charge"],
        hostPayOut: json["host_pay_out"],
        totalProfit: json["total_profit"],
        calendarInfo: json["calendar_info"] == null
            ? []
            : List<CalendarInfo>.from(
            json["calendar_info"].map((x) => CalendarInfo.fromJson(x))),
        guestPaymentStatus: json["guest_payment_status"],
        hostPaymentStatus: json["host_payment_status"],
        status: json["status"],
        chatRoomId: json["chat_room_id"],
        cancellationReason: json["cancellation_reason"],
        guestReviewDone: json["guest_review_done"],
        hostReviewDone: json["host_review_done"],
        appliedCouponCode: json["applied_coupon_code"],
        discountAmountApplied: json["discount_amount_applied"],
        priceAfterDiscount: json["price_after_discount"],
        refundAmount: json["refund_amount"],
        isRefunded: json["is_refunded"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        extraGuestCount: json["extra_guest_count"],
        extraGuestCharge: json["extra_guest_charge"],
        expiresAt: json["expires_at"],
        guest: json["guest"] == null ? null : Guest.fromJson(json["guest"]),
        host: json["host"] == null ? null : Host.fromJson(json["host"]),
        reviewData: json["review_data"] == null
            ? []
            : List<ReviewData>.from(
            json["review_data"].map((x) => ReviewData.fromJson(x))),
        cancellationPolicy: json["cancellation_policy"] == null
            ? null
            : CancellationPolicy.fromJson(json["cancellation_policy"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "invoice_no": invoiceNo,
    "guest_id": guestId,
    "host_id": hostId,
    "reservation_code": reservationCode,
    "listing_id": listingId,
    "pgw_transaction_number": pgwTransactionNumber,
    "listing": listing?.toJson(),
    "check_in": checkIn,
    "check_out": checkOut,
    "night_count": nightCount,
    "guest_count": guestCount,
    "price": price,
    "guest_service_charge": guestServiceCharge,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "price_info": priceInfo == null
        ? null
        : Map.from(priceInfo!)
        .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "host_service_charge": hostServiceCharge,
    "host_pay_out": hostPayOut,
    "total_profit": totalProfit,
    "calendar_info": calendarInfo == null
        ? []
        : calendarInfo!.map((x) => x.toJson()).toList(),
    "guest_payment_status": guestPaymentStatus,
    "host_payment_status": hostPaymentStatus,
    "status": status,
    "chat_room_id": chatRoomId,
    "cancellation_reason": cancellationReason,
    "guest_review_done": guestReviewDone,
    "host_review_done": hostReviewDone,
    "applied_coupon_code": appliedCouponCode,
    "discount_amount_applied": discountAmountApplied,
    "price_after_discount": priceAfterDiscount,
    "refund_amount": refundAmount,
    "is_refunded": isRefunded,
    "phone_number": phoneNumber,
    "location": location,
    "extra_guest_count": extraGuestCount,
    "extra_guest_charge": extraGuestCharge,
    "expires_at": expiresAt,
    "guest": guest?.toJson(),
    "host": host?.toJson(),
    "review_data":
    reviewData == null ? [] : reviewData!.map((x) => x.toJson()).toList(),
    "cancellation_policy": cancellationPolicy?.toJson(),
  };
}

class ReviewData {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final int? listingId;
  final int? bookingId;
  final String? image;
  final String? fullName;
  final int? reviewById;
  final int? reviewForId;
  final int? rating;
  final String? review;
  final bool? isGuestReview;
  final bool? isHostReview;

  ReviewData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.listingId,
    this.bookingId,
    this.image,
    this.fullName,
    this.reviewById,
    this.reviewForId,
    this.rating,
    this.review,
    this.isGuestReview,
    this.isHostReview,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    listingId: json["listing_id"],
    bookingId: json["booking_id"],
    image: json["image"],
    fullName: json["full_name"],
    reviewById: json["review_by_id"],
    reviewForId: json["review_for_id"],
    rating: json["rating"],
    review: json["review"],
    isGuestReview: json["is_guest_review"],
    isHostReview: json["is_host_review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "listing_id": listingId,
    "booking_id": bookingId,
    "image": image,
    "full_name": fullName,
    "review_by_id": reviewById,
    "review_for_id": reviewForId,
    "rating": rating,
    "review": review,
    "is_guest_review": isGuestReview,
    "is_host_review": isHostReview,
  };
}


class Listing {
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
  final int? price;
  final int? extraChargePerPerson;
  final String? coverPhoto;
  final String? verifiedStatus;
  final List<dynamic>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final LocationData? currentLocation;
  final String? currentLocationName;
  final LocationData? meetupPoint;
  final String? meetupPointName;
  final LocationData? coverageArea;
  final String? coverageAreaName;
  final int? cancellationPolicyId;
  final String? deletedAt;
  final int? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;

  Listing({
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

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    uniqueId: json["uniqueId"],
    hostId: json["host_id"],
    categoryId: json["category_id"],
    aSubCategoryId: json["a_sub_category_id"],
    title: json["title"],
    aboutYou: json["about_you"],
    details: json["details"],
    assistanceDescription: json["assistance_description"],
    maxPerson: json["max_person"],
    price: json["price"],
    extraChargePerPerson: json["extra_charge_per_person"],
    coverPhoto: json["cover_photo"],
    verifiedStatus: json["verified_status"],
    images: json["images"] ?? [],
    status: json["status"],
    isEnableMultipleDateSelection:
    json["is_enable_multiple_date_selection"],
    instantBookingAllowed: json["instant_booking_allowed"],
    currentLocation: json["current_location"] == null
        ? null
        : LocationData.fromJson(json["current_location"]),
    currentLocationName: json["current_location_name"],
    meetupPoint: json["meetup_point"] == null
        ? null
        : LocationData.fromJson(json["meetup_point"]),
    meetupPointName: json["meetup_point_name"],
    coverageArea: json["coverage_area"] == null
        ? null
        : LocationData.fromJson(json["coverage_area"]),
    coverageAreaName: json["coverage_area_name"],
    cancellationPolicyId: json["cancellation_policy_id"],
    deletedAt: json["deletedAt"],
    avgRating: json["avg_rating"],
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "uniqueId": uniqueId,
    "host_id": hostId,
    "category_id": categoryId,
    "a_sub_category_id": aSubCategoryId,
    "title": title,
    "about_you": aboutYou,
    "details": details,
    "assistance_description": assistanceDescription,
    "max_person": maxPerson,
    "price": price,
    "extra_charge_per_person": extraChargePerPerson,
    "cover_photo": coverPhoto,
    "verified_status": verifiedStatus,
    "images": images ?? [],
    "status": status,
    "is_enable_multiple_date_selection": isEnableMultipleDateSelection,
    "instant_booking_allowed": instantBookingAllowed,
    "current_location": currentLocation?.toJson(),
    "current_location_name": currentLocationName,
    "meetup_point": meetupPoint?.toJson(),
    "meetup_point_name": meetupPointName,
    "coverage_area": coverageArea?.toJson(),
    "coverage_area_name": coverageAreaName,
    "cancellation_policy_id": cancellationPolicyId,
    "deletedAt": deletedAt,
    "avg_rating": avgRating,
    "total_rating_sum": totalRatingSum,
    "total_rating_count": totalRatingCount,
  };
}

class LocationData {
  final String? type;
  final List<double>? coordinates;

  LocationData({
    this.type,
    this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    type: json["type"],
    coordinates:
    json["coordinates"] == null ? [] : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates ?? [],
  };
}

class PriceInfo {
  final int? id;
  final String? note;
  final int? price;
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

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
    id: json["id"],
    note: json["note"],
    price: json["price"],
    isBooked: json["isBooked"],
    isBlocked: json["isBlocked"],
    bookingData: json["bookingData"] == null
        ? []
        : List<BookingData>.from(
        json["bookingData"].map((x) => BookingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "price": price,
    "isBooked": isBooked,
    "isBlocked": isBlocked,
    "bookingData":
    bookingData == null ? [] : bookingData!.map((x) => x.toJson()).toList(),
  };
}

class BookingData {
  final BookingUser? user;
  final BookingInfo? booking;

  BookingData({
    this.user,
    this.booking,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    user: json["user"] == null ? null : BookingUser.fromJson(json["user"]),
    booking: json["booking"] == null
        ? null
        : BookingInfo.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "booking": booking?.toJson(),
  };
}

class BookingUser {
  final String? id;
  final String? image;
  final String? fullName;

  BookingUser({
    this.id,
    this.image,
    this.fullName,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) => BookingUser(
    id: json["id"],
    image: json["image"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "full_name": fullName,
  };
}

class BookingInfo {
  final String? invoiceNo;

  BookingInfo({this.invoiceNo});

  factory BookingInfo.fromJson(Map<String, dynamic> json) => BookingInfo(
    invoiceNo: json["invoice_no"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_no": invoiceNo,
  };
}

class CalendarInfo {
  final int? price;
  final String? endDate;
  final int? basePrice;
  final String? startDate;

  CalendarInfo({
    this.price,
    this.endDate,
    this.basePrice,
    this.startDate,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
    price: json["price"],
    endDate: json["end_date"],
    basePrice: json["base_price"],
    startDate: json["start_date"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "end_date": endDate,
    "base_price": basePrice,
    "start_date": startDate,
  };
}

class Guest {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? image;
  final String? phoneNumber;
  final String? identityVerificationStatus;

  Guest({
    this.id,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.image,
    this.phoneNumber,
    this.identityVerificationStatus,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    createdAt: json["created_at"],
    image: json["image"],
    phoneNumber: json["phone_number"],
    identityVerificationStatus: json["identity_verification_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "created_at": createdAt,
    "image": image,
    "phone_number": phoneNumber,
    "identity_verification_status": identityVerificationStatus,
  };
}

class Host {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? image;
  final String? phoneNumber;
  final String? identityVerificationStatus;

  Host({
    this.id,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.image,
    this.phoneNumber,
    this.identityVerificationStatus,
  });

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    createdAt: json["created_at"],
    image: json["image"],
    phoneNumber: json["phone_number"],
    identityVerificationStatus: json["identity_verification_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "created_at": createdAt,
    "image": image,
    "phone_number": phoneNumber,
    "identity_verification_status": identityVerificationStatus,
  };
}

class CancellationPolicy {
  final int? id;
  final String? policyName;
  final String? description;
  final int? refundPercentage;
  final int? cancellationDeadline;

  CancellationPolicy({
    this.id,
    this.policyName,
    this.description,
    this.refundPercentage,
    this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      CancellationPolicy(
        id: json["id"],
        policyName: json["policy_name"],
        description: json["description"],
        refundPercentage: json["refund_percentage"],
        cancellationDeadline: json["cancellation_deadline"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "policy_name": policyName,
    "description": description,
    "refund_percentage": refundPercentage,
    "cancellation_deadline": cancellationDeadline,
  };
}

// Hello I am Tamim