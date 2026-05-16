class HomeResponse {
  final int statusCode;
  final List<HomeSection> data;
  final int responseTime;

  HomeResponse({
    required this.statusCode,
    required this.data,
    required this.responseTime,
  });

  factory HomeResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HomeResponse(statusCode: 0, data: [], responseTime: 0);
    }

    return HomeResponse(
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List?)
          ?.map((e) => HomeSection.fromJson(e as Map<String, dynamic>?))
          .toList() ??
          [],
      responseTime: json['responseTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
      'responseTime': responseTime,
    };
  }
}

class HomeSection {
  final String sectionTitle;
  final List<PropertyItem> items;

  HomeSection({
    required this.sectionTitle,
    required this.items,
  });

  factory HomeSection.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HomeSection(sectionTitle: '', items: []);
    }

    return HomeSection(
      sectionTitle: json['sectionTitle'] ?? '',
      items: (json['items'] as List?)
          ?.map((e) => PropertyItem.fromJson(e as Map<String, dynamic>?))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionTitle': sectionTitle,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class PropertyItem {
  final int id;
  final String title;
  final String uniqueId;
  final String coverPhoto;
  final int price;
  final int guestCount;
  final String area;
  final String? thana; // Nullable
  final String district;
  final double avgRating;
  final int totalRatingCount;
  final int totalBookingCount;

  PropertyItem({
    required this.id,
    required this.title,
    required this.uniqueId,
    required this.coverPhoto,
    required this.price,
    required this.guestCount,
    required this.area,
    this.thana,
    required this.district,
    required this.avgRating,
    required this.totalRatingCount,
    required this.totalBookingCount,
  });

  factory PropertyItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PropertyItem(
        id: 0,
        title: '',
        uniqueId: '',
        coverPhoto: '',
        price: 0,
        guestCount: 0,
        area: '',
        thana: null,
        district: '',
        avgRating: 0.0,
        totalRatingCount: 0,
        totalBookingCount: 0,
      );
    }

    return PropertyItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      coverPhoto: json['cover_photo'] ?? '', // Fixed: was 'coverPhoto'
      price: json['price'] ?? 0,
      guestCount: json['guestCount'] ?? 0,
      area: json['area'] ?? '',
      thana: json['thana'], // Can be null
      district: json['district'] ?? '',
      avgRating: (json['avg_rating'] is int)
          ? (json['avg_rating'] as int).toDouble()
          : (json['avg_rating'] ?? 0.0).toDouble(),
      totalRatingCount: json['total_rating_count'] ?? 0,
      totalBookingCount: json['total_booking_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'unique_id': uniqueId,
      'cover_photo': coverPhoto, // Fixed: was 'coverPhoto'
      'price': price,
      'guestCount': guestCount,
      'area': area,
      'thana': thana,
      'district': district,
      'avg_rating': avgRating,
      'total_rating_count': totalRatingCount,
      'total_booking_count': totalBookingCount,
    };
  }
}
// Hello I am Tamim