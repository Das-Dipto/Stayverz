class BookingResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final BookingData data;

  BookingResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: BookingData.fromJson(json['data'] ?? {}),
    );
  }
}

class BookingData {
  final int id;
  final String invoiceNo;
  final double totalPrice;
  final int guestCount;
  final int nightCount;
  final String checkIn;
  final String checkOut;
  final int? childrenCount;
  final int? infantCount;
  final int? adultCount;

  BookingData({
    required this.id,
    required this.invoiceNo,
    required this.totalPrice,
    required this.guestCount,
    required this.nightCount,
    required this.checkIn,
    required this.checkOut,
    this.childrenCount,
    this.infantCount,
    this.adultCount,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'] ?? 0,
      invoiceNo: json['invoice_no'] ?? '',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      guestCount: json['guest_count'] ?? 0,
      nightCount: json['night_count'] ?? 0,
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      childrenCount: json['children_count'],
      infantCount: json['infant_count'],
      adultCount: json['adult_count'],
    );
  }
}

// Hello I am Tamim