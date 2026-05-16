import 'dart:convert';
class CoHostAssignmentRequest {
  final int coHostUserId;
  final String accessLevel;
  final List<int> listingIds;
  final String commissionPercentage;

  CoHostAssignmentRequest({
    required this.coHostUserId,
    required this.accessLevel,
    required this.listingIds,
    required this.commissionPercentage,
  });

  factory CoHostAssignmentRequest.fromJson(Map<String, dynamic> json) {
    return CoHostAssignmentRequest(
      coHostUserId: json['co_host_user_id'],
      accessLevel: json['access_level'],
      listingIds: List<int>.from(json['listing_ids']),
      commissionPercentage: json['commission_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co_host_user_id': coHostUserId,
      'access_level': accessLevel,
      'listing_ids': listingIds,
      'commission_percentage': commissionPercentage,
    };
  }
}

class CoHostAssignmentResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final Data? data;

  CoHostAssignmentResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CoHostAssignmentResponse.fromRawJson(String str) => CoHostAssignmentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoHostAssignmentResponse.fromJson(Map<String, dynamic> json) => CoHostAssignmentResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final List<NewlyAssigned>? newlyAssigned;
  final List<NewlyAssigned>? updatedAssignments;

  Data({
    this.newlyAssigned,
    this.updatedAssignments,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    newlyAssigned: json["newly_assigned"] == null ? [] : List<NewlyAssigned>.from(json["newly_assigned"]!.map((x) => NewlyAssigned.fromJson(x))),
    updatedAssignments: json["updated_assignments"] == null ? [] : List<NewlyAssigned>.from(json["updated_assignments"]!.map((x) => NewlyAssigned.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "newly_assigned": newlyAssigned == null ? [] : List<dynamic>.from(newlyAssigned!.map((x) => x.toJson())),
    "updated_assignments": updatedAssignments == null ? [] : List<dynamic>.from(updatedAssignments!.map((x) => x.toJson())),
  };
}

class NewlyAssigned {
  final int? id;
  final ListingDetails? listingDetails;
  final CoHostUserDetails? coHostUserDetails;
  final String? accessLevel;
  final String? commissionPercentage;
  final bool? isActive;
  final DateTime? createdAt;

  NewlyAssigned({
    this.id,
    this.listingDetails,
    this.coHostUserDetails,
    this.accessLevel,
    this.commissionPercentage,
    this.isActive,
    this.createdAt,
  });

  factory NewlyAssigned.fromRawJson(String str) => NewlyAssigned.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewlyAssigned.fromJson(Map<String, dynamic> json) => NewlyAssigned(
    id: json["id"],
    listingDetails: json["listing_details"] == null ? null : ListingDetails.fromJson(json["listing_details"]),
    coHostUserDetails: json["co_host_user_details"] == null ? null : CoHostUserDetails.fromJson(json["co_host_user_details"]),
    accessLevel: json["access_level"],
    commissionPercentage: json["commission_percentage"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing_details": listingDetails?.toJson(),
    "co_host_user_details": coHostUserDetails?.toJson(),
    "access_level": accessLevel,
    "commission_percentage": commissionPercentage,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}

class CoHostUserDetails {
  final int? id;
  final String? fullName;
  final String? username;
  final String? image;
  final String? uType;

  CoHostUserDetails({
    this.id,
    this.fullName,
    this.username,
    this.image,
    this.uType,
  });

  factory CoHostUserDetails.fromRawJson(String str) => CoHostUserDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoHostUserDetails.fromJson(Map<String, dynamic> json) => CoHostUserDetails(
    id: json["id"],
    fullName: json["full_name"],
    username: json["username"],
    image: json["image"],
    uType: json["u_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "username": username,
    "image": image,
    "u_type": uType,
  };
}

class ListingDetails {
  final int? id;
  final String? title;
  final String? coverPhoto;

  ListingDetails({
    this.id,
    this.title,
    this.coverPhoto,
  });

  factory ListingDetails.fromRawJson(String str) => ListingDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListingDetails.fromJson(Map<String, dynamic> json) => ListingDetails(
    id: json["id"],
    title: json["title"],
    coverPhoto: json["cover_photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "cover_photo": coverPhoto,
  };
}

// Hello I am Tamim