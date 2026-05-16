class CalendarPostResponse {
  final bool success;
  final int statusCode;
  final String message;
  final DataWrapper? data;

  CalendarPostResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CalendarPostResponse.fromJson(Map<String, dynamic> json) {
    return CalendarPostResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null ? DataWrapper.fromJson(json['data']) : null,
    );
  }
}

class DataWrapper {
  final String message;

  DataWrapper({required this.message});

  factory DataWrapper.fromJson(Map<String, dynamic> json) {
    return DataWrapper(
      message: json['message'],
    );
  }
}

// Hello I am Tamim