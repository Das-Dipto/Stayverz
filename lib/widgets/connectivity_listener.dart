import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/network/connectivity_service.dart';
import '../services/network/connectivity_popup_manager.dart';

/// Single source of truth for connectivity UI.
/// Wraps the app and shows no-internet popup when disconnected.
class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();

  /// Call this before navigation to prevent connectivity popup conflicts
  static void markNavigation() {
    _ConnectivityListenerState? state;
    try {
      state = Get.find<_ConnectivityListenerState>();
    } catch (_) {
      // State not registered yet, ignore
      return;
    }
    state.markNavigation();
  }
}

class _ConnectivityListenerState extends State<ConnectivityListener>
    with WidgetsBindingObserver {
  Worker? _worker;
  final _popupManager = ConnectivityPopupManager();
  Timer? _disconnectDebounceTimer;
  bool _isAppResuming = false;
  DateTime? _lastNavigationTime;
  static const _debounceDuration = Duration(seconds: 1);
  static const _navigationCooldown = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Register state with GetX for static access
    if (!Get.isRegistered<_ConnectivityListenerState>()) {
      Get.put<_ConnectivityListenerState>(this, permanent: true);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConnectivityListener();
    });
  }

  /// Call this when navigation occurs to prevent popup conflicts
  void markNavigation() {
    _lastNavigationTime = DateTime.now();
  }

  bool get _isInNavigationCooldown {
    if (_lastNavigationTime == null) return false;
    return DateTime.now().difference(_lastNavigationTime!) < _navigationCooldown;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _worker?.dispose();
    _disconnectDebounceTimer?.cancel();
    // Unregister from GetX
    if (Get.isRegistered<_ConnectivityListenerState>()) {
      Get.delete<_ConnectivityListenerState>();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App resumed from background - set flag to prevent false positive
      _isAppResuming = true;
      // Clear flag after debounce period
      Future.delayed(_debounceDuration, () {
        if (mounted) {
          setState(() => _isAppResuming = false);
        }
      });
    }
  }

  void _initConnectivityListener() async {
    final service = Get.find<ConnectivityService>();

    // Wait for initial connectivity check to complete (avoid showing popup during startup)
    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (service.status != ConnectivityStatus.checking) break;
    }

    // Listen to connectivity changes with debounce
    _worker = ever(service.isConnectedStream, (bool isConnected) {
      if (kDebugMode) {
        print('[ConnectivityListener] Stream received: isConnected=$isConnected, status=${service.status}');
      }

      if (!isConnected) {
        if (kDebugMode) {
          print('[ConnectivityListener] Disconnected detected, starting debounce timer...');
        }
        // Debounce showing popup - only show if disconnected for sustained period
        _disconnectDebounceTimer?.cancel();
        _disconnectDebounceTimer = Timer(_debounceDuration, () {
          if (kDebugMode) {
            print('[ConnectivityListener] Debounce completed, checking conditions...');
          }
          // Double-check conditions before showing
          if (mounted &&
              !service.isConnected &&
              service.status == ConnectivityStatus.disconnected &&
              !_isAppResuming &&
              !_isInNavigationCooldown) {
            if (kDebugMode) {
              print('[ConnectivityListener] Showing no internet popup');
            }
            _popupManager.showNoInternetPopup(
              onRetry: () {
                // Check connection first, then process any queued requests
                service.checkConnection().then((isConnected) {
                  if (isConnected) {
                    // If we have connection now, process the queued requests
                    service.processQueue();
                  }
                });
              },
              message: service.connectionMessage,
            );
          } else {
            if (kDebugMode) {
              print('[ConnectivityListener] Conditions not met - mounted=$mounted, isConnected=${service.isConnected}, status=${service.status}, _isAppResuming=$_isAppResuming, _isInNavigationCooldown=$_isInNavigationCooldown');
            }
          }
        });
      } else {
        if (kDebugMode) {
          print('[ConnectivityListener] Connected detected, closing popup if open');
        }
        // Cancel debounce timer and close popup immediately on reconnect
        _disconnectDebounceTimer?.cancel();
        _popupManager.closeOnConnectionRestored();
      }
    });

    // Check initial state only after check completed
    if (!service.isConnected &&
        service.status == ConnectivityStatus.disconnected &&
        !_isInNavigationCooldown) {
      _popupManager.showNoInternetPopup(
        onRetry: () {
          service.checkConnection().then((isConnected) {
            if (isConnected) {
              service.processQueue();
            }
          });
        },
        message: service.connectionMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
// Hello I am Tamim