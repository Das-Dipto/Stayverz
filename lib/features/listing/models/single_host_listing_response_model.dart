import 'dart:convert';

class SingleHostListingResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final SingleListingData? data;

  SingleHostListingResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SingleHostListingResponseModel.fromRawJson(String str) => SingleHostListingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleHostListingResponseModel.fromJson(Map<String, dynamic> json) => SingleHostListingResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : SingleListingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class SingleListingData {
  final int? id;
  final double? latitude;
  final double? longitude;
  final bool? instantBookingAllowed;
  final bool? requireGuestGoodTrackRecord;
  final String? categoryName;
  final bool? enableLengthOfStayDiscount;
  final LengthOfStayDiscounts? lengthOfStayDiscounts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uniqueId;
  final String? title;
  final String? description;
  final double? price;
  final String? coverPhoto;
  final List<String>? images;
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
  final double? avgRating;
  final double? totalRatingSum;
  final int? totalRatingCount;
  final int? totalBookingCount;
  final String? location;
  final String? district;
  final String? division;
  final String? area;
  final String? city;
  final bool? isDeleted;
  final dynamic deletedAt;
  final int? host;
  final int? category;
  final List<AmenityElement>? amenities;
  final double? guestServiceCharge;
  final double? hostServiceCharge;

  SingleListingData({
    this.id,
    this.latitude,
    this.longitude,
    this.instantBookingAllowed,
    this.requireGuestGoodTrackRecord,
    this.categoryName,
    this.enableLengthOfStayDiscount,
    this.lengthOfStayDiscounts,
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
    this.district,
    this.division,
    this.area,
    this.city,
    this.isDeleted,
    this.deletedAt,
    this.host,
    this.category,
    this.amenities,
    this.guestServiceCharge,
    this.hostServiceCharge,
  });

  factory SingleListingData.fromRawJson(String str) => SingleListingData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleListingData.fromJson(Map<String, dynamic> json) => SingleListingData(
    id: json["id"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    instantBookingAllowed: json["instant_booking_allowed"],
    requireGuestGoodTrackRecord: json["require_guest_good_track_record"],
    categoryName: json["category_name"],
    enableLengthOfStayDiscount: json["enable_length_of_stay_discount"],
    lengthOfStayDiscounts: json["length_of_stay_discounts"] == null ? null : LengthOfStayDiscounts.fromJson(json["length_of_stay_discounts"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    uniqueId: json["unique_id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    coverPhoto: json["cover_photo"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    livingRoomImages: json["living_room_images"] == null
        ? []
        : List<String>.from(json["living_room_images"].map((x) => x)),

    kitchenImages: json["kitchen_images"] == null
        ? []
        : List<String>.from(json["kitchen_images"].map((x) => x)),

    bathroomImages: json["bathroom_images"] == null
        ? []
        : List<String>.from(json["bathroom_images"].map((x) => x)),

    bedroomImages: json["bedroom_images"] == null
        ? []
        : List<String>.from(json["bedroom_images"].map((x) => x)),

    washroomImages: json["washroom_images"] == null
        ? []
        : List<String>.from(json["washroom_images"].map((x) => x)),
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
    cancellationPolicy: json["cancellation_policy"] == null ? null : CancellationPolicy.fromJson(json["cancellation_policy"]),
    checkIn: json["check_in"],
    checkOut: json["check_out"],
    avgRating: json["avg_rating"],
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
    totalBookingCount: json["total_booking_count"],
    location: json["location"],
    district: json["district"],
    division: json["division"],
    area: json["area"],
    city: json["city"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    host: json["host"],
    category: json["category"],
    amenities: json["amenities"] == null ? [] : List<AmenityElement>.from(json["amenities"]!.map((x) => AmenityElement.fromJson(x))),
    guestServiceCharge: json["guest_service_charge"]?.toDouble(),
    hostServiceCharge: json["host_service_charge"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "instant_booking_allowed": instantBookingAllowed,
    "require_guest_good_track_record": requireGuestGoodTrackRecord,
    "category_name": categoryName,
    "enable_length_of_stay_discount": enableLengthOfStayDiscount,
    "length_of_stay_discounts": lengthOfStayDiscounts?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "unique_id": uniqueId,
    "title": title,
    "description": description,
    "price": price,
    "cover_photo": coverPhoto,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "living_room_images": livingRoomImages == null
        ? []
        : List<dynamic>.from(livingRoomImages!.map((x) => x)),

    "kitchen_images": kitchenImages == null
        ? []
        : List<dynamic>.from(kitchenImages!.map((x) => x)),

    "bathroom_images": bathroomImages == null
        ? []
        : List<dynamic>.from(bathroomImages!.map((x) => x)),

    "bedroom_images": bedroomImages == null
        ? []
        : List<dynamic>.from(bedroomImages!.map((x) => x)),

    "washroom_images": washroomImages == null
        ? []
        : List<dynamic>.from(washroomImages!.map((x) => x)),

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
    "district": district,
    "division": division,
    "area": area,
    "city": city,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "host": host,
    "category": category,
    "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x.toJson())),
    "guest_service_charge": guestServiceCharge,
    "host_service_charge": hostServiceCharge,
  };
}

class AmenityElement {
  final int? id;
  final AmenityAmenity? amenity;

  AmenityElement({
    this.id,
    this.amenity,
  });

  factory AmenityElement.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AmenityElement();

    return AmenityElement(
      id: json["id"] is int ? json["id"] : null,
      amenity: json["amenity"] is Map<String, dynamic>
          ? AmenityAmenity.fromJson(json["amenity"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "amenity": amenity?.toJson(),
  };
}


class AmenityAmenity {
  final String? name;
  final String? aType;
  final String? icon;
  final int? id;

  AmenityAmenity({
    this.name,
    this.aType,
    this.icon,
    this.id,
  });

  factory AmenityAmenity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AmenityAmenity();

    return AmenityAmenity(
      name: json["name"]?.toString(),
      aType: json["a_type"]?.toString(),
      icon: json["icon"]?.toString(),
      id: json["id"] is int ? json["id"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "a_type": aType,
    "icon": icon,
    "id": id,
  };
}


class CancellationPolicy {
  final int? id;
  final String? description;
  final String? policyName;
  final int? refundPercentage;
  final int? cancellationDeadline;

  CancellationPolicy({
    this.id,
    this.description,
    this.policyName,
    this.refundPercentage,
    this.cancellationDeadline,
  });

  factory CancellationPolicy.fromRawJson(String str) => CancellationPolicy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
    id: json["id"],
    description: json["description"],
    policyName: json["policy_name"],
    refundPercentage: json["refund_percentage"],
    cancellationDeadline: json["cancellation_deadline"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "policy_name": policyName,
    "refund_percentage": refundPercentage,
    "cancellation_deadline": cancellationDeadline,
  };
}


class LengthOfStayDiscounts {
  final Map<String, int> discounts;

  LengthOfStayDiscounts({required this.discounts});

  factory LengthOfStayDiscounts.fromRawJson(String str) =>
      LengthOfStayDiscounts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LengthOfStayDiscounts.fromJson(Map<String, dynamic> json) {
    final discountsMap = json.map<String, int>((key, value) =>
        MapEntry(key, (value is int) ? value : int.tryParse(value.toString()) ?? 0));
    return LengthOfStayDiscounts(discounts: discountsMap);
  }

  Map<String, dynamic> toJson() => discounts;
}
// Hello I am Tamim