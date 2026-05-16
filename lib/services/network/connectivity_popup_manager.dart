import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart' show globalNavigatorKey;

/// Centralized singleton service to manage connectivity popup state
/// Prevents duplicate popups from multiple sources (Listener, Controller, Interceptor)
class ConnectivityPopupManager {
  static final ConnectivityPopupManager _instance = ConnectivityPopupManager._internal();
  factory ConnectivityPopupManager() => _instance;
  ConnectivityPopupManager._internal();

  // Track popup state
  bool _isPopupShowing = false;
  DateTime? _lastPopupTime;

  // Debounce duration to prevent rapid show/hide cycles
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  /// Check if popup can be shown (not already showing and debounce passed)
  bool canShowPopup() {
    if (_isPopupShowing) {
      return false;
    }

    // Debounce check
    if (_lastPopupTime != null) {
      final timeSinceLastPopup = DateTime.now().difference(_lastPopupTime!);
      if (timeSinceLastPopup < _debounceDuration) {
        return false;
      }
    }

    return true;
  }

  /// Show no internet popup (bottom sheet) - only one at a time
  void showNoInternetPopup({
    required VoidCallback onRetry,
    String? message,
  }) {
    if (!canShowPopup()) return;

    final context = Get.context ?? globalNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    _isPopupShowing = true;
    _lastPopupTime = DateTime.now();

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _NoInternetBottomSheet(
        onRetry: () {
          _hidePopup();
          onRetry();
        },
        message: message,
      ),
    ).whenComplete(() {
      _isPopupShowing = false;
    });
  }

  /// Hide the current popup if showing
  void _hidePopup() {
    if (!_isPopupShowing) return;

    final context = Get.context ?? globalNavigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Close popup when connection is restored
  void closeOnConnectionRestored() {
    if (_isPopupShowing) {
      _hidePopup();
    }
  }

  /// Check if popup is currently showing
  bool get isPopupShowing => _isPopupShowing;

  /// Reset state (useful for testing or app lifecycle events)
  void reset() {
    _isPopupShowing = false;
    _lastPopupTime = null;
  }
}

/// No internet connection bottom sheet widget
class _NoInternetBottomSheet extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const _NoInternetBottomSheet({
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Connection status icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off,
                  size: 40,
                  color: Get.theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                message ?? 'Please check your internet connection and try again.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Retry button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 22),
                  label: const Text(
                    'Retry Connection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.primary,
                    foregroundColor: Get.theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Text(
                'This will close automatically when connection is restored.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim