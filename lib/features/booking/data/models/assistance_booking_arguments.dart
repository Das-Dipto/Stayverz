import 'dart:convert';
import 'package:stayverz_flutter_app/features/assistance_service/models/single_public_assistance_listing_response_model.dart';

class AssistanceBookingArguments {
  final PublicAssistanceData? assistanceData;
  final int? nightCount;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? extraGuestCount;
  final String? phoneNumber;
  final String? location;

  AssistanceBookingArguments({
    this.assistanceData,
    this.nightCount,
    this.checkIn,
    this.checkOut,
    this.extraGuestCount,
    this.phoneNumber,
    this.location,
  });

  factory AssistanceBookingArguments.fromRawJson(String str) => AssistanceBookingArguments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceBookingArguments.fromJson(Map<String, dynamic> json) => AssistanceBookingArguments(
    assistanceData: json["assistance_data"] == null ? null : PublicAssistanceData.fromJson(json["assistance_data"]),
    nightCount: json["night_count"],
    checkIn: json["checkIn"] == null ? null : DateTime.parse(json["checkIn"]),
    checkOut: json["checkOut"] == null ? null : DateTime.parse(json["checkOut"]),
    extraGuestCount: json["extraGuestCount"],
    phoneNumber: json["phoneNumber"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "assistance_data": assistanceData?.toJson(),
    "night_count": nightCount,
    "checkIn": "${checkIn!.year.toString().padLeft(4, '0')}-${checkIn!.month.toString().padLeft(2, '0')}-${checkIn!.day.toString().padLeft(2, '0')}",
    "checkOut": "${checkOut!.year.toString().padLeft(4, '0')}-${checkOut!.month.toString().padLeft(2, '0')}-${checkOut!.day.toString().padLeft(2, '0')}",
    "extraGuestCount": extraGuestCount,
    "phoneNumber": phoneNumber,
    "location": location,
  };
}


// Hello I am Tamim