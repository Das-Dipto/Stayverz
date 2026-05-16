import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../controllers/reservation_controller.dart';
import '../repositories/reservation_repository_impl.dart';
import '../repositories/reservation_repository_interface.dart';

class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is registered (should be registered by NetworkBinding)
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before ListingBinding');
    }
    
    // Register repository
    Get.lazyPut<ReservationRepositoryInterface>(
      () => ReservationRepositoryImpl(),
      fenix: true,
    );
    
    // Register controller
    Get.lazyPut<ReservationController>(
      () => ReservationController(Get.find<ReservationRepositoryInterface>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim