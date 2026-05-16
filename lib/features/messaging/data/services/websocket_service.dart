import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/websocket_models.dart' show ChatStatsModel, WebSocketMessage, WebSocketStatus;
import 'package:stayverz_flutter_app/services/network/connectivity_service.dart';

/// Service for managing WebSocket connections for real-time messaging
class WebSocketService extends GetxService {
  // Constants
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const int _maxReconnectAttempts = 5;
  static const String _globalRoomId = 'global';
  static const String _chatStatsId = 'stats';
  
  // Track which channels are connected
  bool _chatStatsConnected = false;
  bool _globalRoomConnected = false;

  // Connection state and authentication
  final Rx<WebSocketStatus> _connectionStatus = WebSocketStatus.disconnected.obs;
  WebSocketStatus get currentStatus => _connectionStatus.value;
  Stream<WebSocketStatus> get connectionStatus => _connectionStatus.stream;

  // WebSocket channels
  WebSocketChannel? _chatStatsChannel;
  WebSocketChannel? _globalRoomChannel;
  WebSocketChannel? _conversationChannel;
  String? _currentConversationId;
  String? _lastConversationId; // Backup to preserve ID for reconnection
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  // Timers and state
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _debounceTimer; // For debouncing connectivity changes
  int _reconnectAttempts = 0;
  bool _isManuallyDisconnecting = false;
  bool _pendingChatStatsConnection = false;
  bool _pendingGlobalRoomConnection = false;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  // Authentication token
  String? _authToken;

  // Stream controllers - broadcast for multiple listeners
  final _chatStatsController = StreamController<Map<String, dynamic>>.broadcast();
  final _globalEventController = StreamController<Map<String, dynamic>>.broadcast();
  final _conversationController = StreamController<Map<String, dynamic>>.broadcast();

  // Callback for when connection is restored
  VoidCallback? onConnectionRestored;

  // Stream getters
  Stream<Map<String, dynamic>> get chatStatsStream => _chatStatsController.stream;
  Stream<Map<String, dynamic>> get globalEventStream => _globalEventController.stream;
  Stream<Map<String, dynamic>> get conversationStream => _conversationController.stream;

  /// Connect to WebSocket with the given URL
  WebSocketChannel _createWebSocketChannel(
    String url,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _logger.i('Creating WebSocket channel for URL: $url');
    
    // Check connectivity before attempting connection
    final connectivityService = Get.find<ConnectivityService>();
    if (!connectivityService.isConnected) {
      _logger.w('Cannot create WebSocket: No internet connection');
      _updateConnectionStatus(WebSocketStatus.error);
      throw Exception('No internet connection - WebSocket connection blocked');
    }
    
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse(url),
        protocols: ['chat', 'json'],
      );
      _setupSocketListeners(channel, onMessage);
      _logger.i('WebSocket channel connected: $url');
      _updateConnectionStatus(WebSocketStatus.connected);
      resetReconnectAttempts();
      return channel;
    } catch (e) {
      _logger.e('Failed to create WebSocket channel: $e');
      _updateConnectionStatus(WebSocketStatus.error);
      _scheduleReconnect('reconnect');
      rethrow;
    }
  }

  /// Ensure WebSocket connection is established
  Future<void> _ensureConnected() async {
    if (_connectionStatus.value == WebSocketStatus.connected) return;

    _updateConnectionStatus(WebSocketStatus.connecting);

    try {
      await initialize(
        _authToken ?? '',
        connectStats: _chatStatsChannel != null || _pendingChatStatsConnection,
        connectGlobal: _globalRoomChannel != null || _pendingGlobalRoomConnection,
      );

      // Reconnect to active conversation (use backup if current is null)
      final conversationToReconnect = _currentConversationId ?? _lastConversationId;
      if (conversationToReconnect != null) {
        if (kDebugMode) {
          print('[WebSocketService._ensureConnected] Reconnecting to conversation: $conversationToReconnect (current: $_currentConversationId, backup: $_lastConversationId)');
        }
        await connectToConversation(conversationToReconnect);
      }

      _updateConnectionStatus(WebSocketStatus.connected);
      resetReconnectAttempts();
      
      // Notify listeners that connection is restored
      onConnectionRestored?.call();
    } catch (e) {
      _logger.e('Failed to establish WebSocket connection: $e');
      _updateConnectionStatus(WebSocketStatus.error);
      _scheduleReconnect('reconnect');
      rethrow;
    }
  }

  /// Handle app resume/foreground
  void onAppResumed() {
    if (_connectionStatus.value != WebSocketStatus.connected) {
      _ensureConnected();
    }
  }

  /// Reconnect to all active WebSocket connections
  Future<void> _reconnect() async {
    _logger.i('Attempting to reconnect WebSockets...');
    try {
      if (_pendingChatStatsConnection) {
        await _connectToChatStats();
      }
      if (_pendingGlobalRoomConnection) {
        await _connectToGlobalRoom();
      }
      if (_currentConversationId != null) {
        _connectToConversationChannel(_currentConversationId!);
      }
      
      // Notify that connection is restored
      onConnectionRestored?.call();
    } catch (e) {
      _logger.e('Error during WebSocket reconnection: $e');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(const Duration(seconds: 5), _reconnect);
    }
  }

  /// Update connection status and notify listeners
  void _updateConnectionStatus(WebSocketStatus status) {
    if (_connectionStatus.value != status) {
      _connectionStatus.value = status;
      if (kDebugMode) {
        print('[WebSocketService] Status: $status');
      }
    }
  }

  /// Start sending heartbeat pings
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _sendHeartbeat();
    });
  }

  /// Stop the heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Reset reconnect attempts counter
  @visibleForTesting
  void resetReconnectAttempts() {
    _reconnectAttempts = 0;
  }

  /// Schedule a reconnection attempt
  void _scheduleReconnect(String connectionId) {
    if (kDebugMode) {
      print('[WebSocketService._scheduleReconnect] Scheduling reconnect for: $connectionId');
      print('[WebSocketService._scheduleReconnect] Current _currentConversationId: $_currentConversationId');
      print('[WebSocketService._scheduleReconnect] Backup _lastConversationId: $_lastConversationId');
      print('[WebSocketService._scheduleReconnect] Attempt count: $_reconnectAttempts');
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        print('[WebSocketService] Max reconnection attempts reached for $connectionId');
      }
      _updateConnectionStatus(WebSocketStatus.error);
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay * (_reconnectAttempts + 1), () async {
      _reconnectAttempts++;
      if (kDebugMode) {
        print('[WebSocketService] Reconnecting to $connectionId (attempt $_reconnectAttempts)');
        print('[WebSocketService] _currentConversationId during reconnect: $_currentConversationId');
        print('[WebSocketService] _lastConversationId during reconnect: $_lastConversationId');
      }
      _updateConnectionStatus(WebSocketStatus.reconnecting);

      try {
        if (connectionId == _chatStatsId) {
          await _connectToChatStats();
        } else if (connectionId == _globalRoomId) {
          await _connectToGlobalRoom();
        } else if (connectionId == _currentConversationId || connectionId == _lastConversationId) {
          // Reconnect to conversation using either current or backup ID
          final targetId = _currentConversationId ?? _lastConversationId;
          if (targetId != null) {
            await connectToConversation(targetId);
          }
        } else if (connectionId == 'unknown' || connectionId == 'reconnect') {
          // For unknown/reconnect, restore all connections including conversation
          await _ensureConnected();
          // Also explicitly reconnect to conversation if we have a backup ID
          if (_lastConversationId != null && _currentConversationId == null) {
            await connectToConversation(_lastConversationId!);
          }
        } else {
          await _ensureConnected();
        }

        if (_connectionStatus.value == WebSocketStatus.connected) {
          resetReconnectAttempts();
        }
      } catch (e) {
        if (kDebugMode) {
          print('[WebSocketService] Reconnection attempt failed: $e');
        }
        _updateConnectionStatus(WebSocketStatus.error);
        _scheduleReconnect(connectionId);
      }
    });
  }

  /// Initialize the WebSocket service with authentication token
  Future<void> initialize(
    String authToken, {
    bool connectStats = false,
    bool connectGlobal = false,
  }) async {
    try {
      // Skip re-initialization if already connected with the same token
      if (_authToken == authToken && 
          _connectionStatus.value == WebSocketStatus.connected &&
          _chatStatsConnected == connectStats &&
          _globalRoomConnected == connectGlobal) {
        if (kDebugMode) {
          print('[WebSocketService] Already initialized with same token and connections, skipping');
        }
        return;
      }

      // Only reset if token changed or we need to change connection configuration
      final shouldReset = _authToken != authToken || 
                          _chatStatsConnected != connectStats ||
                          _globalRoomConnected != connectGlobal;
      
      _authToken = authToken;
      _pendingChatStatsConnection = connectStats;
      _pendingGlobalRoomConnection = connectGlobal;

      if (shouldReset) {
        _resetConnectionState();
      }

      _setupConnectivityListener();

      if (_authToken == null || _authToken!.isEmpty) {
        _logger.w('WebSocket initialization skipped: No auth token provided.');
        return;
      }

      // Check connectivity before attempting connection
      final connectivityService = Get.find<ConnectivityService>();
      if (!connectivityService.isConnected) {
        // Wait briefly for connectivity check to complete (it may be in progress)
        final hasConnection = await connectivityService.waitForConnection(
          timeout: const Duration(seconds: 5),
        );
        if (!hasConnection) {
          _logger.w('WebSocket initialization delayed: No internet connection');
          _updateConnectionStatus(WebSocketStatus.disconnected);
          return;
        }
      }

      if (connectStats) {
        await _connectToChatStats();
        _chatStatsConnected = true;
      }

      if (connectGlobal) {
        await _connectToGlobalRoom();
        _globalRoomConnected = true;
      }

      _startHeartbeat();
    } catch (e) {
      _updateConnectionStatus(WebSocketStatus.error);
      if (_authToken != null && _authToken!.isNotEmpty) {
        _scheduleReconnect('init');
      }
      rethrow;
    }
  }
  
  /// Setup listener for connectivity changes with DEBOUNCING
  /// This prevents rapid reconnection attempts when connectivity fluctuates
  void _setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    final connectivityService = Get.find<ConnectivityService>();
    _connectivitySubscription = connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.connected) {
        // DEBOUNCE: Wait 3 seconds before reconnecting to avoid rapid toggling
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          if (_connectionStatus.value != WebSocketStatus.connected) {
            _logger.i('Internet restored - debounced reconnect starting');
            _onInternetRestored();
          }
        });
      }
    });
  }
  
  /// Handle internet restoration - reconnect pending WebSocket connections
  void _onInternetRestored() {
    if (_authToken == null || _authToken!.isEmpty) return;
    if (_connectionStatus.value == WebSocketStatus.connected) return;
    
    _logger.i('Auto-reconnecting WebSocket after internet restoration');
    
    if (_pendingChatStatsConnection && !_chatStatsConnected) {
      _connectToChatStats().catchError((e) {
        _logger.e('Auto-reconnect chat stats failed: $e');
      });
    }
    
    if (_pendingGlobalRoomConnection && !_globalRoomConnected) {
      _connectToGlobalRoom().catchError((e) {
        _logger.e('Auto-reconnect global room failed: $e');
      });
    }
    
    if (_currentConversationId != null && _conversationChannel == null) {
      connectToConversation(_currentConversationId!).catchError((e) {
        _logger.e('Auto-reconnect conversation failed: $e');
      });
    }
  }

  /// Connect to chat stats WebSocket if not already connected
  Future<void> _connectToChatStats() async {
    if (_chatStatsConnected && _chatStatsChannel != null) {
      return;
    }
    if (_authToken == null || _authToken!.isEmpty) {
      _logger.w('Cannot connect to chat stats: No auth token');
      return;
    }

    await _chatStatsChannel?.sink.close();

    try {
      final url = ApiRoutes.chatStatsWebSocketUrl(_authToken ?? '');
      _chatStatsChannel = _createWebSocketChannel(
        url, 
        (data) {
          if (!_chatStatsController.isClosed) {
            _chatStatsController.add(data);
          }
        },
      );
      if (kDebugMode) {
        print('[WebSocketService] Connected to chat stats WebSocket');
      }
    } catch (e) {
      _logger.e('Failed to connect to chat stats WebSocket: $e');
      _reconnect();
    }
  }

  /// Connect to the global room WebSocket if not already connected
  Future<void> _connectToGlobalRoom() async {
    if (_globalRoomConnected && _globalRoomChannel != null) {
      return;
    }
    if (_authToken == null || _authToken!.isEmpty) {
      _logger.w('Cannot connect to global room: No auth token');
      return;
    }

    await _globalRoomChannel?.sink.close();

    try {
      final url = ApiRoutes.chatGlobalRoomWebSocketUrl(_authToken ?? '');
      _globalRoomChannel = _createWebSocketChannel(
        url,
        (data) {
          if (!_globalEventController.isClosed) {
            _globalEventController.add(data);
          }
        },
      );
      if (kDebugMode) {
        print('[WebSocketService] Connected to global room WebSocket');
      }
    } catch (e) {
      _logger.e('Failed to connect to global room WebSocket: $e');
      _reconnect();
    }
  }

  /// Setup listeners for WebSocket channel
  void _setupSocketListeners(
    WebSocketChannel channel,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    channel.stream.listen(
      (dynamic message) {
        _logger.i('WebSocket message received: $message');
        final Map<String, dynamic> data;
        if (message is String) {
          data = jsonDecode(message) as Map<String, dynamic>;
          onMessage(data);
        } else if (message is Map<String, dynamic>) {
          data = message;
          onMessage(data);
        }
      },
      onDone: () {
        _logger.w('WebSocket connection closed');
        _updateConnectionStatus(WebSocketStatus.disconnected);
        if (!_isManuallyDisconnecting) {
          _scheduleReconnect('unknown');
        }
      },
      onError: (error) {
        _logger.e('WebSocket error: $error');
        _updateConnectionStatus(WebSocketStatus.error);
        if (!_isManuallyDisconnecting) {
          _scheduleReconnect('unknown');
        }
      },
      cancelOnError: true,
    );
  }

  /// Send a message through a conversation's WebSocket
  Future<void> sendMessage({
    required Map<String, dynamic> message,
    required String conversationId,
  }) async {
    try {
      final messageJson = jsonEncode(message);

      // Debug logging
      if (kDebugMode) {
        print('[WebSocketService.sendMessage] Target: $conversationId');
        print('[WebSocketService.sendMessage] _conversationChannel: $_conversationChannel');
        print('[WebSocketService.sendMessage] _currentConversationId: $_currentConversationId');
        print('[WebSocketService.sendMessage] _conversationChannel?.closeCode: ${_conversationChannel?.closeCode}');
        print('[WebSocketService.sendMessage] _globalRoomChannel: $_globalRoomChannel');
        print('[WebSocketService.sendMessage] _globalRoomChannel?.closeCode: ${_globalRoomChannel?.closeCode}');
      }

      // Try conversation-specific channel first, but verify it matches the target conversation
      if (_conversationChannel != null &&
          _conversationChannel!.closeCode == null &&
          _currentConversationId == conversationId) {
        _conversationChannel!.sink.add(messageJson);
        _logger.i('Message sent to conversation WebSocket: $conversationId');
        return;
      }

      // Log why conversation channel was not used
      if (kDebugMode) {
        if (_conversationChannel == null) {
          print('[WebSocketService.sendMessage] Conversation channel is null');
        } else if (_conversationChannel!.closeCode != null) {
          print('[WebSocketService.sendMessage] Conversation channel is closed (code: ${_conversationChannel!.closeCode})');
        } else if (_currentConversationId != conversationId) {
          print('[WebSocketService.sendMessage] Conversation ID mismatch: connected to $_currentConversationId, trying to send to $conversationId');
        }
      }

      // Fall back to global room channel if available
      if (_globalRoomChannel != null && _globalRoomChannel!.closeCode == null) {
        _globalRoomChannel!.sink.add(messageJson);
        _logger.i('Message sent to global room WebSocket (fallback)');
        return;
      }

      throw Exception('No WebSocket channel available (conversation or global)');
    } catch (e) {
      _logger.e('Failed to send WebSocket message: $e');
      rethrow;
    }
  }

  /// Send a heartbeat ping to the server
  void _sendHeartbeat() {
    try {
      final ping = jsonEncode({'command': 'ping'});
      if (_chatStatsChannel != null && _chatStatsChannel!.closeCode == null) {
        _chatStatsChannel!.sink.add(ping);
      }
      if (_globalRoomChannel != null && _globalRoomChannel!.closeCode == null) {
        _globalRoomChannel!.sink.add(ping);
      }
      if (_conversationChannel != null && _conversationChannel!.closeCode == null) {
        _conversationChannel!.sink.add(ping);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[WebSocketService] Error sending heartbeat: $e');
      }
    }
  }

  /// Connect to a specific conversation channel, disconnecting from any previous one.
  WebSocketChannel _connectToConversationChannel(String conversationId) {
    if (kDebugMode) {
      print('[WebSocketService._connectToConversationChannel] Starting connection for: $conversationId');
      print('[WebSocketService._connectToConversationChannel] Current _currentConversationId: $_currentConversationId');
      print('[WebSocketService._connectToConversationChannel] Current _conversationChannel: $_conversationChannel');
    }

    if (_currentConversationId == conversationId && _conversationChannel != null) {
      if (kDebugMode) {
        print('[WebSocketService._connectToConversationChannel] Already connected, returning existing channel');
      }
      return _conversationChannel!;
    }

    if (_currentConversationId != null) {
      if (kDebugMode) {
        print('[WebSocketService._connectToConversationChannel] Disconnecting from previous: $_currentConversationId');
      }
      disconnectFromConversation(_currentConversationId!);
    }

    try {
      final url = ApiRoutes.getChatRoomWebSocketUrl(conversationId, _authToken ?? '');
      if (kDebugMode) {
        print('[WebSocketService._connectToConversationChannel] Connecting to URL: $url');
      }

      final channel = _createWebSocketChannel(
        url,
        (data) {
          if (kDebugMode) {
            print('[WebSocketService._connectToConversationChannel] Message received on conversation $conversationId: $data');
          }
          if (!_conversationController.isClosed) {
            _conversationController.add(data);
          }
        },
      );

      _conversationChannel = channel;
      _currentConversationId = conversationId;
      _lastConversationId = conversationId; // Also update backup
      if (kDebugMode) {
        print('[WebSocketService._connectToConversationChannel] Connection established. _conversationChannel set: $_conversationChannel, _currentConversationId set: $_currentConversationId, _lastConversationId set: $_lastConversationId');
      }

      return channel;
    } catch (e) {
      _logger.e('Failed to connect to conversation WebSocket: $e');
      if (kDebugMode) {
        print('[WebSocketService._connectToConversationChannel] Connection failed with error: $e');
      }
      rethrow;
    }
  }

  /// Connect to a specific conversation WebSocket
  Future<void> connectToConversation(String conversationId) async {
    if (kDebugMode) {
      print('[WebSocketService.connectToConversation] Called for: $conversationId');
    }

    if (_currentConversationId == conversationId && _conversationChannel != null) {
      if (kDebugMode) {
        print('[WebSocketService.connectToConversation] Already connected to $conversationId, skipping');
      }
      return;
    }

    try {
      final channel = _connectToConversationChannel(conversationId);
      if (kDebugMode) {
        print('[WebSocketService.connectToConversation] Connected to conversation: $conversationId, channel: $channel');
      }
      _logger.i('Connected to conversation: $conversationId');
    } catch (e) {
      _logger.e('Failed to connect to conversation $conversationId: $e');
      if (kDebugMode) {
        print('[WebSocketService.connectToConversation] Failed to connect: $e');
      }
      rethrow;
    }
  }

  /// Disconnect from a specific conversation's WebSocket
  Future<void> disconnectFromConversation(String conversationId) async {
    if (kDebugMode) {
      print('[WebSocketService.disconnectFromConversation] Called for: $conversationId');
      print('[WebSocketService.disconnectFromConversation] Current _currentConversationId: $_currentConversationId');
    }

    if (_currentConversationId != conversationId) {
      if (kDebugMode) {
        print('[WebSocketService.disconnectFromConversation] Skipping - ID mismatch. Current: $_currentConversationId, Requested: $conversationId');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('[WebSocketService.disconnectFromConversation] Closing channel and clearing state');
      }
      await _conversationChannel?.sink.close();
      _conversationChannel = null;
      _lastConversationId = _currentConversationId; // Preserve for reconnection
      _currentConversationId = null;
      _logger.i('Disconnected from conversation: $conversationId (preserved ID: $_lastConversationId)');
    } catch (e) {
      _logger.e('Error disconnecting from conversation $conversationId: $e');
      rethrow;
    }
  }

  /// Disconnect all WebSocket connections
  Future<void> disconnect() async {
    _isManuallyDisconnecting = true;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _debounceTimer?.cancel();
    try {
      await _chatStatsChannel?.sink.close();
      await _globalRoomChannel?.sink.close();
      await _conversationChannel?.sink.close();
      _conversationChannel = null;
      _lastConversationId = _currentConversationId; // Preserve for reconnection
      _currentConversationId = null;

      _updateConnectionStatus(WebSocketStatus.disconnected);
      if (kDebugMode) {
        print('[WebSocketService] All WebSocket connections disconnected');
      }
    } catch (e) {
      _logger.e('Error disconnecting WebSocket connections: $e');
      rethrow;
    } finally {
      _isManuallyDisconnecting = false;
    }
  }

  /// Only reset connection state, NEVER recreate stream controllers
  void _resetConnectionState() {
    if (kDebugMode) {
      print('[WebSocketService._resetConnectionState] Resetting connection state');
      print('[WebSocketService._resetConnectionState] Current _currentConversationId: $_currentConversationId');
      print('[WebSocketService._resetConnectionState] Current _conversationChannel: $_conversationChannel');
      print('[WebSocketService._resetConnectionState] Stack trace:');
      print(StackTrace.current);
    }
    _isManuallyDisconnecting = true;

    try {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = null;
      _debounceTimer?.cancel();
      
      _reconnectTimer?.cancel();
      _chatStatsChannel?.sink.close().catchError((_) {});
      _globalRoomChannel?.sink.close().catchError((_) {});
      _conversationChannel?.sink.close().catchError((_) {});

      _chatStatsChannel = null;
      _globalRoomChannel = null;
      _conversationChannel = null;
      // Preserve _lastConversationId for reconnection - don't clear it here
      _currentConversationId = null;
      _reconnectAttempts = 0;
      _chatStatsConnected = false;
      _globalRoomConnected = false;
      _connectionStatus.value = WebSocketStatus.disconnected;

      _stopHeartbeat();
    } finally {
      _isManuallyDisconnecting = false;
    }
  }

  @override
  void onClose() {
    if (kDebugMode) {
      print('[WebSocketService] Permanently closing WebSocketService');
    }
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    disconnect();
    if (!_chatStatsController.isClosed) {
      _chatStatsController.close();
    }
    if (!_globalEventController.isClosed) {
      _globalEventController.close();
    }
    if (!_conversationController.isClosed) {
      _conversationController.close();
    }
    super.onClose();
  }
}
