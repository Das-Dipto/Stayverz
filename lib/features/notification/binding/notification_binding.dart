import 'package:get/get.dart';



import '../presentation/controller/notification_controller.dart';
import '../repositories/notification_repository.dart';
import '../repositories/notification_repository_impl.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // Register repository implementation
    Get.lazyPut<NotificationRepository>(
          () => NotificationRepositoryImpl(),
    );

    // Register controller with repository
    Get.lazyPut<NotificationController>(
          () => NotificationController(
        repository: Get.find<NotificationRepository>(),
      ),
    );
  }
}
// Hello I am Tamim