import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../services/network/error_display_manager.dart';
import '../../../services/network/api_client.dart';
import '../../../services/network/connectivity_service.dart';
import '../../../controllers/connectivity_controller.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../../features/auth/repositories/auth_repository_interface.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../features/booking/bindings/booking_binding.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/finance_report/bindings/finance_report_binding.dart';
import '../../features/reservation/bindings/reservation_binding.dart';
import '../../features/messaging/data/services/websocket_service.dart' as ws;
import '../../features/messaging/data/services/notification_service.dart';
import '../../features/messaging/data/repositories/messaging_repository.dart';

class CoreBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ErrorDisplayManager - singleton for centralized error display
    Get.put<ErrorDisplayManager>(
      ErrorDisplayManager(),
      permanent: true,
    );

    // Initialize Logger
    if (!Get.isRegistered<Logger>()) {
      Get.lazyPut<Logger>(
        () => Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 5,
            lineLength: 100,
            colors: true,
            printEmojis: true,
            printTime: false,
          ),
        ),
        fenix: true,
      );
    }

    // Initialize ConnectivityService - IMMEDIATE (not lazy) so it starts monitoring
    // Only create if not already registered to ensure singleton behavior
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put<ConnectivityService>(
        ConnectivityService(),
        permanent: true, // Keep alive throughout app lifecycle
      );
    }

    // Initialize ApiClient with default base URL
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(
        () => ApiClient.create(), // Uses connectivity-aware API client
        fenix: true,
      );
    }

    // Initialize ConnectivityController - IMMEDIATE (not lazy) so it starts listening
    // Only create if not already registered to ensure singleton behavior
    if (!Get.isRegistered<ConnectivityController>()) {
      Get.put<ConnectivityController>(
        ConnectivityController(),
        permanent: true, // Keep alive throughout app lifecycle
      );
    }

    // Initialize AuthRepository
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    // Register interface pointing to the concrete implementation
    if (!Get.isRegistered<AuthRepositoryInterface>()) {
      Get.lazyPut<AuthRepositoryInterface>(
        () => Get.find<AuthRepository>(),
        fenix: true,
      );
    }

    // Initialize AuthController
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(Get.find<AuthRepositoryInterface>()),
        fenix: true,
      );
    }

    // Initialize WebSocketService globally
    if (!Get.isRegistered<ws.WebSocketService>()) {
      Get.lazyPut<ws.WebSocketService>(
        () => ws.WebSocketService(),
        fenix: true, // Keep alive across route changes
      );
    }

    // Initialize NotificationService globally
    if (!Get.isRegistered<NotificationService>()) {
      Get.lazyPut<NotificationService>(
        () => NotificationService(),
        fenix: true, // Keep alive across route changes
      );
    }

    // Initialize MessagingRepository globally to ensure WebSocket event listeners are active
    if (!Get.isRegistered<MessagingRepository>()) {
      Get.lazyPut<MessagingRepository>(
        () => MessagingRepositoryImpl(),
        fenix: true, // Keep alive across route changes
      );
    }

    // Initialize Booking dependencies
    BookingBinding().dependencies();

    // Initialize Reservation dependencies
    ReservationBinding().dependencies();

    // Initialize Reservation dependencies
    FinanceReportBinding().dependencies();
    
    // Initialize Profile dependencies
    ProfileBinding().dependencies();
  }
}

// Hello I am Tamim