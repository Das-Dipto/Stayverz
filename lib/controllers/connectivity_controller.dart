import 'dart:async';

import 'package:get/get.dart';

import '../services/network/connectivity_service.dart';

/// Controller for connectivity state - no UI logic here.
/// UI is handled by ConnectivityListener using ConnectivityPopupManager.
class ConnectivityController extends GetxController {
  static ConnectivityController get to => Get.find();

  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();

  // Reactive state only - no UI flags
  final RxBool _isRetrying = false.obs;
  final RxInt _queuedRequestCount = 0.obs;

  // Getters
  bool get isConnected => _connectivityService.isConnected;
  bool get isDisconnected => _connectivityService.isDisconnected;
  String get connectionMessage => _connectivityService.connectionMessage;
  bool get isRetrying => _isRetrying.value;
  int get queuedRequestCount => _queuedRequestCount.value;
  bool get hasQueuedRequests => _queuedRequestCount.value > 0;
  
  /// Stream that emits when connection is restored - use for auto-refresh
  Stream<void> get onConnectionRestored => _connectivityService.onConnectionRestored;

  @override
  void onInit() {
    super.onInit();
  }

  /// Manually check connectivity
  Future<bool> checkConnectivity() async {
    return await _connectivityService.checkConnection();
  }

  /// Retry connection with loading state
  /// UI feedback handled by ConnectivityPopupManager
  Future<void> retryConnection() async {
    _isRetrying.value = true;
    update();

    final isConnected = await checkConnectivity();

    _isRetrying.value = false;
    update();

    // No snackbars - UI handled by ConnectivityPopupManager
  }

  /// Wait for internet connection
  Future<bool> waitForConnection({Duration? timeout}) async {
    return await _connectivityService.waitForConnection(
      timeout: timeout ?? const Duration(seconds: 120),
    );
  }

  /// Get detailed connection information
  Map<String, dynamic> getConnectionInfo() {
    return _connectivityService.getConnectionInfo();
  }

  /// Process all queued GET requests when connection is restored
  /// Call this from retry button or when connection is manually restored
  Future<void> processQueue() async {
    _isRetrying.value = true;
    update();

    await _connectivityService.processQueue();
    _updateQueueCount();

    _isRetrying.value = false;
    update();
  }

  /// Clear all queued requests (useful for logout)
  void clearQueue() {
    _connectivityService.clearQueue();
    _updateQueueCount();
    update();
  }

  /// Update the reactive queue count from service
  void _updateQueueCount() {
    _queuedRequestCount.value = _connectivityService.queuedRequestCount;
  }

  /// Refresh queue count - call periodically or when needed
  void refreshQueueCount() {
    _updateQueueCount();
  }
}

// Hello I am Tamim