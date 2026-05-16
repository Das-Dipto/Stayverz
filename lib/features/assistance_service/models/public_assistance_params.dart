import 'dart:convert';

class PublicAssistanceParams {
  final String? categoryId;
  final String? subcategoryId;
  final String? assistanceId;

  PublicAssistanceParams({
    this.categoryId,
    this.subcategoryId,
    this.assistanceId,
  });

  factory PublicAssistanceParams.fromRawJson(String str) => PublicAssistanceParams.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PublicAssistanceParams.fromJson(Map<String, dynamic> json) => PublicAssistanceParams(
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    assistanceId: json["assistance_id"],
  );

  Map<String, String> toJson() => {
    "category_id": categoryId ?? '',
    "subcategory_id": subcategoryId ?? '',
    "assistance_id": assistanceId ?? '',
  };
}

// Hello I am Tamim