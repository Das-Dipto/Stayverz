class AssistanceBookingModel {
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
  final DateTime? checkIn;
  final DateTime? checkOut;
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
  final DateTime? expiresAt;
  final HostInfo? hostInfo;
  final GuestInfo? guestInfo;
  final List<ReviewData>? reviewData;
  final CancellationPolicy? cancellationPolicy;

  // Assistance preference
  final String? assistance;

  AssistanceBookingModel({
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
    this.hostInfo,
    this.guestInfo,
    this.reviewData,
    this.cancellationPolicy,
    this.assistance,
  });

  factory AssistanceBookingModel.fromJson(Map<String, dynamic> json) {
    return AssistanceBookingModel(
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
      listing:
      json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      checkIn:
      json['check_in'] != null ? DateTime.parse(json['check_in']) : null,
      checkOut:
      json['check_out'] != null ? DateTime.parse(json['check_out']) : null,
      nightCount: json['night_count'],
      guestCount: json['guest_count'],
      price: (json['price'] as num?)?.toDouble(),
      guestServiceCharge: (json['guest_service_charge'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      priceInfo: json['price_info'] != null
          ? (json['price_info'] as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, PriceInfo.fromJson(v)),
      )
          : null,
      hostServiceCharge: (json['host_service_charge'] as num?)?.toDouble(),
      hostPayOut: (json['host_pay_out'] as num?)?.toDouble(),
      totalProfit: (json['total_profit'] as num?)?.toDouble(),
      calendarInfo: json['calendar_info'] != null
          ? (json['calendar_info'] as List)
          .map((e) => CalendarInfo.fromJson(e))
          .toList()
          : null,
      guestPaymentStatus: json['guest_payment_status'],
      hostPaymentStatus: json['host_payment_status'],
      status: json['status'],
      chatRoomId: json['chat_room_id'],
      cancellationReason: json['cancellation_reason'],
      guestReviewDone: json['guest_review_done'],
      hostReviewDone: json['host_review_done'],
      appliedCouponCode: json['applied_coupon_code'],
      discountAmountApplied: (json['discount_amount_applied'] as num?)?.toDouble(),
      priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
      refundAmount: (json['refund_amount'] as num?)?.toDouble(),
      isRefunded: json['is_refunded'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      extraGuestCount: json['extra_guest_count'],
      extraGuestCharge: (json['extra_guest_charge'] as num?)?.toDouble(),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      hostInfo: json['hostInfo'] != null ? HostInfo.fromJson(json['hostInfo']) : null,
      guestInfo: json['guestInfo'] != null ? GuestInfo.fromJson(json['guestInfo']) : null,
      reviewData: json['review_data'] != null
          ? (json['review_data'] as List)
          .map((e) => ReviewData.fromJson(e))
          .toList()
          : null,
      cancellationPolicy: json['cancellation_policy'] != null
          ? CancellationPolicy.fromJson(json['cancellation_policy'])
          : null,
      assistance: json['listing']?['assistance_description'],
    );
  }
}

// Example of nested classes with null safety
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
  final List<String>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final LocationPoint? currentLocation;
  final String? currentLocationName;
  final LocationPoint? meetupPoint;
  final String? meetupPointName;
  final LocationPoint? coverageArea;
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

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
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
      price: (json['price'] as num?)?.toDouble(),
      extraChargePerPerson: (json['extra_charge_per_person'] as num?)?.toDouble(),
      coverPhoto: json['cover_photo'],
      verifiedStatus: json['verified_status'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      status: json['status'],
      isEnableMultipleDateSelection: json['is_enable_multiple_date_selection'],
      instantBookingAllowed: json['instant_booking_allowed'],
      currentLocation: json['current_location'] != null
          ? LocationPoint.fromJson(json['current_location'])
          : null,
      currentLocationName: json['current_location_name'],
      meetupPoint: json['meetup_point'] != null
          ? LocationPoint.fromJson(json['meetup_point'])
          : null,
      meetupPointName: json['meetup_point_name'],
      coverageArea: json['coverage_area'] != null
          ? LocationPoint.fromJson(json['coverage_area'])
          : null,
      coverageAreaName: json['coverage_area_name'],
      cancellationPolicyId: json['cancellation_policy_id'],
      deletedAt:
      json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingSum: (json['total_rating_sum'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'],
    );
  }
}

class LocationPoint {
  final String? type;
  final List<double>? coordinates;

  LocationPoint({this.type, this.coordinates});

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from((json['coordinates'] as List).map((x) => x.toDouble()))
          : null,
    );
  }
}


class PriceInfo {
  final int? id;
  final double? price;

  PriceInfo({this.id, this.price});

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      id: json['id'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

class CalendarInfo {
  final double? price;
  final double? basePrice;
  final DateTime? startDate;
  final DateTime? endDate;

  CalendarInfo({this.price, this.basePrice, this.startDate, this.endDate});

  factory CalendarInfo.fromJson(Map<String, dynamic> json) {
    return CalendarInfo(
      price: (json['price'] as num?)?.toDouble(),
      basePrice: (json['base_price'] as num?)?.toDouble(),
      startDate:
      json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate:
      json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }
}

class HostInfo {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? image;

  HostInfo({this.id, this.firstName, this.lastName, this.image});

  factory HostInfo.fromJson(Map<String, dynamic> json) {
    return HostInfo(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
    );
  }
}

class GuestInfo {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? phoneNumber;
  final String? identityVerificationStatus;

  GuestInfo({this.id, this.firstName, this.lastName, this.image, this.phoneNumber, this.identityVerificationStatus});

  factory GuestInfo.fromJson(Map<String, dynamic> json) {
    return GuestInfo(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      phoneNumber: json['phone_number'],
      identityVerificationStatus: json['identity_verification_status'],
    );
  }
}


class ReviewData {
  final int? id;
  final String? fullName;
  final String? image;
  final String? review;
  final double? rating;

  ReviewData({this.id, this.fullName, this.image, this.review, this.rating});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'],
      fullName: json['full_name'],
      image: json['image'],
      review: json['review'],
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
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

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'],
      policyName: json['policy_name'],
      description: json['description'],
      refundPercentage: json['refund_percentage'],
      cancellationDeadline: json['cancellation_deadline'],
    );
  }
}

// Hello I am Tamim