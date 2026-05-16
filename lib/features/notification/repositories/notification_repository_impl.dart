// features/notification/data/repository/notification_repository_impl.dart
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/notification/repositories/notification_repository.dart';

import '../../../../services/network/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../data/model.dart';


class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<NotificationResponse> getUserNotifications({
    required bool isApp,
    int pageSize = 10,
    int page = 1,
  }) async {
    try {

      final response = await _apiClient.get(
        ApiRoutes.getUserNotifications,
        queryParameters: {
          'is_app': isApp,
          'page_size': pageSize,
          'page': page,
        },
      );

      // Check if the response contains the expected data structure
      final responseData = response.data;
      if (responseData == null) {
        throw Exception('No response data received from server');
      }


      // Parse the response
      final notificationResponse = NotificationResponse.fromJson(responseData);

      return notificationResponse;

    } on dio.DioException catch (e) {

      // Let your ApiClient handle 401 errors with token refresh
      // Don't catch 401 here if your interceptor is handling it
      if (e.response?.statusCode == 401) {
        // Rethrow to let interceptor handle it
        rethrow;
      } else if (e.response?.statusCode == 404) {
        throw Exception('Notifications endpoint not found.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. Please check your permissions.');
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == dio.DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.type == dio.DioExceptionType.badResponse) {
        throw Exception('Server error: ${e.response?.statusCode}');
      }

      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

class TokenRefreshInterceptor extends Interceptor {
  static const _maxRetries = 3;
  static int _retryCount = 0;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {

      // Prevent infinite retry loop
      if (_retryCount >= _maxRetries) {
        _retryCount = 0;
        // Navigate to login or show error
        Get.offAllNamed('/login'); // Or however you handle logout
        return handler.reject(err);
      }

      _retryCount++;

      try {
        // Refresh token logic
        final newToken = await refreshToken();

        if (newToken != null) {
          // Reset retry count on success
          _retryCount = 0;

          // Retry the request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );

          return handler.resolve(response);
        } else {
          _retryCount = 0;
          return handler.reject(err);
        }
      } catch (e) {
        _retryCount = 0;
        return handler.reject(err);
      }
    } else {
      // Reset retry count for non-401 errors
      _retryCount = 0;
      return handler.next(err);
    }
  }

  Future<String?> refreshToken() async {
    // Your token refresh logic
    return null;
  }
}

// Hello I am Tamim