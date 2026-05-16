class ReviewRequest {
  final String id;
  final int rating;
  final String review;

  ReviewRequest({
    required this.id,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'review': review,
  };
}
class ReviewResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String dataMessage;

  ReviewResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataMessage,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      dataMessage: json['data']['message'],
    );
  }
}

// Hello I am Tamim