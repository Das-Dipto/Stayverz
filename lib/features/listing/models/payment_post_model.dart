class PaymentPostModel {
  final String booking;

  PaymentPostModel({required this.booking});

  Map<String, dynamic> toJson() {
    return {
      'booking': booking,
    };
  }
}

// Hello I am Tamim