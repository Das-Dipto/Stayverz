import 'dart:convert';

class HostAssistanceMonthlyEarningResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final AssistanceMonthlyEarningData? data;

  HostAssistanceMonthlyEarningResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HostAssistanceMonthlyEarningResponseModel.fromRawJson(String str) => HostAssistanceMonthlyEarningResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostAssistanceMonthlyEarningResponseModel.fromJson(Map<String, dynamic> json) => HostAssistanceMonthlyEarningResponseModel(
    success: json["success"],
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : AssistanceMonthlyEarningData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class AssistanceMonthlyEarningData {
  final int? selectedYear;
  final int? selectedMonth;
  final String? selectedMonthName;
  final String? totalNetEarningsForMonth;
  final String? grossBookingEarningsForMonth;
  final String? totalHostServiceFeeForMonth;
  final String? netFromBookingsForMonth;
  final PerformanceStats? performanceStats;
  final List<ListingsContributingToEarning>? listingsContributingToEarnings;

  AssistanceMonthlyEarningData({
    this.selectedYear,
    this.selectedMonth,
    this.selectedMonthName,
    this.totalNetEarningsForMonth,
    this.grossBookingEarningsForMonth,
    this.totalHostServiceFeeForMonth,
    this.netFromBookingsForMonth,
    this.performanceStats,
    this.listingsContributingToEarnings,
  });

  factory AssistanceMonthlyEarningData.fromRawJson(String str) => AssistanceMonthlyEarningData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceMonthlyEarningData.fromJson(Map<String, dynamic> json) => AssistanceMonthlyEarningData(
    selectedYear: json["selected_year"],
    selectedMonth: json["selected_month"],
    selectedMonthName: json["selected_month_name"],
    totalNetEarningsForMonth: json["total_net_earnings_for_month"],
    grossBookingEarningsForMonth: json["gross_booking_earnings_for_month"],
    totalHostServiceFeeForMonth: json["total_host_service_fee_for_month"],
    netFromBookingsForMonth: json["net_from_bookings_for_month"],
    performanceStats: json["performance_stats"] == null ? null : PerformanceStats.fromJson(json["performance_stats"]),
    listingsContributingToEarnings: json["listings_contributing_to_earnings"] == null ? [] : List<ListingsContributingToEarning>.from(json["listings_contributing_to_earnings"]!.map((x) => ListingsContributingToEarning.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "selected_year": selectedYear,
    "selected_month": selectedMonth,
    "selected_month_name": selectedMonthName,
    "total_net_earnings_for_month": totalNetEarningsForMonth,
    "gross_booking_earnings_for_month": grossBookingEarningsForMonth,
    "total_host_service_fee_for_month": totalHostServiceFeeForMonth,
    "net_from_bookings_for_month": netFromBookingsForMonth,
    "performance_stats": performanceStats?.toJson(),
    "listings_contributing_to_earnings": listingsContributingToEarnings == null ? [] : List<dynamic>.from(listingsContributingToEarnings!.map((x) => x.toJson())),
  };
}

class ListingsContributingToEarning {
  final int? listingId;
  final String? listingTitle;
  final String? listingCoverPhoto;
  final String? earningsFromThisListingForMonth;

  ListingsContributingToEarning({
    this.listingId,
    this.listingTitle,
    this.listingCoverPhoto,
    this.earningsFromThisListingForMonth,
  });

  factory ListingsContributingToEarning.fromRawJson(String str) => ListingsContributingToEarning.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListingsContributingToEarning.fromJson(Map<String, dynamic> json) => ListingsContributingToEarning(
    listingId: json["listing_id"],
    listingTitle: json["listing_title"],
    listingCoverPhoto: json["listing_cover_photo"],
    earningsFromThisListingForMonth: json["earnings_from_this_listing_for_month"],
  );

  Map<String, dynamic> toJson() => {
    "listing_id": listingId,
    "listing_title": listingTitle,
    "listing_cover_photo": listingCoverPhoto,
    "earnings_from_this_listing_for_month": earningsFromThisListingForMonth,
  };
}

class PerformanceStats {
  final int? totalNightsBookedForMonth;
  final double? averageNightsPerStayForMonth;

  PerformanceStats({
    this.totalNightsBookedForMonth,
    this.averageNightsPerStayForMonth,
  });

  factory PerformanceStats.fromRawJson(String str) => PerformanceStats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerformanceStats.fromJson(Map<String, dynamic> json) => PerformanceStats(
    totalNightsBookedForMonth: json["total_nights_booked_for_month"],
    averageNightsPerStayForMonth: json["average_nights_per_stay_for_month"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total_nights_booked_for_month": totalNightsBookedForMonth,
    "average_nights_per_stay_for_month": averageNightsPerStayForMonth,
  };
}

// Hello I am Tamim