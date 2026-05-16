import 'dart:convert';

class UpdateCalendarResponseModel {
  final int? status;
  final String? message;
  final Data? data;
  final DateTime? timestamp;

  UpdateCalendarResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory UpdateCalendarResponseModel.fromRawJson(String str) => UpdateCalendarResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCalendarResponseModel.fromJson(Map<String, dynamic> json) => UpdateCalendarResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class Data {
  final String? message;

  Data({
    this.message,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

// Hello I am Tamim