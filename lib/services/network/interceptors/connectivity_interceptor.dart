import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../connectivity_service.dart';
import '../../../core/error/network_exceptions.dart';

/// Interceptor that adds connectivity headers to requests.
/// NOTE: This interceptor does NOT show UI popups - that's handled by ConnectivityListener.
/// NOTE: Retries are handled by ApiClient.request() - this prevents duplicate retry logic.
class ConnectivityInterceptor extends dio.Interceptor {
  final Logger _logger = Get.find<Logger>();
  final ConnectivityService _connectivityService = ConnectivityService.to;

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    // Just add connectivity info to headers - don't block requests here
    // The UI layer (ConnectivityListener) will handle showing no-internet UI
    options.headers['X-Connectivity-Status'] = _connectivityService.status.name;
    options.headers['X-Network-Type'] = _connectivityService.networkType.name;

    return handler.next(options);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async {


      print('================================');
  print('TYPE      : ${err.type}');
  print('MESSAGE   : ${err.message}');
  print('ERROR      : ${err.error}');
  print('STATUS     : ${err.response?.statusCode}');
  print('RESPONSE   : ${err.response?.data}');
  print('REQUEST URL: ${err.requestOptions.uri}');
  print('================================');


    // Convert to our custom exception
    final networkException = NetworkExceptionFactory.fromDioException(err);

    // Log the error
    _logger.e('Network Error: ${networkException.message}', error: networkException);

    // NOTE: We don't handle retries here anymore - ApiClient.request() handles retries
    // and queues GET requests for automatic retry when connection is restored.
    // This prevents duplicate retry logic and ensures proper queue management.
    
    // Just pass the error through - let ApiClient and UI layer handle it
    return handler.next(err);
  }

}

// Hello I am Tamim