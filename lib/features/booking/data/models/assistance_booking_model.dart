import 'dart:convert';

class AssistanceBookingModel {
  final int? status;
  final String? message;
  final BookedAssistanceData? data;
  final DateTime? timestamp;

  AssistanceBookingModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceBookingModel.fromRawJson(String str) => AssistanceBookingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceBookingModel.fromJson(Map<String, dynamic> json) => AssistanceBookingModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : BookedAssistanceData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class BookedAssistanceData {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? invoiceNo;
  final String? guestId;
  final int? hostId;
  final dynamic reservationCode;
  final int? listingId;
  final dynamic pgwTransactionNumber;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? nightCount;
  final int? guestCount;
  final int? price;
  final double? guestServiceCharge;
  final double? totalPrice;
  final int? paidAmount;
  final Map<String, PriceInfo>? priceInfo;
  final num? hostServiceCharge;
  final num? hostPayOut;
  final num? totalProfit;
  final List<CalendarInfo>? calendarInfo;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;
  final dynamic chatRoomId;
  final dynamic cancellationReason;
  final bool? guestReviewDone;
  final bool? hostReviewDone;
  final dynamic appliedCouponCode;
  final int? discountAmountApplied;
  final double? priceAfterDiscount;
  final int? refundAmount;
  final bool? isRefunded;
  final String? phoneNumber;
  final String? location;
  final int? extraGuestCount;
  final int? extraGuestCharge;
  final dynamic expiresAt;
  final int? originalPriceBeforeDiscount;
  final int? totalDiscountAmount;
  final int? accommodationCharge;
  final double? subtotalBeforeGenericCoupon;

  BookedAssistanceData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.invoiceNo,
    this.guestId,
    this.hostId,
    this.reservationCode,
    this.listingId,
    this.pgwTransactionNumber,
    this.checkIn,
    this.checkOut,
    this.nightCount,
    this.guestCount,
    this.price,
    this.guestServiceCharge,
    this.totalPrice,
    this.paidAmount,
    this.priceInfo,
    this.hostServiceCharge,
    this.hostPayOut,
    this.totalProfit,
    this.calendarInfo,
    this.guestPaymentStatus,
    this.hostPaymentStatus,
    this.status,
    this.chatRoomId,
    this.cancellationReason,
    this.guestReviewDone,
    this.hostReviewDone,
    this.appliedCouponCode,
    this.discountAmountApplied,
    this.priceAfterDiscount,
    this.refundAmount,
    this.isRefunded,
    this.phoneNumber,
    this.location,
    this.extraGuestCount,
    this.extraGuestCharge,
    this.expiresAt,
    this.originalPriceBeforeDiscount,
    this.totalDiscountAmount,
    this.accommodationCharge,
    this.subtotalBeforeGenericCoupon,
  });

  factory BookedAssistanceData.fromRawJson(String str) => BookedAssistanceData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookedAssistanceData.fromJson(Map<String, dynamic> json) => BookedAssistanceData(
    id: json["id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    invoiceNo: json["invoice_no"],
    guestId: json["guest_id"],
    hostId: json["host_id"],
    reservationCode: json["reservation_code"],
    listingId: json["listing_id"],
    pgwTransactionNumber: json["pgw_transaction_number"],
    checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
    checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
    nightCount: json["night_count"],
    guestCount: json["guest_count"],
    price: json["price"],
    guestServiceCharge: double.tryParse("${json["guest_service_charge"] ?? 0}"),
    totalPrice: double.tryParse("${json["total_price"]}"),
    paidAmount: json["paid_amount"],
    priceInfo: Map.from(json["price_info"]!).map((k, v) => MapEntry<String, PriceInfo>(k, PriceInfo.fromJson(v))),
    hostServiceCharge: double.tryParse("${json["host_service_charge"]}"),
    hostPayOut: json["host_pay_out"],
    totalProfit: double.tryParse("${json["total_profit"]}"),
    calendarInfo: json["calendar_info"] == null ? [] : List<CalendarInfo>.from(json["calendar_info"]!.map((x) => CalendarInfo.fromJson(x))),
    guestPaymentStatus: json["guest_payment_status"],
    hostPaymentStatus: json["host_payment_status"],
    status: json["status"],
    chatRoomId: json["chat_room_id"],
    cancellationReason: json["cancellation_reason"],
    guestReviewDone: json["guest_review_done"],
    hostReviewDone: json["host_review_done"],
    appliedCouponCode: json["applied_coupon_code"],
    discountAmountApplied: json["discount_amount_applied"],
    priceAfterDiscount: double.tryParse("${json["price_after_discount"]}"),
    refundAmount: json["refund_amount"],
    isRefunded: json["is_refunded"],
    phoneNumber: json["phone_number"],
    location: json["location"],
    extraGuestCount: json["extra_guest_count"],
    extraGuestCharge: json["extra_guest_charge"],
    expiresAt: json["expires_at"],
    originalPriceBeforeDiscount: json["original_price_before_discount"],
    totalDiscountAmount: json["total_discount_amount"],
    accommodationCharge: json["accommodation_charge"],
    subtotalBeforeGenericCoupon: double.tryParse("${json["subtotal_before_generic_coupon"]}"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "invoice_no": invoiceNo,
    "guest_id": guestId,
    "host_id": hostId,
    "reservation_code": reservationCode,
    "listing_id": listingId,
    "pgw_transaction_number": pgwTransactionNumber,
    "check_in": "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "check_out": "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "night_count": nightCount,
    "guest_count": guestCount,
    "price": price,
    "guest_service_charge": guestServiceCharge,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "price_info": Map.from(priceInfo!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "host_service_charge": hostServiceCharge,
    "host_pay_out": hostPayOut,
    "total_profit": totalProfit,
    "calendar_info": calendarInfo == null ? [] : List<dynamic>.from(calendarInfo!.map((x) => x.toJson())),
    "guest_payment_status": guestPaymentStatus,
    "host_payment_status": hostPaymentStatus,
    "status": status,
    "chat_room_id": chatRoomId,
    "cancellation_reason": cancellationReason,
    "guest_review_done": guestReviewDone,
    "host_review_done": hostReviewDone,
    "applied_coupon_code": appliedCouponCode,
    "discount_amount_applied": discountAmountApplied,
    "price_after_discount": priceAfterDiscount,
    "refund_amount": refundAmount,
    "is_refunded": isRefunded,
    "phone_number": phoneNumber,
    "location": location,
    "extra_guest_count": extraGuestCount,
    "extra_guest_charge": extraGuestCharge,
    "expires_at": expiresAt,
    "original_price_before_discount": originalPriceBeforeDiscount,
    "total_discount_amount": totalDiscountAmount,
    "accommodation_charge": accommodationCharge,
    "subtotal_before_generic_coupon": subtotalBeforeGenericCoupon,
  };
}

class CalendarInfo {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? price;
  final int? basePrice;

  CalendarInfo({
    this.startDate,
    this.endDate,
    this.price,
    this.basePrice,
  });

  factory CalendarInfo.fromRawJson(String str) => CalendarInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    price: json["price"],
    basePrice: json["base_price"],
  );

  Map<String, dynamic> toJson() => {
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "price": price,
    "base_price": basePrice,
  };
}

class PriceInfo {
  final int? id;
  final int? price;
  final bool? isBlocked;
  final bool? isBooked;
  final String? note;
  final List<BookingDatum>? bookingData;

  PriceInfo({
    this.id,
    this.price,
    this.isBlocked,
    this.isBooked,
    this.note,
    this.bookingData,
  });

  factory PriceInfo.fromRawJson(String str) => PriceInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
    id: json["id"],
    price: json["price"],
    isBlocked: json["isBlocked"],
    isBooked: json["isBooked"],
    note: json["note"],
    bookingData: json["bookingData"] == null ? [] : List<BookingDatum>.from(json["bookingData"]!.map((x) => BookingDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "isBlocked": isBlocked,
    "isBooked": isBooked,
    "note": note,
    "bookingData": bookingData == null ? [] : List<dynamic>.from(bookingData!.map((x) => x.toJson())),
  };
}

class BookingDatum {
  final User? user;
  final Booking? booking;

  BookingDatum({
    this.user,
    this.booking,
  });

  factory BookingDatum.fromRawJson(String str) => BookingDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDatum.fromJson(Map<String, dynamic> json) => BookingDatum(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "booking": booking?.toJson(),
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

class User {
  final String? id;
  final String? fullName;
  final String? image;

  User({
    this.id,
    this.fullName,
    this.image,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "image": image,
  };
}

// Hello I am Tamim