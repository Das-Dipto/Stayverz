import 'dart:convert';

class SingleAssistanceListingResponseModel {
  final int? status;
  final String? message;
  final AssistanceSingleData? data;
  final DateTime? timestamp;

  SingleAssistanceListingResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory SingleAssistanceListingResponseModel.fromRawJson(String str) => SingleAssistanceListingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleAssistanceListingResponseModel.fromJson(Map<String, dynamic> json) => SingleAssistanceListingResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : AssistanceSingleData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class AssistanceSingleData {
  final int? id;
  final String? uniqueId;
  final int? hostId;
  final Category? aCategory;
  final Category? aSubCategory;
  final String? title;
  final String? aboutYou;
  final String? details;
  final String? assistanceDescription;
  final int? maxPerson;
  final double? price;
  final int? extraChargePerPerson;
  final String? coverPhoto;
  final List<String>? images;
  final String? status;
  final bool? isEnableMultipleDateSelection;
  final bool? instantBookingAllowed;
  final String? currentLocationName;
  final String? meetupPointName;
  final String? coverageAreaName;
  final int? cancellationPolicyId;
  final List<Review>? review;
  final int? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;
  final CancellationPolicy? cancellationPolicy;

  AssistanceSingleData({
    this.id,
    this.uniqueId,
    this.hostId,
    this.aCategory,
    this.aSubCategory,
    this.title,
    this.aboutYou,
    this.details,
    this.assistanceDescription,
    this.maxPerson,
    this.price,
    this.extraChargePerPerson,
    this.coverPhoto,
    this.images,
    this.status,
    this.isEnableMultipleDateSelection,
    this.instantBookingAllowed,
    this.currentLocationName,
    this.meetupPointName,
    this.coverageAreaName,
    this.cancellationPolicyId,
    this.review,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
    this.cancellationPolicy,
  });

  factory AssistanceSingleData.fromRawJson(String str) => AssistanceSingleData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceSingleData.fromJson(Map<String, dynamic> json) => AssistanceSingleData(
    id: json["id"],
    uniqueId: json["uniqueId"],
    hostId: json["host_id"],
    aCategory: json["a_category"] == null ? null : Category.fromJson(json["a_category"]),
    aSubCategory: json["a_sub_category"] == null ? null : Category.fromJson(json["a_sub_category"]),
    title: json["title"],
    aboutYou: json["about_you"],
    details: json["details"],
    assistanceDescription: json["assistance_description"],
    maxPerson: json["max_person"],
    price: double.tryParse("${json["price"]}"),
    extraChargePerPerson: json["extra_charge_per_person"],
    coverPhoto: json["cover_photo"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    status: json["status"],
    isEnableMultipleDateSelection: json["is_enable_multiple_date_selection"],
    instantBookingAllowed: json["instant_booking_allowed"],
    currentLocationName: json["current_location_name"],
    meetupPointName: json["meetup_point_name"],
    coverageAreaName: json["coverage_area_name"],
    cancellationPolicyId: json["cancellation_policy_id"],
    review: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    avgRating: json["avg_rating"],
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
    cancellationPolicy: json["cancellation_policy"] == null ? null : CancellationPolicy.fromJson(json["cancellation_policy"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uniqueId": uniqueId,
    "host_id": hostId,
    "a_category": aCategory?.toJson(),
    "a_sub_category": aSubCategory?.toJson(),
    "title": title,
    "about_you": aboutYou,
    "details": details,
    "assistance_description": assistanceDescription,
    "max_person": maxPerson,
    "price": price,
    "extra_charge_per_person": extraChargePerPerson,
    "cover_photo": coverPhoto,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "status": status,
    "is_enable_multiple_date_selection": isEnableMultipleDateSelection,
    "instant_booking_allowed": instantBookingAllowed,
    "current_location_name": currentLocationName,
    "meetup_point_name": meetupPointName,
    "coverage_area_name": coverageAreaName,
    "cancellation_policy_id": cancellationPolicyId,
    "review": review == null ? [] : List<dynamic>.from(review!.map((x) => x.toJson())),
    "avg_rating": avgRating,
    "total_rating_sum": totalRatingSum,
    "total_rating_count": totalRatingCount,
    "cancellation_policy": cancellationPolicy?.toJson(),
  };
}

class Category {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final String? description;
  final String? icon;
  final bool? status;
  final int? categoryId;

  Category({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.icon,
    this.status,
    this.categoryId,
  });

  factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    name: json["name"],
    description: json["description"],
    icon: json["icon"],
    status: json["status"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "name": name,
    "description": description,
    "icon": icon,
    "status": status,
    "category_id": categoryId,
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

class Review {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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

  Review({
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

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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

// Hello I am Tamim