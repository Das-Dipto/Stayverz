import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model.dart';
import '../../repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository repository;

  NotificationController({required this.repository});

  // Reactive variables
  var notifications = <NotificationItem>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Pagination / meta data if needed
  var totalNotifications = 0.obs;
  var pageSize = 10;
  var currentPage = 1;

  // Retry logic
  var retryCount = 0;
  final int maxRetries = 3;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isApp = true, int? page}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      retryCount = 0; // Reset retry count

      final response = await repository.getUserNotifications(
        isApp: isApp,
        pageSize: pageSize,
        page: page ?? currentPage,
      );

      notifications.value = response.data;
      totalNotifications.value = response.metaData?.total ?? 0;

    } catch (e) {
      errorMessage.value = e.toString();

      // Auto retry logic for specific errors
      if (_shouldRetry(e.toString()) && retryCount < maxRetries) {
        retryCount++;
        await Future.delayed(Duration(seconds: retryCount)); // Exponential backoff
        return fetchNotifications(isApp: isApp, page: page);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: pull to refresh
  Future<void> refreshNotifications({bool isApp = true}) async {
    currentPage = 1;
    retryCount = 0; // Reset retry count on manual refresh
    await fetchNotifications(isApp: isApp);
  }

  // Optional: load more for pagination
  Future<void> loadMoreNotifications({bool isApp = true}) async {
    if (notifications.length >= totalNotifications.value) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    currentPage++;
    try {
      isLoading.value = true;
      retryCount = 0; // Reset retry count

      final response = await repository.getUserNotifications(
        isApp: isApp,
        pageSize: pageSize,
        page: currentPage,
      );

      notifications.addAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
      currentPage--; // Revert page increment on error

      // Auto retry for pagination
      if (_shouldRetry(e.toString()) && retryCount < maxRetries) {
        retryCount++;
        await Future.delayed(Duration(seconds: retryCount));
        currentPage++; // Re-increment for retry
        return loadMoreNotifications(isApp: isApp);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Check if error should trigger a retry
  bool _shouldRetry(String error) {
    // Don't retry authentication errors (let user login again)
    if (error.contains('Authentication failed') ||
        error.contains('Please login')) {
      return false;
    }

    // Retry network-related errors
    return error.contains('timeout') ||
        error.contains('No internet connection') ||
        error.contains('Failed to connect');
  }
}

// Hello I am Tamim