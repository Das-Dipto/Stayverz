class DocumentRequestModel {
  final String documentType;
  final String live;

  DocumentRequestModel({
    required this.documentType,
    required this.live,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'live': live,
    };
  }
}

// Response Model
class ApiResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      errors: json['errors'],
    );
  }

  bool get isSuccessful => success && statusCode == 200;
}

// Hello I am Tamim