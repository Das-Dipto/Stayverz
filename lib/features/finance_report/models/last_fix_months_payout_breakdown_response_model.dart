import 'dart:convert';

class LastFixMonthsPayoutBreakdownResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final FixMonthsPayoutBreakdownData? data;

  LastFixMonthsPayoutBreakdownResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LastFixMonthsPayoutBreakdownResponseModel.fromRawJson(String str) => LastFixMonthsPayoutBreakdownResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastFixMonthsPayoutBreakdownResponseModel.fromJson(Map<String, dynamic> json) => LastFixMonthsPayoutBreakdownResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : FixMonthsPayoutBreakdownData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class FixMonthsPayoutBreakdownData {
  final DateTime? periodStartDate;
  final DateTime? periodEndDate;
  final String? grossEarningsFromIncludedBookings;
  final String? hostServiceFeeFromIncludedBookings;
  final String? totalReceivedPayoutsInPeriod;

  FixMonthsPayoutBreakdownData({
    this.periodStartDate,
    this.periodEndDate,
    this.grossEarningsFromIncludedBookings,
    this.hostServiceFeeFromIncludedBookings,
    this.totalReceivedPayoutsInPeriod,
  });

  factory FixMonthsPayoutBreakdownData.fromRawJson(String str) => FixMonthsPayoutBreakdownData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FixMonthsPayoutBreakdownData.fromJson(Map<String, dynamic> json) => FixMonthsPayoutBreakdownData(
    periodStartDate: json["period_start_date"] == null ? null : DateTime.parse(json["period_start_date"]),
    periodEndDate: json["period_end_date"] == null ? null : DateTime.parse(json["period_end_date"]),
    grossEarningsFromIncludedBookings: json["gross_earnings_from_included_bookings"],
    hostServiceFeeFromIncludedBookings: json["host_service_fee_from_included_bookings"],
    totalReceivedPayoutsInPeriod: json["total_received_payouts_in_period"],
  );

  Map<String, dynamic> toJson() => {
    "period_start_date": "${periodStartDate!.year.toString().padLeft(4, '0')}-${periodStartDate!.month.toString().padLeft(2, '0')}-${periodStartDate!.day.toString().padLeft(2, '0')}",
    "period_end_date": "${periodEndDate!.year.toString().padLeft(4, '0')}-${periodEndDate!.month.toString().padLeft(2, '0')}-${periodEndDate!.day.toString().padLeft(2, '0')}",
    "gross_earnings_from_included_bookings": grossEarningsFromIncludedBookings,
    "host_service_fee_from_included_bookings": hostServiceFeeFromIncludedBookings,
    "total_received_payouts_in_period": totalReceivedPayoutsInPeriod,
  };
}

// Hello I am Tamim