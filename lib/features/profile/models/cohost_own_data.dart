class CoHostOwnResponseData {
  final bool success;
  final int statusCode;
  final String message;
  final CoHostMetaData metaData;
  final CoHostOwnData data;

  CoHostOwnResponseData({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory CoHostOwnResponseData.fromJson(Map<String, dynamic> json) {
    return CoHostOwnResponseData(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: CoHostMetaData.fromJson(json['meta_data'] ?? {}),
      data: CoHostOwnData.fromJson(json['data'] ?? {}),
    );
  }
}

class CoHostMetaData {
  final int totalPrimaryHostListingsConsidered;
  final int grantedCount;
  final int notGrantedCount;

  CoHostMetaData({
    required this.totalPrimaryHostListingsConsidered,
    required this.grantedCount,
    required this.notGrantedCount,
  });

  factory CoHostMetaData.fromJson(Map<String, dynamic> json) {
    return CoHostMetaData(
      totalPrimaryHostListingsConsidered: json['total_primary_host_listings_considered'] ?? 0,
      grantedCount: json['granted_count'] ?? 0,
      notGrantedCount: json['not_granted_count'] ?? 0,
    );
  }
}

class CoHostOwnData {
  final int coHostId;
  final String name;
  final String image;
  final String bio;
  final int totalActiveListings;
  final double avgRating;
  final int yearsHosting;
  final List<GrantedListing> grantedListings;
  final List<NotGrantedListing> notGrantedListings;

  CoHostOwnData({
    required this.coHostId,
    required this.name,
    required this.image,
    required this.bio,
    required this.totalActiveListings,
    required this.avgRating,
    required this.yearsHosting,
    required this.grantedListings,
    required this.notGrantedListings,
  });

  factory CoHostOwnData.fromJson(Map<String, dynamic> json) {
    return CoHostOwnData(
      coHostId: json['co_host_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
      totalActiveListings: json['total_active_listings'] ?? 0,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      yearsHosting: json['years_hosting'] ?? 0,
      grantedListings: (json['granted_listings'] as List? ?? [])
          .map((e) => GrantedListing.fromJson(e))
          .toList(),
      notGrantedListings: (json['not_granted_listings'] as List? ?? [])
          .map((e) => NotGrantedListing.fromJson(e))
          .toList(),
    );
  }
}

class GrantedListing {
  final int id;
  final String accessLevel;
  final String commissionPercentage;
  final bool isActive;
  final ListingDetails listingDetails;

  GrantedListing({
    required this.id,
    required this.accessLevel,
    required this.commissionPercentage,
    required this.isActive,
    required this.listingDetails,
  });

  factory GrantedListing.fromJson(Map<String, dynamic> json) {
    return GrantedListing(
      id: json['id'] ?? 0,
      accessLevel: json['access_level'] ?? '',
      commissionPercentage: json['commission_percentage'] ?? '0.00',
      isActive: json['is_active'] ?? false,
      listingDetails: ListingDetails.fromJson(json['listing_details'] ?? {}),
    );
  }
}

class ListingDetails {
  final int id;
  final String title;
  final String coverPhoto;
  final double price;
  final String address;

  ListingDetails({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.price,
    required this.address,
  });

  factory ListingDetails.fromJson(Map<String, dynamic> json) {
    return ListingDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
    );
  }
}

class NotGrantedListing {
  final int id;
  final String title;
  final String coverPhoto;
  final double price;
  final String address;

  NotGrantedListing({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.price,
    required this.address,
  });

  factory NotGrantedListing.fromJson(Map<String, dynamic> json) {
    return NotGrantedListing(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
    );
  }
}

// Hello I am Tamim