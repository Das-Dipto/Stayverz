
class BookingDetails {
  final bool? success;
  final int? statusCode;
  final String? message;
  final BookingData? data;

  BookingDetails({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }
}

class BookingData {
  final Booking? bookingData;
  final ReviewData? reviewData;
  final String? chatRoom;

  BookingData({
    this.bookingData,
    this.reviewData,
    this.chatRoom,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingData: json['booking_data'] != null ? Booking.fromJson(json['booking_data']) : null,
      reviewData: json['review_data'] != null ? ReviewData.fromJson(json['review_data']) : null,
      chatRoom: json['chat_room'] as String?,
    );
  }
}

class Booking {
  final int? id;
  final String? invoiceNo;
  final String? reservationCode;
  final String? checkIn;
  final String? checkOut;
  final int? nightCount;
  final int? childrenCount;
  final int? infantCount;
  final int? adultCount;
  final int? guestCount;
  final double? price;
  final double? guestServiceCharge;
  final double? totalPrice;
  final double? paidAmount;
  final Map<String, PriceInfo>? priceInfo;
  final String? status;
  final bool? guestReviewDone;
  final Listing? listing;
  final Host? host;

  Booking({
    this.id,
    this.invoiceNo,
    this.reservationCode,
    this.checkIn,
    this.checkOut,
    this.nightCount,
    this.childrenCount,
    this.infantCount,
    this.adultCount,
    this.guestCount,
    this.price,
    this.guestServiceCharge,
    this.totalPrice,
    this.paidAmount,
    this.priceInfo,
    this.status,
    this.guestReviewDone,
    this.listing,
    this.host,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final priceInfoMap = (json['price_info'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, PriceInfo.fromJson(value)),
    );

    return Booking(
      id: json['id'] as int?,
      invoiceNo: json['invoice_no'] as String?,
      reservationCode: json['reservation_code'] as String?,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      nightCount: json['night_count'] as int?,
      childrenCount: json['children_count'] as int?,
      infantCount: json['infant_count'] as int?,
      adultCount: json['adult_count'] as int?,
      guestCount: json['guest_count'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      guestServiceCharge: (json['guest_service_charge'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      priceInfo: priceInfoMap,
      status: json['status'] as String?,
      guestReviewDone: json['guest_review_done'] as bool?,
      listing: json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
    );
  }
}

class PriceInfo {
  final String? note;
  final double? price;

  PriceInfo({
    this.note,
    this.price,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      note: json['note'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}

class Listing {
  final int? id;
  final String? title;
  final String? coverPhoto;
  final String? address;
  final CancellationPolicy? cancellationPolicy;
  final double? avgRating;
  final int? totalRatingCount;

  Listing({
    this.id,
    this.title,
    this.coverPhoto,
    this.address,
    this.cancellationPolicy,
    this.avgRating,
    this.totalRatingCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as int?,
      title: json['title'] as String?,
      coverPhoto: json['cover_photo'] as String?,
      address: json['address'] as String?,
      cancellationPolicy: json['cancellation_policy'] != null
          ? CancellationPolicy.fromJson(json['cancellation_policy'])
          : null,
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'] as int? ?? 0,
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

class Host {
  final int? id;
  final String? fullName;
  final String? phoneNumber;

  Host({
    this.id,
    this.fullName,
    this.phoneNumber,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] as int?,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}

class ReviewData {
  final String? review;
  final int? rating;
  final String? image;
  final String? fullName;
  final String? createdAt;

  ReviewData({
    this.review,
    this.rating,
    this.image,
    this.fullName,
    this.createdAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      review: json['review'] as String?,
      rating: json['rating'] as int?,
      image: json['image'] as String?,
      fullName: json['full_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'rating': rating,
      'image': image,
      'full_name': fullName,
      'created_at': createdAt,
    };
  }
}

// Hello I am Tamim