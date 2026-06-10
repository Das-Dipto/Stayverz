import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import 'package:logger/logger.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/quick_reply_message_response.dart';
import 'package:stayverz_flutter_app/main.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../services/network/api_client.dart';
import '../../../public_listings/data/models/archived_list_model.dart';
import '../models/archive_message_model.dart';
import '../models/chat_message_models.dart';
import '../models/created_quick_reply_message_response.dart';
import '../services/notification_service.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../models/websocket_models.dart' show WebSocketMessage, WebSocketStatus, ChatStatsModel;
import '../models/message_payload.dart';
import '../services/websocket_service.dart' as ws;
import 'package:dio/dio.dart' as dio;

abstract class MessagingRepository {
  // =======================
  // REST API methods
  // =======================

  Future<List<ChatRoomData>> getChatRooms();

  Future<List<QuickReplyData>> getAllQuickReply();

  Future<ArchivedChatListResponse?> getArchivedChatList({
    int page = 1,
    int limit = 20,
  });

  Future<CreatedReplyMessage?> createQuickReply({
    required String title,
    required String message,
  });

  Future<ArchiveChatResponse?> archiveChat({
    required String roomId,
    required bool archived,
  });

  Future<MessageModel> getConversationMessages(
      String conversationId, {
        int page = 1,
        int limit = 20,
      });

  /// 🔍 Search chat users / conversations
  Future<ChatListResponse> searchChatUsers(
      String query, {
        int page = 1,
        int limit = 20,
      });

  Future<void> sendMessage(
      String conversationId,
      String content,
      );

  Future<void> markMessageAsRead(
      String messageId,
      String conversationId,
      );

      Future<void> postFirstReply({
  required int listingId,
  required int hostId,
  required int guestId,
});

  // =======================
  // WebSocket stream getters
  // =======================

  Stream<Map<String, dynamic>> get chatStatsStream;
  Stream<Map<String, dynamic>> get globalEventStream;
  Stream<Map<String, dynamic>> get conversationEventStream;

  /// Get conversation stream for a specific conversation
  Stream<Map<String, dynamic>> getConversationStream();

  /// Current WebSocket connection status
  WebSocketStatus get connectionStatus;

  /// WebSocket connection status stream
  Stream<WebSocketStatus> get connectionStatusStream;

  // =======================
  // WebSocket methods
  // =======================

  Future<void> connectToMessaging(
      String authToken, {
        bool connectStats = true,
        bool connectGlobal = true,
      });

  Future<void> connectToConversation(String conversationId);

  void disconnectFromConversation(String conversationId);

  void disconnect();

  void sendTypingIndicator(
      String conversationId,
      bool isTyping,
      );
}


class MessagingRepositoryImpl implements MessagingRepository {
  final ApiClient _apiClient;
  final ws.WebSocketService _webSocketService;
  final NotificationService _notificationService;
  final _logger = Logger();

  // Track the current conversation ID for WebSocket subscriptions
  String? _currentConversationId;

  MessagingRepositoryImpl({
    ApiClient? apiClient,
    ws.WebSocketService? webSocketService,
    NotificationService? notificationService,
  }) : _apiClient = apiClient ?? Get.find<ApiClient>(),
       _webSocketService = webSocketService ?? Get.find<ws.WebSocketService>(),
       _notificationService = notificationService ?? Get.find<NotificationService>() {
    // Initialize notification service
    _notificationService.init();

    // Listen for notification clicks
    _notificationService.onNotificationClick.listen(_handleNotificationClick);

    // Listen for WebSocket events for notifications
    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    // Listen for global events for notifications
    _webSocketService.globalEventStream.listen(_handleGlobalEvent);
  }

  void _handleGlobalEvent(Map<String, dynamic> event) {
    if (event['action'] == 'message') {
      _handleNewMessageForNotification(event);
    }
  }

  void _handleNewMessageForNotification(Map<String, dynamic> message) {
    // try {
      final data = message;
      final conversationId = data['room']?['id'];
      final senderName = data['user']?['full_name'] ?? '';
      final content = data['message'] ?? '';
      final messageId = data['id'];
      final userId = data['user']?['user_id'];

      if (conversationId == null || messageId == null) {
        _logger.w('Received incomplete message for notification: $data');
        return;
      }


      // Show notification if not in the current conversation
      if (!_isCurrentConversation(conversationId) && (mainControl.userId.value != "$userId")) {
        _notificationService.showMessageNotification(
          title: senderName ?? 'New Message',
          body: content ?? 'You have a new message',
          payload: MessagePayload(
            conversationId: conversationId,
            messageId: "$messageId",
            senderId: data['sender_id']?.toString() ?? 'unknown',
            title: senderName ?? 'New Message',
            body: content ?? '',
          ),
        );
      }
    // } catch (e) {
    //   _logger.e(
    //     'Error handling new message for notification',
    //     error: e,
    //     stackTrace: StackTrace.current,
    //   );
    // }
  }

  Future<void> postFirstReply({
  required int listingId,
  required int hostId,
  required int guestId,
}) async {
  try {
    final response = await _apiClient.post(
      'https://node-api.stayverz.com/api/v2/response/first-reply',
      data: {
        'listing_id': listingId,
        'host_id': hostId,
        'guest_id': guestId,
      },
    );
    print('✅ firstReply response: ${response.data}');
  } catch (e) {
    print('❌ firstReply error: $e');
    // silently fail
  }
}

  void _handleNotificationClick(MessagePayload payload) {
    try {
      // Navigate to the conversation
      Get.toNamed(
        '/conversation',
        arguments: {
          'conversationId': payload.conversationId,
          'messageId': payload.messageId,
        },
      );
    } catch (e) {
      _logger.e(
        'Error handling notification click',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }

  // REST API implementations

  @override
  Future<ChatListResponse> searchChatUsers(
      String query, {
        int page = 1,
        int limit = 20,
      }) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.messagingBaseURL}/api/v1/chat/user/search/',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return ChatListResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch chat list: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        'searchChatUsers error',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }


  @override
  Future<ArchivedChatListResponse?> getArchivedChatList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.archivedChatList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        return ArchivedChatListResponse.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Failed to load archived chats',
      );
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred');
    }
  }

  // 🔹 ARCHIVE / UNARCHIVE CHAT


  @override
  Future<List<ChatRoomData>> getChatRooms() async {
    try {
      final response = await _apiClient.get(ApiRoutes.chatUserRooms);

      if (response.statusCode == 200 && response.data != null) {
        var result = ChatRoomModel.fromJson(response.data);
        return result.data ?? [];
      } else {
        // Handle empty or invalid response
        return [];
      }
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to load chat rooms');
      rethrow;
    }
  }

  @override
  Future<MessageModel> getConversationMessages(
    String conversationId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.chatUserRoomMessages(conversationId),
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Handle both paginated and non-paginated responses
        final responseData = response.data;
        return MessageModel.fromJson(responseData);
      } else {
        throw Exception(
          'Failed to fetch conversation messages: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error in getConversationMessages for conversation: $conversationId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      // Try WebSocket first for real-time delivery
      _webSocketService.sendMessage(
        message: {
          "action": "message",
          "message": content
        },
        conversationId: conversationId,
      );
    } catch (e) {
      // WebSocket failed, fallback to HTTP API
      if (kDebugMode) {
        _logger.w('WebSocket send failed, falling back to HTTP API: $e');
      }
      
      try {
        final response = await _apiClient.post(
          '${ApiRoutes.chatUserRoomMessages(conversationId)}messages/',
          data: {
            'content': content,
            'm_type': 'normal',
          },
        );
        
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to send message: ${response.statusCode}');
        }
      } catch (httpError) {
        _logger.e(
          'Error sending message via HTTP fallback',
          error: httpError,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }
    }
  }

  @override
  Future<void> markMessageAsRead(
    String messageId,
    String conversationId,
  ) async {
    try {
      // Send read receipt via WebSocket with the required format
      _webSocketService.sendMessage(
        message: {
          'action': 'is_read',
          'status': true,
          'conversationId': conversationId,
          'message_id': messageId,
        },
        conversationId: conversationId,
      );

      _logger.i(
        'Sent read receipt for message $messageId in conversation $conversationId',
      );
    } catch (e) {
      _logger.e(
        'Error sending read receipt',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  // WebSocket stream getters
  @override
  Future<ArchiveChatResponse?> archiveChat({
    required String roomId,
    required bool archived,
  }) async {
    try {
      final payload = {
        "archived": archived,
      };

      final response = await _apiClient.post(
        '${ApiRoutes.archiveChat}/$roomId/',
        data: payload,

      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return ArchiveChatResponse.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Archive chat failed',
      );
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred');
    }
  }
  // WebSocket stream getters

  @override
  Stream<Map<String, dynamic>> get chatStatsStream => _webSocketService.chatStatsStream;

  @override
  Stream<Map<String, dynamic>> get globalEventStream => _webSocketService.globalEventStream;

  @override
  Stream<Map<String, dynamic>> get conversationEventStream =>
      _webSocketService.conversationStream;

  @override
  Stream<Map<String, dynamic>> getConversationStream() {
    return _webSocketService.conversationStream;
  }

  @override
  WebSocketStatus get connectionStatus => _webSocketService.currentStatus;

  @override
  Stream<WebSocketStatus> get connectionStatusStream => _webSocketService.connectionStatus;

  @override
  Future<void> connectToMessaging(
    String authToken, {
    bool connectStats = true,
    bool connectGlobal = true,
  }) async {
    await _webSocketService.initialize(
      authToken,
      connectStats: connectStats,
      connectGlobal: connectGlobal,
    );
  }

  @override
  Future<void> connectToConversation(String conversationId) async {
    _currentConversationId = conversationId;
    await _webSocketService.connectToConversation(conversationId);
  }

  @override
  void disconnectFromConversation(String conversationId) {
    if (_currentConversationId == conversationId) {
      _currentConversationId = null;
    }
    _webSocketService.disconnectFromConversation(conversationId);
  }

  @override
  void disconnect() {
    _webSocketService.disconnect();
  }

  @override
  void sendTypingIndicator(String conversationId, bool isTyping) {
    try {
      _webSocketService.sendMessage(
        message: {
          'type': 'typing',
          'is_typing': isTyping,
          'conversation_id': conversationId,
        },
        conversationId: conversationId,
      );

    } catch (e) {
      _logger.e(
        'Error sending typing indicator',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  bool _isCurrentConversation(String conversationId) {
    return _currentConversationId == conversationId;
  }

  @override
  Future<List<QuickReplyData>> getAllQuickReply() async {
    try {
      final response = await _apiClient.get(ApiRoutes.quickReply);

      if (response.statusCode == 200 && response.data != null) {
        var result = QuickReplyMessageResponse.fromJson(response.data);
        return result.data ?? [];
      } else {
        // Handle empty or invalid response
        return [];
      }
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to load chat rooms');
      rethrow;
    }
  }

  @override
  Future<CreatedReplyMessage?> createQuickReply({required String title, required String message}) async {
    try {
      final payload = {
        "title": title,
        "description": message
      };

      final response = await _apiClient.post(
        ApiRoutes.quickReply,
        data: payload,
      );

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data;
        return CreateQuickReplyMessageResponse.fromJson(data).data;
      } else {
        return null;
      }
    } on dio.DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e, stackTrace) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}

/// Repository for starting new chats and managing chat initiation
class ChatInitRepository {
  final ApiClient _apiClient;

  ChatInitRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  /// Start a new chat with inquiry status
  Future<ChatRoomModel> startInquiryChat({
    required String receiverId,
    required String receiverName,
    required String propertyId,
    String? initialMessage,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/user/start/',
        data: {
          'receiver_id': receiverId,
          'receiver_name': receiverName,
          'property_id': propertyId,
          'status': 'inquiry',
          'initial_message': initialMessage,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return ChatRoomModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to start inquiry chat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting inquiry chat: $e');
    }
  }

  /// Start a confirmed booking chat
  Future<ChatRoomModel> startConfirmedChat({
    required String receiverId,
    required String receiverName,
    required String propertyId,
    required String bookingId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/user/start/',
        data: {
          'receiver_id': receiverId,
          'receiver_name': receiverName,
          'property_id': propertyId,
          'booking_id': bookingId,
          'status': 'confirmed',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return ChatRoomModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to start confirmed chat: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error starting confirmed chat: $e');
    }
  }



}

// Hello I am Tamim