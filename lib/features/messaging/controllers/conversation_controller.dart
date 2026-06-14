import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import 'package:stayverz_flutter_app/features/messaging/controllers/inbox_controller.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/chat_room_model.dart';
import 'package:stayverz_flutter_app/main.dart';
import 'package:stayverz_flutter_app/services/cache/cache_manager.dart';
import '../../listing/models/listing_model.dart';
import '../data/models/message_model.dart';
import '../data/models/message_model.dart' as mssg;
import '../data/models/websocket_models.dart';
import '../data/models/message_payload.dart';
import '../data/repositories/messaging_repository.dart';
import '../data/services/notification_service.dart';


/// Controller for managing individual conversation messages and real-time events
class ConversationController extends GetxController with WidgetsBindingObserver {
  final MessagingRepository _repository;
  final NotificationService _notificationService;
  StreamSubscription<MessagePayload>? _notificationSubscription;

  ConversationController({
    MessagingRepository? repository,
    NotificationService? notificationService,
  }) : _repository = repository ?? Get.find<MessagingRepository>(),
       _notificationService =
           notificationService ?? Get.find<NotificationService>();

  // Required conversation parameters - initialized in initializeConversation()
  String conversationId = '';

  late dynamic? receiver;
  late dynamic? sender;

  // Connection state
  final _isConnected = false.obs;
  bool get isConnected => _isConnected.value;

  // Reactive state
  final _isLoading = false.obs,
      _isLoadingMore = false.obs,
      _isSending = false.obs,
      _isSharingProperty = false.obs;
  final _messages = <MessageData>[].obs;
  final _extraData = mssg.ExtraData().obs;
  final _isParticipantOnline = false.obs, _isParticipantTyping = false.obs;
  final _typingUsers = <String, String>{}.obs, _errorMessage = RxnString();
  final _recommendedPropertyId = Rx<int?>(null),
      _recommendedPropertyData = Rx<ListingModel?>(null);
  final RxInt _unreadCount = 0.obs;

  // Emoji picker state
  final _isEmojiPickerVisible = false.obs;
  final FocusNode focusNode = FocusNode();

  // State management
  int _currentPage = 1;
  bool _hasMoreMessages = true, _isUserTyping = false;
  Timer? _typingTimer;
  Timer? _messageSyncTimer; // For periodic sync fallback
  StreamSubscription<Map<String, dynamic>>? _conversationSubscription;
  StreamSubscription<Map<String, dynamic>>? _globalEventSubscription;
  final messageController = TextEditingController(),
      scrollController = ScrollController();

  // Static counter for unique temp message IDs
  static int _tempIdCounter = 0;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isSending => _isSending.value;
  List<MessageData> get messages => _messages;
  Rx<mssg.ExtraData> get extraData => _extraData;
  bool get isParticipantOnline => _isParticipantOnline.value;
  bool get isParticipantTyping => _isParticipantTyping.value;
  Map<String, String> get typingUsers => _typingUsers;
  String? get errorMessage => _errorMessage.value;
  bool get hasMoreMessages => _hasMoreMessages;
  RxBool canSendMessage = RxBool(false);
  String get currentUserId => mainControl.userId.value;
  String? get currentUserProfileImage => null;
  int? get recommendedPropertyId => _recommendedPropertyId.value;
  ListingModel? get recommendedPropertyData => _recommendedPropertyData.value;
  RxBool isReloadThisConv = RxBool(false);

  // Emoji picker getters
  bool get isEmojiPickerVisible => _isEmojiPickerVisible.value;

  // Additional getters for UI compatibility
  RxBool get isUserOnline => _isParticipantOnline;
  RxBool get isTyping => _isParticipantTyping;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _setupScrollListener();
    _setupNotificationListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reconnect to WebSocket when the app is resumed
      _connectToWebSocket();
    }
  }

  /// Start periodic message sync as fallback when WebSocket is unstable
  void _startPeriodicSync() {
    _messageSyncTimer?.cancel();
    _messageSyncTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (conversationId.isNotEmpty && !_isLoading.value) {
        _syncMessages();
      }
    });
  }

  /// Sync messages from API - lightweight check for new messages
  Future<void> _syncMessages() async {
    if (conversationId.isEmpty || _isLoading.value) return;
    try {
      final lastMessage = _messages.isNotEmpty ? _messages.last : null;
      final newMessages = await _repository.getConversationMessages(
        conversationId,
        page: 1,
        limit: 20,
      );
      
      final List<MessageData> newData = newMessages.data ?? [];
      if (newData.isNotEmpty) {
        // Check if we have new messages
        final existingIds = _messages.map((m) => m.id).toSet();
        final actuallyNew = <MessageData>[];
        final tempMessagesToRemove = <String>[];

        for (final m in newData) {
          // Skip if ID already exists
          if (existingIds.contains(m.id)) continue;

          // Check if this matches a temp message we sent - if so, replace it
          final senderId = m.user?.userId?.toString();
          final content = m.content;

          if (senderId == currentUserId && content != null) {
            for (final existing in _messages) {
              if (existing.id?.startsWith('temp_') == true &&
                  existing.content == content &&
                  existing.user?.userId?.toString() == currentUserId) {
                tempMessagesToRemove.add(existing.id!);
                if (kDebugMode) {
                  print('[ConversationController] Will replace temp ${existing.id} with real ${m.id}');
                }
                break;
              }
            }
          }

          actuallyNew.add(m);
        }

        // Remove temp messages that are being replaced
        if (tempMessagesToRemove.isNotEmpty) {
          _messages.removeWhere((m) => tempMessagesToRemove.contains(m.id));
        }

        if (actuallyNew.isNotEmpty) {
          if (kDebugMode) {
            print('[ConversationController] Sync found ${actuallyNew.length} new messages');
          }
          _messages.addAll(actuallyNew);
          _markMessagesAsRead();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ConversationController] Sync error: $e');
      }
    }
  }

  /// Toggle emoji picker visibility and manage keyboard focus
  void toggleEmojiPicker() {
    if (_isEmojiPickerVisible.value) {
      _isEmojiPickerVisible.value = false;
      Future.delayed(const Duration(milliseconds: 100), () {
        focusNode.requestFocus();
      });
    } else {
      focusNode.unfocus();
      _isEmojiPickerVisible.value = true;
    }
  }

  /// Hide emoji picker and show keyboard when text field is tapped
  void onTextFieldTap() {
    if (_isEmojiPickerVisible.value) {
      _isEmojiPickerVisible.value = false;
    }
  }

  /// Initialize conversation with proper error handling and reactive state
  Future<void> initializeConversation(String conversationId) async {
    _isLoading.value = true;
    _errorMessage.value = null;
    this.conversationId = conversationId;
    _startPeriodicSync(); // ← ADD THIS LINE HERE
    
    // Ensure InboxController has a healthy connection
    if (Get.isRegistered<InboxController>()) {
      final inboxController = Get.find<InboxController>();
      await inboxController.ensureConnectionHealth();
    }
    
    await loadMessages();
    await _connectToWebSocket();
    await _markMessagesAsRead();
    _isLoading.value = false;
  }

  /// Retry loading messages with proper error handling
  Future<void> retryLoadMessages() async {
    if (conversationId.isNotEmpty) {
      await initializeConversation(conversationId);
    }
  }

  set recommendedPropertyId(int? id) => _recommendedPropertyId.value = id;
  set recommendedPropertyData(ListingModel? id) =>
      _recommendedPropertyData.value = id;

  /// Setup global event subscription with defensive checks for InboxController
  void _setupGlobalEventSubscription() {
    _globalEventSubscription?.cancel();
    _globalEventSubscription = null;
    
    // Defensive check: InboxController might not be registered in some flows
    if (!Get.isRegistered<InboxController>()) {
      if (kDebugMode) {
        print('[ConversationController] InboxController not registered, skipping global event subscription');
      }
      return;
    }
    
    try {
      final inboxController = Get.find<InboxController>();
      _globalEventSubscription = inboxController.globalEventStream.listen(
        (event) {
          _handleGlobalRoomWebSocketMessage(event);
        },
        onError: (error) {
          _handleError('Global event stream error in conversation: $error');
          if (kDebugMode) {
            print('[ConversationController] Global event stream error: $error');
          }
        },
      );
      if (kDebugMode) {
        print('[ConversationController] Global event subscription established');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ConversationController] Failed to setup global event subscription: $e');
      }
    }
  }

  /// Initialize WebSocket connection and conversation setup with automatic reconnection
  Future<void> _connectToWebSocket() async {
    try {
      _isConnected.value = false;

      // Clean up existing connections and subscriptions
      await _conversationSubscription?.cancel();
      _conversationSubscription = null;
      _repository.disconnectFromConversation(conversationId);

      // Connect to the WebSocket and conversation
      await _repository.connectToConversation(conversationId);

      // Set up the conversation listener
      _conversationSubscription = _repository.getConversationStream().listen(
        _handleWebSocketMessage,
        onError: (error) {
          _handleError('WebSocket error: $error');
          _isConnected.value = false;
          // Attempt to reconnect after a delay
          Future.delayed(const Duration(seconds: 5), _connectToWebSocket);
        },
        onDone: () {
          if (kDebugMode) {
            print('[ConversationController] WebSocket connection closed');
          }
          _isConnected.value = false;
          // Attempt to reconnect if not manually disconnected
          if (Get.isRegistered<ConversationController>()) {
            Future.delayed(const Duration(seconds: 5), _connectToWebSocket);
          }
        },
        cancelOnError: false,
      );

      // Set up the global event subscription
      _setupGlobalEventSubscription();

      _isConnected.value = true;
      if (kDebugMode) {
        print('[ConversationController] WebSocket connected for conversation: $conversationId');
      }

      // Mark messages as read when connection is established
      _markMessagesAsRead();
    } catch (e, stackTrace) {
      _isConnected.value = false;
      _handleError('Failed to connect to WebSocket: $e');
      if (kDebugMode) {
        print('[ConversationController] WebSocket connection error: $e');
        print(stackTrace);
      }
      // Schedule a reconnection attempt
      Future.delayed(const Duration(seconds: 5), _connectToWebSocket);
    }
  }

  /// Mark all messages in the conversation as read
  Future<void> _markMessagesAsRead({bool notifyUser = true, isMy = false}) async {
    try {
      final unreadMessages = isMy ?
          _messages
              .where(
                (m) =>
                    !(m.isRead ?? false) && ("${m.user?.userId ?? ''}") == currentUserId,
              )
              .toList() : _messages
          .where(
            (m) =>
        !(m.isRead ?? false) && ("${m.user?.userId ?? ''}") != currentUserId,
      )
          .toList();

      if (unreadMessages.isEmpty) return;

      // Create a new list to trigger reactivity
      final updatedMessages = List<MessageData>.from(_messages);
      bool hasUpdates = false;

      for (final message in unreadMessages) {
        if(notifyUser) await _repository.markMessageAsRead(message.id ?? '', conversationId);
        final index = updatedMessages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          final current = updatedMessages[index];
          updatedMessages[index] = MessageData(
            id: current.id,
            user: current.user,
            content: current.content,
            meta: current.meta,
            createdAt: current.createdAt,
            updatedAt: current.updatedAt,
            isRead: true,
            file: current.file,
            mType: current.mType,
            status: current.status,
          );
          hasUpdates = true;
        }
      }

      // Only update if there were changes
      if (hasUpdates) {
        _messages.assignAll(updatedMessages);
      }

      // Update unread count
      _unreadCount.value = 0;
    } catch (e) {
      _handleError('Failed to mark messages as read');
    }
  }

  /// Handle incoming WebSocket messages with conversation ID validation
  void _handleWebSocketMessage(Map<String, dynamic> message) {
    if (kDebugMode) {
      print('[ConversationController] Received WS message: $message');
    }

    try {
      // Validate message has required fields
      if (message.isEmpty) return;
      
      // Validate conversation ID matches current conversation
      final msgConversationId = message['conversationId'] ?? message['room_id'] ?? message['room']?['id'];
      if (msgConversationId != null && msgConversationId != conversationId) {
        // Message is for a different conversation, ignore it
        if (kDebugMode) {
          print('[ConversationController] Ignoring message for different conversation: $msgConversationId (current: $conversationId)');
        }
        return;
      }

      final action = message['action'] ?? message['type'];
      
      switch (action) {
        case WebSocketEventTypes.message:
          // _handleIncomingMessage(message);
          break;

        case 'error':
          if (message['type'] == "forbidden") {
            _messages.removeWhere((m) => m.id?.startsWith('temp_') ?? false);
            MainUtils.showToastMessage(message: "${message['message'] ?? ''}");
          }
          break;
          
        case WebSocketEventTypes.readDone:
          _markMessagesAsRead(notifyUser: false, isMy: true);
          break;
          
        default:
          if (kDebugMode) {
            print('[ConversationController] Unhandled WS action: $action');
          }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ConversationController] Error handling WS message: $e');
        print(stackTrace);
      }
    }
  }

  /// Handle global WebSocket events (typing, online status, etc.)
  void _handleGlobalRoomWebSocketMessage(Map<String, dynamic> message) {
    if (kDebugMode) {
      print('[ConversationController] Global event received: $message');
    }

    try {
      final eventType = message['action'] ?? message['type'];

      // Extract conversation ID from message for filtering
      final msgConversationId = message['conversationId']?.toString() ??
          message['conversation_id']?.toString() ??
          message['room_id']?.toString() ??
          message['room']?['id']?.toString();

      // Filter out events for other conversations (except user online/offline which are user-wide)
      final isUserWideEvent = eventType == WebSocketEventTypes.userOnline ||
          eventType == WebSocketEventTypes.userOffline;

      if (!isUserWideEvent &&
          msgConversationId != null &&
          msgConversationId != conversationId) {
        if (kDebugMode) {
          print('[ConversationController] Global event for different conversation, skipping: $msgConversationId');
        }
        return;
      }

      switch (eventType) {
        case WebSocketEventTypes.message:
          _handleIncomingMessage(message);
          break;

        case WebSocketEventTypes.typing:
          _handleTypingStatus(message);
          break;

        case WebSocketEventTypes.userOnline:
          _handleUserOnlineStatus(message, isOnline: true);
          break;

        case WebSocketEventTypes.userOffline:
          _handleUserOnlineStatus(message, isOnline: false);
          break;

        case WebSocketEventTypes.readDone:
          _markMessagesAsRead(notifyUser: false, isMy: true);
          break;

        case 'error':
          if (message['type'] == "forbidden") {
            _messages.removeWhere((m) => m.id?.startsWith('temp_') ?? false);
            MainUtils.showToastMessage(message: "${message['message'] ?? ''}");
          }
          break;

        default:
          if (kDebugMode) {
            print('[ConversationController] Unhandled global event: $eventType');
          }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ConversationController] Error handling global event: $e');
        print(stackTrace);
      }
    }
  }

  /// Handle an incoming message from WebSocket - optimized to not reload from API
  void _handleIncomingMessage(Map<String, dynamic> message) async {
    try {
      if (message.isEmpty) return;

      // Extract conversation ID from various possible fields
      final msgConversationId = message['conversationId']?.toString() ??
          message['room_id']?.toString() ??
          message['room']?['id']?.toString();

      // Validate message belongs to current conversation
      if (msgConversationId != null && msgConversationId != conversationId) {
        if (kDebugMode) {
          print('[ConversationController] Message not for this conversation, skipping: $msgConversationId vs $conversationId');
        }
        return;
      }

      // Extract sender information - handle both global room (user object) and conversation (user string) formats
      final dynamic userRaw = message['user'];
      Map<String, dynamic>? userData;
      String? senderId;

      if (userRaw is Map<String, dynamic>) {
     // Global room format: user is an object with user_id
        userData = userRaw;
        // ✅ Use numeric user_id for comparison, NOT MongoDB id
        senderId = userData['user_id']?.toString() ?? 
                   message['user_id']?.toString();
      } else if (userRaw is String) {
        // Conversation channel format: user is just the user ID string
        senderId = userRaw;
      }

      final messageContent = message['message'] ?? message['content'] ?? '';
      final messageId = message['id']?.toString();

      if (kDebugMode) {
        print('[ConversationController] Handling incoming message from user: $senderId, current user: $currentUserId, userData: $userData');
      }

      // Skip if message is from current user (already added optimistically)
      if (senderId != null && senderId == currentUserId.toString()) {
        if (kDebugMode) {
          print('[ConversationController] Skipping message from current user');
        }
        return;
      }

      // Check for WebSocket echo message (no sender info but has action:message)
      // This happens when server echoes back our sent message
      final isWebSocketEcho = senderId == null &&
                              message['action'] == 'message' &&
                              messageContent.isNotEmpty;

      if (isWebSocketEcho) {
        // Check if this content matches any recently sent temp message from current user
        bool hasMatchingTemp = false;
        for (final m in _messages) {
          if (m.id?.startsWith('temp_') == true &&
              m.content == messageContent &&
              m.user?.userId?.toString() == currentUserId) {
            hasMatchingTemp = true;
            break;
          }
        }

        if (hasMatchingTemp) {
          if (kDebugMode) {
            print('[ConversationController] Skipping WebSocket echo for own message: $messageContent');
          }
          return;
        }
      }

      // Check for duplicate message by ID
      if (messageId != null && _messages.any((m) => m.id == messageId)) {
        if (kDebugMode) {
          print('[ConversationController] Duplicate message by ID, skipping: $messageId');
        }
        return;
      }

      // Check for duplicate by content from same sender (for echo messages without proper ID)
      if (isWebSocketEcho) {
        final hasDuplicateContent = _messages.any((m) {
          if (m.content != messageContent) return false;
          if (m.user?.userId?.toString() != currentUserId) return false;
          if (m.id?.startsWith('temp_') == true) return true;
          if (m.createdAt == null) return false;
          return m.createdAt!.difference(DateTime.now()).inSeconds.abs() < 5;
        });
        if (hasDuplicateContent) {
          if (kDebugMode) {
            print('[ConversationController] Skipping duplicate content from current user');
          }
          return;
        }
      }

      // Get sender user ID for FromUserClass
      final senderUserId = userData?['user_id'] ?? userData?['id'];

      // For conversation channel messages without userData, we need to determine
      // if this is from current user or receiver based on the senderId (MongoDB ID)
      // The global room will provide full user data, so we can skip this if it's a duplicate
      FromUserClass messageUser;
      if (userData != null) {
        // Global room format - full user data
        final numericUserId = senderUserId is int 
            ? senderUserId 
            : int.tryParse(senderUserId?.toString() ?? '');
        messageUser = FromUserClass(
          id: userData['id']?.toString(),
          image: userData['image']?.toString() ?? userData['avatar']?.toString(),
          userId: numericUserId,
        );
      } else {
        // Conversation channel format - user is just a string ID
        // Use receiver info if we have it, otherwise create with just the ID
        // We'll skip this and wait for global room message with full data
        if (kDebugMode) {
          print('[ConversationController] Conversation channel message without user data, waiting for global room: $messageId');
        }
        // Check if message ID is valid - if so, skip this partial message
        if (messageId != null && messageId.isNotEmpty && !messageId.startsWith('ws_')) {
          // This is a real message ID, wait for global room to provide full data
          // Check if we already have this message from global room
          if (_messages.any((m) => m.id == messageId)) {
            if (kDebugMode) {
              print('[ConversationController] Already have message $messageId from global room, skipping');
            }
            return;
          }
        }
        // Create minimal user info - try to use receiver data if available
      final isFromReceiver = senderId != null && senderId != currentUserId.toString();
        messageUser = FromUserClass(
          id: senderId,
          image: isFromReceiver ? (receiver?.avatar ?? '') : mainControl.profileImageUrl.value,
          userId: isFromReceiver
              ? receiver?.userId  // ✅ use numeric userId of receiver for correct side detection
              : int.tryParse(currentUserId),
      );
    }

      // Create message data from WebSocket payload
      final newMessage = MessageData(
        id: messageId ?? 'ws_${DateTime.now().millisecondsSinceEpoch}',
        user: messageUser,
        content: messageContent,
        createdAt: DateTime.tryParse(message['created_at'] ?? '') ?? DateTime.now(),
        isRead: false,
      );

      // Add message and deduplicate to prevent race condition duplicates
      _messages.add(newMessage);

      // Remove duplicates by keeping only the first occurrence of each message ID
      final seenIds = <String?>{};
      _messages.removeWhere((m) {
        if (seenIds.contains(m.id)) return true;
        seenIds.add(m.id);
        return false;
      });

      if (kDebugMode) {
        print('[ConversationController] Added new message, total count: ${_messages.length}');
      }

      // Mark as read and scroll to bottom
      _markMessagesAsRead();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      _handleError('Error handling incoming message: $e');
      if (kDebugMode) {
        print('[ConversationController] Error in _handleIncomingMessage: $e');
      }
    }
  }

  /// Handle typing status from WebSocket
  void _handleTypingStatus(Map<String, dynamic> data) {
    if(data['conversation_id'] == conversationId) {
      isTyping.value = data['is_typing'] ?? false;
    }

    final isUserTyping = data['status'] == true;
    final typingUserId = data['user_id'] as String?;
    final typingUserName = data['user_name'] as String?;

    if (typingUserId != null && typingUserId != currentUserId) {
      _isParticipantTyping.value = isUserTyping;

      // Update typing users list
      if (isUserTyping && typingUserName != null) {
        _typingUsers[typingUserId] = typingUserName;
      } else {
        _typingUsers.remove(typingUserId);
      }

      // Auto-hide typing indicator after 3 seconds of no typing
      _typingTimer?.cancel();
      if (isUserTyping) {
        _typingTimer = Timer(const Duration(seconds: 3), () {
          _isParticipantTyping.value = false;
          _typingUsers.remove(typingUserId);
        });
      }
    }
  }

  /// Handle user online/offline status
  void _handleUserOnlineStatus(
    Map<String, dynamic> data, {
    required bool isOnline,
  }) {
    final userId = data['user_id'] as String?;
    if (userId == sender) {
      _isParticipantOnline.value = isOnline;
    }
  }

  /// Handle message read receipt
  void _handleMessageRead(Map<String, dynamic> data) {
    final messageId = data['room_id'] as String?;
    if (messageId == null) return;
    if(messageId != conversationId) return;

    // Create a new list to trigger reactivity
    final updatedMessages = List<MessageData>.from(_messages);
    bool hasUpdates = false;

    final index = updatedMessages.indexWhere((m) => m.id == messageId);
    if (index != -1 && updatedMessages[index].isRead != true) {
      final msg = updatedMessages[index];
      updatedMessages[index] = MessageData(
        id: msg.id,
        user: msg.user,
        content: msg.content,
        meta: msg.meta,
        createdAt: msg.createdAt,
        updatedAt: msg.updatedAt,
        isRead: true,
        file: msg.file,
        mType: msg.mType,
        status: msg.status,
      );
      hasUpdates = true;
    }

    // Only update if there were changes
    if (hasUpdates) {
      _messages.assignAll(updatedMessages);
    }
  }

  /// Public method to refresh messages (called from UI)
  Future<void> refreshMessages() async {
    await loadMessages();
  }

  /// Handle typing events for message input
  void onMessageTyping(String text) {
    canSendMessage.value = messageController.text.trim().isNotEmpty && !_isSending.value;
    text.trim().isEmpty ? _stopTyping() : _isUserTyping ? _resetTypingTimer() : _startTyping();
  }

  void _startTyping() {
    if (_isUserTyping) return;
    _isUserTyping = true;
    _repository.sendTypingIndicator(conversationId, true);
    _resetTypingTimer();
  }

  void _stopTyping() {
    if (!_isUserTyping) return;
    _isUserTyping = false;
    _typingTimer?.cancel();
    _repository.sendTypingIndicator(conversationId, false);
  }

  void _resetTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), _stopTyping);
  }

  @override
  void onClose() {
    if (_isUserTyping) _stopTyping();
    _typingTimer?.cancel();
    _messageSyncTimer?.cancel();
    _conversationSubscription?.cancel();
    _conversationSubscription = null;
    _globalEventSubscription?.cancel();
    _globalEventSubscription = null;
    _notificationSubscription?.cancel();
    _notificationSubscription = null;
    try {
      _repository.disconnectFromConversation(conversationId);
      _isConnected.value = false;
    } catch (e) {}
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    _errorMessage.value = null;
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _setupNotificationListener() {
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationService.onNotificationClick.listen(
      (payload) {
        if (payload.conversationId == conversationId &&
            payload.messageId != null) {
          _scrollToMessage(payload.messageId!);
        }
      },
      onError: (error) {
        _handleError('Notification listener error: $error');
        if (kDebugMode) {
          print('[ConversationController] Notification listener error: $error');
        }
      },
    );
  }

  void _scrollToMessage(String messageId) {
    if (!scrollController.hasClients) return;
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index < 0) return;
    final position = (index * 100.0).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
    if ((scrollController.offset - position).abs() > 1.0) {
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<String> _getAuthToken() async {
    try {
      final token = await CacheManager.getToken;
      if (token.isEmpty) throw Exception('No authentication token found');
      return token;
    } catch (e) {
      throw Exception('Failed to get authentication token');
    }
  }

  void _setupConnectionListener() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString() && !_isConnected.value) {
        _connectToWebSocket();
      }
      return null;
    });

    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isConnected.value && Get.isRegistered<ConversationController>()) {
        _connectToWebSocket();
      }
    });

    _repository.connectionStatusStream.listen((status) {
      _isConnected.value = status == WebSocketStatus.connected;
      if (status == WebSocketStatus.connected) {
        _connectToWebSocket();
      } else if (status == WebSocketStatus.error) {
        _handleError('Connection error. Reconnecting...');
        Future.delayed(const Duration(seconds: 5), _connectToWebSocket);
      }
    });
  }

  /// Setup scroll listener for pagination
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (!scrollController.hasClients ||
          !_hasMoreMessages ||
          _isLoadingMore.value) {
        return;
      }

      final position = scrollController.position;
      final maxScroll = position.maxScrollExtent;
      final currentPixels = position.pixels;

      // Load more when scrolled within 200 pixels of the top
      if (currentPixels <= 200 && currentPixels > 0) {
        loadMoreMessages();
      }
    });
  }

  Future<void> loadMessages() async {
    try {
      _isLoading.value = true;
      _clearError();
      final newMessages = await _repository.getConversationMessages(
        conversationId,
        page: 1,
        limit: 100,
      );
      List dataList = newMessages.data ?? [];
      _messages.assignAll([...dataList]);
      if(newMessages.extraData != null){_extraData.value = newMessages.extraData!;}
      _currentPage = 1;
      _hasMoreMessages = dataList.length == 20;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      _handleError('Failed to load messages: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (!_hasMoreMessages || _isLoadingMore.value) return;
    try {
      _isLoadingMore.value = true;
      final newMessages = await _repository.getConversationMessages(
        conversationId,
        page: _currentPage + 1,
        limit: 20,
      );
      List<MessageData> messageData = newMessages.data ?? [];
      if (messageData.isNotEmpty) {
        _messages.insertAll(0, messageData.reversed.toList());
        _currentPage++;
        _hasMoreMessages = messageData.length == 20;
      } else {
        _hasMoreMessages = false;
      }
    } catch (e) {
      _handleError('Failed to load more messages: $e');
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Send a message
  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty || _isSending.value) return;

    try {
      _isSending.value = true;
      _clearError();

      // Clear the input immediately for better UX
      messageController.clear();
      _stopTyping();

      // Create a temporary message for optimistic UI update
      // Use counter to ensure uniqueness even within same millisecond
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}_${_tempIdCounter++}';
      final tempMessage = MessageData(
        id: tempId,
        content: content,
        isRead: false,
        user: FromUserClass(
          image: mainControl.profileImageUrl.value,
          userId: int.parse(currentUserId),
        ),
        createdAt: DateTime.now(),
      );

      // Add temporary message to the list
      _messages.add(tempMessage);
      if (kDebugMode) {
        print('[ConversationController] Added temp message: $tempId, content: $content, total: ${_messages.length}');
      }

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      // Send the message
      final message = await _repository.sendMessage(conversationId, content);

      // ✅ Only call if current user is HOST
if (mainControl.uType.value == 'host') {
  try {
    final chatRoom = _extraData.value.chatRoom;
    final listingId = chatRoom?.listing?.id;
    final hostId = chatRoom?.toUser.firstOrNull?.userId ?? chatRoom?.fromUser?.userId;
    final guestId = chatRoom?.fromUser?.userId;

    if (listingId != null && hostId != null && guestId != null) {
      await _repository.postFirstReply(
        listingId: listingId,
        hostId: hostId,
        guestId: guestId,
      );
      print('✅ firstReply POST success');
    } else {
      print('⚠️ firstReply skipped: listingId=$listingId hostId=$hostId guestId=$guestId');
    }
  } catch (e) {
    print('❌ firstReply POST failed: $e');
    // silently fail
  }
}

      canSendMessage.value = false;

      // Message sent successfully
    } catch (e) {
      // Remove the temporary message on error
      if (kDebugMode) {
        print('[ConversationController] Send failed, removing temp messages. Error: $e');
      }
      _messages.removeWhere((m) => (m.id?.startsWith('temp_') ?? false));

      // Restore message to input
      messageController.text = content;
      _handleError('Failed to send message. Please try again.');
    } finally {
      _isSending.value = false;
    }
  }

  /// Send a property share message
  Future<void> shareProperty() async {
    if (recommendedPropertyId == null) return;

    try {
      _isSharingProperty.value = true;

      var item = _recommendedPropertyData.value;
      var payload = {
        "property_id": item?.unique_id,
        "message": item?.title,
        "cost": "BDT ${item?.price.toStringAsFixed(0)}/per night",
        "image": item?.cover_photo,
      };
      String stringifyPayload = json.encode(payload);

      // Create a temporary message for optimistic UI update
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      final tempMessage = MessageData(
        id: tempId,
        content: stringifyPayload,
        isRead: false,
        user: FromUserClass(
          image: mainControl.profileImageUrl.value,
          userId: int.parse(currentUserId),
        ),
        createdAt: DateTime.now(),
      );

      // Add temporary message to the list
      _messages.add(tempMessage);

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      // Send the message
      await _repository.sendMessage(conversationId, stringifyPayload);
      Get.back();
      // Message sent successfully
    } catch (e) {
      _isSharingProperty.value = false;
      _recommendedPropertyId.value = null;
      _recommendedPropertyData.value = null;
      _handleError('Failed to send message. Please try again.');
    } finally {
      _recommendedPropertyId.value = null;
      _recommendedPropertyData.value = null;
      _isSharingProperty.value = false;
    }
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    if (!scrollController.positions.any((p) => p.hasContentDimensions)) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 100) {
      scrollController.animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isNearBottom() {
    if (!scrollController.hasClients) return true;
    final position = scrollController.position;
    return position.pixels >= position.maxScrollExtent - 100;
  }

  void _handleError(String message) => _errorMessage.value = message;
  void _clearError() => _errorMessage.value = null;

  /// Get typing indicator text
  String getTypingIndicatorText() {
    final typingUsersList = _typingUsers.values.toList();

    if (typingUsersList.isEmpty) return '';

    if (typingUsersList.length == 1) {
      return '${typingUsersList.first} is typing...';
    } else if (typingUsersList.length == 2) {
      return '${typingUsersList.join(' and ')} are typing...';
    } else {
      return '${typingUsersList.length} people are typing...';
    }
  }

  bool isMyMessage(MessageData message) =>
      (message.user?.id ?? false) != sender;
  String formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );
    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
