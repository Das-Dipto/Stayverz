import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/user_feedback/controllers/user_feedback_controller.dart';
import 'package:stayverz_flutter_app/features/user_feedback/repositories/user_feedback_repository_interface.dart';
import 'package:stayverz_flutter_app/features/user_feedback/repositories/user_feedback_repository_impl.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

import '../controllers/app_feed_back.dart';

class UserFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient exists
    assert(
    Get.isRegistered<ApiClient>(),
    'ApiClient must be registered before UserFeedbackBinding',
    );

    /// =========================
    /// UI Controller (Screen)
    /// =========================
    Get.lazyPut<UserFeedbackControllerStyab>(
          () => UserFeedbackControllerStyab(),
      fenix: true,
    );

    /// =========================
    /// Repository Layer
    /// =========================
    if (!Get.isRegistered<UserFeedbackRepository>()) {
      Get.lazyPut<UserFeedbackRepository>(
            () => UserFeedbackRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<UserFeedbackRepositoryInterface>()) {
      Get.lazyPut<UserFeedbackRepositoryInterface>(
            () => Get.find<UserFeedbackRepository>(),
        fenix: true,
      );
    }

    /// =========================
    /// Domain / Logic Controller
    /// =========================
    if (!Get.isRegistered<UserFeedbackController>()) {
      Get.lazyPut<UserFeedbackController>(
            () => UserFeedbackController(
          Get.find<UserFeedbackRepositoryInterface>(),
        ),
        fenix: true,
      );
    }
  }
}


// Hello I am Tamim