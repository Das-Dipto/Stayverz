import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized singleton to manage API error display
/// Prevents duplicate error messages from multiple sources
class ErrorDisplayManager {
  static final ErrorDisplayManager _instance = ErrorDisplayManager._internal();
  factory ErrorDisplayManager() => _instance;
  ErrorDisplayManager._internal();

  // Track last error to prevent duplicates
  String? _lastErrorMessage;
  DateTime? _lastErrorTime;

  // Debounce duration
  static const Duration _debounceDuration = Duration(seconds: 2);

  /// Show error message (prevents duplicates)
  void showError(String message, {String title = 'Error'}) {
    // Check for duplicate
    if (_lastErrorMessage == message && _lastErrorTime != null) {
      final timeSinceLast = DateTime.now().difference(_lastErrorTime!);
      if (timeSinceLast < _debounceDuration) {
        return;
      }
    }

    _lastErrorMessage = message;
    _lastErrorTime = DateTime.now();

    // Only show if not already showing
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Show success message
  void showSuccess(String message, {String title = 'Success'}) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

// Hello I am Tamim