import 'dart:convert';

class CreateAssistanceResponseModel {
  final int? status;
  final String? message;
  final CreatedAssistanceData? data;
  final DateTime? timestamp;

  CreateAssistanceResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory CreateAssistanceResponseModel.fromRawJson(String str) => CreateAssistanceResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateAssistanceResponseModel.fromJson(Map<String, dynamic> json) => CreateAssistanceResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : CreatedAssistanceData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class CreatedAssistanceData {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uniqueId;
  final dynamic hostId;
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
  final CoverageArea? currentLocation;
  final String? currentLocationName;
  final CoverageArea? meetupPoint;
  final String? meetupPointName;
  final CoverageArea? coverageArea;
  final String? coverageAreaName;
  final int? cancellationPolicyId;
  final DateTime? deletedAt;
  final int? avgRating;
  final int? totalRatingSum;
  final int? totalRatingCount;

  CreatedAssistanceData({
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

  factory CreatedAssistanceData.fromRawJson(String str) => CreatedAssistanceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedAssistanceData.fromJson(Map<String, dynamic> json) => CreatedAssistanceData(
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
    price: json["price"]?.toDouble(),
    extraChargePerPerson: json["extra_charge_per_person"]?.toDouble(),
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
    deletedAt: json["deletedAt"] == null ? null : DateTime.parse(json["deletedAt"]),
    avgRating: json["avg_rating"],
    totalRatingSum: json["total_rating_sum"],
    totalRatingCount: json["total_rating_count"],
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
    "deletedAt": deletedAt?.toIso8601String(),
    "avg_rating": avgRating,
    "total_rating_sum": totalRatingSum,
    "total_rating_count": totalRatingCount,
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

// Hello I am Tamim