import 'dart:convert';

class HostListingConfigurationModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ConfigurationData? data;

  HostListingConfigurationModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostListingConfigurationModel.fromRawJson(String str) =>
      HostListingConfigurationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostListingConfigurationModel.fromJson(Map<String, dynamic> json) =>
      HostListingConfigurationModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : ConfigurationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ConfigurationData {
  final List<Category>? categories;
  final Map<String, List<Amenity>>? amenities;
  final List<PlaceType>? placeTypes;
  final List<CancellationPolicy>? cancellationPolicy;

  ConfigurationData({
    this.categories,
    this.amenities,
    this.placeTypes,
    this.cancellationPolicy,
  });

  factory ConfigurationData.fromJson(Map<String, dynamic> json) {
    final Map<String, List<Amenity>>? parsedAmenities = json["amenities"] != null
        ? (json["amenities"] as Map<String, dynamic>).map((key, value) {
      return MapEntry<String, List<Amenity>>(
        key,
        List<Amenity>.from(value.map((x) => Amenity.fromJson(x))),
      );
    })
        : null;

    return ConfigurationData(
      categories: json["categories"] == null
          ? []
          : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
      amenities: parsedAmenities,
      placeTypes: json["place_types"] == null
          ? []
          : List<PlaceType>.from(json["place_types"].map((x) => PlaceType.fromJson(x))),
      cancellationPolicy: json["cancellation_policy"] == null
          ? []
          : List<CancellationPolicy>.from(
          json["cancellation_policy"].map((x) => CancellationPolicy.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final amenitiesJson = <String, dynamic>{};
    amenities?.forEach((key, value) {
      amenitiesJson[key] = value.map((e) => e.toJson()).toList();
    });

    return {
      "categories": categories?.map((x) => x.toJson()).toList(),
      "amenities": amenitiesJson,
      "place_types": placeTypes?.map((x) => x.toJson()).toList(),
      "cancellation_policy": cancellationPolicy?.map((x) => x.toJson()).toList(),
    };
  }
}

class Category {
  final int? id;
  final String? name;
  final String? icon;
  final String? iconMobile;

  Category({
    this.id,
    this.name,
    this.icon,
    this.iconMobile,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    iconMobile: json["icon_mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "icon_mobile": iconMobile,
  };
}

class Amenity {
  final int? id;
  final String? name;
  final String? icon;
  final String? iconMobile;
  final bool? status;

  Amenity({
    this.id,
    this.name,
    this.icon,
    this.iconMobile,
    this.status
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    iconMobile: json["icon_mobile"],
    status: json["status"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "icon_mobile": iconMobile,
    "status": status,
  };
}

class PlaceType {
  final String? id;
  final String? name;
  final String? icon;
  final String? iconMobile;
  final String? shortDescription;

  PlaceType({
    this.id,
    this.name,
    this.icon,
    this.iconMobile,
    this.shortDescription,
  });

  factory PlaceType.fromJson(Map<String, dynamic> json) => PlaceType(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    iconMobile: json["icon_mobile"],
    shortDescription: json["short_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "icon_mobile": iconMobile,
    "short_description": shortDescription,
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