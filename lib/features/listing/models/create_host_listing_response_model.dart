import 'dart:convert';

class CreateHostListingResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final CreatedListing? data;

  CreateHostListingResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CreateHostListingResponseModel.fromRawJson(String str) =>
      CreateHostListingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateHostListingResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateHostListingResponseModel(
      success: json["success"],
      statusCode: json["statusCode"] ?? json["status_code"],
      message: json["message"],
      data:
      json["data"] != null ? CreatedListing.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class CreatedListing {
  final int? id;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uniqueId;
  final String? title;
  final String? description;
  final num? price;
  final String? coverPhoto;

  final List<dynamic>? images;
  final List<String>? livingRoomImages;
  final List<String>? kitchenImages;
  final List<String>? bathroomImages;
  final List<String>? bedroomImages;
  final List<String>? washroomImages;

  final String? placeType;
  final String? status;
  final String? verificationStatus;

  final int? guestCount;
  final int? bedroomCount;
  final int? bedCount;
  final int? bathroomCount;

  final int? minimumNights;
  final int? maximumNights;

  final String? address;

  final bool? petAllowed;
  final bool? eventAllowed;
  final bool? smokingAllowed;
  final bool? mediaAllowed;
  final bool? unmarriedCouplesAllowed;

  final CancellationPolicy? cancellationPolicy;

  final String? checkIn;
  final String? checkOut;

  final num? avgRating;
  final double? totalRatingSum;
  final int? totalRatingCount;
  final int? totalBookingCount;

  final dynamic location; // FIXED ✅ (Map / String / null accept করবে)

  final int? host;
  final dynamic category;

  CreatedListing({
    this.id,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.uniqueId,
    this.title,
    this.description,
    this.price,
    this.coverPhoto,
    this.images,
    this.livingRoomImages,
    this.kitchenImages,
    this.bathroomImages,
    this.bedroomImages,
    this.washroomImages,
    this.placeType,
    this.status,
    this.verificationStatus,
    this.guestCount,
    this.bedroomCount,
    this.bedCount,
    this.bathroomCount,
    this.minimumNights,
    this.maximumNights,
    this.address,
    this.petAllowed,
    this.eventAllowed,
    this.smokingAllowed,
    this.mediaAllowed,
    this.unmarriedCouplesAllowed,
    this.cancellationPolicy,
    this.checkIn,
    this.checkOut,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
    this.totalBookingCount,
    this.location,
    this.host,
    this.category,
  });

  factory CreatedListing.fromJson(Map<String, dynamic> json) {
    return CreatedListing(
      id: json["id"],
      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),
      createdAt:
      json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
      updatedAt:
      json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
      uniqueId: json["unique_id"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      coverPhoto: json["cover_photo"],

      images: json["images"] != null ? List.from(json["images"]) : [],

      livingRoomImages: json["living_room_images"] != null
          ? List<String>.from(json["living_room_images"])
          : [],

      kitchenImages: json["kitchen_images"] != null
          ? List<String>.from(json["kitchen_images"])
          : [],

      bathroomImages: json["bathroom_images"] != null
          ? List<String>.from(json["bathroom_images"])
          : [],

      bedroomImages: json["bedroom_images"] != null
          ? List<String>.from(json["bedroom_images"])
          : [],

      washroomImages: json["washroom_images"] != null
          ? List<String>.from(json["washroom_images"])
          : [],

      placeType: json["place_type"],
      status: json["status"],
      verificationStatus: json["verification_status"],

      guestCount: json["guest_count"],
      bedroomCount: json["bedroom_count"],
      bedCount: json["bed_count"],
      bathroomCount: json["bathroom_count"],

      minimumNights: json["minimum_nights"],
      maximumNights: json["maximum_nights"],

      address: json["address"],

      petAllowed: json["pet_allowed"],
      eventAllowed: json["event_allowed"],
      smokingAllowed: json["smoking_allowed"],
      mediaAllowed: json["media_allowed"],
      unmarriedCouplesAllowed: json["unmarried_couples_allowed"],

      cancellationPolicy: json["cancellation_policy"] != null
          ? CancellationPolicy.fromJson(json["cancellation_policy"])
          : null,

      checkIn: json["check_in"],
      checkOut: json["check_out"],

      avgRating: json["avg_rating"],
      totalRatingSum: (json["total_rating_sum"] as num?)?.toDouble(),
      totalRatingCount: json["total_rating_count"],
      totalBookingCount: json["total_booking_count"],

      location: json["location"], // SAFE ✅

      host: json["host"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "unique_id": uniqueId,
    "title": title,
    "description": description,
    "price": price,
    "cover_photo": coverPhoto,
    "images": images ?? [],
    "living_room_images": livingRoomImages ?? [],
    "kitchen_images": kitchenImages ?? [],
    "bathroom_images": bathroomImages ?? [],
    "bedroom_images": bedroomImages ?? [],
    "washroom_images": washroomImages ?? [],
    "place_type": placeType,
    "status": status,
    "verification_status": verificationStatus,
    "guest_count": guestCount,
    "bedroom_count": bedroomCount,
    "bed_count": bedCount,
    "bathroom_count": bathroomCount,
    "minimum_nights": minimumNights,
    "maximum_nights": maximumNights,
    "address": address,
    "pet_allowed": petAllowed,
    "event_allowed": eventAllowed,
    "smoking_allowed": smokingAllowed,
    "media_allowed": mediaAllowed,
    "unmarried_couples_allowed": unmarriedCouplesAllowed,
    "cancellation_policy": cancellationPolicy?.toJson(),
    "check_in": checkIn,
    "check_out": checkOut,
    "avg_rating": avgRating,
    "total_rating_sum": totalRatingSum,
    "total_rating_count": totalRatingCount,
    "total_booking_count": totalBookingCount,
    "location": location,
    "host": host,
    "category": category,
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

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json["id"],
      policyName: json["policy_name"],
      description: json["description"],
      refundPercentage: json["refund_percentage"],
      cancellationDeadline: json["cancellation_deadline"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "policy_name": policyName,
    "description": description,
    "refund_percentage": refundPercentage,
    "cancellation_deadline": cancellationDeadline,
  };
}
// Hello I am Tamim