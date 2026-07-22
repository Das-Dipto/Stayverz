import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import 'package:stayverz_flutter_app/services/cache/cache_manager.dart';
import '../models/runsys_status_model.dart';

/// Handles integration with the external Runsys system.
/// Uses a dedicated ApiClient (own base URL, own host) — kept separate
/// from AuthRepositoryInterface since this talks to a different backend.
class RunsysRepository {
  static const String _baseUrl = 'https://node-api.stayverz.com/api/v2';

  // No shared interceptors here — different host, different token-refresh
  // rules. We attach Authorization/x-user-id manually per request.
  final ApiClient _client = ApiClient(baseUrl: _baseUrl, useInterceptors: false);

  Future<RunsysStatusModel?> getIntegrationStatus(String userId) async {
    try {
      final token = await CacheManager.getToken;

      final response = await _client.get(
        '/runsys/status',
        options: Options(
          headers: {
            'x-user-id': userId,
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      print("This is integration result- ${response}");
      if (response.data is Map<String, dynamic>) {
        return RunsysStatusModel.fromJson(response.data as Map<String, dynamic>);
      }
      dev.log('⚠️ [RunsysRepository] Unexpected response shape: ${response.data}');
      return null;
    } catch (e, st) {
      dev.log('❌ [RunsysRepository] getIntegrationStatus failed', error: e, stackTrace: st);
      return null;
    }
  }

  // Reserved for later (manual trigger from Menu screen) — not called yet.
  Future<RunsysStatusModel?> createIntegrationBridge({
    required String companyName,
    required String email,
    required String phoneNumber,
    String? userId,
  }) async {
    try {
      final token = await CacheManager.getToken;

      final response = await _client.post(
        '/runsys/request',
        data: {
          'companyName': companyName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
        options: Options(
          headers: {
            if (userId != null) 'x-user-id': userId,
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return RunsysStatusModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e, st) {
      dev.log('❌ [RunsysRepository] createIntegrationBridge failed', error: e, stackTrace: st);
      return null;
    }
  }
}

// Hello I am Tamim