import 'dart:convert';

class HostFinanceReportResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final HostFinanceReportData data;

  HostFinanceReportResponseModel({
    this.success = false,
    this.statusCode = 0,
    this.message = '',
    HostFinanceReportData? data,
  }) : data = data ?? HostFinanceReportData();

  factory HostFinanceReportResponseModel.fromRawJson(String str) =>
      HostFinanceReportResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostFinanceReportResponseModel.fromJson(Map<String, dynamic> json) =>
      HostFinanceReportResponseModel(
        success: json["success"] as bool? ?? false,
        statusCode: json["status_code"] as int? ?? 0,
        message: json["message"] as String? ?? '',
        data: json["data"] != null
            ? HostFinanceReportData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class HostFinanceReportData {
  final String currentMonthTotalEarnings;
  final String summaryPreviousYearBookingEarnings;
  final String summaryLifetimeSuggestionRewards;
  final List<CurrentYearMonthlyBookingAmount> last12MonthsPaymentsOverview;
  final List<CurrentYearMonthlyBookingAmount> last6MonthsReceivedPaymentsGraph;
  final String totalEarningsLast6MonthsFromPayouts;
  final List<CurrentYearMonthlyBookingAmount> currentYearMonthlyBookingAmounts;
  final List<CurrentYearMonthlyBookingAmount> previousYearMonthlyBookingAmounts;
  final String currentYearTotalIncome;
  final String previousYearTotalIncome;
  final List<Last12MonthsIncomePaymentsGraph> last12MonthsIncomePaymentsGraph;
  final List<HistoricalYearlyIncomeSummary> historicalYearlyIncomeSummary;
  final Insights insights;

  HostFinanceReportData({
    this.currentMonthTotalEarnings = '',
    this.summaryPreviousYearBookingEarnings = '',
    this.summaryLifetimeSuggestionRewards = '',
    this.last12MonthsPaymentsOverview = const [],
    this.last6MonthsReceivedPaymentsGraph = const [],
    this.totalEarningsLast6MonthsFromPayouts = '',
    this.currentYearMonthlyBookingAmounts = const [],
    this.previousYearMonthlyBookingAmounts = const [],
    this.currentYearTotalIncome = '',
    this.previousYearTotalIncome = '',
    this.last12MonthsIncomePaymentsGraph = const [],
    this.historicalYearlyIncomeSummary = const [],
    Insights? insights,
  }) : insights = insights ?? Insights();

  factory HostFinanceReportData.fromRawJson(String str) =>
      HostFinanceReportData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostFinanceReportData.fromJson(Map<String, dynamic> json) =>
      HostFinanceReportData(
        currentMonthTotalEarnings:
        json["current_month_total_earnings"] as String? ?? '',
        summaryPreviousYearBookingEarnings:
        json["summary_previous_year_booking_earnings"] as String? ?? '',
        summaryLifetimeSuggestionRewards:
        json["summary_lifetime_suggestion_rewards"] as String? ?? '',
        last12MonthsPaymentsOverview: (json["last_12_months_payments_overview"]
        as List<dynamic>?)
            ?.map((x) => CurrentYearMonthlyBookingAmount.fromJson(x))
            .toList() ??
            [],
        last6MonthsReceivedPaymentsGraph:
        (json["last_6_months_received_payments_graph"] as List<dynamic>?)
            ?.map((x) => CurrentYearMonthlyBookingAmount.fromJson(x))
            .toList() ??
            [],
        totalEarningsLast6MonthsFromPayouts:
        json["total_earnings_last_6_months_from_payouts"] as String? ?? '',
        currentYearMonthlyBookingAmounts:
        (json["current_year_monthly_booking_amounts"] as List<dynamic>?)
            ?.map((x) => CurrentYearMonthlyBookingAmount.fromJson(x))
            .toList() ??
            [],
        previousYearMonthlyBookingAmounts:
        (json["previous_year_monthly_booking_amounts"] as List<dynamic>?)
            ?.map((x) => CurrentYearMonthlyBookingAmount.fromJson(x))
            .toList() ??
            [],
        currentYearTotalIncome:
        json["current_year_total_income"] as String? ?? '',
        previousYearTotalIncome:
        json["previous_year_total_income"] as String? ?? '',
        last12MonthsIncomePaymentsGraph:
        (json["last_12_months_income_payments_graph"] as List<dynamic>?)
            ?.map((x) => Last12MonthsIncomePaymentsGraph.fromJson(x))
            .toList() ??
            [],
        historicalYearlyIncomeSummary:
        (json["historical_yearly_income_summary"] as List<dynamic>?)
            ?.map((x) => HistoricalYearlyIncomeSummary.fromJson(x))
            .toList() ??
            [],
        insights: json["insights"] != null
            ? Insights.fromJson(json["insights"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "current_month_total_earnings": currentMonthTotalEarnings,
    "summary_previous_year_booking_earnings":
    summaryPreviousYearBookingEarnings,
    "summary_lifetime_suggestion_rewards": summaryLifetimeSuggestionRewards,
    "last_12_months_payments_overview":
    last12MonthsPaymentsOverview.map((x) => x.toJson()).toList(),
    "last_6_months_received_payments_graph":
    last6MonthsReceivedPaymentsGraph.map((x) => x.toJson()).toList(),
    "total_earnings_last_6_months_from_payouts":
    totalEarningsLast6MonthsFromPayouts,
    "current_year_monthly_booking_amounts":
    currentYearMonthlyBookingAmounts.map((x) => x.toJson()).toList(),
    "previous_year_monthly_booking_amounts":
    previousYearMonthlyBookingAmounts.map((x) => x.toJson()).toList(),
    "current_year_total_income": currentYearTotalIncome,
    "previous_year_total_income": previousYearTotalIncome,
    "last_12_months_income_payments_graph":
    last12MonthsIncomePaymentsGraph.map((x) => x.toJson()).toList(),
    "historical_yearly_income_summary":
    historicalYearlyIncomeSummary.map((x) => x.toJson()).toList(),
    "insights": insights.toJson(),
  };
}

class CurrentYearMonthlyBookingAmount {
  final int year;
  final int month;
  final String monthName;
  final String bookingAmountEarned;
  final String receivedPaymentAmount;

  CurrentYearMonthlyBookingAmount({
    this.year = 0,
    this.month = 0,
    this.monthName = '',
    this.bookingAmountEarned = '',
    this.receivedPaymentAmount = '',
  });

  factory CurrentYearMonthlyBookingAmount.fromRawJson(String str) =>
      CurrentYearMonthlyBookingAmount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentYearMonthlyBookingAmount.fromJson(Map<String, dynamic> json) =>
      CurrentYearMonthlyBookingAmount(
        year: json["year"] as int? ?? 0,
        month: json["month"] as int? ?? 0,
        monthName: json["month_name"] as String? ?? '',
        bookingAmountEarned: json["booking_amount_earned"] as String? ?? '',
        receivedPaymentAmount:
        json["received_payment_amount"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "month_name": monthName,
    "booking_amount_earned": bookingAmountEarned,
    "received_payment_amount": receivedPaymentAmount,
  };
}

class HistoricalYearlyIncomeSummary {
  final int year;
  final String totalIncome;

  HistoricalYearlyIncomeSummary({
    this.year = 0,
    this.totalIncome = '',
  });

  factory HistoricalYearlyIncomeSummary.fromRawJson(String str) =>
      HistoricalYearlyIncomeSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoricalYearlyIncomeSummary.fromJson(Map<String, dynamic> json) =>
      HistoricalYearlyIncomeSummary(
        year: json["year"] as int? ?? 0,
        totalIncome: json["total_income"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    "year": year,
    "total_income": totalIncome,
  };
}

class Insights {
  final int last7DaysNightsBooked;
  final String last30DaysBookingValue;
  final double last365Days5StarRatingPercentage;

  Insights({
    this.last7DaysNightsBooked = 0,
    this.last30DaysBookingValue = '',
    this.last365Days5StarRatingPercentage = 0.0,
  });

  factory Insights.fromRawJson(String str) =>
      Insights.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Insights.fromJson(Map<String, dynamic> json) => Insights(
    last7DaysNightsBooked: json["last_7_days_nights_booked"] as int? ?? 0,
    last30DaysBookingValue:
    json["last_30_days_booking_value"] as String? ?? '',
    last365Days5StarRatingPercentage:
    (json["last_365_days_5_star_rating_percentage"] as num?)
        ?.toDouble() ??
        0.0,
  );

  Map<String, dynamic> toJson() => {
    "last_7_days_nights_booked": last7DaysNightsBooked,
    "last_30_days_booking_value": last30DaysBookingValue,
    "last_365_days_5_star_rating_percentage":
    last365Days5StarRatingPercentage,
  };
}

class Last12MonthsIncomePaymentsGraph {
  final int year;
  final int month;
  final String monthName;
  final String bookingRelatedEarnings;
  final String suggestionRewardsEarned;
  final String grossTotalEarnings;

  Last12MonthsIncomePaymentsGraph({
    this.year = 0,
    this.month = 0,
    this.monthName = '',
    this.bookingRelatedEarnings = '',
    this.suggestionRewardsEarned = '',
    this.grossTotalEarnings = '',
  });

  factory Last12MonthsIncomePaymentsGraph.fromRawJson(String str) =>
      Last12MonthsIncomePaymentsGraph.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Last12MonthsIncomePaymentsGraph.fromJson(
      Map<String, dynamic> json) =>
      Last12MonthsIncomePaymentsGraph(
        year: json["year"] as int? ?? 0,
        month: json["month"] as int? ?? 0,
        monthName: json["month_name"] as String? ?? '',
        bookingRelatedEarnings:
        json["booking_related_earnings"] as String? ?? '',
        suggestionRewardsEarned:
        json["suggestion_rewards_earned"] as String? ?? '',
        grossTotalEarnings: json["gross_total_earnings"] as String? ?? '',
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