/// Request payload for POST stripe/create-payment
class CreateStripePaymentRequest {
  final String bookingId;
  final String currency;
  final String email;

  CreateStripePaymentRequest({
    required this.bookingId,
    required this.currency,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId,
        'currency': currency,
        'email': email,
      };
}

/// Response is intentionally loose until backend confirms exact shape.
/// We keep the raw map around (`raw`) so nothing is lost, and pull out
/// the fields we can reasonably guess (client_secret OR a hosted url).
class CreateStripePaymentResponse {
  final bool success;
  final Map<String, dynamic> raw;
  final String? message;
  final String? clientSecret;
  final String? paymentIntentId;
  final String? checkoutUrl;
  final String? stripePublicKey; // ADD THIS

  CreateStripePaymentResponse({
    required this.success,
    required this.raw,
    this.message, // ADD THIS
    this.clientSecret,
    this.paymentIntentId,
    this.checkoutUrl,
    this.stripePublicKey, // ADD THIS
  });

  factory CreateStripePaymentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return CreateStripePaymentResponse(
      success: json['success'] ?? false,
      raw: json,
      message: json['message'], // ADD THIS
      clientSecret: data['client_secret'] ?? data['clientSecret'],
      paymentIntentId: data['transaction_id'] ?? data['payment_id'],
      checkoutUrl: data['checkout_url'] ??
          data['payment_gateway_url'] ??
          data['url'],
      stripePublicKey: data['stripe_public_key'], // ADD THIS
    );
  }
}

/// Request payload for POST stripe/confirm-payment
class ConfirmStripePaymentRequest {
  final String paymentIntentId;

  ConfirmStripePaymentRequest({required this.paymentIntentId});

  Map<String, dynamic> toJson() => {
        'payment_intent_id': paymentIntentId,
      };
}

class ConfirmStripePaymentResponse {
  final bool success;
  final Map<String, dynamic> raw;
  final String? status;

  ConfirmStripePaymentResponse({
    required this.success,
    required this.raw,
    this.status,
  });

  factory ConfirmStripePaymentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};
    return ConfirmStripePaymentResponse(
      success: json['success'] ?? false,
      raw: json,
      status: data['status'],
    );
  }
}