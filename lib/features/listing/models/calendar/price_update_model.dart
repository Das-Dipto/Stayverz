class BookingPayload {
  final int id;
  final String price;
  final bool isBlocked;
  final bool isBooked;
  final Map<String, dynamic> bookingData;
  final String note;
  final String startDate;
  final String endDate;

  BookingPayload({
    required this.id,
    required this.price,
    required this.isBlocked,
    required this.isBooked,
    required this.bookingData,
    required this.note,
    required this.startDate,
    required this.endDate,
  });

  factory BookingPayload.fromJson(Map<String, dynamic> json) {
    return BookingPayload(
      id: json['id'],
      price: json['price'],
      isBlocked: json['is_blocked'],
      isBooked: json['is_booked'],
      bookingData: json['booking_data'] ?? {},
      note: json['note'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'is_blocked': isBlocked,
      'is_booked': isBooked,
      'booking_data': bookingData,
      'note': note,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

// Hello I am Tamim