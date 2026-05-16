class PaymentResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final PaymentData data;

  PaymentResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: PaymentData.fromJson(json['data']),
    );
  }
}

class PaymentData {
  final String paymentGatewayUrl;
  final String successUrl; // Added
  final String failUrl;    // Added
  final String cancelUrl;  // Added
  final String logo;

  PaymentData({
    required this.paymentGatewayUrl,
    required this.successUrl,
    required this.failUrl,
    required this.cancelUrl,
    required this.logo,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      paymentGatewayUrl: json['payment_gateway_url'],
      successUrl: json['success_url'],  // Added
      failUrl: json['fail_url'],        // Added
      cancelUrl: json['cancel_url'],    // Added
      logo: json['logo'],
    );
  }
}

// Hello I am Tamim