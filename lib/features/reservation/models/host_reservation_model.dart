import 'dart:convert';

class HostReservationModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<ReservationData>? data;

  HostReservationModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostReservationModel.fromRawJson(String str) => HostReservationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostReservationModel.fromJson(Map<String, dynamic> json) => HostReservationModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ReservationData>.from(json["data"]!.map((x) => ReservationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReservationData {
  final int? id;
  final List<Review>? reviews;
  final dynamic originalPriceBeforeDiscount;
  final dynamic totalDiscountAmount;
  final dynamic accommodationCharge;
  final dynamic subtotalBeforeGenericCoupon;
  final dynamic lengthOfStayDiscountPercent;
  final dynamic lengthOfStayDiscountAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? invoiceNo;
  final String? pgwTransactionNumber;
  final String? reservationCode;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? nightCount;
  final int? childrenCount;
  final int? infantCount;
  final int? adultCount;
  final int? guestCount;
  final double? price;
  final double? guestServiceCharge;
  final double? totalPrice;
  final double? paidAmount;
  final double? hostServiceCharge;
  final double? hostPayOut;
  final double? totalProfit;
  final double? gatewayFee;
  final double? refundAmount;
  final bool? isRefunded;
  final Map<String, PriceInfo>? priceInfo;
  final String? guestPaymentStatus;
  final String? hostPaymentStatus;
  final String? status;
  final String? cancellationReason;
  final bool? hostReviewDone;
  final bool? guestReviewDone;
  final List<CalendarInfo>? calendarInfo;
  final String? chatRoomId;
  final dynamic appliedCouponCode;
  final dynamic appliedCouponType;
  final String? discountAmountApplied;
  final dynamic priceAfterDiscount;
  final dynamic invoicePdf;
  final dynamic invoiceGeneratedAt;
  final Guest? guest;
  final int? host;
  final Listing? listing;
  final dynamic appliedReferralCoupon;
  final dynamic appliedAdminCoupon;

  ReservationData({
    this.id,
    this.reviews,
    this.originalPriceBeforeDiscount,
    this.totalDiscountAmount,
    this.accommodationCharge,
    this.subtotalBeforeGenericCoupon,
    this.lengthOfStayDiscountPercent,
    this.lengthOfStayDiscountAmount,
    this.createdAt,
    this.updatedAt,
    this.invoiceNo,
    this.pgwTransactionNumber,
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
    this.hostServiceCharge,
    this.hostPayOut,
    this.totalProfit,
    this.gatewayFee,
    this.refundAmount,
    this.isRefunded,
    this.priceInfo,
    this.guestPaymentStatus,
    this.hostPaymentStatus,
    this.status,
    this.cancellationReason,
    this.hostReviewDone,
    this.guestReviewDone,
    this.calendarInfo,
    this.chatRoomId,
    this.appliedCouponCode,
    this.appliedCouponType,
    this.discountAmountApplied,
    this.priceAfterDiscount,
    this.invoicePdf,
    this.invoiceGeneratedAt,
    this.guest,
    this.host,
    this.listing,
    this.appliedReferralCoupon,
    this.appliedAdminCoupon,
  });

  factory ReservationData.fromRawJson(String str) => ReservationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReservationData.fromJson(Map<String, dynamic> json) => ReservationData(
    id: json["id"],
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    originalPriceBeforeDiscount: json["original_price_before_discount"],
    totalDiscountAmount: json["total_discount_amount"],
    accommodationCharge: json["accommodation_charge"],
    subtotalBeforeGenericCoupon: json["subtotal_before_generic_coupon"],
    lengthOfStayDiscountPercent: json["length_of_stay_discount_percent"],
    lengthOfStayDiscountAmount: json["length_of_stay_discount_amount"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    invoiceNo: json["invoice_no"],
    pgwTransactionNumber: json["pgw_transaction_number"],
    reservationCode: json["reservation_code"],
    checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
    checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
    nightCount: json["night_count"],
    childrenCount: json["children_count"],
    infantCount: json["infant_count"],
    adultCount: json["adult_count"],
    guestCount: json["guest_count"],
    price: json["price"],
    guestServiceCharge: json["guest_service_charge"]?.toDouble(),
    totalPrice: json["total_price"]?.toDouble(),
    paidAmount: json["paid_amount"]?.toDouble(),
    hostServiceCharge: json["host_service_charge"]?.toDouble(),
    hostPayOut: json["host_pay_out"]?.toDouble(),
    totalProfit: json["total_profit"]?.toDouble(),
    gatewayFee: json["gateway_fee"],
    refundAmount: json["refund_amount"],
    isRefunded: json["is_refunded"],
    priceInfo: Map.from(json["price_info"]!).map((k, v) => MapEntry<String, PriceInfo>(k, PriceInfo.fromJson(v))),
    guestPaymentStatus: json["guest_payment_status"],
    hostPaymentStatus: json["host_payment_status"],
    status: json["status"],
    cancellationReason: json["cancellation_reason"],
    hostReviewDone: json["host_review_done"],
    guestReviewDone: json["guest_review_done"],
    calendarInfo: json["calendar_info"] == null ? [] : List<CalendarInfo>.from(json["calendar_info"]!.map((x) => CalendarInfo.fromJson(x))),
    chatRoomId: json["chat_room_id"],
    appliedCouponCode: json["applied_coupon_code"],
    appliedCouponType: json["applied_coupon_type"],
    discountAmountApplied: json["discount_amount_applied"],
    priceAfterDiscount: json["price_after_discount"],
    invoicePdf: json["invoice_pdf"],
    invoiceGeneratedAt: json["invoice_generated_at"],
    guest: json["guest"] == null ? null : Guest.fromJson(json["guest"]),
    host: json["host"],
    listing: json["listing"] == null ? null : Listing.fromJson(json["listing"]),
    appliedReferralCoupon: json["applied_referral_coupon"],
    appliedAdminCoupon: json["applied_admin_coupon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
    "original_price_before_discount": originalPriceBeforeDiscount,
    "total_discount_amount": totalDiscountAmount,
    "accommodation_charge": accommodationCharge,
    "subtotal_before_generic_coupon": subtotalBeforeGenericCoupon,
    "length_of_stay_discount_percent": lengthOfStayDiscountPercent,
    "length_of_stay_discount_amount": lengthOfStayDiscountAmount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "invoice_no": invoiceNo,
    "pgw_transaction_number": pgwTransactionNumber,
    "reservation_code": reservationCode,
    "check_in": "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "check_out": "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "night_count": nightCount,
    "children_count": childrenCount,
    "infant_count": infantCount,
    "adult_count": adultCount,
    "guest_count": guestCount,
    "price": price,
    "guest_service_charge": guestServiceCharge,
    "total_price": totalPrice,
    "paid_amount": paidAmount,
    "host_service_charge": hostServiceCharge,
    "host_pay_out": hostPayOut,
    "total_profit": totalProfit,
    "gateway_fee": gatewayFee,
    "refund_amount": refundAmount,
    "is_refunded": isRefunded,
    "price_info": Map.from(priceInfo!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "guest_payment_status": guestPaymentStatus,
    "host_payment_status": hostPaymentStatus,
    "status": status,
    "cancellation_reason": cancellationReason,
    "host_review_done": hostReviewDone,
    "guest_review_done": guestReviewDone,
    "calendar_info": calendarInfo == null ? [] : List<dynamic>.from(calendarInfo!.map((x) => x.toJson())),
    "chat_room_id": chatRoomId,
    "applied_coupon_code": appliedCouponCode,
    "applied_coupon_type": appliedCouponType,
    "discount_amount_applied": discountAmountApplied,
    "price_after_discount": priceAfterDiscount,
    "invoice_pdf": invoicePdf,
    "invoice_generated_at": invoiceGeneratedAt,
    "guest": guest?.toJson(),
    "host": host,
    "listing": listing?.toJson(),
    "applied_referral_coupon": appliedReferralCoupon,
    "applied_admin_coupon": appliedAdminCoupon,
  };
}

class CalendarInfo {
  final int? id;
  final double? price;
  final DateTime? endDate;
  final bool? isBooked;
  final double? basePrice;
  final bool? isBlocked;
  final int? listingId;
  final DateTime? startDate;

  CalendarInfo({
    this.id,
    this.price,
    this.endDate,
    this.isBooked,
    this.basePrice,
    this.isBlocked,
    this.listingId,
    this.startDate,
  });

  factory CalendarInfo.fromRawJson(String str) => CalendarInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalendarInfo.fromJson(Map<String, dynamic> json) => CalendarInfo(
    id: json["id"],
    price: json["price"],
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    isBooked: json["is_booked"],
    basePrice: json["base_price"],
    isBlocked: json["is_blocked"],
    listingId: json["listing_id"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "is_booked": isBooked,
    "base_price": basePrice,
    "is_blocked": isBlocked,
    "listing_id": listingId,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
  };
}

class Guest {
  final int? id;
  final String? fullName;
  final String? phoneNumber;

  Guest({
    this.id,
    this.fullName,
    this.phoneNumber,
  });

  factory Guest.fromRawJson(String str) => Guest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
  };
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

  factory Listing.fromRawJson(String str) => Listing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json["id"],
    title: json["title"],
    coverPhoto: json["cover_photo"],
    address: json["address"],
    cancellationPolicy: json["cancellation_policy"] == null ? null : CancellationPolicy.fromJson(json["cancellation_policy"]),
    avgRating: json["avg_rating"]?.toDouble(),
    totalRatingCount: json["total_rating_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "cover_photo": coverPhoto,
    "address": address,
    "cancellation_policy": cancellationPolicy?.toJson(),
    "avg_rating": avgRating,
    "total_rating_count": totalRatingCount,
  };
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

  factory CancellationPolicy.fromRawJson(String str) => CancellationPolicy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
    id: json["id"],
    description: json["description"],
    policyName: json["policy_name"],
    refundPercentage: json["refund_percentage"],
    cancellationDeadline: json["cancellation_deadline"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "policy_name": policyName,
    "refund_percentage": refundPercentage,
    "cancellation_deadline": cancellationDeadline,
  };
}

class PriceInfo {
  final String? note;
  final double? price;
  final BookingData? bookingData;

  PriceInfo({
    this.note,
    this.price,
    this.bookingData,
  });

  factory PriceInfo.fromRawJson(String str) => PriceInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
    note: json["note"],
    price: json["price"],
    bookingData: json["booking_data"] == null ? null : BookingData.fromJson(json["booking_data"]),
  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "price": price,
    "booking_data": bookingData?.toJson(),
  };
}

class BookingData {
  BookingData();

  factory BookingData.fromRawJson(String str) => BookingData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Review {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isHostReview;
  final bool? isGuestReview;
  final int? rating;
  final String? review;
  final int? listing;
  final int? booking;
  final int? reviewBy;
  final int? reviewFor;

  Review({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isHostReview,
    this.isGuestReview,
    this.rating,
    this.review,
    this.listing,
    this.booking,
    this.reviewBy,
    this.reviewFor,
  });

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isHostReview: json["is_host_review"],
    isGuestReview: json["is_guest_review"],
    rating: json["rating"],
    review: json["review"],
    listing: json["listing"],
    booking: json["booking"],
    reviewBy: json["review_by"],
    reviewFor: json["review_for"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_host_review": isHostReview,
    "is_guest_review": isGuestReview,
    "rating": rating,
    "review": review,
    "listing": listing,
    "booking": booking,
    "review_by": reviewBy,
    "review_for": reviewFor,
  };
}

// Hello I am Tamim