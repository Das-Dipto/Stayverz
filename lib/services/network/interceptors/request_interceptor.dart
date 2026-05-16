import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../cache/cache_manager.dart';

/// Interceptor that adds authentication token and other headers to requests

class RequestInterceptor extends Interceptor {
  // final MainController _mainController = Get.find<MainController>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token
    final token = await CacheManager.getToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Add device ID or other identifiers if needed
    // if (await CacheManager.getUserId() != null) {
    //   options.headers['X-User-ID'] = await CacheManager.getUserId();
    // }


    // Log request details
    if (options.data != null) {
    }
    if (options.queryParameters.isNotEmpty) {
    }

    return handler.next(options);
  }
}

// Hello I am Tamim