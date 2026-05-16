import 'package:meta/meta.dart';

class PostBookingResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PostBookingErrors? errors;

  PostBookingResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.errors,
  });

  factory PostBookingResponse.fromJson(Map<String, dynamic> json) {
    return PostBookingResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      errors: json['errors'] != null
          ? PostBookingErrors.fromJson(json['errors'])
          : null,
    );
  }
}

class PostBookingErrors {
  final List<String>? nonFieldErrors;

  PostBookingErrors({this.nonFieldErrors});

  factory PostBookingErrors.fromJson(Map<String, dynamic> json) {
    return PostBookingErrors(
      nonFieldErrors: (json['non_field_errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

// Hello I am Tamim