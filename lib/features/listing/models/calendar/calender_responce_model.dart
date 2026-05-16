class CalendarResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CalendarDataWrapper data;

  CalendarResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: CalendarDataWrapper.fromJson(json['data']),
    );
  }
}

class CalendarDataWrapper {
  final Listing listing;
  final Map<String, CalendarDayData> calendarData;

  CalendarDataWrapper({required this.listing, required this.calendarData});

  factory CalendarDataWrapper.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawCalendar = json['calendar_data'] ?? {};
    final Map<String, CalendarDayData> calendarData = rawCalendar.map(
      (key, value) => MapEntry(key, CalendarDayData.fromJson(value)),
    );

    return CalendarDataWrapper(
      listing: Listing.fromJson(json['listing']),
      calendarData: calendarData,
    );
  }
}

class Listing {
  final double basePrice;
  final int minimumNights;
  final int maximumNights;
  final double guestServiceCharge;
  final double hostServiceCharge;

  Listing({
    required this.basePrice,
    required this.minimumNights,
    required this.maximumNights,
    required this.guestServiceCharge,
    required this.hostServiceCharge,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      basePrice: (json['base_price'] ?? 0).toDouble(),
      minimumNights: json['minimum_nights'] ?? 0,
      maximumNights: json['maximum_nights'] ?? 0,
      guestServiceCharge: (json['guest_service_charge'] ?? 0).toDouble(),
      hostServiceCharge: (json['host_service_charge'] ?? 0).toDouble(),
    );
  }
}

class CalendarDayData {
  final int? id;
  final double? price;
  final bool? isBlocked;
  final bool? isBooked;
  final BookingData? bookingData;
  final String? note;

  CalendarDayData({
    this.id,
    this.price,
    this.isBlocked,
    this.isBooked,
    this.bookingData,
    this.note,
  });

  factory CalendarDayData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CalendarDayData();
    return CalendarDayData(
      id: json['id'] as int?,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      isBlocked: json['is_blocked'] as bool?,
      isBooked: json['is_booked'] as bool?,
      bookingData:
          (json['booking_data'] != null &&
                  (json['booking_data'] as Map).isNotEmpty)
              ? BookingData.fromJson(json['booking_data'])
              : null,
      note: json['note'] as String?,
    );
  }
}

class BookingData {
  final UserData? user;
  final Booking? booking;

  BookingData({this.user, this.booking});

  factory BookingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingData();
    return BookingData(
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      booking:
          json['booking'] != null ? Booking.fromJson(json['booking']) : null,
    );
  }
}

class UserData {
  final int? id;
  final String? email;
  final String? image;
  final String? uType;
  final String? fullName;
  final String? phoneNumber;

  UserData({
    this.id,
    this.email,
    this.image,
    this.uType,
    this.fullName,
    this.phoneNumber,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserData();
    return UserData(
      id: json['id'] as int?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      uType: json['u_type'] as String?,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}

class Booking {
  final int? id;
  final String? invoiceNo;
  final String? reservationCode;

  Booking({this.id, this.invoiceNo, this.reservationCode});

  factory Booking.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Booking();
    return Booking(
      id: json['id'] as int?,
      invoiceNo: json['invoice_no'] as String?,
      reservationCode: json['reservation_code'] as String?,
    );
  }
}

// Hello I am Tamim