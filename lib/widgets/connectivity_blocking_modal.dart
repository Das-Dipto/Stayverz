import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/connectivity_controller.dart';

/// Full-screen connectivity modal that blocks navigation
class ConnectivityBlockingModal extends StatelessWidget {
  const ConnectivityBlockingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ConnectivityController>(
      builder: (controller) {
        // Only show when disconnected
        if (controller.isConnected) {
          return const SizedBox.shrink();
        }

        return WillPopScope(
          onWillPop: () async {
            // Prevent back navigation when offline
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Connection status icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wifi_off,
                        size: 50,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      controller.connectionMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You need an internet connection to use this app. Please check your connection and try again.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Retry button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: GetX<ConnectivityController>(
                        builder: (controller) {
                          return ElevatedButton(
                            onPressed: controller.isRetrying ? null : () async {
                              
                              // Check connectivity - UI feedback handled by popup manager
                              await controller.checkConnectivity();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: controller.isRetrying
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Checking...'),
                                    ],
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        'Retry',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Info text
                    const Text(
                      'This screen will disappear automatically when your connection is restored.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Service to manage blocking connectivity modal
class ConnectivityBlockingService {
  static bool _isShowing = false;
  static OverlayEntry? _overlayEntry;
  
  /// Show blocking connectivity modal
  static void showBlockingModal(BuildContext context) {
    if (_isShowing) {
      return;
    }
    
    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => const ConnectivityBlockingModal(),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }
  
  /// Hide blocking connectivity modal
  static void hideBlockingModal() {
    if (!_isShowing || _overlayEntry == null) {
      return;
    }
    
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }
  
  /// Check if modal is currently showing
  static bool get isShowing => _isShowing;
}

// Hello I am Tamim