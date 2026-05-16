import 'dart:convert';

class AssistanceBookingResponse {
  final int? status;
  final String? message;
  final List<AssistanceBookingData>? data;
  final String? timestamp;

  AssistanceBookingResponse({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceBookingResponse.fromJson(Map<String, dynamic> json) =>
      AssistanceBookingResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<AssistanceBookingData>.from(
            json['data'].map((x) => AssistanceBookingData.fromJson(x))),
        timestamp: json['timestamp'],
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    'timestamp': timestamp,
  };
}

class AssistanceBookingData {
  final int? id;
  final String? invoiceNo;
  final String? guestId;
  final String? hostId;
  final String? reservationCode;
  final int? listingId;
  final String? checkIn;
  final String? checkOut;
  final int? nightCount;
  final int? guestCount;
  final double? price;
  final double? totalPrice;
  final double? paidAmount;
  final AssistanceListing? listing;
  final AssistanceGuest? guest;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;

  AssistanceBookingData({
    this.id,
    this.invoiceNo,
    this.guestId,
    this.hostId,
    this.reservationCode,
    this.listingId,
    this.checkIn,
    this.checkOut,
    this.nightCount,
    this.guestCount,
    this.price,
    this.totalPrice,
    this.paidAmount,
    this.listing,
    this.guest,
    this.guestPaymentStatus,
    this.hostPaymentStatus,
    this.status,
  });

  factory AssistanceBookingData.fromJson(Map<String, dynamic> json) =>
      AssistanceBookingData(
        id: json['id'],
        invoiceNo: json['invoice_no'],
        guestId: json['guest_id'],
        hostId: json['host_id'],
        reservationCode: json['reservation_code'],
        listingId: json['listing_id'],
        checkIn: json['check_in'],
        checkOut: json['check_out'],
        nightCount: json['night_count'],
        guestCount: json['guest_count'],
        price: (json['price'] as num?)?.toDouble(),
        totalPrice: (json['total_price'] as num?)?.toDouble(),
        paidAmount: (json['paid_amount'] as num?)?.toDouble(),
        listing: json['listing'] != null
            ? AssistanceListing.fromJson(json['listing'])
            : null,
        guest: json['guest'] != null
            ? AssistanceGuest.fromJson(json['guest'])
            : null,
        guestPaymentStatus: json['guest_payment_status'],
        hostPaymentStatus: json['host_payment_status'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_no': invoiceNo,
    'guest_id': guestId,
    'host_id': hostId,
    'reservation_code': reservationCode,
    'listing_id': listingId,
    'check_in': checkIn,
    'check_out': checkOut,
    'night_count': nightCount,
    'guest_count': guestCount,
    'price': price,
    'total_price': totalPrice,
    'paid_amount': paidAmount,
    'listing': listing?.toJson(),
    'guest': guest?.toJson(),
    'guest_payment_status': guestPaymentStatus,
    'host_payment_status': hostPaymentStatus,
    'status': status,
  };
}

class AssistanceListing {
  final int? id;
  final String? title;
  final String? details;
  final double? price;
  final String? coverPhoto;
  final List<String>? images;
  final String? currentLocationName;
  final String? coverageAreaName;
  final double? avgRating;

  AssistanceListing({
    this.id,
    this.title,
    this.details,
    this.price,
    this.coverPhoto,
    this.images,
    this.currentLocationName,
    this.coverageAreaName,
    this.avgRating,
  });

  factory AssistanceListing.fromJson(Map<String, dynamic> json) =>
      AssistanceListing(
        id: json['id'],
        title: json['title'],
        details: json['details'],
        price: (json['price'] as num?)?.toDouble(),
        coverPhoto: json['cover_photo'],
        images: json['images'] == null
            ? []
            : List<String>.from(json['images'].map((x) => x.toString())),
        currentLocationName: json['current_location_name'],
        coverageAreaName: json['coverage_area_name'],
        avgRating: (json['avg_rating'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'details': details,
    'price': price,
    'cover_photo': coverPhoto,
    'images': images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x)),
    'current_location_name': currentLocationName,
    'coverage_area_name': coverageAreaName,
    'avg_rating': avgRating,
  };
}

class AssistanceGuest {
  final String? id;
  final String? fullName;
  final String? email;
  final String? image;
  final String? phoneNumber;
  final bool? isActive;
  final String? uType;
  final double? avgRating;

  AssistanceGuest({
    this.id,
    this.fullName,
    this.email,
    this.image,
    this.phoneNumber,
    this.isActive,
    this.uType,
    this.avgRating,
  });

  factory AssistanceGuest.fromJson(Map<String, dynamic> json) =>
      AssistanceGuest(
        id: json['id'],
        fullName: json['first_name'] != null && json['last_name'] != null
            ? "${json['first_name']} ${json['last_name']}"
            : json['full_name'],
        email: json['email'],
        image: json['image'],
        phoneNumber: json['phoneNumber'],
        isActive: json['isActive'],
        uType: json['uType'],
        avgRating: (json['avg_rating'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'image': image,
    'phoneNumber': phoneNumber,
    'isActive': isActive,
    'uType': uType,
    'avg_rating': avgRating,
  };
}

// Hello I am Tamim