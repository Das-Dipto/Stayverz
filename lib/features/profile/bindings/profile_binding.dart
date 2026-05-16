import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/repositories/listing_repository_impl.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../controllers/profile_controller.dart';
import '../../listing/controllers/listing_controller.dart';
import '../../listing/repositories/listing_repository_interface.dart';
import '../repositories/profile_repository_impl.dart';
import '../repositories/profile_repository_interface.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // ApiClient is already registered by MainBinding, so we can use it directly
    assert(
      Get.isRegistered<ApiClient>(),
      'ApiClient must be registered before ProfileBinding',
    );

    // Register the repository
    Get.lazyPut<ProfileRepositoryInterface>(
      () => ProfileRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut<ListingRepositoryInterface>(
          () => ListingRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut<ListingController>(
          () => ListingController(Get.find<ListingRepositoryInterface>()),
      fenix: true,
    );

    // Register the controller with its dependencies
    Get.lazyPut<ProfileController>(
      () =>
          ProfileController(repository: Get.find<ProfileRepositoryInterface>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim