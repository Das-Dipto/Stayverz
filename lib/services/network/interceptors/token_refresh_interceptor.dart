import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:stayverz_flutter_app/controllers/main_controller.dart';
import 'package:stayverz_flutter_app/core/constants/app_routes.dart';

/// Interceptor that handles 401 Unauthorized errors by attempting to refresh the token
/// and retry the original request
/// Interceptor that handles 401 Unauthorized errors by attempting to refresh the token
/// This uses a more aggressive approach by intercepting responses directly
class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final _isRefreshing = false.obs;
  final _pendingRequests = <RequestOptions, Completer<Response>>{}; // Track pending requests during token refresh

  TokenRefreshInterceptor(this._dio) {
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if this is a 401 response and handle it directly
    if (response.statusCode == 401 || response.statusCode == 403) {
      
      // Check if response contains token expiration messages
      final data = response.data;
      bool isTokenExpired = false;
      
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString().toLowerCase() ?? '';
        isTokenExpired = message.contains('expired') || 
                         message.contains('invalid token') || message.contains('Forbidden') ||
                         message.contains('signature');
        
      }
      
      if (isTokenExpired) {
        // For responses, use the existing flow we have for error handling
        
        // Mark as refreshing to prevent multiple refresh attempts
        _isRefreshing.value = true;
        
        // Use Get.find to get the AuthController to handle token refresh
        final authController = Get.find<AuthController>();
        authController.refreshToken().then((success) {
          if (success) {
            // Retry the original request with new token
            _retryRequest(response.requestOptions).then((newResponse) {
              // Process queued requests and resolve this one
              _processQueuedRequests();
              handler.next(newResponse);
            }).catchError((error) {
              handler.next(response); // Fall back to original response on error
            });
          } else {
            // Logout and redirect
            authController.logOut();
            Get.offAllNamed(AppRoute.login);
            handler.next(response); // Continue with original response
          }
          _isRefreshing.value = false;
        }).catchError((e) {
          _isRefreshing.value = false;
          handler.next(response); // Continue with original response
        });
        return;
      }
    }
    
    // Allow normal responses to pass through
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Special debugging banner to make it obvious in logs
    
    final response = err.response;
    final options = err.requestOptions;
    
    // Check if error is due to token expiration (401 Unauthorized)
    if (response?.statusCode == 401) {
      
      // Look for specific message about token expiration
      final responseData = response?.data;
      bool isTokenExpired = false;
      
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message']?.toString() ?? '';
        isTokenExpired = message.toLowerCase().contains('expired') || 
                       message.toLowerCase().contains('invalid token') ||
                       message.toLowerCase().contains('signature');
        
      }
      
      // If there's already a refresh attempt in progress, queue this request
      if (_isRefreshing.value) {
        await _enqueueRequest(options, handler);
        return;
      }
      
      // Mark as refreshing to prevent multiple refresh attempts
      _isRefreshing.value = true;
      
      try {
        final authController = Get.find<AuthController>();
        final success = await authController.refreshToken();
        
        if (success) {
          
          // Retry the original request with new token
          final retryResponse = await _retryRequest(options);
          
          // Process any queued requests
          await _processQueuedRequests();
          
          // Return the successful response
          handler.resolve(retryResponse);
        } else {
          
          // Logout and redirect to login screen
          authController.logOut();
          Get.offAllNamed(AppRoute.login);
          
          // Continue with the original error
          handler.next(err);
        }
      } catch (e) {
        handler.next(err);
      } finally {
        _isRefreshing.value = false;
      }
    } else {
      // For non-401 errors, continue with normal error handling
      handler.next(err);
    }
  }
  
  /// Retry the original request with the new token
  Future<Response> _retryRequest(RequestOptions options) async {
    
    // Get the latest token from MainController
    final mainController = Get.find<MainController>();
    final newToken = mainController.accessToken.value;
    
    // Create a copy of the original headers
    final headers = Map<String, dynamic>.from(options.headers);
    
    // Update the Authorization header with the new token
    if (newToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $newToken';
    }
    
    final newRequestOptions = Options(
      method: options.method,
      headers: headers, // Use updated headers
      responseType: options.responseType,
      contentType: options.contentType,
      extra: options.extra,
      validateStatus: options.validateStatus,
      receiveDataWhenStatusError: options.receiveDataWhenStatusError,
    );

    return await _dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: newRequestOptions,
      cancelToken: options.cancelToken,
    );
  }
  
  /// Enqueue a request to be processed after token refresh
  Future<void> _enqueueRequest(RequestOptions options, ErrorInterceptorHandler handler) async {
    final completer = Completer<Response>();
    _pendingRequests[options] = completer;
    
    try {
      final response = await completer.future;
      handler.resolve(response);
    } catch (e) {
      handler.reject(DioException(
        requestOptions: options,
        error: e,
      ));
    }
  }
  
  /// Process all queued requests after a successful token refresh
  Future<void> _processQueuedRequests() async {
    for (final entry in _pendingRequests.entries) {
      final options = entry.key;
      final completer = entry.value;
      
      try {
        final response = await _retryRequest(options);
        completer.complete(response);
      } catch (e) {
        completer.completeError(e);
      }
    }
    
    _pendingRequests.clear();
  }
}

// Hello I am Tamim