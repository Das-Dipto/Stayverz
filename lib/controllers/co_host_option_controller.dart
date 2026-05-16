import 'package:get/get.dart';
import '../services/network/error_display_manager.dart';
import '../core/utils/main_utils.dart';

class CoHostController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  // Observable variables
  final RxString currentLocation = 'Fetching location...'.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // State management
  final RxBool showHosts = false.obs;
  final RxString selectedLocation = ''.obs;

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final locationData = await MainUtils.getCurrentLocation();
      
      if (locationData['success'] == true) {
        latitude.value = locationData['latitude'] ?? 0.0;
        longitude.value = locationData['longitude'] ?? 0.0;
        currentLocation.value = locationData['address'] ?? 'Location not available';
      } else {
        errorMessage.value = locationData['error'] ?? 'Failed to get location';
        currentLocation.value = 'Location not available';
        _errorDisplay.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      currentLocation.value = 'Error getting location';
      _errorDisplay.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Clear location data
  void clearLocation() {
    currentLocation.value = 'Location not set';
    latitude.value = 0.0;
    longitude.value = 0.0;
    errorMessage.value = '';
  }
  
  // Go back to location selection
  void goBackToLocation() {
    showHosts.value = false;
    selectedLocation.value = '';
  }
}

// Hello I am Tamim