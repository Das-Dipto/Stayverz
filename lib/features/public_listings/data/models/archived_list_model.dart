// Helper for safe DateTime parsing
DateTime? parseDate(String? dateStr) =>
    dateStr != null ? DateTime.tryParse(dateStr) : null;

// ------------------ Main Response ------------------
class ArchivedChatListResponse {
  final List<ArchivedChatRoom> data;
  final ArchivedExtraData? extraData;
  final ArchivedMetaInfo? metaInfo;

  ArchivedChatListResponse({
    required this.data,
    this.extraData,
    this.metaInfo,
  });

  factory ArchivedChatListResponse.fromJson(Map<String, dynamic> json) {
    // Normalize data to always be a list
    List<ArchivedChatRoom> parseData(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => ArchivedChatRoom.fromJson(e)).toList();
      } else if (value is Map<String, dynamic>) {
        return [ArchivedChatRoom.fromJson(value)];
      }
      return [];
    }

    return ArchivedChatListResponse(
      data: parseData(json['data']),
      extraData: json['extra_data'] != null
          ? ArchivedExtraData.fromJson(json['extra_data'])
          : null,
      metaInfo: json['meta_info'] != null
          ? ArchivedMetaInfo.fromJson(json['meta_info'])
          : null,
    );
  }

}

// ------------------ Chat Room ------------------
class ArchivedChatRoom {
  final String id;
  final String name;
  final ArchivedChatUser? fromUser;
  final List<ArchivedChatUser> toUser;
  final String status;
  final bool archived;
  final bool isReviewed;
  final ArchivedLatestMessage? latestMessage;
  final ArchivedBookingData? bookingData;
  final ArchivedListing? listing;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArchivedChatRoom({
    required this.id,
    required this.name,
    this.fromUser,
    required this.toUser,
    required this.status,
    required this.archived,
    required this.isReviewed,
    this.latestMessage,
    this.bookingData,
    this.listing,
    this.createdAt,
    this.updatedAt,
  });

  factory ArchivedChatRoom.fromJson(Map<String, dynamic> json) {
    // Handle `to_user` as single object or list
    List<ArchivedChatUser> parseToUser(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => ArchivedChatUser.fromJson(e)).toList();
      } else if (value is Map<String, dynamic>) {
        return [ArchivedChatUser.fromJson(value)];
      }
      return [];
    }

    return ArchivedChatRoom(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      fromUser: json['from_user'] != null
          ? ArchivedChatUser.fromJson(json['from_user'])
          : null,
      toUser: parseToUser(json['to_user']),
      status: json['status'] ?? '',
      archived: json['archived'] == true,
      isReviewed: json['is_reviewed'] == true,
      latestMessage: json['latest_message'] != null
          ? ArchivedLatestMessage.fromJson(json['latest_message'])
          : null,
      bookingData: json['booking_data'] != null
          ? ArchivedBookingData.fromJson(json['booking_data'])
          : null,
      listing: json['listing'] != null
          ? ArchivedListing.fromJson(json['listing'])
          : null,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

// ------------------ Chat User ------------------
class ArchivedChatUser {
  final String id;
  final String username;
  final String fullName;
  final int? userId;
  final String email;
  final String image;
  final String phoneNumber;
  final DateTime? lastOnline;
  final bool onlineStatus;

  ArchivedChatUser({
    required this.id,
    required this.username,
    required this.fullName,
    this.userId,
    required this.email,
    required this.image,
    required this.phoneNumber,
    this.lastOnline,
    required this.onlineStatus,
  });

  factory ArchivedChatUser.fromJson(Map<String, dynamic> json) {
    return ArchivedChatUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      userId: json['user_id'],
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      lastOnline: parseDate(json['last_online']),
      onlineStatus: json['online_status'] == true,
    );
  }
}

// ------------------ Latest Message ------------------
class ArchivedLatestMessage {
  final String content;
  final ArchivedMessageUser? user;
  final bool isRead;
  final String mType;
  final DateTime? createdAt;

  ArchivedLatestMessage({
    required this.content,
    this.user,
    required this.isRead,
    required this.mType,
    this.createdAt,
  });

  factory ArchivedLatestMessage.fromJson(Map<String, dynamic> json) {
    return ArchivedLatestMessage(
      content: json['content'] ?? '',
      user: json['user'] != null
          ? ArchivedMessageUser.fromJson(json['user'])
          : null,
      isRead: json['is_read'] == true,
      mType: json['m_type'] ?? '',
      createdAt: parseDate(json['created_at']),
    );
  }
}

// ------------------ Message User ------------------
class ArchivedMessageUser {
  final String username;
  final String fullName;
  final String image;
  final int? userId;

  ArchivedMessageUser({
    required this.username,
    required this.fullName,
    required this.image,
    this.userId,
  });

  factory ArchivedMessageUser.fromJson(Map<String, dynamic> json) {
    return ArchivedMessageUser(
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      image: json['image'] ?? '',
      userId: json['user_id'],
    );
  }
}

// ------------------ Booking Data ------------------
class ArchivedBookingData {
  final String checkIn;
  final String checkOut;
  final int adult;
  final int children;
  final int infant;
  final int pets;
  final int totalGuestCount;

  ArchivedBookingData({
    required this.checkIn,
    required this.checkOut,
    required this.adult,
    required this.children,
    required this.infant,
    required this.pets,
    required this.totalGuestCount,
  });

  factory ArchivedBookingData.fromJson(Map<String, dynamic> json) {
    return ArchivedBookingData(
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

// ------------------ Listing ------------------
class ArchivedListing {
  final int? id;
  final String name;
  final String area;
  final String thana;
  final String district;
  final String division;
  final String exactLocation;

  ArchivedListing({
    this.id,
    required this.name,
    required this.area,
    required this.thana,
    required this.district,
    required this.division,
    required this.exactLocation,
  });

  factory ArchivedListing.fromJson(Map<String, dynamic> json) {
    return ArchivedListing(
      id: json['id'],
      name: json['name'] ?? '',
      area: json['area'] ?? '',
      thana: json['thana'] ?? '',
      district: json['district'] ?? '',
      division: json['division'] ?? '',
      exactLocation: json['exact_location'] ?? '',
    );
  }
}

// ------------------ Extra Data ------------------
class ArchivedExtraData {
  final int allMessageCount;

  ArchivedExtraData({required this.allMessageCount});

  factory ArchivedExtraData.fromJson(Map<String, dynamic> json) {
    return ArchivedExtraData(
      allMessageCount: json['all_message_count'] ?? 0,
    );
  }
}

// ------------------ Meta Info ------------------
class ArchivedMetaInfo {
  final int count;
  final int currentPage;
  final int? nextPage;
  final int prevPage;
  final int lastPage;

  ArchivedMetaInfo({
    required this.count,
    required this.currentPage,
    this.nextPage,
    required this.prevPage,
    required this.lastPage,
  });

  factory ArchivedMetaInfo.fromJson(Map<String, dynamic> json) {
    return ArchivedMetaInfo(
      count: json['count'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'] ?? 0,
      lastPage: json['lastPage'] ?? 1,
    );
  }
}

// Hello I am Tamim