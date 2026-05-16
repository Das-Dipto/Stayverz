class GivenReviewResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MetaData? metaData;
  final List<GivenReviewData>? data;

  GivenReviewResponse({
    this.success,
    this.statusCode,
    this.message,
    this.metaData,
    this.data,
  });

  factory GivenReviewResponse.fromJson(Map<String, dynamic> json) {
    return GivenReviewResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: json['meta_data'] != null
          ? MetaData.fromJson(json['meta_data'])
          : null,
      data: (json['data'] != null)
          ? List<GivenReviewData>.from(
          json['data'].map((e) => GivenReviewData.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'status_code': statusCode,
    'message': message,
    'meta_data': metaData?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class MetaData {
  final int? total;
  final int? pageSize;
  final dynamic next;
  final dynamic previous;

  MetaData({
    this.total,
    this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page_size': pageSize,
    'next': next,
    'previous': previous,
  };
}

class GivenReviewData {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final bool? isHostReview;
  final bool? isGuestReview;
  final int? rating;
  final String? review;
  final ListingData? listing;
  final int? booking;
  final ReviewBy? reviewBy;
  final int? reviewFor;

  GivenReviewData({
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

  factory GivenReviewData.fromJson(Map<String, dynamic> json) {
    return GivenReviewData(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isHostReview: json['is_host_review'] ?? false,
      isGuestReview: json['is_guest_review'] ?? false,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      listing: json['my_listing'] != null
          ? ListingData.fromJson(json['my_listing'])
          : null,
      booking: json['booking'] ?? 0,
      reviewBy: json['review_by'] != null
          ? ReviewBy.fromJson(json['review_by'])
          : null,
      reviewFor: json['review_for'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_host_review': isHostReview,
    'is_guest_review': isGuestReview,
    'rating': rating,
    'review': review,
    'my_listing': listing?.toJson(),
    'booking': booking,
    'review_by': reviewBy?.toJson(),
    'review_for': reviewFor,
  };
}

class ListingData {
  final int? id;
  final String? uniqueId;
  final String? title;
  final String? coverPhoto;

  ListingData({
    this.id,
    this.uniqueId,
    this.title,
    this.coverPhoto,
  });

  factory ListingData.fromJson(Map<String, dynamic> json) {
    return ListingData(
      id: json['id'] ?? 0,
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? 'Untitled Listing',
      coverPhoto: json['cover_photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'unique_id': uniqueId,
    'title': title,
    'cover_photo': coverPhoto,
  };
}

class ReviewBy {
  final int? id;
  final String? fullName;
  final String? image;
  final String? phoneNumber;
  final String? userType;

  ReviewBy({
    this.id,
    this.fullName,
    this.image,
    this.phoneNumber,
    this.userType,
  });

  factory ReviewBy.fromJson(Map<String, dynamic> json) {
    return ReviewBy(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown User',
      image: json['image'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userType: json['u_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'image': image,
    'phone_number': phoneNumber,
    'u_type': userType,
  };
}

// Hello I am Tamim