// chat_models.dart

// chat_models.dart

class ChatListResponse {
  final bool success;
  final String message;
  final List<ChatItem> data;
  final SearchMetaInfo? metaInfo;

  ChatListResponse({
    required this.success,
    required this.message,
    required this.data,
    this.metaInfo,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatItem.fromJson(e))
          .toList() ??
          [],
      metaInfo: json['meta_info'] != null
          ? SearchMetaInfo.fromJson(json['meta_info'])
          : null,
    );
  }
}


class ChatItem {
  final String id;
  final String name;
  final SearchUser? fromUser;
  final SearchUser? toUser;
  final String status;
  final bool archived;
  final bool isReviewed;
  final MatchedMessage? matchedMessage;
  final BookingData? bookingData;
  final Listing? listing;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatItem({
    required this.id,
    required this.name,
    this.fromUser,
    this.toUser,
    required this.status,
    required this.archived,
    required this.isReviewed,
    this.matchedMessage,
    this.bookingData,
    this.listing,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      fromUser:
      json['from_user'] != null ? SearchUser.fromJson(json['from_user']) : null,
      toUser:
      json['to_user'] != null ? SearchUser.fromJson(json['to_user']) : null,
      status: json['status'] ?? '',
      archived: json['archived'] ?? false,
      isReviewed: json['is_reviewed'] ?? false,
      matchedMessage: json['matched_message'] != null
          ? MatchedMessage.fromJson(json['matched_message'])
          : null,
      bookingData: json['booking_data'] != null
          ? BookingData.fromJson(json['booking_data'])
          : null,
      listing:
      json['listing'] != null ? Listing.fromJson(json['listing']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class SearchUser {
  final String id;
  final String username;
  final String name;
  final int userId;
  final String email;
  final String avatar;
  final String phoneNumber;
  final DateTime? lastOnline;
  final bool onlineStatus;

  SearchUser({
    required this.id,
    required this.username,
    required this.name,
    required this.userId,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    this.lastOnline,
    required this.onlineStatus,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['full_name'] ?? '',
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      avatar: json['image'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      lastOnline: json['last_online'] != null
          ? DateTime.tryParse(json['last_online'])
          : null,
      onlineStatus: json['online_status'] ?? false,
    );
  }
}

class MatchedMessage {
  final String content;
  final DateTime? createdAt;

  MatchedMessage({
    required this.content,
    this.createdAt,
  });

  factory MatchedMessage.fromJson(Map<String, dynamic> json) {
    return MatchedMessage(
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class BookingData {
  final String checkIn;
  final String checkOut;
  final int adult;
  final int children;
  final int infant;
  final int pets;
  final int totalGuestCount;

  BookingData({
    required this.checkIn,
    required this.checkOut,
    required this.adult,
    required this.children,
    required this.infant,
    required this.pets,
    required this.totalGuestCount,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      adult: json['adult'] ?? 0,
      children: json['children'] ?? 0,
      infant: json['infant'] ?? 0,
      pets: json['pets'] ?? 0,
      totalGuestCount: json['total_guest_count'] ?? 0,
    );
  }
}

class Listing {
  final int id;
  final String name;

  Listing({
    required this.id,
    required this.name,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class SearchMetaInfo {
  final int count;
  final int currentPage;
  final int? nextPage;
  final int prevPage;
  final int lastPage;

  SearchMetaInfo({
    required this.count,
    required this.currentPage,
    this.nextPage,
    required this.prevPage,
    required this.lastPage,
  });

  factory SearchMetaInfo.fromJson(Map<String, dynamic> json) {
    return SearchMetaInfo(
      count: json['count'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'] ?? 0,
      lastPage: json['lastPage'] ?? 1,
    );
  }
}

// Hello I am Tamim