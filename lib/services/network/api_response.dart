class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse.success(this.data, {this.statusCode})
      : isSuccess = true,
        message = null;

  ApiResponse.error(this.message, {this.statusCode})
      : isSuccess = false,
        data = null;
}

// Hello I am Tamim