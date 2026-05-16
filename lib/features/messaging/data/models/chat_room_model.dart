import 'dart:convert';

class ChatRoomModel {
  final bool? success;
  final String? message;
  final List<ChatRoomData>? data;
  final ExtraData? extraData;
  final MetaInfo? metaInfo;

  ChatRoomModel({
    this.success,
    this.message,
    this.data,
    this.extraData,
    this.metaInfo,
  });

  factory ChatRoomModel.fromRawJson(String str) => ChatRoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ChatRoomData>.from(json["data"]!.map((x) => ChatRoomData.fromJson(x))),
    extraData: json["extra_data"] == null ? null : ExtraData.fromJson(json["extra_data"]),
    metaInfo: json["meta_info"] == null ? null : MetaInfo.fromJson(json["meta_info"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "extra_data": extraData?.toJson(),
    "meta_info": metaInfo?.toJson(),
  };
}

class ChatRoomData {
  final String? id;
  final String? name;
  final User? fromUser;
  final List<User> toUsers;
  final String? status;
  final LatestMessage? latestMessage;
  final BookingData? bookingData;
  final Listing? listing;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Computed properties for UI
  User? get receiver => toUsers.isNotEmpty ? toUsers.first : null; 
  List<User> get receiverList => toUsers; 
  User? get sender => fromUser; // Alias for toUser to match UI expectations
  bool get isOnline => toUsers.isNotEmpty ? toUsers.first.isOnline : false;
  int get unreadCount => latestMessage?.unreadCount ?? 0;
  String? get lastMessage => latestMessage?.content;
  DateTime? get lastMessageTime => latestMessage?.createdAt;

  ChatRoomData({
    this.id,
    this.name,
    this.fromUser,
    this.toUsers = const [],
    this.status,
    this.latestMessage,
    this.bookingData,
    this.listing,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatRoomData.fromRawJson(String str) => ChatRoomData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<User> parseToUsers(dynamic raw) {
   if (raw is List) { 
     return raw.map((e) => User.fromJson(e)).toList(); 
   } else if (raw is Map<String, dynamic>) { 
     return [User.fromJson(raw)]; 
   } else { 
     return []; 
   } 
 } 

  factory ChatRoomData.fromJson(Map<String, dynamic> json) => ChatRoomData(
    id: json["id"],
    name: json["name"],
    fromUser: json["from_user"] == null ? null : User.fromJson(json["from_user"]),
    toUsers: parseToUsers(json["to_user"]),
    status: json["status"],
    latestMessage: json["latest_message"] == null ? null : LatestMessage.fromJson(json["latest_message"]),
    bookingData: json["booking_data"] == null ? null : BookingData.fromJson(json["booking_data"]),
    listing: json["my_listing"] == null ? null : Listing.fromJson(json["my_listing"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "from_user": fromUser?.toJson(),
    "to_user": List<dynamic>.from(toUsers.map((x) => x.toJson())),
    "status": status,
    "latest_message": latestMessage?.toJson(),
    "booking_data": bookingData?.toJson(),
    "my_listing": listing?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  ChatRoomData copyWith({
    String? id,
    String? name,
    User? fromUser,
    List<User>? toUsers,
    String? status,
    LatestMessage? latestMessage,
    BookingData? bookingData,
    Listing? listing,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatRoomData(
      id: id ?? this.id,
      name: name ?? this.name,
      fromUser: fromUser ?? this.fromUser,
      toUsers: toUsers ?? this.toUsers,
      status: status ?? this.status,
      latestMessage: latestMessage ?? this.latestMessage?.copyWith(
        unreadCount: unreadCount ?? this.latestMessage?.unreadCount ?? 0,
      ),
      bookingData: bookingData ?? this.bookingData,
      listing: listing ?? this.listing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BookingData {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? adult;
  final int? children;
  final int? infant;
  final int? pets;
  final int? totalGuestCount;

  BookingData({
    this.checkIn,
    this.checkOut,
    this.adult,
    this.children,
    this.infant,
    this.pets,
    this.totalGuestCount,
  });

  factory BookingData.fromRawJson(String str) => BookingData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
    checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
    adult: json["adult"],
    children: json["children"],
    infant: json["infant"],
    pets: json["pets"],
    totalGuestCount: json["total_guest_count"],
  );

  Map<String, dynamic> toJson() => {
    "check_in": "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "check_out": "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "adult": adult,
    "children": children,
    "infant": infant,
    "pets": pets,
    "total_guest_count": totalGuestCount,
  };
}

class User {
  final String? id;
  final String? name;
  final int? userId;
  final String? email;
  final String? avatar;
  final String? phoneNumber;
  final String? status;
  final bool isOnline;
  final DateTime? lastOnline;
  final bool? onlineStatus;

  User({
    this.id,
    this.name,
    this.userId,
    this.email,
    this.avatar,
    this.phoneNumber,
    this.status,
    this.isOnline = false,
    this.lastOnline,
    this.onlineStatus,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["full_name"],
    userId: json["user_id"],
    email: json["email"],
    avatar: json["image"],
    phoneNumber: json["phone_number"],
    status: json["status"],
    isOnline: json["is_online"] ?? false,
    lastOnline: json["last_online"] == null ? null : DateTime.parse(json["last_online"]),
    onlineStatus: json["online_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": name,
    "user_id": userId,
    "email": email,
    "image": avatar,
    "phone_number": phoneNumber,
    "status": status,
    "is_online": isOnline,
    "last_online": lastOnline?.toIso8601String(),
    "online_status": onlineStatus,
  };

  User copyWith({
    String? id,
    int? userId,
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? status,
    bool? isOnline,
  }) {
    return User(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastOnline: lastOnline,
      onlineStatus: onlineStatus,
    );
  }
}

class LatestMessage {
  final String? id;
  final String? content;
  final String? messageType;
  final String? senderId;
  final String? receiverId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final int unreadCount;
  final bool? isRead;
  final String? mType;

  LatestMessage({
    this.id,
    this.content,
    this.messageType,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.unreadCount = 0,
    this.isRead,
    this.mType,
  });

  factory LatestMessage.fromRawJson(String str) => LatestMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
    id: json['id'],
    content: json['content'],
    messageType: json['message_type'],
    senderId: json['sender_id'],
    receiverId: json['receiver_id'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    user: json['user'] == null ? null : User.fromJson(json['user']),
    unreadCount: json['unread_count'] ?? 0,
    isRead: json['is_read'],
    mType: json['m_type'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'message_type': messageType,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'user': user?.toJson(),
    'unread_count': unreadCount,
    'is_read': isRead,
    'm_type': mType,
  };

  LatestMessage copyWith({
    String? id,
    String? content,
    String? messageType,
    String? senderId,
    String? receiverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    int? unreadCount,
    bool? isRead,
    String? mType,
  }) {
    return LatestMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      unreadCount: unreadCount ?? this.unreadCount,
      isRead: isRead ?? this.isRead,
      mType: mType ?? this.mType,
    );
  }
}

class Listing {
  final String? name;
  final int? id;

  Listing({
    this.name,
    this.id,
  });

  factory Listing.fromRawJson(String str) => Listing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}

class ExtraData {
  final int? allMessageCount;

  ExtraData({
    this.allMessageCount,
  });

  factory ExtraData.fromRawJson(String str) => ExtraData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExtraData.fromJson(Map<String, dynamic> json) => ExtraData(
    allMessageCount: json["all_message_count"],
  );

  Map<String, dynamic> toJson() => {
    "all_message_count": allMessageCount,
  };
}

class MetaInfo {
  final int? count;
  final int? currentPage;
  final dynamic nextPage;
  final int? prevPage;
  final int? lastPage;

  MetaInfo({
    this.count,
    this.currentPage,
    this.nextPage,
    this.prevPage,
    this.lastPage,
  });

  factory MetaInfo.fromRawJson(String str) => MetaInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaInfo.fromJson(Map<String, dynamic> json) => MetaInfo(
    count: json["count"],
    currentPage: json["currentPage"],
    nextPage: json["nextPage"],
    prevPage: json["prevPage"],
    lastPage: json["lastPage"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "currentPage": currentPage,
    "nextPage": nextPage,
    "prevPage": prevPage,
    "lastPage": lastPage,
  };
}

// Hello I am Tamim