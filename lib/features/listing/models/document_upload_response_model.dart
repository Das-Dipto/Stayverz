class DocumentUploadResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final DocumentUploadData data;

  DocumentUploadResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DocumentUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponseModel(
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
      message: json['message'] as String,
      data: DocumentUploadData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class DocumentUploadData {
  final List<String> urls;

  DocumentUploadData({required this.urls});

  factory DocumentUploadData.fromJson(Map<String, dynamic> json) {
    return DocumentUploadData(
      urls: List<String>.from(json['urls'] as List),
    );
  }
}

// Hello I am Tamim