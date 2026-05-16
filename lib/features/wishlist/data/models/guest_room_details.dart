class ListingModel {
  final bool success;
  final int statusCode;
  final String message;
  final ListingData data;

  ListingModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: ListingData.fromJson(json['data']),
    );
  }
}

class ListingData {
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
  final CancellationPolicy cancellationPolicy;
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
  final List<dynamic> amenities;
  final Map<String, CalendarData> calendarData;
  final double serviceChargePercentage;
  final List<dynamic> reviews;

  ListingData({
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
    required this.amenities,
    required this.calendarData,
    required this.serviceChargePercentage,
    required this.reviews,
  });

  factory ListingData.fromJson(Map<String, dynamic> json) {
    Map<String, CalendarData> calendarMap = {};
    (json['calendar_data'] as Map<String, dynamic>).forEach((key, value) {
      calendarMap[key] = CalendarData.fromJson(value);
    });

    return ListingData(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      instantBookingAllowed: json['instant_booking_allowed'],
      requireGuestGoodTrackRecord: json['require_guest_good_track_record'],
      enableLengthOfStayDiscount: json['enable_length_of_stay_discount'],
      lengthOfStayDiscounts: json['length_of_stay_discounts'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      uniqueId: json['unique_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      coverPhoto: json['cover_photo'],
      images: List<String>.from(json['images']),
      placeType: json['place_type'],
      status: json['status'],
      verificationStatus: json['verification_status'],
      guestCount: json['guest_count'],
      bedroomCount: json['bedroom_count'],
      bedCount: json['bed_count'],
      bathroomCount: json['bathroom_count'],
      minimumNights: json['minimum_nights'],
      maximumNights: json['maximum_nights'],
      address: json['address'],
      petAllowed: json['pet_allowed'],
      eventAllowed: json['event_allowed'],
      smokingAllowed: json['smoking_allowed'],
      mediaAllowed: json['media_allowed'],
      unmarriedCouplesAllowed: json['unmarried_couples_allowed'],
      cancellationPolicy: CancellationPolicy.fromJson(json['cancellation_policy']),
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      avgRating: (json['avg_rating'] as num).toDouble(),
      totalRatingSum: (json['total_rating_sum'] as num).toDouble(),
      totalRatingCount: json['total_rating_count'],
      totalBookingCount: json['total_booking_count'],
      location: json['location'],
      district: json['district'] ?? "",
      division: json['division'] ?? "",
      area: json['area'] ?? "",
      city: json['city'] ?? "",
      isDeleted: json['is_deleted'],
      deletedAt: json['deleted_at'],
      host: Host.fromJson(json['host']),
      category: json['category'],
      amenities: json['amenities'] ?? [],
      calendarData: calendarMap,
      serviceChargePercentage: (json['service_charge_percentage'] as num).toDouble(),
      reviews: json['reviews'] ?? [],
    );
  }
}

class CancellationPolicy {
  final String type;
  final String description;

  CancellationPolicy({
    required this.type,
    required this.description,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) {
    return CancellationPolicy(
      type: json['type'],
      description: json['description'],
    );
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
  final String dateJoined;
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
      fullName: json['full_name'],
      image: json['image'],
      email: json['email'],
      identityVerificationStatus: json['identity_verification_status'],
      status: json['status'],
      bio: json['bio'],
      dateJoined: json['date_joined'],
      languages: json['translations'],
      address: json['address'],
      phoneNumber: json['phone_number'],
    );
  }
}

class CalendarData {
  final int id;
  final double price;
  final bool isBlocked;
  final bool isBooked;
  final BookingData? bookingData;
  final String note;

  CalendarData({
    required this.id,
    required this.price,
    required this.isBlocked,
    required this.isBooked,
    this.bookingData,
    required this.note,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      isBlocked: json['is_blocked'],
      isBooked: json['is_booked'],
      bookingData: json['booking_data'] != null && json['booking_data'].isNotEmpty
          ? BookingData.fromJson(json['booking_data'])
          : null,
      note: json['note'],
    );
  }
}

class BookingData {
  final BookingUser user;
  final Booking booking;

  BookingData({
    required this.user,
    required this.booking,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      user: BookingUser.fromJson(json['user']),
      booking: Booking.fromJson(json['booking']),
    );
  }
}

class BookingUser {
  final int id;
  final String email;
  final String image;
  final String uType;
  final String fullName;
  final String phoneNumber;

  BookingUser({
    required this.id,
    required this.email,
    required this.image,
    required this.uType,
    required this.fullName,
    required this.phoneNumber,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'],
      email: json['email'],
      image: json['image'],
      uType: json['u_type'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
    );
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
      invoiceNo: json['invoice_no'],
      reservationCode: json['reservation_code'],
    );
  }
}

// Hello I am Tamim