import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:stayverz_flutter_app/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stayverz_flutter_app/features/wishlist/presentation/controllers/wishlist_controller.dart';

class WishlistBinding implements Bindings {
  @override
  void dependencies() {
    // Register repositories
    if (!Get.isRegistered<WishlistRepository>()) {
      Get.lazyPut<WishlistRepository>(
        () => WishlistRepositoryImpl(),
        fenix: true,
      );
    }

    // Register controller
    Get.lazyPut<WishlistController>(
      () => WishlistController(repository: Get.find<WishlistRepository>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim