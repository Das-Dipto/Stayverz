import 'package:stayverz_flutter_app/services/network/api_client.dart';
import 'package:stayverz_flutter_app/services/network/api_response.dart';
import '../models/user_feedback_model.dart';
import 'user_feedback_repository_interface.dart';

class UserFeedbackRepository implements UserFeedbackRepositoryInterface {
  final ApiClient _apiClient;

  UserFeedbackRepository(this._apiClient);

  @override
  Future<ApiResponse<Map<String, dynamic>>> submitFeedback(UserFeedbackModel feedback) async {
    try {
      final response = await _apiClient.post(
        '/api/feedback/submit',
        data: feedback.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to submit feedback');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<List<String>>> getFeedbackCategories() async {
    try {
      final response = await _apiClient.get('/api/feedback/categories');
      
      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = response.data['categories'];
        final List<String> categories = categoriesJson.cast<String>();
        return ApiResponse.success(categories);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> canSubmitFeedback(String? userId) async {
    try {
      final response = await _apiClient.get(
        '/api/feedback/can-submit',
        queryParameters: userId != null ? {'user_id': userId} : null,
      );
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data['can_submit'] ?? true);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to check feedback status');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}

// Hello I am Tamim