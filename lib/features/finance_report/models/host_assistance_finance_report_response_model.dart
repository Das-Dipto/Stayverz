import 'dart:convert';

class HostAssistanceFinanceReportResponseModel {
  final int? status;
  final String? message;
  final AssistanceFinanceReportData? data;
  final DateTime? timestamp;

  HostAssistanceFinanceReportResponseModel({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory HostAssistanceFinanceReportResponseModel.fromRawJson(String str) => HostAssistanceFinanceReportResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostAssistanceFinanceReportResponseModel.fromJson(Map<String, dynamic> json) => HostAssistanceFinanceReportResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : AssistanceFinanceReportData.fromJson(json["data"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class AssistanceFinanceReportData {
  final int? currentMonthTotalEarnings;
  final int? summaryPreviousYearBookingEarnings;
  final int? summaryLifetimeSuggestionRewards;
  final List<AssistanceCurrentYearMonthlyBookingAmount>? last12MonthsPaymentsOverview;
  final List<AssistanceCurrentYearMonthlyBookingAmount>? last6MonthsReceivedPaymentsGraph;
  final int? totalEarningsLast6MonthsFromPayouts;
  final List<AssistanceCurrentYearMonthlyBookingAmount>? currentYearMonthlyBookingAmounts;
  final List<AssistanceCurrentYearMonthlyBookingAmount>? previousYearMonthlyBookingAmounts;
  final int? currentYearTotalIncome;
  final int? previousYearTotalIncome;
  final List<AssistanceLast12MonthsIncomePaymentsGraph>? last12MonthsIncomePaymentsGraph;
  final List<AsssitanceHistoricalYearlyIncomeSummary>? historicalYearlyIncomeSummary;
  final Insights? insights;

  AssistanceFinanceReportData({
    this.currentMonthTotalEarnings,
    this.summaryPreviousYearBookingEarnings,
    this.summaryLifetimeSuggestionRewards,
    this.last12MonthsPaymentsOverview,
    this.last6MonthsReceivedPaymentsGraph,
    this.totalEarningsLast6MonthsFromPayouts,
    this.currentYearMonthlyBookingAmounts,
    this.previousYearMonthlyBookingAmounts,
    this.currentYearTotalIncome,
    this.previousYearTotalIncome,
    this.last12MonthsIncomePaymentsGraph,
    this.historicalYearlyIncomeSummary,
    this.insights,
  });

  factory AssistanceFinanceReportData.fromRawJson(String str) => AssistanceFinanceReportData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceFinanceReportData.fromJson(Map<String, dynamic> json) => AssistanceFinanceReportData(
    currentMonthTotalEarnings: json["current_month_total_earnings"],
    summaryPreviousYearBookingEarnings: json["summary_previous_year_booking_earnings"],
    summaryLifetimeSuggestionRewards: json["summary_lifetime_suggestion_rewards"],
    last12MonthsPaymentsOverview: json["last_12_months_payments_overview"] == null ? [] : List<AssistanceCurrentYearMonthlyBookingAmount>.from(json["last_12_months_payments_overview"]!.map((x) => AssistanceCurrentYearMonthlyBookingAmount.fromJson(x))),
    last6MonthsReceivedPaymentsGraph: json["last_6_months_received_payments_graph"] == null ? [] : List<AssistanceCurrentYearMonthlyBookingAmount>.from(json["last_6_months_received_payments_graph"]!.map((x) => AssistanceCurrentYearMonthlyBookingAmount.fromJson(x))),
    totalEarningsLast6MonthsFromPayouts: json["total_earnings_last_6_months_from_payouts"],
    currentYearMonthlyBookingAmounts: json["current_year_monthly_booking_amounts"] == null ? [] : List<AssistanceCurrentYearMonthlyBookingAmount>.from(json["current_year_monthly_booking_amounts"]!.map((x) => AssistanceCurrentYearMonthlyBookingAmount.fromJson(x))),
    previousYearMonthlyBookingAmounts: json["previous_year_monthly_booking_amounts"] == null ? [] : List<AssistanceCurrentYearMonthlyBookingAmount>.from(json["previous_year_monthly_booking_amounts"]!.map((x) => AssistanceCurrentYearMonthlyBookingAmount.fromJson(x))),
    currentYearTotalIncome: json["current_year_total_income"],
    previousYearTotalIncome: json["previous_year_total_income"],
    last12MonthsIncomePaymentsGraph: json["last_12_months_income_payments_graph"] == null ? [] : List<AssistanceLast12MonthsIncomePaymentsGraph>.from(json["last_12_months_income_payments_graph"]!.map((x) => AssistanceLast12MonthsIncomePaymentsGraph.fromJson(x))),
    historicalYearlyIncomeSummary: json["historical_yearly_income_summary"] == null ? [] : List<AsssitanceHistoricalYearlyIncomeSummary>.from(json["historical_yearly_income_summary"]!.map((x) => AsssitanceHistoricalYearlyIncomeSummary.fromJson(x))),
    insights: json["insights"] == null ? null : Insights.fromJson(json["insights"]),
  );

  Map<String, dynamic> toJson() => {
    "current_month_total_earnings": currentMonthTotalEarnings,
    "summary_previous_year_booking_earnings": summaryPreviousYearBookingEarnings,
    "summary_lifetime_suggestion_rewards": summaryLifetimeSuggestionRewards,
    "last_12_months_payments_overview": last12MonthsPaymentsOverview == null ? [] : List<dynamic>.from(last12MonthsPaymentsOverview!.map((x) => x.toJson())),
    "last_6_months_received_payments_graph": last6MonthsReceivedPaymentsGraph == null ? [] : List<dynamic>.from(last6MonthsReceivedPaymentsGraph!.map((x) => x.toJson())),
    "total_earnings_last_6_months_from_payouts": totalEarningsLast6MonthsFromPayouts,
    "current_year_monthly_booking_amounts": currentYearMonthlyBookingAmounts == null ? [] : List<dynamic>.from(currentYearMonthlyBookingAmounts!.map((x) => x.toJson())),
    "previous_year_monthly_booking_amounts": previousYearMonthlyBookingAmounts == null ? [] : List<dynamic>.from(previousYearMonthlyBookingAmounts!.map((x) => x.toJson())),
    "current_year_total_income": currentYearTotalIncome,
    "previous_year_total_income": previousYearTotalIncome,
    "last_12_months_income_payments_graph": last12MonthsIncomePaymentsGraph == null ? [] : List<dynamic>.from(last12MonthsIncomePaymentsGraph!.map((x) => x.toJson())),
    "historical_yearly_income_summary": historicalYearlyIncomeSummary == null ? [] : List<dynamic>.from(historicalYearlyIncomeSummary!.map((x) => x.toJson())),
    "insights": insights?.toJson(),
  };
}

class AssistanceCurrentYearMonthlyBookingAmount {
  final int? year;
  final int? month;
  final String? monthName;
  final int? bookingAmountEarned;
  final int? receivedPaymentAmount;

  AssistanceCurrentYearMonthlyBookingAmount({
    this.year,
    this.month,
    this.monthName,
    this.bookingAmountEarned,
    this.receivedPaymentAmount,
  });

  factory AssistanceCurrentYearMonthlyBookingAmount.fromRawJson(String str) => AssistanceCurrentYearMonthlyBookingAmount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCurrentYearMonthlyBookingAmount.fromJson(Map<String, dynamic> json) => AssistanceCurrentYearMonthlyBookingAmount(
    year: json["year"],
    month: json["month"],
    monthName: json["month_name"],
    bookingAmountEarned: json["booking_amount_earned"],
    receivedPaymentAmount: json["received_payment_amount"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "month_name": monthName,
    "booking_amount_earned": bookingAmountEarned,
    "received_payment_amount": receivedPaymentAmount,
  };
}

class AsssitanceHistoricalYearlyIncomeSummary {
  final int? year;
  final int? totalIncome;

  AsssitanceHistoricalYearlyIncomeSummary({
    this.year,
    this.totalIncome,
  });

  factory AsssitanceHistoricalYearlyIncomeSummary.fromRawJson(String str) => AsssitanceHistoricalYearlyIncomeSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AsssitanceHistoricalYearlyIncomeSummary.fromJson(Map<String, dynamic> json) => AsssitanceHistoricalYearlyIncomeSummary(
    year: json["year"],
    totalIncome: json["total_income"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "total_income": totalIncome,
  };
}

class Insights {
  final int? last7DaysNightsBooked;
  final int? last30DaysBookingValue;
  final int? last365Days5StarRatingPercentage;

  Insights({
    this.last7DaysNightsBooked,
    this.last30DaysBookingValue,
    this.last365Days5StarRatingPercentage,
  });

  factory Insights.fromRawJson(String str) => Insights.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Insights.fromJson(Map<String, dynamic> json) => Insights(
    last7DaysNightsBooked: json["last_7_days_nights_booked"],
    last30DaysBookingValue: json["last_30_days_booking_value"],
    last365Days5StarRatingPercentage: json["last_365_days_5_star_rating_percentage"],
  );

  Map<String, dynamic> toJson() => {
    "last_7_days_nights_booked": last7DaysNightsBooked,
    "last_30_days_booking_value": last30DaysBookingValue,
    "last_365_days_5_star_rating_percentage": last365Days5StarRatingPercentage,
  };
}

class AssistanceLast12MonthsIncomePaymentsGraph {
  final int? year;
  final int? month;
  final String? monthName;
  final int? bookingRelatedEarnings;
  final int? suggestionRewardsEarned;
  final int? grossTotalEarnings;

  AssistanceLast12MonthsIncomePaymentsGraph({
    this.year,
    this.month,
    this.monthName,
    this.bookingRelatedEarnings,
    this.suggestionRewardsEarned,
    this.grossTotalEarnings,
  });

  factory AssistanceLast12MonthsIncomePaymentsGraph.fromRawJson(String str) => AssistanceLast12MonthsIncomePaymentsGraph.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceLast12MonthsIncomePaymentsGraph.fromJson(Map<String, dynamic> json) => AssistanceLast12MonthsIncomePaymentsGraph(
    year: json["year"],
    month: json["month"],
    monthName: json["month_name"],
    bookingRelatedEarnings: json["booking_related_earnings"],
    suggestionRewardsEarned: json["suggestion_rewards_earned"],
    grossTotalEarnings: json["gross_total_earnings"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "month_name": monthName,
    "booking_related_earnings": bookingRelatedEarnings,
    "suggestion_rewards_earned": suggestionRewardsEarned,
    "gross_total_earnings": grossTotalEarnings,
  };
}

// Hello I am Tamim