import 'dart:convert';

class MapsSuggestionsResponseModel {
  final bool? success;
  final int? statusCode;
  final dynamic message;
  final List<PlaceSuggestion>? data;

  MapsSuggestionsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MapsSuggestionsResponseModel.fromRawJson(String str) => MapsSuggestionsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MapsSuggestionsResponseModel.fromJson(Map<String, dynamic> json) => MapsSuggestionsResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PlaceSuggestion>.from(json["data"]!.map((x) => PlaceSuggestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PlaceSuggestion {
  final int? id;
  final String? longitude;
  final String? latitude;
  final String? address;
  final String? addressBn;
  final String? city;
  final String? cityBn;
  final String? area;
  final String? areaBn;
  final int? postCode;
  final String? pType;
  final String? subType;
  final String? district;
  final String? uCode;

  PlaceSuggestion({
    this.id,
    this.longitude,
    this.latitude,
    this.address,
    this.addressBn,
    this.city,
    this.cityBn,
    this.area,
    this.areaBn,
    this.postCode,
    this.pType,
    this.subType,
    this.district,
    this.uCode,
  });

  factory PlaceSuggestion.fromRawJson(String str) => PlaceSuggestion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) => PlaceSuggestion(
    id: json["id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    address: json["address"],
    addressBn: json["address_bn"],
    city: json["city"],
    cityBn: json["city_bn"],
    area: json["area"],
    areaBn: json["area_bn"],
    postCode: int.tryParse("${json["postCode"] ?? '0'}"),
    pType: json["pType"],
    subType: json["subType"],
    district: json["district"],
    uCode: json["uCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "longitude": longitude,
    "latitude": latitude,
    "address": address,
    "address_bn": addressBn,
    "city": city,
    "city_bn": cityBn,
    "area": area,
    "area_bn": areaBn,
    "postCode": postCode,
    "pType": pType,
    "subType": subType,
    "district": district,
    "uCode": uCode,
  };
}

// Hello I am Tamim