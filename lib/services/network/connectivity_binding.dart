import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/connectivity_service.dart';
import 'package:stayverz_flutter_app/controllers/connectivity_controller.dart';

/// Connectivity binding for dependency injection
class ConnectivityBinding extends Bindings {
  @override
  void dependencies() {
    // Register connectivity service
    Get.put(ConnectivityService(), permanent: true);
    
    // Register connectivity controller
    Get.put(ConnectivityController(), permanent: true);
  }
}

// Hello I am Tamim