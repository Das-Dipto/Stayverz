import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../controllers/listing_controller.dart';
import '../controllers/listing_edit_controller.dart';
import '../repositories/listing_repository_impl.dart';
import '../repositories/listing_repository_interface.dart';

class ListingBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is registered (should be registered by NetworkBinding)
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before ListingBinding');
    }
    
    // Register repository
    Get.lazyPut<ListingRepositoryInterface>(
      () => ListingRepositoryImpl(),
      fenix: true,
    );


    // Register controller
    Get.lazyPut<ListingController>(
      () => ListingController(Get.find<ListingRepositoryInterface>()),
      fenix: true,
    );

    // Register controller
    Get.lazyPut<ListingEditController>(
          () => ListingEditController(Get.find<ListingRepositoryInterface>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim