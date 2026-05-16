import 'dart:convert';

class QuickReplyMessageResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<QuickReplyData>? data;

  QuickReplyMessageResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory QuickReplyMessageResponse.fromRawJson(String str) => QuickReplyMessageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuickReplyMessageResponse.fromJson(Map<String, dynamic> json) => QuickReplyMessageResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<QuickReplyData>.from(json["data"]!.map((x) => QuickReplyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuickReplyData {
  final int? id;
  final String? hostUsername;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? description;
  final int? host;

  QuickReplyData({
    this.id,
    this.hostUsername,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.host,
  });

  factory QuickReplyData.fromRawJson(String str) => QuickReplyData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuickReplyData.fromJson(Map<String, dynamic> json) => QuickReplyData(
    id: json["id"],
    hostUsername: json["host_username"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    title: json["title"],
    description: json["description"],
    host: json["host"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "host_username": hostUsername,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "title": title,
    "description": description,
    "host": host,
  };
}

// Hello I am Tamim