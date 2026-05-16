import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Connectivity status enum
enum ConnectivityStatus {
  connected,
  disconnected,
  checking,
}

/// Network type enum
enum NetworkType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}

/// Simple and reliable connectivity service
/// FIXED: Only emits status changes when connectivity actually changes
class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final Logger _logger = Get.find<Logger>();
  final Connectivity _connectivity = Connectivity();

  // Stream controllers
  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Reactive variables
  final Rx<ConnectivityStatus> _status = ConnectivityStatus.checking.obs;
  final RxBool _hasInternet = false.obs;
  final RxString _connectionMessage = 'Checking connection...'.obs;

  // Timer for health checks - only logs, doesn't broadcast if status unchanged
  Timer? _healthCheckTimer;
  static const Duration healthCheckInterval = Duration(seconds: 30); // Increased from 2s to 30s

  // Track last known state to prevent duplicate broadcasts
  ConnectivityStatus _lastBroadcastStatus = ConnectivityStatus.checking;
  bool _lastInternetState = false;
  DateTime _lastStatusChange = DateTime.now();

  // Getters
  ConnectivityStatus get status => _status.value;
  bool get isConnected => _hasInternet.value;
  RxBool get isConnectedStream => _hasInternet;
  bool get hasInternet => _hasInternet.value;
  bool get isDisconnected => _status.value == ConnectivityStatus.disconnected;
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;
  String get connectionMessage => _connectionMessage.value;
  NetworkType get networkType => NetworkType.none;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    _startHealthCheck();
  }

  @override
  void onClose() {
    _healthCheckTimer?.cancel();
    _connectivitySubscription?.cancel();
    if (!_statusController.isClosed) {
      _statusController.close();
    }
    super.onClose();
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    try {
      // Check current connectivity immediately
      await _checkCurrentConnectivity();

      // Listen to connectivity changes from the system
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        if (results.isNotEmpty) {
          _handleConnectivityChange(results.first);
        }
      });
    } catch (e) {
      _updateStatus(ConnectivityStatus.disconnected, 'Failed to initialize connectivity', force: true);
    }
  }

  /// Check current connectivity status
  Future<void> _checkCurrentConnectivity() async {
    try {
      _updateStatus(ConnectivityStatus.checking, 'Checking connection...', force: false);

      final results = await _connectivity.checkConnectivity();
      if (results.isNotEmpty) {
        await _handleConnectivityChange(results.first);
      }
    } catch (e) {
      _updateStatus(ConnectivityStatus.disconnected, 'Failed to check connectivity', force: true);
    }
  }

  /// Handle connectivity changes
  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        _updateStatus(ConnectivityStatus.checking, 'Network available, checking internet...', force: false);
        await _verifyInternetConnection();
        break;
      case ConnectivityResult.none:
        _updateStatus(ConnectivityStatus.disconnected, 'No internet connection', force: true);
        _hasInternet.value = false;
        break;
    }
  }

  /// Verify actual internet connection (not just network availability)
  Future<bool> _verifyInternetConnection() async {
    try {
      // Try to reach Google with short timeout
      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 3));
        final response = await request.close()
            .timeout(const Duration(seconds: 3));
        client.close();

        if (response.statusCode == 200) {
          _updateStatus(ConnectivityStatus.connected, 'Connected to internet', force: true);
          _hasInternet.value = true;
          return true;
        }
      } catch (e) {
        // Silent fail, try next
      }

      // If Google fails, try Cloudflare
      try {
        final client2 = HttpClient();
        final request2 = await client2.getUrl(Uri.parse('https://www.cloudflare.com'))
            .timeout(const Duration(seconds: 3));
        final response2 = await request2.close()
            .timeout(const Duration(seconds: 3));
        client2.close();

        if (response2.statusCode == 200) {
          _updateStatus(ConnectivityStatus.connected, 'Connected to internet', force: true);
          _hasInternet.value = true;
          return true;
        }
      } catch (e) {
        // Silent fail
      }

      _updateStatus(ConnectivityStatus.disconnected, 'Network available but no internet access', force: true);
      _hasInternet.value = false;
      return false;
    } catch (e) {
      _updateStatus(ConnectivityStatus.disconnected, 'Failed to verify internet connection', force: true);
      _hasInternet.value = false;
      return false;
    }
  }

  /// Start periodic health check - only verifies connection, doesn't spam status updates
  void _startHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(healthCheckInterval, (timer) {
      // Only verify connection in background, don't broadcast unless status actually changed
      _silentHealthCheck();
    });
  }

  /// Silent health check - only updates status if it actually changed
  Future<void> _silentHealthCheck() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return;
      
      final result = results.first;
      
      // Quick check - if we have a connection, verify it's still working
      if (_hasInternet.value && result != ConnectivityResult.none) {
        final hasInternet = await _quickInternetCheck();
        if (!hasInternet && _hasInternet.value) {
          // Internet was lost
          _updateStatus(ConnectivityStatus.disconnected, 'Internet connection lost', force: true);
          _hasInternet.value = false;
        }
      } else if (!_hasInternet.value && result != ConnectivityResult.none) {
        // We didn't have internet but now have a network - check if internet is back
        await _verifyInternetConnection();
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ConnectivityService] Health check error: $e');
      }
    }
  }

  /// Quick internet check without status updates
  Future<bool> _quickInternetCheck() async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 2));
      final response = await request.close()
          .timeout(const Duration(seconds: 2));
      client.close();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Manual connectivity check
  Future<bool> checkConnection() async {
    await _checkCurrentConnectivity();
    return _hasInternet.value;
  }

  /// Wait for internet connection
  Future<bool> waitForConnection({Duration timeout = const Duration(seconds: 30)}) async {
    if (isConnected) return true;

    final completer = Completer<bool>();
    
    StreamSubscription? subscription;
    subscription = statusStream.listen((status) {
      if (status == ConnectivityStatus.connected) {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
    });

    Timer(timeout, () {
      subscription?.cancel();
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  /// Update status and notify listeners - only broadcasts if status actually changed
  void _updateStatus(ConnectivityStatus status, String message, {required bool force}) {
    if (_statusController.isClosed) return;
    
    _status.value = status;
    _connectionMessage.value = message;
    
    // Only broadcast to stream if:
    // 1. force is true (actual connectivity change)
    // 2. OR status is different from last broadcast
    final bool shouldBroadcast = force || status != _lastBroadcastStatus;
    
    if (shouldBroadcast) {
      _lastBroadcastStatus = status;
      _lastStatusChange = DateTime.now();
      _statusController.add(status);
      
      if (kDebugMode) {
        print('[ConnectivityService] Status broadcast: $status - $message');
      }
    } else {
      // Just log locally without broadcasting
      if (kDebugMode && status != ConnectivityStatus.checking) {
        print('[ConnectivityService] Status unchanged: $status');
      }
    }
    
    // Always log via logger for debugging
    _logger.i('Connectivity Status: $status - $message');
  }

  /// Get detailed connection information
  Map<String, dynamic> getConnectionInfo() {
    return {
      'status': _status.value.name,
      'isConnected': _hasInternet.value,
      'message': _connectionMessage.value,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
