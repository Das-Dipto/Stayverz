import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/blog/controllers/blog_controller.dart';
import 'package:stayverz_flutter_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:stayverz_flutter_app/features/blog/data/repositories/blog_repository_interface.dart';

class BlogBinding implements Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is registered
    if (!Get.isRegistered<BlogRepositoryInterface>()) {
      Get.lazyPut<BlogRepositoryInterface>(
        () => BlogRepositoryImpl(),
        fenix: true,
      );
    }

    // Register the controller
    Get.lazyPut<BlogController>(
      () => BlogController(
        Get.find<BlogRepositoryInterface>(),
      ),
      fenix: true,
    );
  }
}

// Hello I am Tamim