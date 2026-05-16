import 'dart:convert';

class AssistanceCategoriesResponse {
  final int? status;
  final String? message;
  final List<AssistanceCategory>? data;
  final DateTime? timestamp;

  AssistanceCategoriesResponse({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceCategoriesResponse.fromRawJson(String str) => AssistanceCategoriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCategoriesResponse.fromJson(Map<String, dynamic> json) => AssistanceCategoriesResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AssistanceCategory>.from(json["data"]!.map((x) => AssistanceCategory.fromJson(x))),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class AssistanceCategory {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final String? description;
  final String? icon;
  final bool? status;
  final List<AssistanceCategory>? subCategory;
  final int? categoryId;

  AssistanceCategory({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.icon,
    this.status,
    this.subCategory,
    this.categoryId,
  });

  factory AssistanceCategory.fromRawJson(String str) => AssistanceCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCategory.fromJson(Map<String, dynamic> json) => AssistanceCategory(
    id: json["id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    name: json["name"],
    description: json["description"],
    icon: json["icon"],
    status: json["status"],
    subCategory: json["subCategory"] == null ? [] : List<AssistanceCategory>.from(json["subCategory"]!.map((x) => AssistanceCategory.fromJson(x))),
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "name": name,
    "description": description,
    "icon": icon,
    "status": status,
    "subCategory": subCategory == null ? [] : List<dynamic>.from(subCategory!.map((x) => x.toJson())),
    "category_id": categoryId,
  };
}

// Hello I am Tamim