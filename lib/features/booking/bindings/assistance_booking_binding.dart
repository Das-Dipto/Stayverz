import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:stayverz_flutter_app/features/booking/domain/repositories/booking_repository_interface.dart';
import '../controllers/assistance_booking_controller.dart';

class AssistanceBookingBinding implements Bindings {
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
    Get.lazyPut<AssistanceBookingController>(
      () => AssistanceBookingController(
        Get.find<BookingRepositoryInterface>(),
      ),
      fenix: true,
    );

    if (Get.isRegistered<AssistanceBookingController>()) {
      AssistanceBookingController c = Get.find<AssistanceBookingController>();
      c.setArgumentData();
    }

  }
}

// Hello I am Tamim