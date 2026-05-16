class NotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData? metaData;
  final List<NotificationItem> data;
  final int stats;

  NotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
    required this.stats,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: json['meta_data'] != null
          ? MetaData.fromJson(json['meta_data'])
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationItem.fromJson(e))
          .toList() ??
          [],
      stats: json['stats'] ?? 0,
    );
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final int? next;
  final int? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: _parseInt(json['total']),
      pageSize: _parseInt(json['page_size']),
      next: _parseIntNullable(json['next']),
      previous: _parseIntNullable(json['previous']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class NotificationItem {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String eventType;
  final NotificationData? data;
  final bool isRead;
  final bool isApp;
  final String nType;
  final UserData? user;

  NotificationItem({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.eventType,
    this.data,
    required this.isRead,
    required this.isApp,
    required this.nType,
    this.user,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      eventType: json['event_type'] ?? '',
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
      isRead: json['is_read'] ?? false,
      isApp: json['is_app'] ?? false,
      nType: json['n_type'] ?? '',
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class NotificationData {
  final String link;
  final String message;
  final String identifier;

  NotificationData({
    required this.link,
    required this.message,
    required this.identifier,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      link: json['link'] ?? '',
      message: json['message'] ?? '',
      identifier: json['identifier'] ?? '',
    );
  }
}

class UserData {
  final int id;
  final String fullName;
  final String? image;
  final String? phoneNumber;

  UserData({
    required this.id,
    required this.fullName,
    this.image,
    this.phoneNumber,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      image: json['image']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
    );
  }
}
// Hello I am Tamim