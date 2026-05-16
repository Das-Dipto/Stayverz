import 'package:get/get.dart';
import 'api_client.dart';
import '../../core/constants/api_routes.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ApiClient as a singleton if not already initialized
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(
        ApiClient.create(), // Uses the default API base URL
        permanent: true,
      );
    }
  }
}

/// Specialized binding for messaging API client
class MessagingNetworkBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize Messaging ApiClient as a singleton if not already initialized
    if (!Get.isRegistered<ApiClient>(tag: 'messaging')) {
      Get.put<ApiClient>(
        ApiClient.forMessaging(), // Uses the messaging API base URL
        tag: 'messaging',
        permanent: true,
      );
    }
  }
}

// Hello I am Tamim