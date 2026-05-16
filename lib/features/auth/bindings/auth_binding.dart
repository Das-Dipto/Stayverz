import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:stayverz_flutter_app/features/auth/repositories/auth_repository_interface.dart';
import 'package:stayverz_flutter_app/features/auth/repositories/auth_repository.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient should already be registered by MainBinding
    assert(Get.isRegistered<ApiClient>(), 'ApiClient must be registered before AuthBinding');
    
    // Register the concrete implementation
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    // Register the interface pointing to the concrete implementation
    if (!Get.isRegistered<AuthRepositoryInterface>()) {
      Get.lazyPut<AuthRepositoryInterface>(
        () => Get.find<AuthRepository>(),
        fenix: true,
      );
    }
    
    // Initialize AuthController
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(Get.find<AuthRepositoryInterface>()),
        fenix: true,
      );
    }
  }
}

// Hello I am Tamim