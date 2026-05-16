import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/cache/cache_manager.dart';
import 'package:stayverz_flutter_app/core/constants/app_routes.dart';
import '../../controllers/main_controller.dart';

/// AuthGuard ensures only authenticated users can access protected routes.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      
      // Check if MainController is registered
      if (!Get.isRegistered<MainController>()) {
        return const RouteSettings(name: AppRoute.login);
      }
      
      final mainControl = Get.find<MainController>();
      
      // Debug log current state
      
      // Check if user is logged in and has a valid token
      if (mainControl.isLogin.value && 
          mainControl.accessToken.value.isNotEmpty &&
          mainControl.uType.value.isNotEmpty) {
        return null; // Allow access
      }
      
      // If not logged in but we have a token in cache, try to restore session
      final prefs = CacheManager.prefs;
      if (prefs == null) {
        return const RouteSettings(name: AppRoute.login);
      }
      
      final token = prefs.getString(CacheKeys.token.name) ?? '';
      if (token.isEmpty) {
        return const RouteSettings(name: AppRoute.login);
      }
      
      // Update MainController with cached values
      mainControl.accessToken(token);
      mainControl.isLogin.value = true;
      mainControl.uType.value = (prefs.getString(CacheKeys.role.name) ?? '').toLowerCase();
      
      // Additional user data
      mainControl.userId.value = prefs.getString(CacheKeys.msisdn.name) ?? '';
      mainControl.teacherId.value = prefs.getString(CacheKeys.teacherId.name) ?? '';
      mainControl.studentId.value = prefs.getString(CacheKeys.studentId.name) ?? '';
      mainControl.guardianId.value = prefs.getString(CacheKeys.guardianId.name) ?? '';
      mainControl.profileImageUrl.value = prefs.getString(CacheKeys.profileImageUrl.name) ?? '';
      
      
      return null; // Allow access after restoring session
      
    } catch (e) {
      return const RouteSettings(name: AppRoute.login);
    }
  }
}

// Hello I am Tamim