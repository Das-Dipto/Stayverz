class HostListingItemModel {
  final int id;
  final String uniqueId;
  final String title;
  final String description;
  final double price;
  final String coverPhoto;
  final List<String> images;
  final String placeType;
  final String status;
  final String verificationStatus;
  final int guestCount;
  final int bedroomCount;
  final int bedCount;
  final int bathroomCount;
  final String address;
  final double avgRating;
  final int totalRatingCount;
  final String district;
  final String division;
  final String area;
  final String? slug;
  final int host;

  HostListingItemModel({
    required this.id,
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.price,
    required this.coverPhoto,
    required this.images,
    required this.placeType,
    required this.status,
    required this.verificationStatus,
    required this.guestCount,
    required this.bedroomCount,
    required this.bedCount,
    required this.bathroomCount,
    required this.address,
    required this.avgRating,
    required this.totalRatingCount,
    required this.district,
    required this.division,
    required this.area,
    this.slug,
    required this.host,
  });

  factory HostListingItemModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is int) return v.toDouble();
      if (v is double) return v;
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return HostListingItemModel(
      id: _toInt(json['id']),
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: _toDouble(json['price']),
      coverPhoto: json['cover_photo'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      placeType: json['place_type'] ?? '',
      status: json['status'] ?? '',
      verificationStatus: json['verification_status'] ?? '',
      guestCount: _toInt(json['guest_count']),
      bedroomCount: _toInt(json['bedroom_count']),
      bedCount: _toInt(json['bed_count']),
      bathroomCount: _toInt(json['bathroom_count']),
      address: json['address'] ?? '',
      avgRating: _toDouble(json['avg_rating']),
      totalRatingCount: _toInt(json['total_rating_count']),
      district: json['district'] ?? '',
      division: json['division'] ?? '',
      area: json['area'] ?? '',
      slug: json['slug'],
      host: _toInt(json['host']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'title': title,
      'description': description,
      'price': price,
      'cover_photo': coverPhoto,
      'images': images,
      'place_type': placeType,
      'status': status,
      'verification_status': verificationStatus,
      'guest_count': guestCount,
      'bedroom_count': bedroomCount,
      'bed_count': bedCount,
      'bathroom_count': bathroomCount,
      'address': address,
      'avg_rating': avgRating,
      'total_rating_count': totalRatingCount,
      'district': district,
      'division': division,
      'area': area,
      'slug': slug,
      'host': host,
    };
  }
}