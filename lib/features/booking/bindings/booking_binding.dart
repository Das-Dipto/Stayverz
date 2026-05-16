import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:stayverz_flutter_app/features/booking/domain/repositories/booking_repository_interface.dart';
import '../controllers/booking_controller.dart';

class BookingBinding implements Bindings {
  @override
  void dependencies() {
    // Register repositories
    if (!Get.isRegistered<BookingRepositoryInterface>()) {
      Get.lazyPut<BookingRepositoryInterface>(
        () => BookingRepositoryImpl(),
        fenix: true,
      );
    }

    // Register controllers
    Get.lazyPut<BookingController>(
      () => BookingController(
        Get.find<BookingRepositoryInterface>(),
      ),
      fenix: true,
    );
  }
}

// Hello I am Tamim