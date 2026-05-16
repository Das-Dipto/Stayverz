import 'dart:developer';
import 'package:dio/dio.dart';

/// Interceptor that logs API errors.
/// UI error display is handled by ConnectivityListener using ConnectivityPopupManager.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Error UI is handled by ConnectivityPopupManager via ConnectivityListener
    // No snackbars here to avoid duplicate UI

    // Continue with the error
    return handler.next(err);
  }
}

// Hello I am Tamim