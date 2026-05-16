import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../error/failures.dart';
import '../error/network_exceptions.dart';
import '../../services/network/connectivity_service.dart';

/// Base repository class that provides common error handling and connectivity checks
abstract class BaseRepository {
  final Logger _logger = Get.find<Logger>();
  final ConnectivityService _connectivityService = ConnectivityService.to;
  
  /// Execute a function with proper error handling and connectivity checks
  /// 
  /// [function] - The function to execute
  /// [operationName] - Name of the operation for logging purposes
  /// [checkConnectivity] - Whether to check connectivity before execution (default: true)
  /// [retryOnFailure] - Whether to retry on network failures (default: true)
  /// 
  /// Returns [Right] with the result on success, or [Left] with a [Failure] on error
  Future<Either<Failure, T>> safeCall<T>(
    Future<T> Function() function, {
    required String operationName,
    bool checkConnectivity = true,
    bool retryOnFailure = true,
  }) async {
    try {
      // Check connectivity if required
      if (checkConnectivity && !_connectivityService.hasInternet) {
        _logger.w('No internet connection for operation: $operationName');
        
        if (retryOnFailure) {
          // Wait for connection
          final hasConnection = await _connectivityService.waitForConnection(
            timeout: const Duration(seconds: 15),
          );
          
          if (!hasConnection) {
            return Left(NetworkFailure(message: 'No internet connection'));
          }
        } else {
          return Left(NetworkFailure(message: 'No internet connection'));
        }
      }
      
      _logger.d('Executing operation: $operationName');
      
      // Execute the function
      final result = await function();
      
      _logger.d('Operation completed successfully: $operationName');
      return Right(result);
      
    } on NetworkException catch (e) {
      _logger.e('Network error in $operationName: ${e.message}', error: e);
      
      // Convert NetworkException to appropriate Failure
      return Left(_mapNetworkExceptionToFailure(e));
      
    } catch (e) {
      _logger.e('Unexpected error in $operationName: $e', error: e);
      
      // Handle other exceptions
      if (e is Failure) {
        return Left(e);
      }
      
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  /// Execute a function without returning Either (for void operations)
  /// 
  /// Returns true on success, false on failure
  Future<bool> safeExecute(
    Future<void> Function() function, {
    required String operationName,
    bool checkConnectivity = true,
    bool retryOnFailure = true,
  }) async {
    final result = await safeCall<void>(
      function,
      operationName: operationName,
      checkConnectivity: checkConnectivity,
      retryOnFailure: retryOnFailure,
    );
    
    return result.isRight();
  }
  
  /// Map NetworkException to appropriate Failure
  Failure _mapNetworkExceptionToFailure(NetworkException exception) {
    switch (exception.runtimeType) {
      case NoInternetException _:
        return NetworkFailure(message: exception.message);
        
      case ConnectionTimeoutException _:
      case RequestTimeoutException _:
        return NetworkFailure(message: exception.message);
        
      case BadRequestException _:
        return ValidationFailure(message: exception.message);
        
      case UnauthorizedException _:
        return ServerFailure(message: exception.message);
        
      case ForbiddenException _:
        return ServerFailure(message: exception.message);
        
      case NotFoundException _:
        return ServerFailure(message: exception.message);
        
      case TooManyRequestsException _:
        return ServerFailure(message: exception.message);
        
      case InternalServerException _:
      case ServiceUnavailableException _:
        return ServerFailure(message: exception.message);
        
      case NetworkConnectionException _:
        return NetworkFailure(message: exception.message);
        
      default:
        return ServerFailure(message: exception.message);
    }
  }
  
  /// Execute with retry logic for specific operations
  Future<Either<Failure, T>> withRetry<T>(
    Future<T> Function() function,
    String operationName, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      attempts++;
      
      final result = await safeCall<T>(
        () async {
          // Add retry count to function call for logging
          if (attempts > 1) {
            _logger.d('Retry attempt $attempts for $operationName');
          }
          return await function();
        },
        operationName: '$operationName (attempt $attempts/$maxRetries)',
        checkConnectivity: attempts == 1, // Only check connectivity on first attempt
        retryOnFailure: false, // We handle retry logic here
      );
      
      if (result.isRight()) {
        return result;
      }
      
      // If this is the last attempt, return the failure
      if (attempts >= maxRetries) {
        _logger.e('All retry attempts failed for $operationName');
        return result;
      }
      
      // Wait before retrying
      await Future.delayed(delay * attempts); // Exponential backoff
      
      // Check connectivity before retry
      if (!_connectivityService.hasInternet) {
        _logger.w('No internet connection before retry $attempts for $operationName');
        await _connectivityService.waitForConnection(
          timeout: const Duration(seconds: 10),
        );
      }
    }
    
    return Left(ServerFailure(message: 'Operation failed after $maxRetries attempts'));
  }
  
  /// Execute operation with timeout
  Future<Either<Failure, T>> withTimeout<T>(
    Future<T> Function() function,
    String operationName, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final result = await function().timeout(timeout);
      return Right(result);
    } catch (e) {
      if (e is TimeoutException) {
        _logger.e('Timeout in $operationName: $e');
        return Left(NetworkFailure(message: 'Operation timed out'));
      }
      
      // Handle other errors with safeCall
      return await safeCall<T>(() => throw e, operationName: operationName);
    }
  }
}

/// Extension to provide convenient methods for common operations
extension RepositoryExtensions on BaseRepository {
  /// Execute a GET request with error handling
  Future<Either<Failure, T>> get<T>(
    Future<T> Function() getFunction,
    String operationName,
  ) async {
    return safeCall<T>(getFunction, operationName: operationName);
  }
  
  /// Execute a POST request with error handling
  Future<Either<Failure, T>> post<T>(
    Future<T> Function() postFunction,
    String operationName,
  ) async {
    return safeCall<T>(postFunction, operationName: operationName);
  }
  
  /// Execute a PUT request with error handling
  Future<Either<Failure, T>> put<T>(
    Future<T> Function() putFunction,
    String operationName,
  ) async {
    return safeCall<T>(putFunction, operationName: operationName);
  }
  
  /// Execute a DELETE request with error handling
  Future<Either<Failure, T>> delete<T>(
    Future<T> Function() deleteFunction,
    String operationName,
  ) async {
    return safeCall<T>(deleteFunction, operationName: operationName);
  }
  
  /// Execute an upload operation with error handling
  Future<Either<Failure, T>> upload<T>(
    Future<T> Function() uploadFunction,
    String operationName,
  ) async {
    return withTimeout<T>(
      uploadFunction,
      operationName,
      timeout: const Duration(minutes: 5), // Longer timeout for uploads
    );
  }
}

// Hello I am Tamim