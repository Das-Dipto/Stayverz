import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/chat_room_model.dart';

import '../../../../controllers/main_controller.dart';
import '../../../services/network/api_client.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/inbox_controller.dart';
import '../data/repositories/messaging_repository.dart';
import '../data/services/notification_service.dart';

/// Binding for messaging feature dependencies
class MessagingBinding extends Bindings {
  @override
  void dependencies() {
    // Note: WebSocketService, NotificationService, and MessagingRepository are now initialized globally in CoreBinding
    
    // Initialize chat init repository
    Get.lazyPut<ChatInitRepository>(
      () => ChatInitRepository(),
      fenix: true,
    );
    
    // Initialize inbox controller - CRITICAL: must be registered before ConversationController
    if (!Get.isRegistered<InboxController>()) {
      Get.put<InboxController>(InboxController(), permanent: true);
    }
  }
}

/// Binding specifically for conversation screen
class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure messaging dependencies are loaded
    if (!Get.isRegistered<MessagingRepository>()) {
      // Auto-load messaging binding if not already loaded
      MessagingBinding().dependencies();
    }

    // CRITICAL: Ensure InboxController is registered first (ConversationController depends on it)
    if (!Get.isRegistered<InboxController>()) {
      Get.put<InboxController>(InboxController(), permanent: true);
    }

    // Get route arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // Validate required arguments
    final conversationId = args['conversationId'] as String?;
    dynamic? receiver = args['receiver'];
    dynamic? sender = args['sender'];

    // Initialize the controller with the required parameters
    // Use put instead of lazyPut to ensure immediate initialization
    if (!Get.isRegistered<ConversationController>()) {
      Get.put<ConversationController>(
        ConversationController(
          repository: Get.find<MessagingRepository>(),
          notificationService: Get.find<NotificationService>(),
        ),
        permanent: true,
      );
    }
    
    final controller = Get.find<ConversationController>();

    // Set conversation parameters (FIXED: correct assignment - receiver and sender were swapped)
    controller.conversationId = conversationId ?? '';
    controller.receiver = receiver;  // FIXED: was incorrectly assigned to sender
    controller.sender = sender;        // FIXED: was incorrectly assigned to receiver
    
    // Initialize the conversation
    if (conversationId != null && conversationId.isNotEmpty) {
      controller.initializeConversation(conversationId);
    }
  }
  
  // Helper method to get auth token from MainController
  String? _getAuthToken() {
    try {
      // Get the auth token from the MainController
      if (Get.isRegistered<MainController>()) {
        final mainController = Get.find<MainController>();
        return mainController.accessToken.value;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting auth token: $e');
      }
      return null;
    }
  }
}

/// Binding for chat initiation features
class ChatInitBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is available
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before ChatInitBinding');
    }

    // Register ChatInitRepository if not already registered
    if (!Get.isRegistered<ChatInitRepository>()) {
      Get.lazyPut<ChatInitRepository>(
        () => ChatInitRepository(),
      );
    }
    
    // Ensure InboxController is registered
    if (!Get.isRegistered<InboxController>()) {
      Get.put<InboxController>(InboxController(), permanent: true);
    }
  }
}
