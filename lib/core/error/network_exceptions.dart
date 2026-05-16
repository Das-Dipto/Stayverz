import 'package:dio/dio.dart';

/// Base network exception class
abstract class NetworkException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final int? statusCode;
  
  const NetworkException({
    required this.message,
    this.code,
    this.originalError,
    this.statusCode,
  });
  
  @override
  String toString() => 'NetworkException: $message';
}

/// No internet connection exception
class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'No internet connection',
    super.code,
    super.originalError,
  });
}

/// Connection timeout exception
class ConnectionTimeoutException extends NetworkException {
  final Duration timeout;
  
  const ConnectionTimeoutException({
    super.message = 'Connection timeout',
    super.code,
    super.originalError,
    required this.timeout,
  });
}

/// Request timeout exception
class RequestTimeoutException extends NetworkException {
  final Duration timeout;
  
  const RequestTimeoutException({
    super.message = 'Request timeout',
    super.code,
    super.originalError,
    required this.timeout,
  });
}

/// Server error exception
class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    required super.statusCode,
  });
}

/// Bad request exception (400)
class BadRequestException extends ServerException {
  final Map<String, dynamic>? validationErrors;
  
  const BadRequestException({
    super.message = 'Bad request',
    super.code,
    super.originalError,
    this.validationErrors,
  }) : super(statusCode: 400);
}

/// Unauthorized exception (401)
class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.code,
    super.originalError,
  }) : super(statusCode: 401);
}

/// Forbidden exception (403)
class ForbiddenException extends ServerException {
  const ForbiddenException({
    super.message = 'Forbidden',
    super.code,
    super.originalError,
  }) : super(statusCode: 403);
}

/// Not found exception (404)
class NotFoundException extends ServerException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code,
    super.originalError,
  }) : super(statusCode: 404);
}

/// Validation exception (422)
class ValidationException extends BadRequestException {
  const ValidationException({
    super.message = 'Validation failed',
    super.code,
    super.originalError,
    super.validationErrors,
  });
}

/// Too many requests exception (429)
class TooManyRequestsException extends ServerException {
  final Duration? retryAfter;
  
  const TooManyRequestsException({
    super.message = 'Too many requests',
    super.code,
    super.originalError,
    this.retryAfter,
  }) : super(statusCode: 429);
}

/// Internal server error exception (500)
class InternalServerException extends ServerException {
  const InternalServerException({
    super.message = 'Internal server error',
    super.code,
    super.originalError,
  }) : super(statusCode: 500);
}

/// Service unavailable exception (503)
class ServiceUnavailableException extends ServerException {
  const ServiceUnavailableException({
    super.message = 'Service unavailable',
    super.code,
    super.originalError,
  }) : super(statusCode: 503);
}

/// Network connection error exception
class NetworkConnectionException extends NetworkException {
  const NetworkConnectionException({
    super.message = 'Network connection error',
    super.code,
    super.originalError,
  });
}

/// Unknown network exception
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    super.message = 'Unknown network error',
    super.code,
    super.originalError,
    super.statusCode,
  });
}

/// Utility class to convert Dio exceptions to NetworkExceptions
class NetworkExceptionFactory {
  static NetworkException fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutException(
          message: 'Connection timeout. Please check your internet connection.',
          originalError: dioException,
          timeout: dioException.requestOptions.connectTimeout ?? const Duration(seconds: 30),
        );
        
      case DioExceptionType.sendTimeout:
        return RequestTimeoutException(
          message: 'Request timeout. Please try again.',
          originalError: dioException,
          timeout: dioException.requestOptions.sendTimeout ?? const Duration(seconds: 30),
        );
        
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutException(
          message: 'Response timeout. Please try again.',
          originalError: dioException,
          timeout: dioException.requestOptions.receiveTimeout ?? const Duration(seconds: 30),
        );
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(dioException);
        
      case DioExceptionType.cancel:
        return const NetworkConnectionException(
          message: 'Request was cancelled',
        );
        
      case DioExceptionType.connectionError:
        return const NoInternetException(
          message: 'No internet connection. Please check your network settings.',
        );
        
      case DioExceptionType.badCertificate:
        return const NetworkConnectionException(
          message: 'Security certificate error. Please contact support.',
        );
        
      case DioExceptionType.unknown:
        return UnknownNetworkException(
          message: dioException.message ?? 'Unknown network error',
          originalError: dioException,
        );
    }
  }
  
  static NetworkException _handleBadResponse(DioException dioException) {
    final response = dioException.response;
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;
    
    // Extract message from response if available
    String message = 'Request failed';
    Map<String, dynamic>? validationErrors;
    
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      validationErrors = data['errors'] as Map<String, dynamic>?;
    }
    
    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message,
          originalError: dioException,
          validationErrors: validationErrors,
        );
        
      case 401:
        return UnauthorizedException(
          message: message,
          originalError: dioException,
        );
        
      case 403:
        return ForbiddenException(
          message: message,
          originalError: dioException,
        );
        
      case 404:
        return NotFoundException(
          message: message,
          originalError: dioException,
        );
        
      case 422:
        return ValidationException(
          message: message,
          originalError: dioException,
          validationErrors: validationErrors,
        );
        
      case 429:
        Duration? retryAfter;
        final retryAfterHeader = response?.headers['retry-after']?.first;
        if (retryAfterHeader != null) {
          final seconds = int.tryParse(retryAfterHeader);
          if (seconds != null) {
            retryAfter = Duration(seconds: seconds);
          }
        }
        return TooManyRequestsException(
          message: message,
          originalError: dioException,
          retryAfter: retryAfter,
        );
        
      case 500:
        return InternalServerException(
          message: message,
          originalError: dioException,
        );
        
      case 503:
        return ServiceUnavailableException(
          message: message,
          originalError: dioException,
        );
        
      default:
        return ServerException(
          message: message,
          originalError: dioException,
          statusCode: statusCode,
        );
    }
  }
}

// Hello I am Tamim