class CoHostResponseData {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<CoHostData> data;

  CoHostResponseData({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory CoHostResponseData.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>? ?? [];
    return CoHostResponseData(
      success: json['success'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: dataList.map((e) => CoHostData.fromJson(e)).toList(),
    );
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final int? next;
  final int? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] as int? ?? 0,
      pageSize: json['page_size'] as int? ?? 0,
      next: json['next'] as int?,
      previous: json['previous'] as int?,
    );
  }
}

class CoHostData {
  final int id;
  final String username;
  final String fullName;
  final String? image;
  final String bio;
  final int totalActiveListings;
  final double avgRating;
  final int yearsHosting;
  final String currentSuperhostTier;
  final double? distanceKm;

  CoHostData({
    required this.id,
    required this.username,
    required this.fullName,
    this.image,
    required this.bio,
    required this.totalActiveListings,
    required this.avgRating,
    required this.yearsHosting,
    required this.currentSuperhostTier,
    this.distanceKm,
  });

  factory CoHostData.fromJson(Map<String, dynamic> json) {
    return CoHostData(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      image: json['image'] as String?,
      bio: json['bio'] as String? ?? '',
      totalActiveListings: json['total_active_listings'] as int? ?? 0,
      avgRating: (json['avg_rating'] is int)
          ? (json['avg_rating'] as int).toDouble()
          : (json['avg_rating'] as double?) ?? 0.0,
      yearsHosting: json['years_hosting'] as int? ?? 0,
      currentSuperhostTier: json['current_superhost_tier'] as String? ?? '',
      distanceKm: (json['distance_km'] != null)
          ? (json['distance_km'] is int
          ? (json['distance_km'] as int).toDouble()
          : json['distance_km'] as double?)
          : null,
    );
  }
}

// Hello I am Tamim