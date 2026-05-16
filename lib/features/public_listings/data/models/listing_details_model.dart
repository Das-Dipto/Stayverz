class ListingDetailsModel {
  final int? id;
  final double? latitude;
  final double? longitude;
  final bool? instantBookingAllowed;
  final bool? requireGuestGoodTrackRecord;
  final bool? enableLengthOfStayDiscount;
  final Map<String, dynamic>? lengthOfStayDiscounts;
  final String? uniqueId;
  final String? title;
  final String? description;
  final double? price;
  final String? coverPhoto;
  final List<String>? images;
  final List<String>? living_room_images;
  final List<String>? kitchen_images;
  final List<String>? bathroom_images;
  final List<String>? bedroom_images;
  final List<String>? washroom_images;
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
  final Host? host;
  final int? category;
  final List<AmenityItem>? amenities;
  final Map<String, CalendarDay>? calendarData;
  final double? serviceChargePercentage;
  final List<Review>? reviews;


  ListingDetailsModel({
    this.id,
    this.latitude,
    this.longitude,
    this.instantBookingAllowed,
    this.requireGuestGoodTrackRecord,
    this.enableLengthOfStayDiscount,
    this.lengthOfStayDiscounts,
    this.uniqueId,
    this.title,
    this.description,
    this.price,
    this.coverPhoto,
    this.images,
    this.living_room_images,
    this.kitchen_images,
    this.bathroom_images,
    this.bedroom_images,
    this.washroom_images,
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
    this.amenities,
    this.calendarData,
    this.serviceChargePercentage,
    this.reviews,
  });


  factory ListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return ListingDetailsModel(
      id: json['id'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      instantBookingAllowed: json['instant_booking_allowed'] as bool?,
      requireGuestGoodTrackRecord: json['require_guest_good_track_record'] as bool?,
      enableLengthOfStayDiscount: json['enable_length_of_stay_discount'] as bool?,
      lengthOfStayDiscounts: json['length_of_stay_discounts'] != null 
          ? Map<String, dynamic>.from(json['length_of_stay_discounts'])
          : null,
      uniqueId: json['unique_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      coverPhoto: json['cover_photo'] as String?,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      living_room_images: json['living_room_images'] != null
          ? List<String>.from(json['living_room_images'])
          : null,

      kitchen_images: json['kitchen_images'] != null
          ? List<String>.from(json['kitchen_images'])
          : null,

      bathroom_images: json['bathroom_images'] != null
          ? List<String>.from(json['bathroom_images'])
          : null,

      bedroom_images: json['bedroom_images'] != null
          ? List<String>.from(json['bedroom_images'])
          : null,

      washroom_images: json['washroom_images'] != null
          ? List<String>.from(json['washroom_images'])
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
          ? CancellationPolicy.fromJson(json['cancellation_policy'])
          : null,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingSum: (json['total_rating_sum'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'] as int?,
      totalBookingCount: json['total_booking_count'] as int?,
      location: json['location'] as String?,
      district: json['district'] as String?,
      division: json['division'] as String?,
      area: json['area'] as String?,
      city: json['city'] as String?,
      isDeleted: json['is_deleted'] as bool?,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
      category: json['category'] as int?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((item) => AmenityItem.fromJson(item))
          .toList(),
      calendarData: json['calendar_data'] != null
          ? Map.from(json['calendar_data']).map((k, v) =>
              MapEntry(k as String, CalendarDay.fromJson(v as Map<String, dynamic>)))
          : null,
      serviceChargePercentage: (json['service_charge_percentage'] as num?)?.toDouble(),
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
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
      'unique_id': uniqueId,
      'title': title,
      'description': description,
      'price': price,
      'cover_photo': coverPhoto,
      'images': images,
      'living_room_images': living_room_images,
      'kitchen_images': kitchen_images,
      'bathroom_images': bathroom_images,
      'bedroom_images': bedroom_images,
      'washroom_images': washroom_images,
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
      'cancellation_policy': cancellationPolicy?.toJson(),
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
      'deleted_at': deletedAt?.toIso8601String(),
      'host': host?.toJson(),
      'category': category,
      'amenities': amenities?.map((item) => item.toJson()).toList(),
      'calendar_data': calendarData?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class CancellationPolicy {
  final int id;
  final String description;
  final String policyName;
  final int refundPercentage;
  final int cancellationDeadline;

  CancellationPolicy({
    required this.id,
    required this.description,
    required this.policyName,
    required this.refundPercentage,
    required this.cancellationDeadline,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      policyName: json['policy_name'] ?? '',
      refundPercentage: json['refund_percentage'] ?? 0,
      cancellationDeadline: json['cancellation_deadline'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'policy_name': policyName,
      'refund_percentage': refundPercentage,
      'cancellation_deadline': cancellationDeadline,
    };
  }
}

class Host {
  final int id;
  final String fullName;
  final String image;
  final String email;
  final String identityVerificationStatus;
  final String status;
  final String bio;
  final DateTime dateJoined;
  final List<dynamic> languages;
  final String address;
  final String phoneNumber;

  Host({
    required this.id,
    required this.fullName,
    required this.image,
    required this.email,
    required this.identityVerificationStatus,
    required this.status,
    required this.bio,
    required this.dateJoined,
    required this.languages,
    required this.address,
    required this.phoneNumber,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      identityVerificationStatus: json['identity_verification_status'] ?? '',
      status: json['status'] ?? '',
      bio: json['bio'] ?? '',
      dateJoined: DateTime.parse(json['date_joined']),
      languages: List<dynamic>.from(json['languages'] ?? []),
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'image': image,
      'email': email,
      'identity_verification_status': identityVerificationStatus,
      'status': status,
      'bio': bio,
      'date_joined': dateJoined.toIso8601String(),
      'languages': languages,
      'address': address,
      'phone_number': phoneNumber,
    };
  }
}

class CalendarDay {
  final int id;
  final double price;
  final bool isBlocked;
  final bool isBooked;
  final BookingData bookingData;
  final String note;

  CalendarDay({
    required this.id,
    required this.price,
    required this.isBlocked,
    required this.isBooked,
    required this.bookingData,
    required this.note,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      isBlocked: json['is_blocked'],
      isBooked: json['is_booked'],
      bookingData: json['booking_data'] != null && (json['booking_data'] as Map).isNotEmpty
          ? BookingData.fromJson(json['booking_data'])
          : BookingData.empty(),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'is_blocked': isBlocked,
      'is_booked': isBooked,
      'booking_data': bookingData.toJson(),
      'note': note,
    };
  }
}

class BookingData {
  final User? user;
  final Booking? booking;

  BookingData({
    this.user,
    this.booking,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      booking: json['booking'] != null ? Booking.fromJson(json['booking']) : null,
    );
  }

  factory BookingData.empty() => BookingData();

  Map<String, dynamic> toJson() {
    return {
      if (user != null) 'user': user!.toJson(),
      if (booking != null) 'booking': booking!.toJson(),
    };
  }

  bool get isEmpty => user == null && booking == null;
}

class User {
  final int id;
  final String email;
  final String image;
  final String uType;
  final String fullName;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.image,
    required this.uType,
    required this.fullName,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      uType: json['u_type'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'image': image,
      'u_type': uType,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }
}

class AmenityItem {
  final int id;
  final Amenity amenity;

  AmenityItem({
    required this.id,
    required this.amenity,
  });

  factory AmenityItem.fromJson(Map<String, dynamic> json) {
    return AmenityItem(
      id: json['id'],
      amenity: Amenity.fromJson(json['amenity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amenity': amenity.toJson(),
    };
  }
}

class Amenity {
  final int? id;
  final String? name;
  final String? icon;
  final String? type;
  final String? category;
  final bool? newStatus;
  final bool? status;

  Amenity({
    this.id,
    this.name,
    this.icon,
    this.type,
    this.category,
    this.newStatus,
    this.status,
  });

  factory Amenity.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return  Amenity();
    }

    return Amenity(
      id: json['id'] as int?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      type: json['a_type'] as String?,
      category: json['category'] as String?,
      newStatus: json['new_status'] as bool?,
      status: json['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'a_type': type,
      'category': category,
      'new_status': newStatus,
      'status': status,
    };
  }
}


class Booking {
  final int id;
  final String invoiceNo;
  final String reservationCode;

  Booking({
    required this.id,
    required this.invoiceNo,
    required this.reservationCode,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      invoiceNo: json['invoice_no'] ?? '',
      reservationCode: json['reservation_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_no': invoiceNo,
      'reservation_code': reservationCode,
    };
  }
}

class ReviewUser {
  final int id;
  final String fullName;
  final String image;
  final String phoneNumber;
  final String uType;

  ReviewUser({
    required this.id,
    required this.fullName,
    required this.image,
    required this.phoneNumber,
    required this.uType,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      image: json['image'] as String,
      phoneNumber: json['phone_number'] as String,
      uType: json['u_type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'image': image,
    'phone_number': phoneNumber,
    'u_type': uType,
  };
}

class Review {
  final int id;
  final int rating;
  final String review;
  final ReviewUser reviewBy;

  Review({
    required this.id,
    required this.rating,
    required this.review,
    required this.reviewBy,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      rating: json['rating'] as int,
      review: json['review'] as String,
      reviewBy: ReviewUser.fromJson(json['review_by'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'review': review,
    'review_by': reviewBy.toJson(),
  };
}

// Hello I am Tamim