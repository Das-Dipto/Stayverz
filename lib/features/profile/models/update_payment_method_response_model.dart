import 'dart:convert';

class UpdatePaymentMethodResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final Data? data;

  UpdatePaymentMethodResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory UpdatePaymentMethodResponseModel.fromRawJson(String str) => UpdatePaymentMethodResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdatePaymentMethodResponseModel.fromJson(Map<String, dynamic> json) => UpdatePaymentMethodResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
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