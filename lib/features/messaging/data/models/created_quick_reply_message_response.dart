import 'dart:convert';

class CreateQuickReplyMessageResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final CreatedReplyMessage? data;

  CreateQuickReplyMessageResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CreateQuickReplyMessageResponse.fromRawJson(String str) => CreateQuickReplyMessageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateQuickReplyMessageResponse.fromJson(Map<String, dynamic> json) => CreateQuickReplyMessageResponse(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : CreatedReplyMessage.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class CreatedReplyMessage {
  final int? id;
  final String? hostUsername;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? description;
  final int? host;

  CreatedReplyMessage({
    this.id,
    this.hostUsername,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.host,
  });

  factory CreatedReplyMessage.fromRawJson(String str) => CreatedReplyMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedReplyMessage.fromJson(Map<String, dynamic> json) => CreatedReplyMessage(
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