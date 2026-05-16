import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'api_client.dart';

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

/// Model for queued GET requests that failed due to no internet
class QueuedRequest {
  final String id;
  final String path;
  final Map<String, dynamic>? queryParameters;
  final dio.Options? options;
  final Completer<dio.Response> completer;
  final DateTime queuedAt;
  int retryCount;

  QueuedRequest({
    required this.id,
    required this.path,
    this.queryParameters,
    this.options,
    required this.completer,
    this.retryCount = 0,
  }) : queuedAt = DateTime.now();
}

/// Simple and reliable connectivity service
/// Features:
/// - OS-level connectivity detection (no periodic URL pinging)
/// - GET request queue for failed requests
/// - Auto-retry when connection restored
/// - Restoration stream for UI auto-refresh
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

  // Queue for failed GET requests to retry when connection restored
  final List<QueuedRequest> _requestQueue = [];
  final _queueLock = Object();
  bool _isProcessingQueue = false;
  
  // Stream to notify when connection is restored (for UI auto-refresh)
  final StreamController<void> _connectionRestoredController = StreamController<void>.broadcast();
  Stream<void> get onConnectionRestored => _connectionRestoredController.stream;

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
    // Note: No periodic health check - we only rely on OS-level connectivity changes
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    if (!_statusController.isClosed) {
      _statusController.close();
    }
    if (!_connectionRestoredController.isClosed) {
      _connectionRestoredController.close();
    }
    // Cancel any pending completers in queue
    for (final request in _requestQueue) {
      if (!request.completer.isCompleted) {
        request.completer.completeError(
          dio.DioException(
            requestOptions: dio.RequestOptions(path: request.path),
            type: dio.DioExceptionType.connectionError,
            error: 'Service disposed while request was queued',
          ),
        );
      }
    }
    _requestQueue.clear();
    super.onClose();
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    try {
      // Check current connectivity immediately
      await _checkCurrentConnectivity();

      // Listen to connectivity changes from the system
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
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
      await _handleConnectivityChange(results);
    } catch (e) {
      _updateStatus(ConnectivityStatus.disconnected, 'Failed to check connectivity', force: true);
    }
  }

  /// Handle connectivity changes - now processes all results from the list
  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    // Debug logging
    if (kDebugMode) {
      print('[ConnectivityService] Raw results: $results');
    }

    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      _updateStatus(ConnectivityStatus.disconnected, 'No internet connection', force: true);
      _hasInternet.value = false;
      if (kDebugMode) {
        print('[ConnectivityService] DISCONNECTED - no active connections');
      }
      return;
    }

    // Check if any active connection exists
    final hasActiveConnection = results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);

    if (!hasActiveConnection) {
      // No active connection - we're disconnected
      _updateStatus(ConnectivityStatus.disconnected, 'No internet connection', force: true);
      _hasInternet.value = false;
      if (kDebugMode) {
        print('[ConnectivityService] DISCONNECTED - only other/bluetooth/none');
      }
      return;
    }

    // We have an active connection type, verify internet actually works
    _updateStatus(ConnectivityStatus.checking, 'Network available, checking internet...', force: false);
    final wasConnected = _hasInternet.value;
    await _verifyInternetConnection();

    // If we just reconnected, process queue and notify listeners
    if (_hasInternet.value && !wasConnected) {
      _connectionRestoredController.add(null);
      processQueue();
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

  /// Add a GET request to the queue for retry when connection is restored
  /// Returns a Future that completes when the request is eventually successful
  /// or fails permanently after retries
  Future<dio.Response<T>> queueRequest<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    final completer = Completer<dio.Response<T>>();
    final request = QueuedRequest(
      id: '${DateTime.now().millisecondsSinceEpoch}_$path',
      path: path,
      queryParameters: queryParameters,
      options: options,
      completer: completer as Completer<dio.Response>,
    );

    synchronized(_queueLock, () {
      _requestQueue.add(request);
      _logger.i('Queued GET request: $path (Queue size: ${_requestQueue.length})');
    });

    return completer.future;
  }

  /// Process all queued requests when connection is restored
  /// Called automatically when connection is restored
  Future<void> processQueue() async {
    if (_isProcessingQueue) return;
    if (!isConnected) {
      _logger.w('Cannot process queue: No internet connection');
      return;
    }

    _isProcessingQueue = true;
    _logger.i('Processing request queue (${_requestQueue.length} items)');

    final List<QueuedRequest> requestsToProcess = [];
    synchronized(_queueLock, () {
      requestsToProcess.addAll(_requestQueue);
      _requestQueue.clear();
    });

    final apiClient = Get.find<ApiClient>();
    int successCount = 0;
    int failCount = 0;

    for (final request in requestsToProcess) {
      if (request.completer.isCompleted) continue;

      try {
        final response = await apiClient.get<dynamic>(
          request.path,
          queryParameters: request.queryParameters,
          options: request.options,
        );

        if (!request.completer.isCompleted) {
          request.completer.complete(response);
          successCount++;
        }
      } catch (e) {
        if (!request.completer.isCompleted) {
          if (e is dio.DioException) {
            request.completer.completeError(e);
          } else {
            request.completer.completeError(
              dio.DioException(
                requestOptions: dio.RequestOptions(path: request.path),
                type: dio.DioExceptionType.unknown,
                error: e,
              ),
            );
          }
          failCount++;
        }
      }
    }

    _logger.i('Queue processing complete: $successCount succeeded, $failCount failed');
    _isProcessingQueue = false;

    // If any requests remain (shouldn't happen, but just in case), add them back
    if (_requestQueue.isNotEmpty) {
      _logger.w('Some requests were added during processing, will retry on next connection');
    }
  }

  /// Get current queue size (for debugging/UI display)
  int get queuedRequestCount => _requestQueue.length;

  /// Check if there are pending queued requests
  bool get hasQueuedRequests => _requestQueue.isNotEmpty;

  /// Clear all queued requests (useful for logout/reset scenarios)
  void clearQueue() {
    synchronized(_queueLock, () {
      for (final request in _requestQueue) {
        if (!request.completer.isCompleted) {
          request.completer.completeError(
            dio.DioException(
              requestOptions: dio.RequestOptions(path: request.path),
              type: dio.DioExceptionType.cancel,
              error: 'Request cancelled - queue cleared',
            ),
          );
        }
      }
      _requestQueue.clear();
    });
    _logger.i('Request queue cleared');
  }

  /// Get detailed connection information
  Map<String, dynamic> getConnectionInfo() {
    return {
      'status': _status.value.name,
      'isConnected': _hasInternet.value,
      'message': _connectionMessage.value,
      'queuedRequests': _requestQueue.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Simple synchronized block helper
void synchronized(Object lock, VoidCallback action) {
  // In Dart, this is just a marker - actual synchronization happens via isolates
  // For single-threaded Dart, this is sufficient for our purposes
  action();
}
