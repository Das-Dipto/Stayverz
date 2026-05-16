import 'dart:developer';

import 'package:dio/dio.dart';

/// Interceptor that handles successful responses and logs response data
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Log response data if it exists and is not too large
    if (response.data != null) {
      try {
        final data = response.data.toString();
        if (data.length < 1000) {
          // Truncate long responses
        } else {
        }
      } catch (e) {
      }
    }

    // Check for specific status codes that might need special handling
    if (response.statusCode == 204) {
      // No content
    }

    // Continue with the response
    return handler.next(response);
  }
}

// Hello I am Tamim