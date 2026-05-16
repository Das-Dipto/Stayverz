import 'package:stayverz_flutter_app/services/network/api_response.dart';
import '../models/user_feedback_model.dart';

abstract class UserFeedbackRepositoryInterface {
  /// Submits user feedback to the server
  Future<ApiResponse<Map<String, dynamic>>> submitFeedback(UserFeedbackModel feedback);
  
  /// Gets available feedback categories
  Future<ApiResponse<List<String>>> getFeedbackCategories();
  
  /// Checks if user has already submitted feedback recently
  Future<ApiResponse<bool>> canSubmitFeedback(String? userId);
}

// Hello I am Tamim