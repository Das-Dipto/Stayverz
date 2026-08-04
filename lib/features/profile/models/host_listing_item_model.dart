class HostListingItemModel {
  final String id;
  final String uniqueId;
  final String title;
  final String coverPhoto;
  final List<String> images;
  final double price;
  final int guestCount;
  final int bedroomCount;
  final int bathroomCount;
  final int bedCount;
  final String placeType;
  final String status;
  final double avgRating;
  final int totalRatingCount;
  final int totalBookingCount;
  final String address;
  final String city;
  final String district;
  final String division;
  final String? createdAt;
  final String? updatedAt;
  final String displayImage;
  final String totalBooked;
  final String totalBlocked;

  HostListingItemModel({
    required this.id,
    required this.uniqueId,
    required this.title,
    required this.coverPhoto,
    required this.images,
    required this.price,
    required this.guestCount,
    required this.bedroomCount,
    required this.bathroomCount,
    required this.bedCount,
    required this.placeType,
    required this.status,
    required this.avgRating,
    required this.totalRatingCount,
    required this.totalBookingCount,
    required this.address,
    required this.city,
    required this.district,
    required this.division,
    this.createdAt,
    this.updatedAt,
    required this.displayImage,
    required this.totalBooked,
    required this.totalBlocked,
  });

  factory HostListingItemModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return HostListingItemModel(
      id: json['id']?.toString() ?? '',
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      price: _toDouble(json['price']),
      guestCount: _toInt(json['guest_count']),
      bedroomCount: _toInt(json['bedroom_count']),
      bathroomCount: _toInt(json['bathroom_count']),
      bedCount: _toInt(json['bed_count']),
      placeType: json['place_type'] ?? '',
      status: json['status'] ?? '',
      avgRating: _toDouble(json['avg_rating']),
      totalRatingCount: _toInt(json['total_rating_count']),
      totalBookingCount: _toInt(json['total_booking_count']),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      division: json['division'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      displayImage: json['display_image'] ?? '',
      totalBooked: json['total_booked']?.toString() ?? '0',
      totalBlocked: json['total_blocked']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'title': title,
      'cover_photo': coverPhoto,
      'images': images,
      'price': price,
      'guest_count': guestCount,
      'bedroom_count': bedroomCount,
      'bathroom_count': bathroomCount,
      'bed_count': bedCount,
      'place_type': placeType,
      'status': status,
      'avg_rating': avgRating,
      'total_rating_count': totalRatingCount,
      'total_booking_count': totalBookingCount,
      'address': address,
      'city': city,
      'district': district,
      'division': division,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'display_image': displayImage,
      'total_booked': totalBooked,
      'total_blocked': totalBlocked,
    };
  }
}