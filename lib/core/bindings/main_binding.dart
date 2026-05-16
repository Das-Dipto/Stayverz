import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../../features/auth/repositories/auth_repository_interface.dart';
import 'core_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core dependencies first
    CoreBinding().dependencies();
    
    // Initialize MainController with AuthRepositoryInterface
    if (!Get.isRegistered<MainController>()) {
      Get.lazyPut<MainController>(
        () => MainController(
          authRepository: Get.find<AuthRepositoryInterface>(),
        ),
        fenix: true,
      );
    }
  }
}

// Hello I am Tamim