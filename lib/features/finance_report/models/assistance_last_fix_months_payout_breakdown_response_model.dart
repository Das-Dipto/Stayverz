import 'dart:convert';

class AssistanceLastFixMonthsPayoutBreakdownResponseModel {
  final int? status;
  final String? message;
  final AssistanceFixMonthsPayoutBreakdownData? data;
  final DateTime? timestamp;

  AssistanceLastFixMonthsPayoutBreakdownResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceLastFixMonthsPayoutBreakdownResponseModel.fromRawJson(String str) => AssistanceLastFixMonthsPayoutBreakdownResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceLastFixMonthsPayoutBreakdownResponseModel.fromJson(Map<String, dynamic> json) => AssistanceLastFixMonthsPayoutBreakdownResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : AssistanceFixMonthsPayoutBreakdownData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class AssistanceFixMonthsPayoutBreakdownData {
  final DateTime? periodStartDate;
  final DateTime? periodEndDate;
  final int? grossEarningsFromIncludedBookings;
  final int? hostServiceFeeFromIncludedBookings;
  final int? totalReceivedPayoutsInPeriod;

  AssistanceFixMonthsPayoutBreakdownData({
    this.periodStartDate,
    this.periodEndDate,
    this.grossEarningsFromIncludedBookings,
    this.hostServiceFeeFromIncludedBookings,
    this.totalReceivedPayoutsInPeriod,
  });

  factory AssistanceFixMonthsPayoutBreakdownData.fromRawJson(String str) => AssistanceFixMonthsPayoutBreakdownData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceFixMonthsPayoutBreakdownData.fromJson(Map<String, dynamic> json) => AssistanceFixMonthsPayoutBreakdownData(
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