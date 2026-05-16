import 'dart:convert';


class AssistanceBookingReviewModel {
  int? status;
  String? message;
  AssistanceGuestReviewData? data;
  String? timestamp;

  AssistanceBookingReviewModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceBookingReviewModel.fromJson(Map<String, dynamic> json) =>
      AssistanceBookingReviewModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AssistanceGuestReviewData.fromJson(json["data"]),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp,
  };
}

class AssistanceGuestReviewData {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? listingId;
  int? bookingId;
  Booking? booking;
  String? image;
  String? fullName;
  int? reviewById;
  int? reviewForId;
  int? rating;
  String? review;
  bool? isGuestReview;
  bool? isHostReview;

  AssistanceGuestReviewData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.listingId,
    this.bookingId,
    this.booking,
    this.image,
    this.fullName,
    this.reviewById,
    this.reviewForId,
    this.rating,
    this.review,
    this.isGuestReview,
    this.isHostReview,
  });

  factory AssistanceGuestReviewData.fromJson(Map<String, dynamic> json) => AssistanceGuestReviewData(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    listingId: json["listing_id"],
    bookingId: json["booking_id"],
    booking:
    json["booking"] == null ? null : Booking.fromJson(json["booking"]),
    image: json["image"],
    fullName: json["full_name"],
    reviewById: json["review_by_id"],
    reviewForId: json["review_for_id"],
    rating: json["rating"],
    review: json["review"],
    isGuestReview: json["is_guest_review"],
    isHostReview: json["is_host_review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "listing_id": listingId,
    "booking_id": bookingId,
    "booking": booking?.toJson(),
    "image": image,
    "full_name": fullName,
    "review_by_id": reviewById,
    "review_for_id": reviewForId,
    "rating": rating,
    "review": review,
    "is_guest_review": isGuestReview,
    "is_host_review": isHostReview,
  };
}

class Booking {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? invoiceNo;
  String? guestId;
  String? hostId;
  String? reservationCode;
  int? listingId;
  String? pgwTransactionNumber;
  String? checkIn;
  String? checkOut;
  int? nightCount;
  int? guestCount;
  int? price;
  int? guestServiceCharge;
  int? totalPrice;
  int? paidAmount;
  Map<String, PriceInfo>? priceInfo;
  int? hostServiceCharge;
  int? hostPayOut;
  int? totalProfit;
  List<CalendarInfo>? calendarInfo;
  String? guestPaymentStatus;
  String? hostPaymentStatus;
  String? status;
  String? chatRoomId;
  String? cancellationReason;
  bool? guestReviewDone;
  bool? hostReviewDone;
  String? appliedCouponCode;
  int? discountAmountApplied;
  int? priceAfterDiscount;
  int? refundAmount;
  bool? isRefunded;
  String? phoneNumber;
  String? location;
  int? extraGuestCount;
  int? extraGuestCharge;
  String? expiresAt;

  Booking({
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
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    invoiceNo: json["invoice_no"],
    guestId: json["guest_id"],
    hostId: json["host_id"],
    reservationCode: json["reservation_code"],
    listingId: json["listing_id"],
    pgwTransactionNumber: json["pgw_transaction_number"],
    checkIn: json["check_in"],
    checkOut: json["check_out"],
    nightCount: json["night_count"],
    guestCount: json["guest_count"],
    price: json["price"],
    guestServiceCharge: json["guest_service_charge"],
    totalPrice: json["total_price"],
    paidAmount: json["paid_amount"],
    priceInfo: json["price_info"] == null
        ? null
        : Map.from(json["price_info"]).map((k, v) =>
        MapEntry<String, PriceInfo>(k, PriceInfo.fromJson(v))),
    hostServiceCharge: json["host_service_charge"],
    hostPayOut: json["host_pay_out"],
    totalProfit: json["total_profit"],
    calendarInfo: json["calendar_info"] == null
        ? []
        : List<CalendarInfo>.from(
        json["calendar_info"].map((x) => CalendarInfo.fromJson(x))),
    guestPaymentStatus: json["guest_payment_status"],
    hostPaymentStatus: json["host_payment_status"],
    status: json["status"],
    chatRoomId: json["chat_room_id"],
    cancellationReason: json["cancellation_reason"],
    guestReviewDone: json["guest_review_done"],
    hostReviewDone: json["host_review_done"],
    appliedCouponCode: json["applied_coupon_code"],
    discountAmountApplied: json["discount_amount_applied"],
    priceAfterDiscount: json["price_after_discount"],
    refundAmount: json["refund_amount"],
    isRefunded: json["is_refunded"],
    phoneNumber: json["phone_number"],
    location: json["location"],
    extraGuestCount: json["extra_guest_count"],
    extraGuestCharge: json["extra_guest_charge"],
    expiresAt: json["expires_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "invoice_no": invoiceNo,
    "guest_id": guestId,
    "host_id": hostId,
    "reservation_code": reservationCode,
    "listing_id": listingId,
    "pgw_transaction_number": pgwTransactionNumber,
    "check_in": checkIn,
    "check_out": checkOut,
    "night_count": nightCount,
    "guest_count": guestCount,
    "price": price,
    "guest_service_charge": guestServiceCharge,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "price_info": priceInfo == null
        ? null
        : Map.from(priceInfo!)
        .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "host_service_charge": hostServiceCharge,
    "host_pay_out": hostPayOut,
    "total_profit": totalProfit,
    "calendar_info": calendarInfo == null
        ? []
        : List<dynamic>.from(calendarInfo!.map((x) => x.toJson())),
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
  };
}

class CalendarInfo {
  int? price;
  String? endDate;
  int? basePrice;
  String? startDate;

  CalendarInfo({
    this.price,
    this.endDate,
    this.basePrice,
    this.startDate,
  });

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
    price: json["price"],
    endDate: json["end_date"],
    basePrice: json["base_price"],
    startDate: json["start_date"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "end_date": endDate,
    "base_price": basePrice,
    "start_date": startDate,
  };
}

class PriceInfo {
  int? id;
  String? note;
  int? price;
  bool? isBooked;
  bool? isBlocked;

  PriceInfo({
    this.id,
    this.note,
    this.price,
    this.isBooked,
    this.isBlocked,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
    id: json["id"],
    note: json["note"],
    price: json["price"],
    isBooked: json["isBooked"],
    isBlocked: json["isBlocked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "price": price,
    "isBooked": isBooked,
    "isBlocked": isBlocked,
  };
}

// Hello I am Tamim