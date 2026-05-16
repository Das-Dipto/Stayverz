import 'dart:convert';

class GetReferralCodeResponse {
  final String? status;
  final String? message;
  final Data? data;

  GetReferralCodeResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetReferralCodeResponse.fromRawJson(String str) => GetReferralCodeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralCodeResponse.fromJson(Map<String, dynamic> json) => GetReferralCodeResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final Code? code;
  final String? targetUrl;
  final String? deepLinkScheme;
  final String? iosStoreUrl;
  final String? androidStoreUrl;
  final int? clicks;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final bool? isExpired;
  final String? referralCode;

  Data({
    this.code,
    this.targetUrl,
    this.deepLinkScheme,
    this.iosStoreUrl,
    this.androidStoreUrl,
    this.clicks,
    this.createdAt,
    this.expiresAt,
    this.isExpired,
    this.referralCode,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    code: json["code"] == null ? null : Code.fromJson(json["code"]),
    targetUrl: json["target_url"],
    deepLinkScheme: json["deep_link_scheme"],
    iosStoreUrl: json["ios_store_url"],
    androidStoreUrl: json["android_store_url"],
    clicks: json["clicks"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
    isExpired: json["is_expired"],
    referralCode: json["referral_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code?.toJson(),
    "target_url": targetUrl,
    "deep_link_scheme": deepLinkScheme,
    "ios_store_url": iosStoreUrl,
    "android_store_url": androidStoreUrl,
    "clicks": clicks,
    "created_at": createdAt?.toIso8601String(),
    "expires_at": expiresAt?.toIso8601String(),
    "is_expired": isExpired,
    "referral_code": referralCode,
  };
}

class Code {
  final int? id;
  final String? code;
  final String? targetUrl;
  final String? deepLinkScheme;
  final String? iosStoreUrl;
  final String? androidStoreUrl;
  final String? title;
  final Meta? meta;
  final int? clicks;
  final bool? isActive;
  final DateTime? expireAt;

  Code({
    this.id,
    this.code,
    this.targetUrl,
    this.deepLinkScheme,
    this.iosStoreUrl,
    this.androidStoreUrl,
    this.title,
    this.meta,
    this.clicks,
    this.isActive,
    this.expireAt,
  });

  factory Code.fromRawJson(String str) => Code.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Code.fromJson(Map<String, dynamic> json) => Code(
    id: json["id"],
    code: json["code"],
    targetUrl: json["target_url"],
    deepLinkScheme: json["deep_link_scheme"],
    iosStoreUrl: json["ios_store_url"],
    androidStoreUrl: json["android_store_url"],
    title: json["title"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    clicks: json["clicks"],
    isActive: json["is_active"],
    expireAt: json["expire_at"] == null ? null : DateTime.parse(json["expire_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "target_url": targetUrl,
    "deep_link_scheme": deepLinkScheme,
    "ios_store_url": iosStoreUrl,
    "android_store_url": androidStoreUrl,
    "title": title,
    "meta": meta?.toJson(),
    "clicks": clicks,
    "is_active": isActive,
    "expire_at": expireAt?.toIso8601String(),
  };
}

class Meta {
  final String? status;
  final String? referCode;
  final int? referrerId;
  final String? referralType;
  final String? referrerType;
  final String? referrerUsername;

  Meta({
    this.status,
    this.referCode,
    this.referrerId,
    this.referralType,
    this.referrerType,
    this.referrerUsername,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    status: json["status"],
    referCode: json["refer_code"],
    referrerId: json["referrer_id"],
    referralType: json["referral_type"],
    referrerType: json["referrer_type"],
    referrerUsername: json["referrer_username"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "refer_code": referCode,
    "referrer_id": referrerId,
    "referral_type": referralType,
    "referrer_type": referrerType,
    "referrer_username": referrerUsername,
  };
}

// Hello I am Tamim