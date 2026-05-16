class WishlistModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<WishlistItem>? data;

  WishlistModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}

class WishlistItem {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? wishlist;
  final Listing? listing;

  WishlistItem({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.wishlist,
    this.listing,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      wishlist: json['wishlist'] as int?,
      listing: json['listing'] != null
          ? Listing.fromJson(json['listing'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Listing {
  final int? id;
  final double? latitude;
  final double? longitude;
  final bool? instantBookingAllowed;
  final bool? requireGuestGoodTrackRecord;
  final String? categoryName;
  final bool? enableLengthOfStayDiscount;
  final Map<String, dynamic>? lengthOfStayDiscounts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? uniqueId;
  final String? title;
  final String? description;
  final double? price;
  final String? coverPhoto;
  final List<String>? images;
  final String? placeType;
  final String? status;
  final String? verificationStatus;
  final int? guestCount;
  final int? bedroomCount;
  final int? bedCount;
  final int? bathroomCount;
  final int? minimumNights;
  final int? maximumNights;
  final String? address;
  final bool? petAllowed;
  final bool? eventAllowed;
  final bool? smokingAllowed;
  final bool? mediaAllowed;
  final bool? unmarriedCouplesAllowed;
  final CancellationPolicy? cancellationPolicy;
  final String? checkIn;
  final String? checkOut;
  final double? avgRating;
  final double? totalRatingSum;
  final int? totalRatingCount;
  final int? totalBookingCount;
  final String? location;
  final String? district;
  final String? division;
  final String? area;
  final String? city;
  final bool? isDeleted;
  final DateTime? deletedAt;
  final int? host;
  final int? category;

  Listing({
    this.id,
    this.latitude,
    this.longitude,
    this.instantBookingAllowed,
    this.requireGuestGoodTrackRecord,
    this.categoryName,
    this.enableLengthOfStayDiscount,
    this.lengthOfStayDiscounts,
    this.createdAt,
    this.updatedAt,
    this.uniqueId,
    this.title,
    this.description,
    this.price,
    this.coverPhoto,
    this.images,
    this.placeType,
    this.status,
    this.verificationStatus,
    this.guestCount,
    this.bedroomCount,
    this.bedCount,
    this.bathroomCount,
    this.minimumNights,
    this.maximumNights,
    this.address,
    this.petAllowed,
    this.eventAllowed,
    this.smokingAllowed,
    this.mediaAllowed,
    this.unmarriedCouplesAllowed,
    this.cancellationPolicy,
    this.checkIn,
    this.checkOut,
    this.avgRating,
    this.totalRatingSum,
    this.totalRatingCount,
    this.totalBookingCount,
    this.location,
    this.district,
    this.division,
    this.area,
    this.city,
    this.isDeleted,
    this.deletedAt,
    this.host,
    this.category,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as int?,
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
      instantBookingAllowed: json['instant_booking_allowed'] as bool?,
      requireGuestGoodTrackRecord: json['require_guest_good_track_record'] as bool?,
      categoryName: json['category_name'] as String?,
      enableLengthOfStayDiscount: json['enable_length_of_stay_discount'] as bool?,
      lengthOfStayDiscounts: json['length_of_stay_discounts'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      uniqueId: json['unique_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      coverPhoto: json['cover_photo'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      placeType: json['place_type'] as String?,
      status: json['status'] as String?,
      verificationStatus: json['verification_status'] as String?,
      guestCount: json['guest_count'] as int?,
      bedroomCount: json['bedroom_count'] as int?,
      bedCount: json['bed_count'] as int?,
      bathroomCount: json['bathroom_count'] as int?,
      minimumNights: json['minimum_nights'] as int?,
      maximumNights: json['maximum_nights'] as int?,
      address: json['address'] as String?,
      petAllowed: json['pet_allowed'] as bool?,
      eventAllowed: json['event_allowed'] as bool?,
      smokingAllowed: json['smoking_allowed'] as bool?,
      mediaAllowed: json['media_allowed'] as bool?,
      unmarriedCouplesAllowed: json['unmarried_couples_allowed'] as bool?,
      cancellationPolicy: json['cancellation_policy'] != null
          ? CancellationPolicy.fromJson(
          json['cancellation_policy'] as Map<String, dynamic>)
          : null,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      avgRating: (json['avg_rating'] != null)
          ? (json['avg_rating'] as num).toDouble()
          : null,
      totalRatingSum: (json['total_rating_sum'] != null)
          ? (json['total_rating_sum'] as num).toDouble()
          : null,
      totalRatingCount: json['total_rating_count'] as int?,
      totalBookingCount: json['total_booking_count'] as int?,
      location: json['location'] as String?,
      district: json['district'] as String?,
      division: json['division'] as String?,
      area: json['area'] as String?,
      city: json['city'] as String?,
      isDeleted: json['is_deleted'] as bool?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      host: json['host'] as int?,
      category: json['category'] as int?,
    );
  }
}

class CancellationPolicy {
  final int? id;
  final String? description;
  final String? policyName;
  final int? refundPercentage;
  final int? cancellationDeadline;

  CancellationPolicy({
    this.id,
    this.description,
    this.policyName,
    this.refundPercentage,
    this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'] as int?,
      description: json['description'] as String?,
      policyName: json['policy_name'] as String?,
      refundPercentage: json['refund_percentage'] as int?,
      cancellationDeadline: json['cancellation_deadline'] as int?,
    );
  }
}

// Hello I am Tamim