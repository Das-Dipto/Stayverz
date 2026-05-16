import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/services/network/connectivity_service.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/request_interceptor.dart';
import 'interceptors/response_interceptor.dart' as res_i;
import 'interceptors/token_refresh_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';

/// The type of content to be used in the request headers
enum ContentType {
  json,
  multipart,
  urlEncoded,
}

/// A powerful HTTP client for making API requests with built-in error handling,
/// logging, and request cancellation.
class ApiClient {
  static const Duration defaultTimeout = Duration(seconds: 120);
  static const int maxRetries = 3;
  
  late final Dio _dio;
  final String baseUrl;
  final Logger _logger = Get.find<Logger>();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final bool useInterceptors;
  final Map<String, CancelToken> _cancelTokens = {};

  /// Creates a new instance of [ApiClient] with default configuration.
  /// Uses the main API base URL.
  factory ApiClient.create() {
    return ApiClient(
      baseUrl: ApiRoutes.apiBaseURL,
      useInterceptors: true,
    );
  }

  /// Creates a new instance of [ApiClient] configured for the messaging API.
  factory ApiClient.forMessaging() {
    return ApiClient(
      baseUrl: ApiRoutes.messagingApiBaseURL,
      useInterceptors: true,
    );
  }

  /// Creates an ApiClient with the specified base URL.
  /// [baseUrl] must not be null.
  ApiClient({
    required String baseUrl,
    this.useInterceptors = true,
  }) : baseUrl = baseUrl {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: defaultTimeout,
        receiveTimeout: defaultTimeout,
        sendTimeout: defaultTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (useInterceptors) {
      // IMPORTANT: The order matters - TokenRefresh must be first to handle 401 errors!
      
      // Start fresh - clear all interceptors to ensure proper order
      _dio.interceptors.clear();

      // 1. TokenRefreshInterceptor first - MUST be first to catch 401 errors
      _dio.interceptors.add(TokenRefreshInterceptor(_dio));
      
      // 2. Request interceptor - adds headers
      _dio.interceptors.add(RequestInterceptor());
      
      // 3. Response formatter
      _dio.interceptors.add(res_i.ResponseInterceptor());
      
      // 4. Connectivity interceptor - handles no internet bottom sheet
      _dio.interceptors.add(ConnectivityInterceptor());
      
      // 5. Error handler (but NOT for 401 as those are handled by TokenRefreshInterceptor)
      _dio.interceptors.add(ErrorInterceptor());
      
      // 6. Logging
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
      
    }
  }

  /// Makes an HTTP request with retry logic and connectivity check
  /// 
  /// [path] The endpoint path
  /// [method] HTTP method (GET, POST, etc.)
  /// [data] Request body
  /// [queryParameters] Query parameters
  /// [options] Request options
  /// [cancelToken] Token to cancel the request
  /// [onSendProgress] Progress callback for sending data
  /// [onReceiveProgress] Progress callback for receiving data
  /// [retries] Number of retry attempts
  /// [contentType] Type of content for the request
  /// [waitForConnection] Whether to wait for connection if disconnected
  Future<dio.Response<T>> request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    int retries = maxRetries,
    ContentType contentType = ContentType.json,
    bool waitForConnection = false,
  }) async {
    final requestId = '${DateTime.now().millisecondsSinceEpoch}_$method';
    final token = cancelToken ?? CancelToken();
    _cancelTokens[requestId] = token;

    try {
      // Note: We don't block requests here anymore - let them go through
      // The UI layer (ConnectivityListener) handles showing no-internet UI
      // If truly offline, the request will fail naturally and be handled by error interceptors

      _logRequest(
        method: method,
        path: path,
        data: data,
        queryParameters: queryParameters,
        requestId: requestId,
      );

      final response = await _executeRequest<T>(
        path: path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        contentType: contentType,
      );

      _logResponse(response, requestId);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        _logger.w('Request $requestId was cancelled');
        rethrow;
      }

      // If it's a connectivity error and we should retry
      if (_isConnectivityError(e) && retries > 0) {
        _logger.w('Connectivity error for request $requestId, waiting and retrying... (${maxRetries - retries + 1}/$maxRetries)');
        
        // Wait for connection and retry
        if (await _connectivityService.waitForConnection(timeout: const Duration(seconds: 10))) {
          await Future.delayed(const Duration(seconds: 1));
          return request<T>(
            path,
            method: method,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            retries: retries - 1,
            contentType: contentType,
            waitForConnection: false, // Don't wait again
          );
        }
        
        // If still no connection after waiting, queue GET requests for later retry
        // POST/PUT/DELETE requests fail immediately as they're not safe to retry automatically
        if (method.toUpperCase() == 'GET' && _shouldQueueForRetry(e)) {
          _logger.i('Queueing GET request $requestId for retry when connection restored');
          return _connectivityService.queueRequest<T>(
            path: path,
            queryParameters: queryParameters,
            options: options,
          );
        }
      }

      // Standard retry logic for other errors
      if (retries > 0 && !_isConnectivityError(e)) {
        _logger.w('Retrying request $requestId (${maxRetries - retries + 1}/$maxRetries)');
        await Future.delayed(const Duration(seconds: 1));
        return request<T>(
          path,
          method: method,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          retries: retries - 1,
          contentType: contentType,
          waitForConnection: false, // Don't wait again
        );
      }

      _logError(e, requestId);
      rethrow;
    } finally {
      _cancelTokens.remove(requestId);
    }
  }

  /// Executes a single HTTP request
  Future<dio.Response<T>> _executeRequest<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required ContentType contentType,
  }) async {
    final headers = <String, dynamic>{
      ...?options?.headers,
      ..._getContentTypeHeader(contentType),
    };

    return await _dio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        headers: headers,
        responseType: options?.responseType,
        contentType: options?.contentType,
        extra: options?.extra,
        followRedirects: options?.followRedirects,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Gets the appropriate content type header
  Map<String, String> _getContentTypeHeader(ContentType type) {
    switch (type) {
      case ContentType.json:
        return {'Content-Type': 'application/json'};
      case ContentType.multipart:
        return {'Content-Type': 'multipart/form-data'};
      case ContentType.urlEncoded:
        return {'Content-Type': 'application/x-www-form-urlencoded'};
    }
  }

  /// Logs request details
  void _logRequest({
    required String method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required String requestId,
  }) {
    _logger.d(''"""
    🚀 [$requestId] $method $path
    Query Parameters: $queryParameters
    Data: $data
    """);
  }

  /// Logs response details
  void _logResponse(dio.Response response, String requestId) {
    _logger.d(''"""
    ✅ [$requestId] ${response.statusCode} ${response.statusMessage}
    Data: ${response.data}
    """);
  }

  /// Logs error details
  void _logError(DioException error, String requestId) {
    _logger.e(''"""
    ❌ [$requestId] ${error.type}
    Error: ${error.error}
    Response: ${error.response?.data}
    StackTrace: ${error.stackTrace}
    """);
  }

  /// Sends a GET request to the specified URL
  Future<dio.Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Sends a POST request to the specified URL
  Future<dio.Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ContentType contentType = ContentType.json,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      contentType: contentType,
    );
  }
  Future<dio.Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        ContentType contentType = ContentType.json,
      }) {
    return request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      contentType: contentType,
    );
  }
  /// Sends a PUT request to the specified URL
  Future<dio.Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ContentType contentType = ContentType.json,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      contentType: contentType,
    );
  }

  /// Sends a DELETE request to the specified URL
  Future<dio.Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
  
  /// Cancels a specific request by its ID
  void cancelRequest(String requestId) {
    _cancelTokens[requestId]?.cancel('Request cancelled by user');
    _cancelTokens.remove(requestId);
  }
  
  /// Cancels all pending requests
  void cancelAllRequests() {
    for (final entry in _cancelTokens.entries) {
      entry.value.cancel('All requests cancelled');
    }
    _cancelTokens.clear();
  }

  /// Uploads a single file to the server
  /// 
  /// [path] The endpoint path
  /// [filePath] Path to the file to upload
  /// [fileField] Field name for the file (default: 'file')
  /// [data] Additional form data
  /// [queryParameters] Query parameters
  /// [options] Request options
  /// [cancelToken] Token to cancel the request
  /// [onSendProgress] Progress callback
  Future<dio.Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fileField = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final fileName = filePath.split('/').last;
    final formData = dio.FormData.fromMap({
      ...?data,
      fileField: await dio.MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    return post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options ?? Options(contentType: 'multipart/form-data'),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      contentType: ContentType.multipart,
    );
  }

  /// Uploads multiple files to the server
  /// 
  /// [path] The endpoint path
  /// [filePaths] List of file paths to upload
  /// [fileField] Field name for the files (default: 'files')
  /// [data] Additional form data
  /// [queryParameters] Query parameters
  /// [options] Request options
  /// [cancelToken] Token to cancel the request
  /// [onSendProgress] Progress callback
  Future<dio.Response<T>> uploadMultipleFiles<T>(
    String path,
    List<String> filePaths, {
    String fileField = 'files',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final files = await Future.wait(
      filePaths.map((filePath) async {
        final fileName = filePath.split('/').last;
        return await dio.MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      }),
    );

    final formData = dio.FormData.fromMap({
      ...?data,
      fileField: files,
    });

    return post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options ?? Options(contentType: 'multipart/form-data'),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Downloads a file from the given URL and saves it to the specified path
  /// 
  /// [url] The URL of the file to download
  /// [savePath] The local path where the file should be saved
  /// [onReceiveProgress] Callback for download progress
  /// [cancelToken] Token to cancel the download
  /// [deleteOnError] Whether to delete the file if an error occurs
  Future<dio.Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
    } on DioException catch (error) {
      // Log error for debugging purposes
      
      // Delete partially downloaded file if requested
      if (deleteOnError && File(savePath).existsSync()) {
        await File(savePath).delete();
      }
      rethrow;
    }
  }

  /// Disposes the Dio client and cancels all pending requests
  void dispose() {
    cancelAllRequests();
    _dio.close();
  }

  /// Check connectivity - returns immediately without waiting
  Future<bool> _checkConnectivityAndWait(bool waitForConnection) async {
    
    // First check: immediate connectivity status
    if (_connectivityService.isConnected) {
      return true;
    }
    
    // If not waiting, return false immediately (block the request)
    if (!waitForConnection) {
      return false;
    }

    // Only wait if explicitly requested (but limited time)
    return await _connectivityService.waitForConnection(
      timeout: const Duration(seconds: 5), // Reduced timeout
    );
  }

  /// Check if request should be queued for retry
  /// Only queue if it's a definite connectivity error (not timeout after connection)
  bool _shouldQueueForRetry(DioException error) {
    // Only queue if we have no internet at all
    if (_connectivityService.isConnected) {
      return false; // We have connection, so error is something else (server error, etc.)
    }
    
    // Queue for definite connectivity errors
    return error.type == DioExceptionType.connectionError ||
           error.type == DioExceptionType.connectionTimeout ||
           (error.type == DioExceptionType.unknown && 
            error.error is SocketException);
  }

  /// Check if an error is related to connectivity
  bool _isConnectivityError(DioException error) {
    if (error.type == DioExceptionType.unknown) {
      final errorMessage = error.error?.toString().toLowerCase() ?? '';
      return errorMessage.contains('no internet') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          error.error is SocketException;
    }
    
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    return false;
  }

}

// Hello I am Tamim