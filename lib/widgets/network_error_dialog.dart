import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/error/network_exceptions.dart';
import '../services/network/connectivity_service.dart';

/// Bottom sheet for showing network errors with retry options
class NetworkErrorBottomSheet extends StatelessWidget {
  final NetworkException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final bool showRetryButton;
  final bool showCancelButton;
  
  const NetworkErrorBottomSheet({
    super.key,
    required this.exception,
    this.onRetry,
    this.onCancel,
    this.showRetryButton = true,
    this.showCancelButton = true,
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

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getErrorColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getErrorIcon(),
                  size: 40,
                  color: _getErrorColor(),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                _getErrorTitle(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                exception.message,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              if (_shouldShowConnectivityInfo()) ...[
                _ConnectivityInfo(),
                const SizedBox(height: 20),
              ],
              
              if (_shouldShowRetryInfo()) ...[
                _RetryInfo(exception: exception),
                const SizedBox(height: 20),
              ],

              // Action buttons
              if (showRetryButton)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onRetry ?? _handleRetry,
                    icon: const Icon(Icons.refresh, size: 22),
                    label: const Text(
                      'Retry',
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
              
              if (showCancelButton) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onCancel ?? () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getErrorIcon() {
    switch (exception.runtimeType) {
      case NoInternetException _:
        return Icons.wifi_off;
      case ConnectionTimeoutException _:
      case RequestTimeoutException _:
        return Icons.access_time;
      case ServerException _:
        return Icons.error_outline;
      case NetworkConnectionException _:
        return Icons.signal_wifi_off;
      default:
        return Icons.warning;
    }
  }
  
  Color _getErrorColor() {
    switch (exception.runtimeType) {
      case NoInternetException _:
      case NetworkConnectionException _:
        return Colors.red;
      case ConnectionTimeoutException _:
      case RequestTimeoutException _:
        return Colors.orange;
      case ServerException _:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
  
  String _getErrorTitle() {
    switch (exception.runtimeType) {
      case NoInternetException _:
        return 'No Internet Connection';
      case ConnectionTimeoutException _:
      case RequestTimeoutException _:
        return 'Connection Timeout';
      case ServerException _:
        return 'Server Error';
      case NetworkConnectionException _:
        return 'Network Error';
      default:
        return 'Error';
    }
  }
  
  bool _shouldShowConnectivityInfo() {
    return exception.runtimeType == NoInternetException ||
           exception.runtimeType == NetworkConnectionException;
  }
  
  bool _shouldShowRetryInfo() {
    return exception.runtimeType == ConnectionTimeoutException ||
           exception.runtimeType == RequestTimeoutException ||
           (exception is ServerException && exception.statusCode! >= 500);
  }
  
  void _handleRetry() {
    Get.back();
    if (exception.runtimeType == NoInternetException) {
      ConnectivityService.to.checkConnection();
    }
    onRetry?.call();
  }
}

/// Widget showing connectivity information
class _ConnectivityInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Get.theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ConnectivityService.to.isConnected 
                    ? Icons.wifi 
                    : Icons.wifi_off,
                color: ConnectivityService.to.isConnected 
                    ? Get.theme.colorScheme.primary
                    : Get.theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Connection Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ConnectivityService.to.connectionMessage,
            style: TextStyle(
              color: ConnectivityService.to.isConnected 
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.error,
              fontSize: 14,
            ),
          ),
          if (ConnectivityService.to.status == ConnectivityStatus.checking) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              backgroundColor: Get.theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    ));
  }
}

/// Widget showing retry information
class _RetryInfo extends StatelessWidget {
  final NetworkException exception;
  
  const _RetryInfo({required this.exception});
  
  @override
  Widget build(BuildContext context) {
    String retryMessage = '';
    
    if (exception.runtimeType == ConnectionTimeoutException ||
        exception.runtimeType == RequestTimeoutException) {
      retryMessage = 'The request timed out. This could be due to a slow connection or server issues. Please check your connection and try again.';
    } else if (exception is ServerException && exception.statusCode! >= 500) {
      retryMessage = 'The server is temporarily unavailable. This is usually a temporary issue. Please try again in a few moments.';
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              retryMessage,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Utility class to show network error bottom sheets
class NetworkErrorDialogs {
  /// Show a network error bottom sheet
  static Future<void> show(
    NetworkException exception, {
    VoidCallback? onRetry,
    VoidCallback? onCancel,
    bool showRetryButton = true,
    bool showCancelButton = true,
  }) async {
    if (Get.isBottomSheetOpen ?? false) return;
    
    Get.bottomSheet(
      NetworkErrorBottomSheet(
        exception: exception,
        onRetry: onRetry,
        onCancel: onCancel,
        showRetryButton: showRetryButton,
        showCancelButton: showCancelButton,
      ),
      isDismissible: showCancelButton,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
  
  /// Show no internet connection bottom sheet
  static Future<void> showNoInternet({
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) async {
    await show(
      const NoInternetException(),
      onRetry: onRetry,
      onCancel: onCancel,
      showCancelButton: true,
    );
  }
  
  /// Show timeout error bottom sheet
  static Future<void> showTimeout({
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) async {
    await show(
      const ConnectionTimeoutException(timeout: Duration(seconds: 30)),
      onRetry: onRetry,
      onCancel: onCancel,
    );
  }
  
  /// Show server error bottom sheet
  static Future<void> showServerError({
    required String message,
    int? statusCode,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) async {
    await show(
      ServerException(
        message: message,
        statusCode: statusCode ?? 500,
      ),
      onRetry: onRetry,
      onCancel: onCancel,
    );
  }
  
  /// Show generic network error bottom sheet
  static Future<void> showGenericError({
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) async {
    await show(
      UnknownNetworkException(message: message),
      onRetry: onRetry,
      onCancel: onCancel,
    );
  }
}

// Hello I am Tamim