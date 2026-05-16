import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/main.dart';
import '../../../controllers/main_controller.dart';
import '../../../services/cache/cache_manager.dart';
import '../../public_listings/data/models/archived_list_model.dart';
import '../data/models/chat_message_models.dart';
import '../data/models/chat_room_model.dart';
import '../data/models/quick_reply_message_response.dart';
import '../data/models/websocket_models.dart';
import '../data/repositories/messaging_repository.dart';
import '../presentation/views/archived_message_screen.dart';

// Tab types
enum InboxTabType { all, unread, guest, stayverz }

/// Controller for managing inbox/chat rooms list and global messaging state
class InboxController extends GetxController with WidgetsBindingObserver {
  final MessagingRepository _repository;

  InboxController({MessagingRepository? repository})
    : _repository = repository ?? Get.find<MessagingRepository>();

  // Reactive state
  final _isLoading = false.obs;
  final _isQuickReplyLoading = false.obs;
  final _isQuickReplyCreating = false.obs;
  final _isRefreshing = false.obs;
  final _chatRooms = <ChatRoomData>[].obs;
  final _myQuickReply = <QuickReplyData>[].obs;
  final _totalUnreadCount = 0.obs;
  final _connectionStatus = WebSocketStatus.disconnected.obs;
  final _errorMessage = RxnString();
  final isReloadConv = RxBool(false);

  // Tab functionality
  final _selectedTabIndex = 0.obs;
  final _filteredChatRooms = <ChatRoomData>[].obs;

  // Stream subscriptions - use broadcast controller for multiple listeners
  late final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get globalEventStream => _eventController.stream;
  StreamSubscription<Map<String, dynamic>>? _chatStatsSubscription;
  StreamSubscription<Map<String, dynamic>>? _globalEventSubscription;
  
  // Track if already initializing to prevent duplicate calls
  bool _isInitializing = false;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  bool get isQuickReplyCreating => _isQuickReplyCreating.value;
  bool get isQuickReplyLoading => _isQuickReplyLoading.value;
  List<ChatRoomData> get chatRooms => _chatRooms;
  List<QuickReplyData> get myQuickReply => _myQuickReply;
  int get totalUnreadCount => _totalUnreadCount.value;
  WebSocketStatus get connectionStatus => _connectionStatus.value;
  String? get errorMessage => _errorMessage.value;

  // Tab getters
  int get selectedTabIndex => _selectedTabIndex.value;
  List<ChatRoomData> get filteredChatRooms => _filteredChatRooms;
  InboxTabType get currentTab => InboxTabType.values[_selectedTabIndex.value];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Filter when chat rooms change
    ever(_chatRooms, (_) => _filterChatRooms());

    // Filter when tab selection changes
    ever(_selectedTabIndex, (_) => _filterChatRooms());

    // Initialize messaging - with debounce to prevent multiple rapid calls
    Future.delayed(Duration.zero, () {
      _initializeMessaging();
    });

    // Archived chats setup
    archivedScrollController.addListener(() {
      if (archivedScrollController.position.pixels >=
              archivedScrollController.position.maxScrollExtent - 200 &&
          !isArchivedLoadingMore.value &&
          (lastArchivedPage == null ||
              currentArchivedPage <= lastArchivedPage!)) {
        loadArchivedChats();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadChatRooms();
    // Refresh archived chats every time the screen is opened
    loadArchivedChats(refresh: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app resumes AND user is on the archived screen
    if (state == AppLifecycleState.resumed &&
        Get.currentRoute == '/archived-message') {
      loadArchivedChats(refresh: true);
    }

    if (state == AppLifecycleState.resumed) {
      // App came to foreground, refresh data and reconnect WebSocket
      loadChatRooms();
      // Ensure WebSocket is healthy
      Future.delayed(const Duration(seconds: 1), () {
        ensureConnectionHealth();
      });
    }
  }

  @override
  void onClose() {
    archivedScrollController.dispose();
    _chatStatsSubscription?.cancel();
    _globalEventSubscription?.cancel();
    _eventController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Initialize messaging system with WebSocket connections
  Future<void> _initializeMessaging() async {
    // Prevent duplicate initialization calls
    if (_isInitializing) {
      if (kDebugMode) {
        print('[InboxController] Already initializing, skipping...');
      }
      return;
    }
    
    _isInitializing = true;
    
    try {
      final authToken = await _getAuthToken();
      if (authToken != null && authToken.isNotEmpty) {
        if (kDebugMode) {
          print('[InboxController] Initializing WebSocket with token...');
        }
        
        await _repository.connectToMessaging(
          authToken,
          connectStats: true,
          connectGlobal: true,
        );
        _setupWebSocketListeners();
        await loadChatRooms();
        await loadQuickReplyFromApi();
        
        if (kDebugMode) {
          print('[InboxController] WebSocket initialized successfully');
        }
      } else {
        if (kDebugMode) {
          print('[InboxController] No auth token, skipping WebSocket init');
        }
      }
    } catch (e) {
      _handleError('Failed to initialize messaging: $e');
      if (kDebugMode) {
        print('[InboxController] WebSocket init error: $e');
      }
    } finally {
      _isInitializing = false;
    }
  }

  /// Setup WebSocket event listeners
  void _setupWebSocketListeners() {
    // Cancel any existing subscriptions to avoid leaks
    _chatStatsSubscription?.cancel();
    _globalEventSubscription?.cancel();

    // ✅ Only update total unread count from stats stream
    _chatStatsSubscription = _repository.chatStatsStream.listen(
      (stats) {
        if (kDebugMode) {
          print('[InboxController] Chat stats received: $stats');
        }
        _totalUnreadCount.value = stats['count'] ?? 0;
      },
      onError: (error) {
        _handleError('Chat stats stream error: $error');
        if (kDebugMode) {
          print('[InboxController] Chat stats error: $error');
        }
      },
    );

    // Listen to global events (user presence, new messages, etc.)
    _globalEventSubscription = _repository.globalEventStream.listen(
      (message) {
        if (kDebugMode) {
          print('[InboxController] Global event received: $message');
        }
        // Broadcast to all listeners (including ConversationController)
        if (!_eventController.isClosed) {
          _eventController.add(message);
        }
        _handleGlobalEvent(message);
      },
      onError: (error) {
        _handleError('Global event stream error: $error');
        if (kDebugMode) {
          print('[InboxController] Global event error: $error');
        }
      },
      onDone: () {
        if (kDebugMode) {
          print('[InboxController] Global event stream closed');
        }
      },
    );

    // Monitor connection status
    ever(_connectionStatus, (status) {
      if (status == WebSocketStatus.connected) {
        _clearError();
        if (kDebugMode) {
          print('[InboxController] WebSocket connected');
        }
      } else if (status == WebSocketStatus.error) {
        _handleError('Connection lost. Attempting to reconnect...');
        if (kDebugMode) {
          print('[InboxController] WebSocket error');
        }
      }
    });
  }

  void createQuickReply(String title, String message) async {
    try {
      _isQuickReplyCreating(true);
      var result = await _repository.createQuickReply(
        title: title,
        message: message,
      );
      if (result != null) {
        await loadQuickReplyFromApi();
        Get.back();
      }
    } catch (e) {
      if (kDebugMode) {
        print('[InboxController] Quick reply error: $e');
      }
    } finally {
      _isQuickReplyCreating(false);
    }
  }

  /// Load chat rooms from server
  Future<void> loadChatRooms() async {
    try {
      _isLoading.value = true;
      _clearError();

      final rooms = await _repository.getChatRooms();
      _chatRooms.assignAll(rooms);

      if (kDebugMode) {
        print('[InboxController] Loaded ${rooms.length} chat rooms');
      }
    } catch (e) {
      _handleError('Failed to load chat rooms: $e');
      if (kDebugMode) {
        print('[InboxController] Load chat rooms error: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  final RxBool _isChatArchiving = false.obs;
  bool get isChatArchiving => _isChatArchiving.value;

  Future<void> archiveChat({
    required String roomId,
    required bool archived,
  }) async {
    try {
      final result = await _repository.archiveChat(
        roomId: roomId,
        archived: archived,
      );

      if (result != null && result.success) {
        // Remove from the list immediately if unarchived
        if (!archived) {
          final index = archivedChats.indexWhere((chat) => chat.id == roomId);
          if (index != -1) {
            archivedChats.removeAt(index);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[InboxController] Archive chat error: $e');
      }
    }
  }

  /// Load quick replies from server
  Future<void> loadQuickReplyFromApi() async {
    try {
      _isQuickReplyLoading.value = true;
      _clearError();

      if (mainControl.uType.value == 'guest') {
        _isQuickReplyLoading.value = false;
        return;
      }

      final replies = await _repository.getAllQuickReply();
      _myQuickReply.assignAll(replies);

      if (kDebugMode) {
        print('[InboxController] Loaded ${replies.length} quick replies');
      }
    } catch (e) {
      _handleError('Failed to load chat replies: $e');
    } finally {
      _isQuickReplyLoading.value = false;
    }
  }

  /// Refresh chat rooms (pull-to-refresh)
  Future<void> refreshChatRooms() async {
    try {
      _isRefreshing.value = true;
      _clearError();

      final rooms = await _repository.getChatRooms();
      _chatRooms.assignAll(rooms);

      if (kDebugMode) {
        print('[InboxController] Refreshed ${rooms.length} chat rooms');
      }
    } catch (e) {
      _handleError('Failed to refresh chat rooms: $e');
    } finally {
      _isRefreshing.value = false;
    }
  }

  /// Handle global WebSocket events
  void _handleGlobalEvent(Map<String, dynamic> message) {
    // Check both 'action' and 'type' fields for event type
    final eventType = message['action'] ?? message['type'];

    if (kDebugMode) {
      print('[InboxController] Handling global event: $eventType');
    }

    switch (eventType) {
      case WebSocketEventTypes.userOnline:
        _handleUserOnlineEvent(message);
        break;
      case WebSocketEventTypes.userOffline:
        _handleUserOfflineEvent(message);
        break;
      case WebSocketEventTypes.message:
        isReloadConv(true);
        _handleNewMessageEvent(message);
        _totalUnreadCount.value += 1;
        isReloadConv(false);
        break;
      case WebSocketEventTypes.typing:
      case 'typing':
        // Typing events are handled by ConversationController via globalEventStream
        break;
      case WebSocketEventTypes.readDone:
        // Handle read receipts
        break;
      default:
        if (kDebugMode) {
          print('[InboxController] Unhandled event type: $eventType');
        }
    }
  }

  /// Handle user online event
  void _handleUserOnlineEvent(Map<String, dynamic> message) {
    if (message.isNotEmpty && message['user_id'] != null) {
      final userId = "${message['user_id'] ?? 0}";
      _updateUserOnlineStatus(userId, true);
    }
  }

  /// Handle user offline event
  void _handleUserOfflineEvent(Map<String, dynamic> message) {
    if (message.isNotEmpty && message['user_id'] != null) {
      final userId = "${message['user_id'] ?? 0}";
      _updateUserOnlineStatus(userId, false);
    }
  }

  /// Handle new message — only mark unread if message is from others
  void _handleNewMessageEvent(Map<String, dynamic> message) {
    if (message.isEmpty) return;
    
    final conversationId = message['conversationId'] as String? ?? 
                          message['room_id'] as String? ??
                          message['room']?['id']?.toString();
    final lastMessage = message['message'] as String? ?? message['content'] as String?;
    final timestamp = message['created_at'] as String?;
    final senderId = message['user_id']?.toString() ?? message['user']?.toString();

    final MainController mainController = Get.find<MainController>();
    final myUserId = mainController.userId.value;

    if (kDebugMode) {
      print('[InboxController] New message from $senderId, my ID: $myUserId, conversation: $conversationId');
    }

    if (conversationId != null && lastMessage != null) {
      final idx = _chatRooms.indexWhere((r) => r.id == conversationId);
      if (idx != -1) {
        final room = _chatRooms[idx];

        // Message from me = isRead true, reset unread to 0
        // Message from others = isRead false, increment unread count
        final isFromMe = senderId == myUserId;
        final newUnreadCount = isFromMe ? 0 : room.unreadCount + 1;
        final parsedTime =
            timestamp != null ? DateTime.parse(timestamp) : DateTime.now();

        _chatRooms[idx] = room.copyWith(
          unreadCount: newUnreadCount,
          latestMessage: (room.latestMessage ?? LatestMessage()).copyWith(
            content: lastMessage,
            createdAt: parsedTime,
            updatedAt: parsedTime,
            isRead: isFromMe,
          ),
        );

        // Re-filter immediately so Unread tab updates in real time
        _filterChatRooms();
        
        if (kDebugMode) {
          print('[InboxController] Updated chat room $conversationId, unread: $newUnreadCount');
        }
      } else {
        // Chat room not found - might be a new conversation, refresh the list
        if (kDebugMode) {
          print('[InboxController] Chat room not found, refreshing list...');
        }
        loadChatRooms();
      }
    }
  }

  /// Update user online status in chat rooms
  void _updateUserOnlineStatus(String userId, bool isOnline) {
    final int i = _chatRooms.indexWhere((room) {
      return room.fromUser?.userId?.toString() == userId ||
          room.toUsers.any((user) {
            return user.userId.toString() == userId;
          });
    });

    if (i != -1) {
      final room = _chatRooms[i];

      User? updatedFromUser = room.fromUser;
      if (room.fromUser?.userId?.toString() == userId) {
        updatedFromUser = room.fromUser?.copyWith(isOnline: isOnline);
      }

      List<User> updatedToUsers = room.toUsers;
      final userIndex = room.toUsers.indexWhere(
        (user) => user.userId.toString() == userId,
      );
      if (userIndex != -1) {
        final newToUsers = List<User>.from(room.toUsers);
        newToUsers[userIndex] = newToUsers[userIndex].copyWith(
          isOnline: isOnline,
        );
        updatedToUsers = newToUsers;
      }

      _chatRooms[i] = room.copyWith(
        fromUser: updatedFromUser,
        toUsers: updatedToUsers,
      );
    }
  }

  /// Get authentication token
  Future<String?> _getAuthToken() async {
    try {
      var token = await CacheManager.getToken;
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('[InboxController] Get token error: $e');
      }
      return null;
    }
  }

  /// Handle errors
  void _handleError(String message) {
    _errorMessage.value = message;
    if (kDebugMode) {
      print('[InboxController] Error: $message');
    }
  }

  /// Clear error message
  void _clearError() {
    _errorMessage.value = null;
  }

  /// Retry connection
  Future<void> retryConnection() async {
    _clearError();
    await _initializeMessaging();
  }

  /// Check and ensure WebSocket connections are healthy
  Future<void> ensureConnectionHealth() async {
    if (_connectionStatus.value != WebSocketStatus.connected) {
      if (kDebugMode) {
        print('[InboxController] Connection not healthy, reconnecting...');
      }
      await retryConnection();
    } else {
      if (kDebugMode) {
        print('[InboxController] Connection is healthy');
      }
    }
  }

  /// Search chat rooms
  void searchChatRooms(String query) {
    if (query.isEmpty) {
      loadChatRooms();
      return;
    }

    final searchQuery = query.toLowerCase();
    _chatRooms.value =
        _chatRooms.where((room) {
          final hasMatchingUser = room.toUsers.any(
            (user) => user.name?.toLowerCase().contains(searchQuery) == true,
          );
          final hasMatchingMessage =
              room.latestMessage?.content?.toLowerCase().contains(
                searchQuery,
              ) ==
              true;
          return hasMatchingUser || hasMatchingMessage;
        }).toList();
  }

  /// Mark all conversations as read
  Future<void> markAllAsRead() async {
    try {
      for (int i = 0; i < _chatRooms.length; i++) {
        _chatRooms[i] = _chatRooms[i].copyWith(
          latestMessage: _chatRooms[i].latestMessage?.copyWith(
            unreadCount: 0,
            isRead: true,
          ),
        );
      }
      _totalUnreadCount.value = 0;
    } catch (e) {
      _handleError('Failed to mark all as read: $e');
    }
  }

  // Tab selection method
  void selectTab(int index) {
    if (index >= 0 && index < InboxTabType.values.length) {
      _selectedTabIndex.value = index;

      // Reload from API every time Unread tab is selected
      if (index == 1) {
        loadChatRooms();
      } else {
        _filterChatRooms();
      }
    }
  }

  // Filter chat rooms with correct unread logic
  void _filterChatRooms() {
    final MainController mainController = Get.find<MainController>();
    final myUserId = mainController.userId.value;

    switch (currentTab) {
      case InboxTabType.all:
        _filteredChatRooms.assignAll(_chatRooms);
        break;

      case InboxTabType.unread:
        _filteredChatRooms.assignAll(
          _chatRooms.where((room) {
            // Get sender of the latest message
            final lastMessageSenderId =
                room.latestMessage?.user?.userId?.toString() ??
                room.latestMessage?.senderId;

            // If I sent the last message, NEVER show as unread for me
            final iSentLastMessage = lastMessageSenderId == myUserId;
            if (iSentLastMessage) return false;

            // Check is_read == false from API response
            final isUnreadFromApi = room.latestMessage?.isRead == false;

            // Check local unread count incremented from WS new messages
            final hasLocalUnread = room.unreadCount > 0;

            return isUnreadFromApi || hasLocalUnread;
          }).toList(),
        );
        break;

      case InboxTabType.guest:
        if (mainController.uType.value == 'guest') {
          _filteredChatRooms.assignAll(_chatRooms);
        } else {
          _filteredChatRooms.assignAll(
            _chatRooms
                .where((room) => room.fromUser?.userId.toString() != myUserId)
                .toList(),
          );
        }
        break;

      case InboxTabType.stayverz:
        if (mainController.uType.value == 'guest') {
          _filteredChatRooms.assignAll([]);
        } else {
          _filteredChatRooms.assignAll(
            _chatRooms
                .where((room) => room.fromUser?.userId.toString() == myUserId)
                .toList(),
          );
        }
        break;
    }
  }

  // Controller reactive variables
  final RxBool _isChatSearching = false.obs;
  final RxList<ChatItem> _chatList = <ChatItem>[].obs;
  final RxString searchText = ''.obs;

  bool get isChatSearching => _isChatSearching.value;
  List<ChatItem> get chatList => _chatList;

  void updateSearchText(String value) {
    searchText.value = value;
    if (value.trim().isNotEmpty) {
      searchChatUsers(value.trim());
    } else {
      clearSearch();
    }
  }

  void clearSearch() {
    searchText.value = '';
    _chatList.clear();
  }

  void searchChatUsers(String query) async {
    try {
      _isChatSearching(true);
      final result = await _repository.searchChatUsers(query);
      _chatList.assignAll(result.data);
    } catch (e) {
      if (kDebugMode) {
        print('[InboxController] Search error: $e');
      }
    } finally {
      _isChatSearching(false);
    }
  }

  final RxList<ArchivedChatRoom> archivedChats = <ArchivedChatRoom>[].obs;
  final RxBool isArchivedLoading = false.obs;
  final RxBool isArchivedLoadingMore = false.obs;

  int currentArchivedPage = 1;
  final int archivedPageLimit = 50;
  int? lastArchivedPage;

  final ScrollController archivedScrollController = ScrollController();

  Future<void> loadArchivedChats({bool refresh = false}) async {
    try {
      if (refresh) {
        currentArchivedPage = 1;
        lastArchivedPage = null;
      }

      if (currentArchivedPage == 1) {
        isArchivedLoading(true);
      } else {
        isArchivedLoadingMore(true);
      }

      final result = await _repository.getArchivedChatList(
        page: currentArchivedPage,
        limit: archivedPageLimit,
      );

      if (result != null) {
        lastArchivedPage = result.metaInfo?.lastPage;

        if (currentArchivedPage == 1) {
          archivedChats.assignAll(result.data);
        } else {
          archivedChats.addAll(result.data);
        }

        currentArchivedPage++;
      }
    } catch (e) {
      if (kDebugMode) {
        print('[InboxController] Load archived error: $e');
      }
    } finally {
      isArchivedLoading(false);
      isArchivedLoadingMore(false);
    }
  }

  void setupArchivedScrollListener() {
    archivedScrollController.addListener(() {
      if (archivedScrollController.position.pixels >=
              archivedScrollController.position.maxScrollExtent - 200 &&
          !isArchivedLoadingMore.value &&
          (lastArchivedPage == null ||
              currentArchivedPage <= lastArchivedPage!)) {
        loadArchivedChats();
      }
    });
  }
}
