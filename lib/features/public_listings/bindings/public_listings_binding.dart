import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/assistance_service/bindings/assistance_service_binding.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/repositories/public_listings_repository.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/repositories/public_listings_repository_impl.dart';
import 'package:stayverz_flutter_app/features/public_listings/domain/repositories/listing_filter_config_repository.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/repositories/listing_filter_config_repository_impl.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/controllers/public_listings_controller.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

class PublicListingsBinding extends Bindings {
  @override
  void dependencies() {
    // Check if ApiClient is already registered
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before PublicListingsBinding');
    }
    
    // Register the repositories
    Get.lazyPut<PublicListingsRepository>(
      () => PublicListingsRepositoryImpl(),
      fenix: true,
    );
    
    Get.lazyPut<ListingFilterConfigRepository>(
      () => ListingFilterConfigRepositoryImpl(),
      fenix: true,
    );
    
    // Register the controller
    Get.lazyPut<PublicListingsController>(
      () => PublicListingsController(
        Get.find<PublicListingsRepository>(),
        Get.find<ListingFilterConfigRepository>(),
      ),
      fenix: true,
    );

    AssistanceServiceBinding().dependencies();
  }
}

// Hello I am Tamim