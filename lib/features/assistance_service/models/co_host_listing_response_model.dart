import 'dart:convert';

class CoHostListingResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MetaData? metaData;
  final List<CoHostListingData>? data;

  CoHostListingResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.metaData,
    this.data,
  });

  factory CoHostListingResponseModel.fromRawJson(String str) => CoHostListingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoHostListingResponseModel.fromJson(Map<String, dynamic> json) => CoHostListingResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    metaData: json["meta_data"] == null ? null : MetaData.fromJson(json["meta_data"]),
    data: json["data"] == null ? [] : List<CoHostListingData>.from(json["data"]!.map((x) => CoHostListingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "meta_data": metaData?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CoHostListingData {
  final int? listingId;
  final String? uniqueId;
  final String? title;
  final String? address;
  final String? coverPhoto;
  final String? status;
  final double? price;
  final int? primaryHostId;
  final String? primaryHostName; // Changed
  final String? accessLevel; // Changed
  final String? accessLevelDisplay; // Changed
  final String? commissionPercentage;
  final bool? isActive;
  final int? id;

  CoHostListingData({
    this.listingId,
    this.uniqueId,
    this.title,
    this.address,
    this.coverPhoto,
    this.status,
    this.price,
    this.primaryHostId,
    this.primaryHostName,
    this.accessLevel,
    this.accessLevelDisplay,
    this.commissionPercentage,
    this.isActive,
    this.id,
  });

  factory CoHostListingData.fromJson(Map<String, dynamic> json) => CoHostListingData(
    listingId: json["listing_id"],
    uniqueId: json["unique_id"],
    title: json["title"],
    address: json["address"],
    coverPhoto: json["cover_photo"],
    status: json["status"],
    price: json["price"]?.toDouble(),
    primaryHostId: json["primary_host_id"],
    primaryHostName: json["primary_host_name"], // Changed
    accessLevel: json["access_level"], // Changed
    accessLevelDisplay: json["access_level_display"], // Changed
    commissionPercentage: json["commission_percentage"],
    isActive: json["is_active"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "listing_id": listingId,
    "unique_id": uniqueId,
    "title": title,
    "address": address,
    "cover_photo": coverPhoto,
    "status": status,
    "price": price,
    "primary_host_id": primaryHostId,
    "primary_host_name": primaryHostName, // Changed
    "access_level": accessLevel, // Changed
    "access_level_display": accessLevelDisplay, // Changed
    "commission_percentage": commissionPercentage,
    "is_active": isActive,
    "id": id,
  };
}


enum AccessLevel {
  SEMI
}

final accessLevelValues = EnumValues({
  "semi": AccessLevel.SEMI
});

enum AccessLevelDisplay {
  SEMI_ACCESS
}

final accessLevelDisplayValues = EnumValues({
  "Semi Access": AccessLevelDisplay.SEMI_ACCESS
});

enum PrimaryHostName {
  JOYNAL_ABEDIN,
  MR_HOST
}

final primaryHostNameValues = EnumValues({
  "Joynal Abedin": PrimaryHostName.JOYNAL_ABEDIN,
  "Mr Host": PrimaryHostName.MR_HOST
});

class MetaData {
  final int? total;
  final String? pageSize;
  final int? next;
  final dynamic previous;

  MetaData({
    this.total,
    this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromRawJson(String str) => MetaData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
    total: json["total"],
    pageSize: json["page_size"],
    next: json["next"],
    previous: json["previous"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page_size": pageSize,
    "next": next,
    "previous": previous,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// Hello I am Tamim