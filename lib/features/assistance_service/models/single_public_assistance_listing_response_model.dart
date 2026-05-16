import 'dart:convert';

import 'dart:convert';

class SinglePublicAssistanceListingResponseModel {
  final int? status;
  final String? message;
  final PublicAssistanceData? data;
  final DateTime? timestamp;

  SinglePublicAssistanceListingResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory SinglePublicAssistanceListingResponseModel.fromRawJson(String str) => SinglePublicAssistanceListingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SinglePublicAssistanceListingResponseModel.fromJson(Map<String, dynamic> json) => SinglePublicAssistanceListingResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : PublicAssistanceData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class PublicAssistanceData {
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
  final int? price;
  final int? extraChargePerPerson;
  final String? coverPhoto;
  final String? verifiedStatus;
  final List<String>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final CoverageArea? currentLocation;
  final String? currentLocationName;
  final CoverageArea? meetupPoint;
  final String? meetupPointName;
  final CoverageArea? coverageArea;
  final String? coverageAreaName;
  final int? cancellationPolicyId;
  final dynamic deletedAt;
  final int? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;
  final Host? host;
  final Map<String, CalendarDatum>? calendarData;
  final double? serviceChargePercentage;
  final List<Review>? reviews;
  final CancellationPolicy? cancellationPolicy;

  PublicAssistanceData({
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
    this.host,
    this.calendarData,
    this.serviceChargePercentage,
    this.reviews,
    this.cancellationPolicy,
  });

  factory PublicAssistanceData.fromRawJson(String str) => PublicAssistanceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PublicAssistanceData.fromJson(Map<String, dynamic> json) => PublicAssistanceData(
    id: json["id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    status: json["status"],
    isEnableMultipleDateSelection: json["is_enable_multiple_date_selection"],
    instantBookingAllowed: json["instant_booking_allowed"],
    currentLocation: json["current_location"] == null ? null : CoverageArea.fromJson(json["current_location"]),
    currentLocationName: json["current_location_name"],
    meetupPoint: json["meetup_point"] == null ? null : CoverageArea.fromJson(json["meetup_point"]),
    meetupPointName: json["meetup_point_name"],
    coverageArea: json["coverage_area"] == null ? null : CoverageArea.fromJson(json["coverage_area"]),
    coverageAreaName: json["coverage_area_name"],
    cancellationPolicyId: json["cancellation_policy_id"],
    deletedAt: json["deletedAt"],
    avgRating: json["avg_rating"],
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
    host: json["host"] == null ? null : Host.fromJson(json["host"]),
    calendarData: Map.from(json["calendar_data"]!).map((k, v) => MapEntry<String, CalendarDatum>(k, CalendarDatum.fromJson(v))),
    serviceChargePercentage: json["service_charge_percentage"]?.toDouble(),
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    cancellationPolicy: json["cancellation_policy"] == null ? null : CancellationPolicy.fromJson(json["cancellation_policy"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
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
    "host": host?.toJson(),
    "calendar_data": Map.from(calendarData!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "service_charge_percentage": serviceChargePercentage,
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
    "cancellation_policy": cancellationPolicy?.toJson(),
  };
}

class CalendarDatum {
  final int? id;
  final int? price;
  final bool? isBlocked;
  final bool? isBooked;
  final List<BookingDatum>? bookingData;
  final String? note;

  CalendarDatum({
    this.id,
    this.price,
    this.isBlocked,
    this.isBooked,
    this.bookingData,
    this.note,
  });

  factory CalendarDatum.fromRawJson(String str) => CalendarDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalendarDatum.fromJson(Map<String, dynamic> json) => CalendarDatum(
    id: json["id"],
    price: json["price"],
    isBlocked: json["isBlocked"],
    isBooked: json["isBooked"],
    bookingData: json["bookingData"] == null ? [] : List<BookingDatum>.from(json["bookingData"]!.map((x) => BookingDatum.fromJson(x))),
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "isBlocked": isBlocked,
    "isBooked": isBooked,
    "bookingData": bookingData == null ? [] : List<dynamic>.from(bookingData!.map((x) => x.toJson())),
    "note": note,
  };
}

class BookingDatum {
  final User? user;
  final Booking? booking;

  BookingDatum({
    this.user,
    this.booking,
  });

  factory BookingDatum.fromRawJson(String str) => BookingDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDatum.fromJson(Map<String, dynamic> json) => BookingDatum(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "booking": booking?.toJson(),
  };
}

class Booking {
  final String? invoiceNo;

  Booking({
    this.invoiceNo,
  });

  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    invoiceNo: json["invoice_no"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_no": invoiceNo,
  };
}

class User {
  final String? id;
  final String? image;
  final String? fullName;

  User({
    this.id,
    this.image,
    this.fullName,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
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

  factory CancellationPolicy.fromRawJson(String str) => CancellationPolicy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
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

class CoverageArea {
  final String? type;
  final List<double>? coordinates;

  CoverageArea({
    this.type,
    this.coordinates,
  });

  factory CoverageArea.fromRawJson(String str) => CoverageArea.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoverageArea.fromJson(Map<String, dynamic> json) => CoverageArea(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class Host {
  final int? id;
  final DateTime? lastLogin;
  final bool? isSuperuser;
  final String? username;
  final String? firstName;
  final String? lastName;
  final bool? isStaff;
  final DateTime? dateJoined;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? image;
  final String? phoneNumber;
  final bool? isActive;
  final String? status;
  final String? uType;
  final String? role;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? identityVerificationStatus;
  final String? identityVerificationMethod;
  final IdentityVerificationImages? identityVerificationImages;
  final String? identityVerificationRejectReason;
  final String? countryCode;
  final double? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;
  final int? totalProperty;
  final double? totalSellAmount;
  final List<dynamic>? wishlistListings;
  final int? pointsBalance;
  final String? hostReferralCreditBalance;
  final dynamic currentSuperhostTier;
  final dynamic superhostMetricsUpdatedAt;
  final int? lifetimeReferralPointsEarned;
  final String? lifetimeReferralTakaEarned;
  final bool? isAvailableForCohosting;
  final bool? isDeleted;

  Host({
    this.id,
    this.lastLogin,
    this.isSuperuser,
    this.username,
    this.firstName,
    this.lastName,
    this.isStaff,
    this.dateJoined,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.image,
    this.phoneNumber,
    this.isActive,
    this.status,
    this.uType,
    this.role,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.identityVerificationStatus,
    this.identityVerificationMethod,
    this.identityVerificationImages,
    this.identityVerificationRejectReason,
    this.countryCode,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
    this.totalProperty,
    this.totalSellAmount,
    this.wishlistListings,
    this.pointsBalance,
    this.hostReferralCreditBalance,
    this.currentSuperhostTier,
    this.superhostMetricsUpdatedAt,
    this.lifetimeReferralPointsEarned,
    this.lifetimeReferralTakaEarned,
    this.isAvailableForCohosting,
    this.isDeleted,
  });

  factory Host.fromRawJson(String str) => Host.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"],
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
    isSuperuser: json["is_superuser"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    isStaff: json["is_staff"],
    dateJoined: json["date_joined"] == null ? null : DateTime.parse(json["date_joined"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    email: json["email"],
    image: json["image"],
    phoneNumber: json["phone_number"],
    isActive: json["is_active"],
    status: json["status"],
    uType: json["u_type"],
    role: json["role"],
    isPhoneVerified: json["is_phone_verified"],
    isEmailVerified: json["is_email_verified"],
    identityVerificationStatus: json["identity_verification_status"],
    identityVerificationMethod: json["identity_verification_method"],
    identityVerificationImages: json["identity_verification_images"] == null ? null : IdentityVerificationImages.fromJson(json["identity_verification_images"]),
    identityVerificationRejectReason: json["identity_verification_reject_reason"],
    countryCode: json["country_code"],
    avgRating: json["avg_rating"]?.toDouble(),
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
    totalProperty: json["total_property"],
    totalSellAmount: json["total_sell_amount"]?.toDouble(),
    wishlistListings: json["wishlist_listings"] == null ? [] : List<dynamic>.from(json["wishlist_listings"]!.map((x) => x)),
    pointsBalance: json["points_balance"],
    hostReferralCreditBalance: json["host_referral_credit_balance"],
    currentSuperhostTier: json["current_superhost_tier"],
    superhostMetricsUpdatedAt: json["superhost_metrics_updated_at"],
    lifetimeReferralPointsEarned: json["lifetime_referral_points_earned"],
    lifetimeReferralTakaEarned: json["lifetime_referral_taka_earned"],
    isAvailableForCohosting: json["is_available_for_cohosting"],
    isDeleted: json["is_deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_login": lastLogin?.toIso8601String(),
    "is_superuser": isSuperuser,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "is_staff": isStaff,
    "date_joined": dateJoined?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "email": email,
    "image": image,
    "phone_number": phoneNumber,
    "is_active": isActive,
    "status": status,
    "u_type": uType,
    "role": role,
    "is_phone_verified": isPhoneVerified,
    "is_email_verified": isEmailVerified,
    "identity_verification_status": identityVerificationStatus,
    "identity_verification_method": identityVerificationMethod,
    "identity_verification_images": identityVerificationImages?.toJson(),
    "identity_verification_reject_reason": identityVerificationRejectReason,
    "country_code": countryCode,
    "avg_rating": avgRating,
    "total_rating_sum": totalRatingSum,
    "total_rating_count": totalRatingCount,
    "total_property": totalProperty,
    "total_sell_amount": totalSellAmount,
    "wishlist_listings": wishlistListings == null ? [] : List<dynamic>.from(wishlistListings!.map((x) => x)),
    "points_balance": pointsBalance,
    "host_referral_credit_balance": hostReferralCreditBalance,
    "current_superhost_tier": currentSuperhostTier,
    "superhost_metrics_updated_at": superhostMetricsUpdatedAt,
    "lifetime_referral_points_earned": lifetimeReferralPointsEarned,
    "lifetime_referral_taka_earned": lifetimeReferralTakaEarned,
    "is_available_for_cohosting": isAvailableForCohosting,
    "is_deleted": isDeleted,
  };
}

class IdentityVerificationImages {
  final dynamic backImage;
  final String? frontImage;

  IdentityVerificationImages({
    this.backImage,
    this.frontImage,
  });

  factory IdentityVerificationImages.fromRawJson(String str) => IdentityVerificationImages.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IdentityVerificationImages.fromJson(Map<String, dynamic> json) => IdentityVerificationImages(
    backImage: json["back_image"],
    frontImage: json["front_image"],
  );

  Map<String, dynamic> toJson() => {
    "back_image": backImage,
    "front_image": frontImage,
  };
}

class Review {
  final int? id;
  final int? rating;
  final String? review;
  final DateTime? reviewDate;
  final String? reviewTimeString;
  final ReviewBy? reviewBy;

  Review({
    this.id,
    this.rating,
    this.review,
    this.reviewDate,
    this.reviewTimeString,
    this.reviewBy,
  });

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    rating: json["rating"],
    review: json["review"],
    reviewDate: json["review_date"] == null ? null : DateTime.parse(json["review_date"]),
    reviewTimeString: json["review_time_string"],
    reviewBy: json["review_by"] == null ? null : ReviewBy.fromJson(json["review_by"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "review": review,
    "review_date": reviewDate?.toIso8601String(),
    "review_time_string": reviewTimeString,
    "review_by": reviewBy?.toJson(),
  };
}

class ReviewBy {
  final int? id;
  final String? name;
  final String? image;

  ReviewBy({
    this.id,
    this.name,
    this.image,
  });

  factory ReviewBy.fromRawJson(String str) => ReviewBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewBy.fromJson(Map<String, dynamic> json) => ReviewBy(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

// Hello I am Tamim