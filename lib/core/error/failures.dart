import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  
  Failure({required this.message});
}

class ServerFailure extends Failure {
   ServerFailure({
    required super.message,
  });
  
  factory ServerFailure.fromDioError(DioError error) {
    String message = 'An error occurred';
    if (error.response != null) {
      message = error.response?.data['message'] ?? 'Server error';
    } else if (error.type == DioErrorType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioErrorType.receiveTimeout) {
      message = 'Receive timeout';
    } else if (error.type == DioErrorType.sendTimeout) {
      message = 'Send timeout';
    } else if (error.type == DioErrorType.badResponse) {
      message = 'Network error';
    }
    return ServerFailure(message: message);
  }
}

class CacheFailure extends Failure {
   CacheFailure({
    required super.message,
  });
}

class NetworkFailure extends Failure {
   NetworkFailure({
    required super.message,
  });
}

class ValidationFailure extends Failure {
   ValidationFailure({
    required super.message,
  });
}

// Hello I am Tamim