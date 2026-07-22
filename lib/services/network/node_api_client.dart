import 'package:dio/dio.dart' hide Response;
import 'package:dio/dio.dart' as dio show Response;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NodeApiClient {
  static const String baseUrl = 'https://node-api.stayverz.com/api/v2/';
  static const Duration _timeout = Duration(seconds: 30);

  late final Dio _dio;
  final Logger _logger = Get.find<Logger>();

  NodeApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<dio.Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required String userId,
  }) async {
    _logger.d('🌐 NodeAPI GET $path userId=$userId');
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: {'x-user-id': userId}),
    );
  }

  Future<dio.Response<T>> post<T>(
    String path, {
    dynamic data,
    required String userId,
  }) async {
    _logger.d('🌐 NodeAPI POST $path userId=$userId data=$data');
    return _dio.post<T>(
      path,
      data: data,
      options: Options(headers: {'x-user-id': userId}),
    );
  }
}