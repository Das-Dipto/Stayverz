class Category {
  final int id;
  final String name;
  final String icon;
  final String iconMobile;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconMobile,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      iconMobile: json['icon_mobile'] ?? '',
    );
  }
}

class Amenity {
  final int id;
  final String name;
  final String icon;
  final String iconMobile;
  final bool? status;

  Amenity({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconMobile,
    this.status
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      iconMobile: json['icon_mobile'] ?? '',
      status: json['status'] ?? false,
    );
  }
}

class AmenityCategories {
  final List<Amenity> entirePlace;
  final List<Amenity> regular;
  final List<Amenity> standOut;
  final List<Amenity> safety;

  AmenityCategories({
    required this.entirePlace,
    required this.regular,
    required this.standOut,
    required this.safety,
  });

  factory AmenityCategories.fromJson(Map<String, dynamic> json) {
    return AmenityCategories(
      entirePlace: _parseAmenityList(json['entire_place']),
      regular: _parseAmenityList(json['regular']),
      standOut: _parseAmenityList(json['stand_out']),
      safety: _parseAmenityList(json['safety']),
    );
  }

  static List<Amenity> _parseAmenityList(dynamic list) {
    if (list == null || list is! List) return [];
    return list.map((e) => Amenity.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class PlaceType {
  final String id;
  final String name;
  final String icon;
  final String iconMobile;
  final String shortDescription;

  PlaceType({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconMobile,
    required this.shortDescription,
  });

  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      iconMobile: json['icon_mobile'] ?? '',
      shortDescription: json['short_description'] ?? '',
    );
  }
}

class CancellationPolicy {
  final int id;
  final String policyName;
  final String description;
  final int refundPercentage;
  final int cancellationDeadline;

  CancellationPolicy({
    required this.id,
    required this.policyName,
    required this.description,
    required this.refundPercentage,
    required this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'],
      policyName: json['policy_name'] ?? '',
      description: json['description'] ?? '',
      refundPercentage: json['refund_percentage'] ?? 0,
      cancellationDeadline: json['cancellation_deadline'] ?? 0,
    );
  }
}

class ListingFilterConfigResponse {
  final List<Category> categories;
  final AmenityCategories amenities;
  final List<PlaceType> placeTypes;
  final List<CancellationPolicy> cancellationPolicies;

  ListingFilterConfigResponse({
    required this.categories,
    required this.amenities,
    required this.placeTypes,
    required this.cancellationPolicies,
  });

  factory ListingFilterConfigResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ListingFilterConfigResponse(
      categories: (data['categories'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [],
      amenities: data['amenities'] != null
          ? AmenityCategories.fromJson(data['amenities'])
          : AmenityCategories(entirePlace: [], regular: [], standOut: [], safety: []),
      placeTypes: (data['place_types'] as List?)?.map((e) => PlaceType.fromJson(e)).toList() ?? [],
      cancellationPolicies: (data['cancellation_policy'] as List?)?.map((e) => CancellationPolicy.fromJson(e)).toList() ?? [],
    );
  }
}

// Hello I am Tamim