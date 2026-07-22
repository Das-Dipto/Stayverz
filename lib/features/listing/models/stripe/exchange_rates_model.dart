class ExchangeRatesResponseModel {
  final bool success;
  final ExchangeRatesData? data;

  ExchangeRatesResponseModel({required this.success, this.data});

  factory ExchangeRatesResponseModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRatesResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ExchangeRatesData.fromJson(json['data'])
          : null,
    );
  }
}

class ExchangeRatesData {
  final String bookingId;
  final String invoiceNo;
  final String baseCurrency;
  final double baseAmount;
  final Map<String, CurrencyRateInfo> currencies;
  final String updatedAt;

  ExchangeRatesData({
    required this.bookingId,
    required this.invoiceNo,
    required this.baseCurrency,
    required this.baseAmount,
    required this.currencies,
    required this.updatedAt,
  });

  factory ExchangeRatesData.fromJson(Map<String, dynamic> json) {
    final currenciesJson = json['currencies'] as Map<String, dynamic>? ?? {};
    return ExchangeRatesData(
      bookingId: '${json['booking_id'] ?? ''}',
      invoiceNo: json['invoice_no'] ?? '',
      baseCurrency: json['base_currency'] ?? 'BDT',
      baseAmount: (json['base_amount'] ?? 0).toDouble(),
      currencies: currenciesJson.map(
        (key, value) => MapEntry(key, CurrencyRateInfo.fromJson(value)),
      ),
      updatedAt: json['updated_at'] ?? '',
    );
  }

  /// Returns only the currencies Stripe supports (excludes base BDT)
  List<String> get stripeSupportedCurrencies =>
      currencies.keys.where((c) => c != baseCurrency).toList();
}

class CurrencyRateInfo {
  final double rate;
  final double amount;
  final String symbol;
  final String display;
  final double? minimum;
  final bool? meetsMinimum;
  final double? bdtEquivalent;

  CurrencyRateInfo({
    required this.rate,
    required this.amount,
    required this.symbol,
    required this.display,
    this.minimum,
    this.meetsMinimum,
    this.bdtEquivalent,
  });

  factory CurrencyRateInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyRateInfo(
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      symbol: json['symbol'] ?? '',
      display: json['display'] ?? '',
      minimum: json['minimum'] != null ? (json['minimum']).toDouble() : null,
      meetsMinimum: json['meetsMinimum'],
      bdtEquivalent: json['bdtEquivalent'] != null
          ? (json['bdtEquivalent']).toDouble()
          : null,
    );
  }
}