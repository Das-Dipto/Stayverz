import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/booking/bindings/booking_binding.dart';

class TripBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize BookingBinding which will initialize BookingController
    BookingBinding().dependencies();
  }
}

// Hello I am Tamim