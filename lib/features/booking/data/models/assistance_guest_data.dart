class AssistanceGuestDataNew {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
  final double? price;
  final double? guestServiceCharge;
  final double? totalPrice;
  final double? paidAmount;
  final Map<String, PriceInfo>? priceInfo;
  final double? hostServiceCharge;
  final double? hostPayOut;
  final double? totalProfit;
  final List<CalendarInfo>? calendarInfo;
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
  final Guest? guest;
  final Host? host;
  final List<dynamic>? reviewData;
  final CancellationPolicy? cancellationPolicy;

  AssistanceGuestDataNew({
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

  factory AssistanceGuestDataNew.fromJson(
    Map<String, dynamic> json,
  ) => AssistanceGuestDataNew(
    id: json['id'],
    createdAt:
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt:
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    invoiceNo: json['invoice_no'],
    guestId: json['guest_id'],
    hostId: json['host_id'],
    reservationCode: json['reservation_code'],
    listingId: json['listing_id'],
    pgwTransactionNumber: json['pgw_transaction_number'],
    listing: json['listing'] != null ? Listing.fromJson(json['listing']) : null,
    checkIn: json['check_in'],
    checkOut: json['check_out'],
    nightCount: json['night_count'],
    guestCount: json['guest_count'],
    price: (json['price'] != null) ? json['price'].toDouble() : null,
    guestServiceCharge:
        (json['guest_service_charge'] != null)
            ? json['guest_service_charge'].toDouble()
            : null,
    totalPrice:
        (json['total_price'] != null) ? json['total_price'].toDouble() : null,
    paidAmount:
        (json['paid_amount'] != null) ? json['paid_amount'].toDouble() : null,
    priceInfo:
        json['price_info'] != null
            ? (json['price_info'] as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, PriceInfo.fromJson(v)),
            )
            : null,
    hostServiceCharge:
        (json['host_service_charge'] != null)
            ? json['host_service_charge'].toDouble()
            : null,
    hostPayOut:
        (json['host_pay_out'] != null) ? json['host_pay_out'].toDouble() : null,
    totalProfit:
        (json['total_profit'] != null) ? json['total_profit'].toDouble() : null,
    calendarInfo:
        json['calendar_info'] != null
            ? List<CalendarInfo>.from(
              json['calendar_info'].map((x) => CalendarInfo.fromJson(x)),
            )
            : null,
    guestPaymentStatus: json['guest_payment_status'],
    hostPaymentStatus: json['host_payment_status'],
    status: json['status'],
    chatRoomId: json['chat_room_id'],
    cancellationReason: json['cancellation_reason'],
    guestReviewDone: json['guest_review_done'],
    hostReviewDone: json['host_review_done'],
    appliedCouponCode: json['applied_coupon_code'],
    discountAmountApplied:
        (json['discount_amount_applied'] != null)
            ? json['discount_amount_applied'].toDouble()
            : null,
    priceAfterDiscount:
        (json['price_after_discount'] != null)
            ? json['price_after_discount'].toDouble()
            : null,
    refundAmount:
        (json['refund_amount'] != null)
            ? json['refund_amount'].toDouble()
            : null,
    isRefunded: json['is_refunded'],
    phoneNumber: json['phone_number'],
    location: json['location'],
    extraGuestCount: json['extra_guest_count'],
    extraGuestCharge:
        (json['extra_guest_charge'] != null)
            ? json['extra_guest_charge'].toDouble()
            : null,
    expiresAt: json['expires_at'],
    guest: json['guest'] != null ? Guest.fromJson(json['guest']) : null,
    host: json['host'] != null ? Host.fromJson(json['host']) : null,
    reviewData: json['review_data'] ?? [],
    cancellationPolicy:
        json['cancellation_policy'] != null
            ? CancellationPolicy.fromJson(json['cancellation_policy'])
            : null,
  );
}

// Nested Models

class Listing {
  final int? id;
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
  final double? price;
  final double? extraChargePerPerson;
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
  final double? avgRating;
  final double? totalRatingSum;
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
    id: json['id'],
    createdAt:
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt:
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    uniqueId: json['uniqueId'],
    hostId: json['host_id'],
    categoryId: json['category_id'],
    aSubCategoryId: json['a_sub_category_id'],
    title: json['title'],
    aboutYou: json['about_you'],
    details: json['details'],
    assistanceDescription: json['assistance_description'],
    maxPerson: json['max_person'],
    price: (json['price'] != null) ? json['price'].toDouble() : null,
    extraChargePerPerson:
        (json['extra_charge_per_person'] != null)
            ? json['extra_charge_per_person'].toDouble()
            : null,
    coverPhoto: json['cover_photo'],
    verifiedStatus: json['verified_status'],
    images: json['images'] ?? [],
    status: json['status'],
    isEnableMultipleDateSelection: json['is_enable_multiple_date_selection'],
    instantBookingAllowed: json['instant_booking_allowed'],
    currentLocation:
        json['current_location'] != null
            ? GeoPoint.fromJson(json['current_location'])
            : null,
    currentLocationName: json['current_location_name'],
    meetupPoint:
        json['meetup_point'] != null
            ? GeoPoint.fromJson(json['meetup_point'])
            : null,
    meetupPointName: json['meetup_point_name'],
    coverageArea:
        json['coverage_area'] != null
            ? GeoPoint.fromJson(json['coverage_area'])
            : null,
    coverageAreaName: json['coverage_area_name'],
    cancellationPolicyId: json['cancellation_policy_id'],
    deletedAt:
        json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    avgRating:
        (json['avg_rating'] != null) ? json['avg_rating'].toDouble() : null,
    totalRatingSum:
        (json['total_rating_sum'] != null)
            ? json['total_rating_sum'].toDouble()
            : null,
    totalRatingCount: json['total_rating_count'],
  );
}

class GeoPoint {
  final String? type;
  final List<double>? coordinates;

  GeoPoint({this.type, this.coordinates});

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
    type: json['type'],
    coordinates:
        json['coordinates'] != null
            ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
            : null,
  );
}

class PriceInfo {
  final int? id;
  final String? note;
  final double? price;
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
    id: json['id'],
    note: json['note'],
    price: (json['price'] != null) ? json['price'].toDouble() : null,
    isBooked: json['isBooked'],
    isBlocked: json['isBlocked'],
    bookingData:
        json['bookingData'] != null
            ? List<BookingData>.from(
              json['bookingData'].map((x) => BookingData.fromJson(x)),
            )
            : [],
  );
}

class BookingData {
  final User? user;
  final Booking? booking;

  BookingData({this.user, this.booking});

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    booking: json['booking'] != null ? Booking.fromJson(json['booking']) : null,
  );
}

class User {
  final String? id;
  final String? image;
  final String? fullName;

  User({this.id, this.image, this.fullName});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], image: json['image'], fullName: json['full_name']);
}

class Booking {
  final String? invoiceNo;

  Booking({this.invoiceNo});

  factory Booking.fromJson(Map<String, dynamic> json) =>
      Booking(invoiceNo: json['invoice_no']);
}

class CalendarInfo {
  final double? price;
  final String? startDate;
  final String? endDate;
  final double? basePrice;

  CalendarInfo({this.price, this.startDate, this.endDate, this.basePrice});

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
    price: (json['price'] != null) ? json['price'].toDouble() : null,
    startDate: json['start_date'],
    endDate: json['end_date'],
    basePrice:
        (json['base_price'] != null) ? json['base_price'].toDouble() : null,
  );
}

class Guest {
  final int? id;
  final String? firstName;
  final String? lastName;
  final DateTime? createdAt;
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
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    createdAt:
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    image: json['image'],
    phoneNumber: json['phone_number'],
    identityVerificationStatus: json['identity_verification_status'],
  );
}

class Host {
  final int? id;
  final String? firstName;
  final String? lastName;
  final DateTime? createdAt;
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
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    createdAt:
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    image: json['image'],
    phoneNumber: json['phone_number'],
    identityVerificationStatus: json['identity_verification_status'],
  );
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
        id: json['id'],
        policyName: json['policy_name'],
        description: json['description'],
        refundPercentage: json['refund_percentage'],
        cancellationDeadline: json['cancellation_deadline'],
      );
}

// Hello I am Tamim