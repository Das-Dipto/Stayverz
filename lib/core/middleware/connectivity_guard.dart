import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/connectivity_controller.dart';

/// Middleware to block navigation when offline
class ConnectivityGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final controller = Get.find<ConnectivityController>();

      // If offline, prevent navigation to new routes
      if (!controller.isConnected) {

        // Allow navigation to connectivity-related routes for testing
        if (route != null && !route.contains('/connectivity')) {
          // Stay on current page, blocking navigation
          return RouteSettings(name: Get.currentRoute);
        }
      }

      return null; // Allow navigation
    } catch (e) {
      return null; // Allow navigation on error
    }
  }

  @override
  int? get priority => 100; // High priority to run before other middleware
}

// Hello I am Tamim