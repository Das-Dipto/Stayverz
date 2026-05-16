import 'dart:convert';

class PostAssistancePaymentModel {
  final int? status;
  final String? message;
  final PostAssistancePaymentData? data;
  final DateTime? timestamp;

  PostAssistancePaymentModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory PostAssistancePaymentModel.fromRawJson(String str) => PostAssistancePaymentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostAssistancePaymentModel.fromJson(Map<String, dynamic> json) => PostAssistancePaymentModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : PostAssistancePaymentData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class PostAssistancePaymentData {
  final String? paymentGatewayUrl;
  final String? logo;
  final String? successUrl;
  final String? failUrl;
  final String? cancelUrl;

  PostAssistancePaymentData({
    this.paymentGatewayUrl,
    this.logo,
    this.successUrl,
    this.failUrl,
    this.cancelUrl,
  });

  factory PostAssistancePaymentData.fromRawJson(String str) => PostAssistancePaymentData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostAssistancePaymentData.fromJson(Map<String, dynamic> json) => PostAssistancePaymentData(
    paymentGatewayUrl: json["paymentGatewayUrl"],
    logo: json["logo"],
    successUrl: json["success_url"],
    failUrl: json["fail_url"],
    cancelUrl: json["cancel_url"],
  );

  Map<String, dynamic> toJson() => {
    "paymentGatewayUrl": paymentGatewayUrl,
    "logo": logo,
    "success_url": successUrl,
    "fail_url": failUrl,
    "cancel_url": cancelUrl,
  };
}

// Hello I am Tamim