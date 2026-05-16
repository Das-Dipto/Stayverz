class PublicListingsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<PublicListingModel> data;

  PublicListingsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory PublicListingsResponse.fromJson(Map<String, dynamic> json) {
    return PublicListingsResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PublicListingModel.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'meta_data': metaData.toJson(),
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final String? next;
  final String? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] ?? 0,
      pageSize: int.tryParse(json['page_size'].toString()) ?? 10,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page_size': pageSize,
      'next': next,
      'previous': previous,
    };
  }
}
class PublicListingModel {
  final int id;
  final double latitude;
  final double longitude;
  final bool instantBookingAllowed;
  final bool requireGuestGoodTrackRecord;
  final bool enableLengthOfStayDiscount;
  final Map<String, dynamic> lengthOfStayDiscounts;
  final String createdAt;
  final String updatedAt;
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
  final int minimumNights;
  final int maximumNights;
  final String address;
  final bool petAllowed;
  final bool eventAllowed;
  final bool smokingAllowed;
  final bool mediaAllowed;
  final bool unmarriedCouplesAllowed;
  final Map<String, dynamic> cancellationPolicy;
  final String checkIn;
  final String checkOut;
  final double avgRating;
  final double totalRatingSum;
  final int totalRatingCount;
  final int totalBookingCount;
  final String location;
  final String district;
  final String division;
  final String area;
  final String city;
  final bool isDeleted;
  final String? deletedAt;
  final Host host;
  final int category;

  PublicListingModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.instantBookingAllowed,
    required this.requireGuestGoodTrackRecord,
    required this.enableLengthOfStayDiscount,
    required this.lengthOfStayDiscounts,
    required this.createdAt,
    required this.updatedAt,
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
    required this.minimumNights,
    required this.maximumNights,
    required this.address,
    required this.petAllowed,
    required this.eventAllowed,
    required this.smokingAllowed,
    required this.mediaAllowed,
    required this.unmarriedCouplesAllowed,
    required this.cancellationPolicy,
    required this.checkIn,
    required this.checkOut,
    required this.avgRating,
    required this.totalRatingSum,
    required this.totalRatingCount,
    required this.totalBookingCount,
    required this.location,
    required this.district,
    required this.division,
    required this.area,
    required this.city,
    required this.isDeleted,
    this.deletedAt,
    required this.host,
    required this.category,
  });

  factory PublicListingModel.fromJson(Map<String, dynamic> json) {
    return PublicListingModel(
      id: json['id'] ?? 0,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      instantBookingAllowed: json['instant_booking_allowed'] ?? false,
      requireGuestGoodTrackRecord: json['require_guest_good_track_record'] ?? false,
      enableLengthOfStayDiscount: json['enable_length_of_stay_discount'] ?? false,
      lengthOfStayDiscounts: json['length_of_stay_discounts'] ?? {},
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      coverPhoto: json['cover_photo'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      placeType: json['place_type'] ?? '',
      status: json['status'] ?? '',
      verificationStatus: json['verification_status'] ?? '',
      guestCount: json['guest_count'] ?? 0,
      bedroomCount: json['bedroom_count'] ?? 0,
      bedCount: json['bed_count'] ?? 0,
      bathroomCount: json['bathroom_count'] ?? 0,
      minimumNights: json['minimum_nights'] ?? 0,
      maximumNights: json['maximum_nights'] ?? 0,
      address: json['address'] ?? '',
      petAllowed: json['pet_allowed'] ?? false,
      eventAllowed: json['event_allowed'] ?? false,
      smokingAllowed: json['smoking_allowed'] ?? false,
      mediaAllowed: json['media_allowed'] ?? false,
      unmarriedCouplesAllowed: json['unmarried_couples_allowed'] ?? false,
      cancellationPolicy: json['cancellation_policy'] ?? {},
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
      totalRatingSum: (json['total_rating_sum'] ?? 0.0).toDouble(),
      totalRatingCount: json['total_rating_count'] ?? 0,
      totalBookingCount: json['total_booking_count'] ?? 0,
      location: json['location'] ?? '',
      district: json['district'] ?? '',
      division: json['division'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      isDeleted: json['is_deleted'] ?? false,
      deletedAt: json['deleted_at'],
      host: _parseHost(json['host']),
      category: json['category'] ?? 0,
    );
  }

  static Host _parseHost(dynamic hostJson) {
    if (hostJson == null) {
      return Host(id: 0, email: '', image: '', identityVerificationStatus: '', status: '');
    } else if (hostJson is int) {
      // If only ID is provided
      return Host(id: hostJson, email: '', image: '', identityVerificationStatus: '', status: '');
    } else if (hostJson is Map<String, dynamic>) {
      // Full object
      return Host.fromJson(hostJson);
    } else {
      return Host(id: 0, email: '', image: '', identityVerificationStatus: '', status: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'instant_booking_allowed': instantBookingAllowed,
      'require_guest_good_track_record': requireGuestGoodTrackRecord,
      'enable_length_of_stay_discount': enableLengthOfStayDiscount,
      'length_of_stay_discounts': lengthOfStayDiscounts,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
      'minimum_nights': minimumNights,
      'maximum_nights': maximumNights,
      'address': address,
      'pet_allowed': petAllowed,
      'event_allowed': eventAllowed,
      'smoking_allowed': smokingAllowed,
      'media_allowed': mediaAllowed,
      'unmarried_couples_allowed': unmarriedCouplesAllowed,
      'cancellation_policy': cancellationPolicy,
      'check_in': checkIn,
      'check_out': checkOut,
      'avg_rating': avgRating,
      'total_rating_sum': totalRatingSum,
      'total_rating_count': totalRatingCount,
      'total_booking_count': totalBookingCount,
      'location': location,
      'district': district,
      'division': division,
      'area': area,
      'city': city,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt,
      'host': host.toJson(),
      'category': category,
    };
  }
}

class Host {
  final int id;
  final String email;
  final String image;
  final String identityVerificationStatus;
  final String status;
  final String? currentSuperhostTier;

  Host({
    required this.id,
    required this.email,
    required this.image,
    required this.identityVerificationStatus,
    required this.status,
    this.currentSuperhostTier,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      identityVerificationStatus: json['identity_verification_status'] ?? '',
      status: json['status'] ?? '',
      currentSuperhostTier: json['current_superhost_tier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'image': image,
      'identity_verification_status': identityVerificationStatus,
      'status': status,
      'current_superhost_tier': currentSuperhostTier,
    };
  }
}

// class PublicListingModel {
//   final int id;
//   final double latitude;
//   final double longitude;
//   final bool instantBookingAllowed;
//   final bool requireGuestGoodTrackRecord;
//   final bool enableLengthOfStayDiscount;
//   final Map<String, dynamic> lengthOfStayDiscounts;
//   final String createdAt;
//   final String updatedAt;
//   final String uniqueId;
//   final String title;
//   final String description;
//   final double price;
//   final String coverPhoto;
//   final List<String> images;
//   final String placeType;
//   final String status;
//   final String verificationStatus;
//   final int guestCount;
//   final int bedroomCount;
//   final int bedCount;
//   final int bathroomCount;
//   final int minimumNights;
//   final int maximumNights;
//   final String address;
//   final bool petAllowed;
//   final bool eventAllowed;
//   final bool smokingAllowed;
//   final bool mediaAllowed;
//   final bool unmarriedCouplesAllowed;
//   final Map<String, dynamic> cancellationPolicy;
//   final String checkIn;
//   final String checkOut;
//   final double avgRating;
//   final double totalRatingSum;
//   final int totalRatingCount;
//   final int totalBookingCount;
//   final String location;
//   final String district;
//   final String division;
//   final String area;
//   final String city;
//   final bool isDeleted;
//   final String? deletedAt;
//   final Host host;
//   final int category;
//
//   PublicListingModel({
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//     required this.instantBookingAllowed,
//     required this.requireGuestGoodTrackRecord,
//     required this.enableLengthOfStayDiscount,
//     required this.lengthOfStayDiscounts,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.uniqueId,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.coverPhoto,
//     required this.images,
//     required this.placeType,
//     required this.status,
//     required this.verificationStatus,
//     required this.guestCount,
//     required this.bedroomCount,
//     required this.bedCount,
//     required this.bathroomCount,
//     required this.minimumNights,
//     required this.maximumNights,
//     required this.address,
//     required this.petAllowed,
//     required this.eventAllowed,
//     required this.smokingAllowed,
//     required this.mediaAllowed,
//     required this.unmarriedCouplesAllowed,
//     required this.cancellationPolicy,
//     required this.checkIn,
//     required this.checkOut,
//     required this.avgRating,
//     required this.totalRatingSum,
//     required this.totalRatingCount,
//     required this.totalBookingCount,
//     required this.location,
//     required this.district,
//     required this.division,
//     required this.area,
//     required this.city,
//     required this.isDeleted,
//     this.deletedAt,
//     required this.host,
//     required this.category,
//   });
//
//   factory PublicListingModel.fromJson(Map<String, dynamic> json) {
//     return PublicListingModel(
//       id: json['id'] ?? 0,
//       latitude: (json['latitude'] ?? 0.0).toDouble(),
//       longitude: (json['longitude'] ?? 0.0).toDouble(),
//       instantBookingAllowed: json['instant_booking_allowed'] ?? false,
//       requireGuestGoodTrackRecord:
//       json['require_guest_good_track_record'] ?? false,
//       enableLengthOfStayDiscount:
//       json['enable_length_of_stay_discount'] ?? false,
//       lengthOfStayDiscounts: json['length_of_stay_discounts'] ?? {},
//       createdAt: json['created_at'] ?? '',
//       updatedAt: json['updated_at'] ?? '',
//       uniqueId: json['unique_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] ?? 0.0).toDouble(),
//       coverPhoto: json['cover_photo'] ?? '',
//       images:
//       (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       placeType: json['place_type'] ?? '',
//       status: json['status'] ?? '',
//       verificationStatus: json['verification_status'] ?? '',
//       guestCount: json['guest_count'] ?? 0,
//       bedroomCount: json['bedroom_count'] ?? 0,
//       bedCount: json['bed_count'] ?? 0,
//       bathroomCount: json['bathroom_count'] ?? 0,
//       minimumNights: json['minimum_nights'] ?? 0,
//       maximumNights: json['maximum_nights'] ?? 0,
//       address: json['address'] ?? '',
//       petAllowed: json['pet_allowed'] ?? false,
//       eventAllowed: json['event_allowed'] ?? false,
//       smokingAllowed: json['smoking_allowed'] ?? false,
//       mediaAllowed: json['media_allowed'] ?? false,
//       unmarriedCouplesAllowed: json['unmarried_couples_allowed'] ?? false,
//       cancellationPolicy: json['cancellation_policy'] ?? {},
//       checkIn: json['check_in'] ?? '',
//       checkOut: json['check_out'] ?? '',
//       avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
//       totalRatingSum: (json['total_rating_sum'] ?? 0.0).toDouble(),
//       totalRatingCount: json['total_rating_count'] ?? 0,
//       totalBookingCount: json['total_booking_count'] ?? 0,
//       location: json['location'] ?? '',
//       district: json['district'] ?? '',
//       division: json['division'] ?? '',
//       area: json['area'] ?? '',
//       city: json['city'] ?? '',
//       isDeleted: json['is_deleted'] ?? false,
//       deletedAt: json['deleted_at'],
//       host: Host.fromJson(json['host'] ?? {}),
//       category: json['category'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'latitude': latitude,
//       'longitude': longitude,
//       'instant_booking_allowed': instantBookingAllowed,
//       'require_guest_good_track_record': requireGuestGoodTrackRecord,
//       'enable_length_of_stay_discount': enableLengthOfStayDiscount,
//       'length_of_stay_discounts': lengthOfStayDiscounts,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'unique_id': uniqueId,
//       'title': title,
//       'description': description,
//       'price': price,
//       'cover_photo': coverPhoto,
//       'images': images,
//       'place_type': placeType,
//       'status': status,
//       'verification_status': verificationStatus,
//       'guest_count': guestCount,
//       'bedroom_count': bedroomCount,
//       'bed_count': bedCount,
//       'bathroom_count': bathroomCount,
//       'minimum_nights': minimumNights,
//       'maximum_nights': maximumNights,
//       'address': address,
//       'pet_allowed': petAllowed,
//       'event_allowed': eventAllowed,
//       'smoking_allowed': smokingAllowed,
//       'media_allowed': mediaAllowed,
//       'unmarried_couples_allowed': unmarriedCouplesAllowed,
//       'cancellation_policy': cancellationPolicy,
//       'check_in': checkIn,
//       'check_out': checkOut,
//       'avg_rating': avgRating,
//       'total_rating_sum': totalRatingSum,
//       'total_rating_count': totalRatingCount,
//       'total_booking_count': totalBookingCount,
//       'location': location,
//       'district': district,
//       'division': division,
//       'area': area,
//       'city': city,
//       'is_deleted': isDeleted,
//       'deleted_at': deletedAt,
//       'host': host.toJson(),
//       'category': category,
//     };
//   }
// }
// class Host {
//   final int id;
//   final String email;
//   final String image;
//   final String identityVerificationStatus;
//   final String status;
//   final String? currentSuperhostTier;
//
//   Host({
//     required this.id,
//     required this.email,
//     required this.image,
//     required this.identityVerificationStatus,
//     required this.status,
//     this.currentSuperhostTier,
//   });
//
//   factory Host.fromJson(Map<String, dynamic> json) {
//     return Host(
//       id: json['id'] ?? 0,
//       email: json['email'] ?? '',
//       image: json['image'] ?? '',
//       identityVerificationStatus: json['identity_verification_status'] ?? '',
//       status: json['status'] ?? '',
//       currentSuperhostTier: json['current_superhost_tier'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'image': image,
//       'identity_verification_status': identityVerificationStatus,
//       'status': status,
//       'current_superhost_tier': currentSuperhostTier,
//     };
//   }
// }

// Hello I am Tamim