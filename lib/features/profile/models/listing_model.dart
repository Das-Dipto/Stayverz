class ListingModel {
  final int id;
  final String uniqueId;
  final String title;
  final double price;
  final String coverPhoto;
  final String address;
  final double avgRating;

  ListingModel({
    required this.id,
    required this.uniqueId,
    required this.title,
    required this.price,
    required this.coverPhoto,
    required this.address,
    required this.avgRating,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] ?? 0,
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? '',
      price:
          (json['price'] is int)
              ? (json['price'] as int).toDouble()
              : (json['price'] ?? 0.0),
      coverPhoto: json['cover_photo'] ?? '',
      address: json['address'] ?? '',
      avgRating:
          (json['avg_rating'] is int)
              ? (json['avg_rating'] as int).toDouble()
              : (json['avg_rating'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'title': title,
      'price': price,
      'cover_photo': coverPhoto,
      'address': address,
      'avg_rating': avgRating,
    };
  }
}

// Hello I am Tamim