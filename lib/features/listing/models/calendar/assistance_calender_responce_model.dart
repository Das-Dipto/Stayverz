import 'dart:convert';

class AssistanceCalendarResponse {
  final int? status;
  final String? message;
  final Data? data;
  final DateTime? timestamp;

  AssistanceCalendarResponse({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceCalendarResponse.fromRawJson(String str) => AssistanceCalendarResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCalendarResponse.fromJson(Map<String, dynamic> json) => AssistanceCalendarResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class Data {
  final Listing? listing;
  final Map<String, CalendarDatum>? calendarData;

  Data({
    this.listing,
    this.calendarData,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    listing: json["listing"] == null ? null : Listing.fromJson(json["listing"]),
    calendarData: Map.from(json["calendar_data"]!).map((k, v) => MapEntry<String, CalendarDatum>(k, CalendarDatum.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "listing": listing?.toJson(),
    "calendar_data": Map.from(calendarData!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class CalendarDatum {
  final int? id;
  final double? price;
  final bool? isBlocked;
  final bool? isBooked;
  final String? note;
  final List<BookingDataItem>? bookingData;

  CalendarDatum({
    this.id,
    this.price,
    this.isBlocked,
    this.isBooked,
    this.note,
    this.bookingData,
  });

  factory CalendarDatum.fromRawJson(String str) =>
      CalendarDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalendarDatum.fromJson(Map<String, dynamic> json) => CalendarDatum(
        id: json["id"],
        price: json["price"]?.toDouble(),
        isBlocked: json["isBlocked"],
        isBooked: json["isBooked"],
        note: json["note"],
        bookingData: json["bookingData"] == null
            ? []
            : List<BookingDataItem>.from(
                json["bookingData"]!.map((x) => BookingDataItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "isBlocked": isBlocked,
        "isBooked": isBooked,
        "note": note,
        "bookingData": bookingData == null
            ? []
            : List<dynamic>.from(bookingData!.map((x) => x.toJson())),
      };
}

class BookingDataItem {
  final User? user;
  final Booking? booking;

  BookingDataItem({
    this.user,
    this.booking,
  });

  factory BookingDataItem.fromRawJson(String str) =>
      BookingDataItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDataItem.fromJson(Map<String, dynamic> json) =>
      BookingDataItem(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        booking:
        json["booking"] == null ? null : Booking.fromJson(json["booking"]),
      );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "booking": booking?.toJson(),
  };
}

class User {
  final String? id;
  final String? image;
  final String? fullName;

  User({
    this.id,
    this.image,
    this.fullName,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]?.toString(),
    image: json["image"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "full_name": fullName,
  };
}

class Booking {
  final String? invoiceNo;

  Booking({
    this.invoiceNo,
  });

  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    invoiceNo: json["invoice_no"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_no": invoiceNo,
  };
}


class Listing {
  final double? basePrice;
  final double? guestServiceCharge;
  final double? hostServiceCharge;

  Listing({
    this.basePrice,
    this.guestServiceCharge,
    this.hostServiceCharge,
  });

  factory Listing.fromRawJson(String str) => Listing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        basePrice: json["base_price"]?.toDouble(),
        guestServiceCharge: json["guest_service_charge"]?.toDouble(),
        hostServiceCharge: json["host_service_charge"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "base_price": basePrice,
        "guest_service_charge": guestServiceCharge,
        "host_service_charge": hostServiceCharge,
      };
}

// Hello I am Tamim