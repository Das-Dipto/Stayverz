import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../controllers/public_assistance_service_controller.dart';
import '../repositories/assistance_service_repository_impl.dart';
import '../repositories/assistance_service_repository_interface.dart';

class PublicAssistanceServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is registered (should be registered by NetworkBinding)
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before ListingBinding');
    }
    
    // Register repository
    Get.lazyPut<AssistanceServiceRepositoryInterface>(
      () => AssistanceServiceRepositoryImpl(),
      fenix: true,
    );


    // Register controller

    Get.lazyPut<PublicAssistanceServiceController>(
      () => PublicAssistanceServiceController(Get.find<AssistanceServiceRepositoryInterface>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim