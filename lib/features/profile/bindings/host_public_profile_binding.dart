import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/profile/controllers/host_public_profile_controller.dart';
import 'package:stayverz_flutter_app/features/profile/repositories/host_public_profile_repository.dart';

class HostPublicProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostPublicProfileRepository>(
      () => HostPublicProfileRepositoryImpl(),
    );
    Get.lazyPut<HostPublicProfileController>(
      () => HostPublicProfileController(Get.find<HostPublicProfileRepository>()),
    );
  }
}