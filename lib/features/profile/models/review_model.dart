import 'listing_model.dart';

class ReviewModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final bool isHostReview;
  final bool isGuestReview;
  final int rating;
  final String review;
  final ListingModel listing;
  final int booking;
  final ReviewerModel reviewBy;
  final int reviewFor;

  ReviewModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isHostReview,
    required this.isGuestReview,
    required this.rating,
    required this.review,
    required this.listing,
    required this.booking,
    required this.reviewBy,
    required this.reviewFor,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isHostReview: json['is_host_review'] ?? false,
      isGuestReview: json['is_guest_review'] ?? false,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      listing: ListingModel.fromJson(json['my_listing'] ?? {}),
      booking: json['booking'] ?? 0,
      reviewBy: ReviewerModel.fromJson(json['review_by'] ?? {}),
      reviewFor: json['review_for'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_host_review': isHostReview,
      'is_guest_review': isGuestReview,
      'rating': rating,
      'review': review,
      'my_listing': listing.toJson(),
      'booking': booking,
      'review_by': reviewBy.toJson(),
      'review_for': reviewFor,
    };
  }
}

class ReviewerModel {
  final int id;
  final String fullName;
  final String image;
  final String phoneNumber;
  final String uType;

  ReviewerModel({
    required this.id,
    required this.fullName,
    required this.image,
    required this.phoneNumber,
    required this.uType,
  });

  factory ReviewerModel.fromJson(Map<String, dynamic> json) {
    return ReviewerModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      uType: json['u_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'image': image,
      'phone_number': phoneNumber,
      'u_type': uType,
    };
  }
}

// Hello I am Tamim