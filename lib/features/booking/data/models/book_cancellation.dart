class BookingCancellationRequest {
  final String id;
  final String cancellationReason;

  BookingCancellationRequest({
    required this.id,
    required this.cancellationReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cancellation_reason': cancellationReason,
    };
  }

  factory BookingCancellationRequest.fromJson(Map<String, dynamic> json) {
    return BookingCancellationRequest(
      id: json['id'] ?? '',
      cancellationReason: json['cancellation_reason'] ?? '',
    );
  }
}

// Response Data Model
class BookingCancellationData {
  final String message;

  BookingCancellationData({
    required this.message,
  });

  factory BookingCancellationData.fromJson(Map<String, dynamic> json) {
    return BookingCancellationData(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

// Response Model
class BookingCancellationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final BookingCancellationData data;

  BookingCancellationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BookingCancellationResponse.fromJson(Map<String, dynamic> json) {
    return BookingCancellationResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: BookingCancellationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}
// Hello I am Tamim