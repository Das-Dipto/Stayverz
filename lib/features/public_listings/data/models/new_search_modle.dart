
class PropertyListResponse {
  final int statusCode;
  final List<NewPropertyItem> data;
  final NewMeta meta;

  PropertyListResponse({
    required this.statusCode,
    required this.data,
    required this.meta,
  });

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) {
    return PropertyListResponse(
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NewPropertyItem.fromJson(e))
          .toList() ??
          [],
      meta: NewMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
class NewPropertyItem {
  final int id;
  final String title;
  final String uniqueId;
  final String coverPhoto;
  final int price;
  final int guestCount;
  final String area;
  final String thana;
  final String district;
  final List<String> images;
  final double avgRating;
  final int totalRatingCount;

  final List<String>? livingRoomImages;
  final List<String>? kitchenImages;
  final List<String>? bathroomImages;
  final List<String>? bedroomImages;
  final List<String>? washroomImages;

  NewPropertyItem({
    required this.id,
    required this.title,
    required this.uniqueId,
    required this.coverPhoto,
    required this.price,
    required this.guestCount,
    required this.area,
    required this.thana,
    required this.district,
    required this.images,
    required this.avgRating,
    required this.totalRatingCount,
    this.livingRoomImages,
    this.kitchenImages,
    this.bathroomImages,
    this.bedroomImages,
    this.washroomImages,
  });

  factory NewPropertyItem.fromJson(Map<String, dynamic> json) {
    return NewPropertyItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      coverPhoto: json['coverPhoto'] ?? '',
      price: (json['price'] ?? 0).toInt(),
      guestCount: (json['guestCount'] ?? json['guest_count'] ?? 0).toInt(),
      area: json['area'] ?? '',
      thana: json['thana'] ?? '',
      district: json['district'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      totalRatingCount: (json['total_rating_count'] ?? 0).toInt(),

      livingRoomImages: _parseStringList(json['living_room_images']),
      kitchenImages: _parseStringList(json['kitchen_images']),
      bathroomImages: _parseStringList(json['bathroom_images']),
      bedroomImages: _parseStringList(json['bedroom_images']),
      washroomImages: _parseStringList(json['washroom_images']),
    );
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    return (value as List<dynamic>).map((e) => e.toString()).toList();
  }
}
class NewMeta {
  final int total;
  final int page;
  final int pageSize;
  final int lastPage;

  NewMeta({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.lastPage,
  });

  factory NewMeta.fromJson(Map<String, dynamic> json) {
    return NewMeta(
      total: json['total'] ?? 0,
      page: int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      pageSize: int.tryParse(
        json['pageSize']?.toString() ?? 
        json['page_size']?.toString() ?? 
        '10'
      ) ?? 10,
      lastPage: int.tryParse(
        json['last_page']?.toString() ?? 
        json['lastPage']?.toString() ?? 
        '1'
      ) ?? 1,
    );
  }
}

// Hello I am Tamim