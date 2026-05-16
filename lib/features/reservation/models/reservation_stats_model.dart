import 'dart:convert';

class ReservationStatsModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ReservationStats? stats;
  final List<Reservation>? data;

  ReservationStatsModel({
    this.success,
    this.statusCode,
    this.message,
    this.stats,
    this.data,
  });

  factory ReservationStatsModel.fromRawJson(String str) => ReservationStatsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReservationStatsModel.fromJson(Map<String, dynamic> json) => ReservationStatsModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    stats: json["stats"] == null ? null : ReservationStats.fromJson(json["stats"]),
    data: json["data"] == null ? [] : List<Reservation>.from(json["data"]!.map((x) => Reservation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "stats": stats?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Reservation {
  final int? id;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? invoiceNo;
  final String? chatRoomId;
  final String? guestImage;
  final String? guestName;
  final String? listingTitle;
  final String? listingUid;

  Reservation({
    this.id,
    this.checkIn,
    this.checkOut,
    this.invoiceNo,
    this.chatRoomId,
    this.guestImage,
    this.guestName,
    this.listingTitle,
    this.listingUid,
  });

  factory Reservation.fromRawJson(String str) => Reservation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json["id"],
    checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
    checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
    invoiceNo: json["invoice_no"],
    chatRoomId: json["chat_room_id"],
    guestImage: json["guest_image"],
    guestName: json["guest_name"],
    listingTitle: json["listing_title"],
    listingUid: json["listing_uid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "check_in": "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "check_out": "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "invoice_no": invoiceNo,
    "chat_room_id": chatRoomId,
    "guest_image": guestImage,
    "guest_name": guestName,
    "listing_title": listingTitle,
    "listing_uid": listingUid,
  };
}

class ReservationStats {
  final int? currentlyHostingCount;
  final int? upcomingCount;
  final int? pendingReviewCount;
  final int? checkingOutCount;
  final int? arrivingSoonCount;

  ReservationStats({
    this.currentlyHostingCount,
    this.upcomingCount,
    this.pendingReviewCount,
    this.checkingOutCount,
    this.arrivingSoonCount,
  });

  factory ReservationStats.fromRawJson(String str) => ReservationStats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReservationStats.fromJson(Map<String, dynamic> json) => ReservationStats(
    currentlyHostingCount: json["currently_hosting_count"],
    upcomingCount: json["upcoming_count"],
    pendingReviewCount: json["pending_review_count"],
    checkingOutCount: json["checking_out_count"],
    arrivingSoonCount: json["arriving_soon_count"],
  );

  Map<String, dynamic> toJson() => {
    "currently_hosting_count": currentlyHostingCount,
    "upcoming_count": upcomingCount,
    "pending_review_count": pendingReviewCount,
    "checking_out_count": checkingOutCount,
    "arriving_soon_count": arrivingSoonCount,
  };
}

// Hello I am Tamim