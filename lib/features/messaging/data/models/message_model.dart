import 'dart:convert';

class MessageModel {
  final bool? success;
  final String? message;
  final List<MessageData>? data;
  final ExtraData? extraData;
  final MetaInfo? metaInfo;

  MessageModel({
    this.success,
    this.message,
    this.data,
    this.extraData,
    this.metaInfo,
  });

  factory MessageModel.fromRawJson(String str) =>
      MessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<MessageData>.from(
        json["data"]!.map((x) => MessageData.fromJson(x))),
    extraData: json["extra_data"] == null
        ? null
        : ExtraData.fromJson(json["extra_data"]),
    metaInfo: json["meta_info"] == null
        ? null
        : MetaInfo.fromJson(json["meta_info"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "extra_data": extraData?.toJson(),
    "meta_info": metaInfo?.toJson(),
  };
}

class MessageData {
  final String? id;
  final FromUserClass? user;
  final String? content;
  final Meta? meta;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isRead;
  final dynamic file;
  final MType? mType;
  final dynamic status;

  MessageData({
    this.id,
    this.user,
    this.content,
    this.meta,
    this.createdAt,
    this.updatedAt,
    this.isRead,
    this.file,
    this.mType,
    this.status,
  });

  factory MessageData.fromRawJson(String str) =>
      MessageData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
    id: json["id"],
    user: json["user"] == null
        ? null
        : FromUserClass.fromJson(json["user"]),
    content: json["content"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    isRead: json["is_read"],
    file: json["file"],
    mType: json["m_type"] != null
        ? mTypeValues.map[json["m_type"]]
        : null,
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "content": content,
    "meta": meta?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_read": isRead,
    "file": file,
    "m_type": mTypeValues.reverse[mType],
    "status": status,
  };
}

enum MType { NORMAL, SYSTEM }

final mTypeValues = EnumValues({
  "normal": MType.NORMAL,
  "system": MType.SYSTEM,
});

/// ✅ UPDATED Meta class (Handles both instant_book + compact versions)
class Meta {
  final bool? instantBook;
  final bool? assistance;
  final String? instantBookStatus;
  final dynamic listing; // Can be String or Listing
  final dynamic booking; // Can be Booking or BookingSummary
  final int? user;

  Meta({
    this.instantBook,
    this.assistance,
    this.instantBookStatus,
    this.listing,
    this.booking,
    this.user,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) {
    dynamic listingValue;
    if (json["listing"] is Map<String, dynamic>) {
      listingValue = Listing.fromJson(json["listing"]);
    } else {
      listingValue = json["listing"];
    }

    dynamic bookingValue;
    if (json["booking"] is Map<String, dynamic>) {
      if (json["booking"]?["booking_date"] != null) {
        bookingValue = Booking.fromJson(json["booking"]);
      } else {
        bookingValue = BookingSummary.fromJson(json["booking"]);
      }
    }

    return Meta(
      instantBook: json["instant_book"],
      // assistance: json["assistance"],
      assistance: json["is_assistance"],
      instantBookStatus: json["instant_book_status"],
      listing: listingValue,
      booking: bookingValue,
      user: json["user"],
    );
  }

  Map<String, dynamic> toJson() => {
    "instant_book": instantBook,
    // "assistance": assistance,
    "is_assistance": assistance,
    "instant_book_status": instantBookStatus,
    "listing": listing is Listing ? (listing as Listing).toJson() : listing,
    "booking": booking is Booking
        ? (booking as Booking).toJson()
        : booking is BookingSummary
        ? (booking as BookingSummary).toJson()
        : booking,
    "user": user,
  };
}

/// ✅ New compact booking model for Case 2
class BookingSummary {
  final int? id;
  final String? invoiceNo;
  final String? reservationCode;

  BookingSummary({
    this.id,
    this.invoiceNo,
    this.reservationCode,
  });

  factory BookingSummary.fromRawJson(String str) =>
      BookingSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingSummary.fromJson(Map<String, dynamic> json) =>
      BookingSummary(
        id: json["id"],
        invoiceNo: json["invoice_no"],
        reservationCode: json["reservation_code"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_no": invoiceNo,
    "reservation_code": reservationCode,
  };
}

class Booking {
  final BookingDat? bookingDate;
  final CheckoutData? checkoutData;

  Booking({
    this.bookingDate,
    this.checkoutData,
  });

  factory Booking.fromRawJson(String str) =>
      Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingDate: json["booking_date"] == null
        ? null
        : BookingDat.fromJson(json["booking_date"]),
    checkoutData: json["checkout_data"] == null
        ? null
        : CheckoutData.fromJson(json["checkout_data"]),
  );

  Map<String, dynamic> toJson() => {
    "booking_date": bookingDate?.toJson(),
    "checkout_data": checkoutData?.toJson(),
  };
}

class BookingDat {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adult;
  final int? children;
  final int? infant;
  final int? pets;
  final int? totalGuestCount;

  BookingDat({
    this.checkIn,
    this.checkOut,
    this.adult,
    this.children,
    this.infant,
    this.pets,
    this.totalGuestCount,
  });

  factory BookingDat.fromRawJson(String str) =>
      BookingDat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDat.fromJson(Map<String, dynamic> json) => BookingDat(
    checkIn: json["check_in"] == null
        ? null
        : DateTime.parse(json["check_in"]),
    checkOut: json["check_out"] == null
        ? null
        : DateTime.parse(json["check_out"]),
    adult: json["adult"],
    children: json["children"],
    infant: json["infant"],
    pets: json["pets"],
    totalGuestCount: json["total_guest_count"],
  );

  Map<String, dynamic> toJson() => {
    "check_in":
    "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "check_out":
    "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "adult": adult,
    "children": children,
    "infant": infant,
    "pets": pets,
    "total_guest_count": totalGuestCount,
  };
}

class CheckoutData {
  final int? nights;
  final double? bookingPrice;
  final double? guestServiceCharge;
  final double? totalPrice;
  final double? hostServiceCharge;
  final double? hostPayOut;
  final Map<String, PriceInfo>? priceInfo;
  final double? totalProfit;

  CheckoutData({
    this.nights,
    this.bookingPrice,
    this.guestServiceCharge,
    this.totalPrice,
    this.hostServiceCharge,
    this.hostPayOut,
    this.priceInfo,
    this.totalProfit,
  });

  factory CheckoutData.fromRawJson(String str) =>
      CheckoutData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
    nights: json["nights"],
    bookingPrice: json["booking_price"],
    guestServiceCharge: json["guest_service_charge"],
    totalPrice: json["total_price"],
    hostServiceCharge: json["host_service_charge"],
    hostPayOut: json["host_pay_out"],
    priceInfo: json["price_info"] == null
        ? null
        : Map.from(json["price_info"]).map((k, v) =>
        MapEntry<String, PriceInfo>(k, PriceInfo.fromJson(v))),
    totalProfit: json["total_profit"],
  );

  Map<String, dynamic> toJson() => {
    "nights": nights,
    "booking_price": bookingPrice,
    "guest_service_charge": guestServiceCharge,
    "total_price": totalPrice,
    "host_service_charge": hostServiceCharge,
    "host_pay_out": hostPayOut,
    "price_info": priceInfo == null
        ? null
        : Map.from(priceInfo!)
        .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "total_profit": totalProfit,
  };
}

class PriceInfo {
  final int? id;
  final double? price;
  final bool? isBlocked;
  final bool? isBooked;
  final BookingData? bookingData;
  final String? note;

  PriceInfo({
    this.id,
    this.price,
    this.isBlocked,
    this.isBooked,
    this.bookingData,
    this.note,
  });

  factory PriceInfo.fromRawJson(String str) =>
      PriceInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
    id: json["id"],
    price: json["price"],
    isBlocked: json["is_blocked"],
    isBooked: json["is_booked"],
bookingData: json["booking_data"] == null || json["booking_data"] is List
    ? null
    : BookingData.fromJson(json["booking_data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "is_blocked": isBlocked,
    "is_booked": isBooked,
    "booking_data": bookingData?.toJson(),
    "note": note,
  };
}

class BookingData {
  BookingData();

  factory BookingData.fromRawJson(String str) =>
      BookingData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData();

  Map<String, dynamic> toJson() => {};
}

class FromUserClass {
  final String? id;
  final String? username;
  final String? fullName;
  final int? userId;
  final String? email;
  final String? image;
  final String? phoneNumber;
  final DateTime? lastOnline;
  final bool? onlineStatus;

  FromUserClass({
    this.id,
    this.username,
    this.fullName,
    this.userId,
    this.email,
    this.image,
    this.phoneNumber,
    this.lastOnline,
    this.onlineStatus,
  });

  factory FromUserClass.fromRawJson(String str) =>
      FromUserClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FromUserClass.fromJson(Map<String, dynamic> json) => FromUserClass(
    id: json["id"] ?? '',
    username: json["username"] ?? '',
    fullName: json["full_name"] ?? '',
    userId: json["user_id"],
    email: json["email"],
    image: json["image"],
    phoneNumber: json["phone_number"],
    lastOnline: json["last_online"] == null
        ? null
        : DateTime.parse(json["last_online"]),
    onlineStatus: json["online_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "full_name": fullName,
    "user_id": userId,
    "email": email,
    "image": image,
    "phone_number": phoneNumber,
    "last_online": lastOnline?.toIso8601String(),
    "online_status": onlineStatus,
  };
}

class ExtraData {
  final ChatRoom? chatRoom;
  final int? unreadMessageCount;

  ExtraData({
    this.chatRoom,
    this.unreadMessageCount,
  });

  factory ExtraData.fromRawJson(String str) =>
      ExtraData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtraData.fromJson(Map<String, dynamic> json) => ExtraData(
    chatRoom: json["chat_room"] == null
        ? null
        : ChatRoom.fromJson(json["chat_room"]),
    unreadMessageCount: json["unread_message_count"],
  );

  Map<String, dynamic> toJson() => {
    "chat_room": chatRoom?.toJson(),
    "unread_message_count": unreadMessageCount,
  };
}

class ChatRoom {
  final String? id;
  final String? name;
  final FromUserClass? fromUser;
  final List<FromUserClass> toUser;
  final String? status;
  final LatestMessage? latestMessage;
  final BookingDat? bookingData;
  final Listing? listing;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatRoom({
    this.id,
    this.name,
    this.fromUser,
    this.toUser = const [],
    this.status,
    this.latestMessage,
    this.bookingData,
    this.listing,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatRoom.fromRawJson(String str) =>
      ChatRoom.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<FromUserClass> parseToUsers(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => FromUserClass.fromJson(e)).toList();
    } else if (raw is Map<String, dynamic>) {
      return [FromUserClass.fromJson(raw)];
    } else {
      return [];
    }
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
    id: json["id"],
    name: json["name"],
    fromUser: json["from_user"] == null
        ? null
        : FromUserClass.fromJson(json["from_user"]),
    toUser: parseToUsers(json["to_user"]),
    status: json["status"],
    latestMessage: json["latest_message"] == null
        ? null
        : LatestMessage.fromJson(json["latest_message"]),
    bookingData: json["booking_data"] == null
        ? null
        : BookingDat.fromJson(json["booking_data"]),
    listing: json["listing"] == null
        ? null
        : Listing.fromJson(json["listing"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "from_user": fromUser?.toJson(),
    "to_user": List<dynamic>.from(toUser.map((x) => x.toJson())),
    "status": status,
    "latest_message": latestMessage?.toJson(),
    "booking_data": bookingData?.toJson(),
    "listing": listing?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class LatestMessage {
  final String? content;
  final LatestMessageUser? user;
  final bool? isRead;
  final MType? mType;
  final DateTime? createdAt;

  LatestMessage({
    this.content,
    this.user,
    this.isRead,
    this.mType,
    this.createdAt,
  });

  factory LatestMessage.fromRawJson(String str) =>
      LatestMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMessage.fromJson(Map<String, dynamic> json) =>
      LatestMessage(
        content: json["content"],
        user: json["user"] == null
            ? null
            : LatestMessageUser.fromJson(json["user"]),
        isRead: json["is_read"],
        mType: json["m_type"] != null
            ? mTypeValues.map[json["m_type"]]
            : null,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "content": content,
    "user": user?.toJson(),
    "is_read": isRead,
    "m_type": mTypeValues.reverse[mType],
    "created_at": createdAt?.toIso8601String(),
  };
}

class LatestMessageUser {
  final String? username;
  final String? fullName;
  final String? email;
  final String? image;

  LatestMessageUser({
    this.username,
    this.fullName,
    this.email,
    this.image,
  });

  factory LatestMessageUser.fromRawJson(String str) =>
      LatestMessageUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMessageUser.fromJson(Map<String, dynamic> json) =>
      LatestMessageUser(
        username: json["username"],
        fullName: json["full_name"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "full_name": fullName,
    "email": email,
    "image": image,
  };
}

class Listing {
  final int? id;
  final String? uniqueId;
  final String? name;
  final String? cover;

  Listing({
    this.id,
    this.uniqueId,
    this.name,
    this.cover,
  });

  factory Listing.fromRawJson(String str) =>
      Listing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json["id"],
    uniqueId: json["unique_id"],
    name: json["name"],
    cover: json["cover"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "name": name,
    "cover": cover,
  };
}

class MetaInfo {
  MetaInfo();

  factory MetaInfo.fromRawJson(String str) =>
      MetaInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaInfo.fromJson(Map<String, dynamic> json) => MetaInfo();

  Map<String, dynamic> toJson() => {};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// Hello I am Tamim