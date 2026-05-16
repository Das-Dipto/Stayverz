import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/booking/controllers/instant_booking_controller.dart';

import '../data/repositories/booking_repository_impl.dart';
import '../domain/repositories/booking_repository_interface.dart';

class InstantBookingBinding extends Bindings {
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


    if (!Get.isRegistered<InstantBookingController>()) {
      Get.lazyPut<InstantBookingController>(
            () => InstantBookingController(
          repository: Get.find<BookingRepositoryInterface>(),
        ),
        fenix: true, // recreate controller if cleared
      );
    }

  }
}

// Hello I am Tamim