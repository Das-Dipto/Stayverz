import 'package:stayverz_flutter_app/features/public_listings/data/models/public_listing_model.dart';

class WishlistItemModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int wishlist;
  final PublicListingModel listing;

  WishlistItemModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.wishlist,
    required this.listing,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      wishlist: json['wishlist'] ?? 0,
      listing: PublicListingModel.fromJson(json['my_listing'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'wishlist': wishlist,
      'my_listing': listing.toJson(),
    };
  }
}

// Hello I am Tamim