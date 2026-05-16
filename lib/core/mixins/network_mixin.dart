import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../error/network_exceptions.dart';
import '../../services/network/connectivity_service.dart';
import '../../widgets/network_error_dialog.dart';

/// Mixin that provides network handling capabilities to controllers
mixin NetworkMixin on GetxController {
  /// Show loading state
  final RxBool _isLoading = false.obs;
  final RxString _loadingMessage = ''.obs;
  
  /// Error handling
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<NetworkException?> _networkException = Rx<NetworkException?>(null);
  
  /// Getters
  bool get isLoading => _isLoading.value;
  String get loadingMessage => _loadingMessage.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  NetworkException? get networkException => _networkException.value;
  
  /// Execute a network operation with loading state
  /// 
  /// [operation] - The network operation to execute
  /// [loadingMessage] - Message to show during loading
  /// [showErrorDialog] - Whether to show error dialog on failure
  /// [onSuccess] - Callback for successful operation
  /// [onError] - Callback for failed operation
  /// [retryOperation] - Optional retry operation for error dialog
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    String loadingMessage = 'Loading...',
    bool showErrorDialog = true,
    VoidCallback? onSuccess,
    VoidFunction1<Failure>? onError,
    Future<T> Function()? retryOperation,
  }) async {
    try {
      // Show loading state
      _setLoading(true, loadingMessage);
      _clearError();
      
      // Execute operation
      final result = await operation();
      
      // Handle success
      _setLoading(false, '');
      onSuccess?.call();
      
      return result;
      
    } on NetworkException catch (e) {
      // Handle network error
      _setLoading(false, '');
      _setError(e);
      
      if (showErrorDialog) {
        await NetworkErrorDialogs.show(
          e,
          onRetry: retryOperation != null ? () => executeWithLoading(
            retryOperation,
            loadingMessage: loadingMessage,
            showErrorDialog: showErrorDialog,
            onSuccess: onSuccess,
            onError: onError,
            retryOperation: retryOperation,
          ) : null,
        );
      }
      
      onError?.call(_mapExceptionToFailure(e));
      return null;
      
    } catch (e) {
      // Handle other errors
      _setLoading(false, '');
      final failure = ServerFailure(message: e.toString());
      _setError(failure);
      
      if (showErrorDialog) {
        await NetworkErrorDialogs.showGenericError(
          message: e.toString(),
          onRetry: retryOperation != null ? () => executeWithLoading(
            retryOperation,
            loadingMessage: loadingMessage,
            showErrorDialog: showErrorDialog,
            onSuccess: onSuccess,
            onError: onError,
            retryOperation: retryOperation,
          ) : null,
        );
      }
      
      onError?.call(failure);
      return null;
    }
  }
  
  /// Execute a network operation that returns Either
  /// 
  /// [operation] - The network operation to execute
  /// [loadingMessage] - Message to show during loading
  /// [showErrorDialog] - Whether to show error dialog on failure
  /// [onSuccess] - Callback for successful operation
  /// [onError] - Callback for failed operation
  /// [retryOperation] - Optional retry operation for error dialog
  Future<T?> executeEitherWithLoading<T>(
    Future<Either<Failure, T>> Function() operation, {
    String loadingMessage = 'Loading...',
    bool showErrorDialog = true,
    VoidFunction1<T>? onSuccess,
    VoidFunction1<Failure>? onError,
    Future<Either<Failure, T>> Function()? retryOperation,
  }) async {
    try {
      // Show loading state
      _setLoading(true, loadingMessage);
      _clearError();
      
      // Execute operation
      final result = await operation();
      
      // Handle result
      _setLoading(false, '');
      
      return result.fold(
        (failure) {
          _setError(failure);
          if (showErrorDialog) {
            NetworkErrorDialogs.showGenericError(
              message: failure.message,
              onRetry: retryOperation != null ? () => executeEitherWithLoading(
                retryOperation,
                loadingMessage: loadingMessage,
                showErrorDialog: showErrorDialog,
                onSuccess: onSuccess,
                onError: onError,
                retryOperation: retryOperation,
              ) : null,
            );
          }
          onError?.call(failure);
          return null;
        },
        (data) {
          onSuccess?.call(data);
          return data;
        },
      );
      
    } catch (e) {
      // Handle unexpected errors
      _setLoading(false, '');
      final failure = ServerFailure(message: e.toString());
      _setError(failure);
      
      if (showErrorDialog) {
        await NetworkErrorDialogs.showGenericError(
          message: e.toString(),
          onRetry: retryOperation != null ? () => executeEitherWithLoading(
            retryOperation,
            loadingMessage: loadingMessage,
            showErrorDialog: showErrorDialog,
            onSuccess: onSuccess,
            onError: onError,
            retryOperation: retryOperation,
          ) : null,
        );
      }
      
      onError?.call(failure);
      return null;
    }
  }
  
  /// Check internet connection before executing operation
  /// 
  /// [operation] - The operation to execute
  /// [timeout] - Timeout for waiting for connection
  /// [onNoConnection] - Callback when no connection is available
  Future<T?> executeWithConnectionCheck<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 15),
    VoidCallback? onNoConnection,
  }) async {
    if (!ConnectivityService.to.hasInternet) {
      final hasConnection = await ConnectivityService.to.waitForConnection(
        timeout: timeout,
      );
      
      if (!hasConnection) {
        onNoConnection?.call();
        await NetworkErrorDialogs.showNoInternet();
        return null;
      }
    }
    
    try {
      return await operation();
    } on NetworkException catch (e) {
      _setError(e);
      await NetworkErrorDialogs.show(e);
      return null;
    }
  }
  
  /// Retry a failed operation
  /// 
  /// [operation] - The operation to retry
  /// [maxRetries] - Maximum number of retry attempts
  /// [delay] - Delay between retries
  /// [onSuccess] - Callback for successful retry
  /// [onFailed] - Callback when all retries fail
  Future<T?> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    VoidFunction1<T>? onSuccess,
    VoidCallback? onFailed,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      attempts++;
      
      try {
        // Check connectivity before retry
        if (!ConnectivityService.to.hasInternet) {
          await ConnectivityService.to.waitForConnection(
            timeout: const Duration(seconds: 10),
          );
        }
        
        final result = await operation();
        onSuccess?.call(result);
        return result;
        
      } catch (e) {
        if (attempts >= maxRetries) {
          onFailed?.call();
          rethrow;
        }
        
        // Wait before retrying
        await Future.delayed(delay * attempts);
      }
    }
    
    return null;
  }
  
  /// Set loading state
  void _setLoading(bool loading, String message) {
    _isLoading.value = loading;
    _loadingMessage.value = message;
  }
  
  /// Set error state
  void _setError(dynamic error) {
    _hasError.value = true;
    
    if (error is NetworkException) {
      _errorMessage.value = error.message;
      _networkException.value = error;
    } else if (error is Failure) {
      _errorMessage.value = error.message;
      _networkException.value = null;
    } else {
      _errorMessage.value = error.toString();
      _networkException.value = null;
    }
  }
  
  /// Clear error state
  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
    _networkException.value = null;
  }
  
  /// Map NetworkException to Failure
  Failure _mapExceptionToFailure(NetworkException exception) {
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
  
  /// Clear all states
  void clearStates() {
    _setLoading(false, '');
    _clearError();
  }
  
  @override
  void onClose() {
    clearStates();
    super.onClose();
  }
}

/// Extension for VoidCallback to support parameters
typedef VoidFunction1<T> = void Function(T);

// Hello I am Tamim