class UserReviewsResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MetaData? metaData;
  final List<UserReviewData>? data;

  UserReviewsResponse({
    this.success,
    this.statusCode,
    this.message,
    this.metaData,
    this.data,
  });

  factory UserReviewsResponse.fromJson(Map<String, dynamic> json) {
    return UserReviewsResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: json['meta_data'] != null
          ? MetaData.fromJson(json['meta_data'])
          : null,
      data: (json['data'] as List?)
          ?.map((e) => UserReviewData.fromJson(e))
          .toList(),
    );
  }
}

class MetaData {
  final int? total;
  final int? pageSize;
  final String? next;
  final String? previous;

  MetaData({this.total, this.pageSize, this.next, this.previous});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      next: json['next'],
      previous: json['previous'],
    );
  }
}

class UserReviewData {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final bool? isHostReview;
  final bool? isGuestReview;
  final int? rating;
  final String? review;
  final ListingData? listing;
  final int? booking;
  final ReviewByData? reviewBy;
  final int? reviewFor;

  UserReviewData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isHostReview,
    this.isGuestReview,
    this.rating,
    this.review,
    this.listing,
    this.booking,
    this.reviewBy,
    this.reviewFor,
  });

  factory UserReviewData.fromJson(Map<String, dynamic> json) {
    return UserReviewData(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isHostReview: json['is_host_review'] ?? false,
      isGuestReview: json['is_guest_review'] ?? false,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      listing: json['my_listing'] != null
          ? ListingData.fromJson(json['my_listing'])
          : null,
      booking: json['booking'],
      reviewBy: json['review_by'] != null
          ? ReviewByData.fromJson(json['review_by'])
          : null,
      reviewFor: json['review_for'],
    );
  }
}

class ListingData {
  final int? id;
  final String? uniqueId;
  final String? title;
  final String? coverPhoto;

  ListingData({this.id, this.uniqueId, this.title, this.coverPhoto});

  factory ListingData.fromJson(Map<String, dynamic> json) {
    return ListingData(
      id: json['id'],
      uniqueId: json['unique_id'],
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
    );
  }
}

class ReviewByData {
  final int? id;
  final String? fullName;
  final String? image;
  final String? phoneNumber;
  final String? uType;

  ReviewByData({
    this.id,
    this.fullName,
    this.image,
    this.phoneNumber,
    this.uType,
  });

  factory ReviewByData.fromJson(Map<String, dynamic> json) {
    return ReviewByData(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      uType: json['u_type'] ?? '',
    );
  }
}

// Hello I am Tamim