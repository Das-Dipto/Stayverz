class AssistanceReviewRequest {
  final int rating;
  final String review;

  AssistanceReviewRequest({
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'review': review,
  };
}

class AssistanceReviewResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String dataMessage;

  AssistanceReviewResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataMessage,
  });

  factory AssistanceReviewResponse.fromJson(Map<String, dynamic> json) {
    return AssistanceReviewResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      dataMessage: json['data']['message'],
    );
  }
}

// Hello I am Tamim