import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../controllers/main_controller.dart';

class UserFeedbackControllerStyab extends GetxController {
  final rating = 0.obs;
  final selectedCategory = ''.obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  final feedbackController = TextEditingController();
  final mainController = Get.find<MainController>();

  late String userId;

  final List<String> categories = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'Performance',
    'UI/UX',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments?['userId']?.toString() ?? mainController.userId.value;
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }

  void setRating(int value) {
    rating.value = value;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  bool get isSubmitEnabled {
    return !isLoading.value &&
        (rating.value > 0 ||
            selectedCategory.value.isNotEmpty ||
            feedbackController.text.trim().isNotEmpty);
  }

  Future<void> submitFeedback() async {
    if (!isSubmitEnabled) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://api-sub.stayverz.com/feedback?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rating': rating.value,
          'category': selectedCategory.value,
          'feedback': feedbackController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isClosed) return; // 🛡 VERY IMPORTANT

        Get.back();

        Get.snackbar(
          'Success',
          'Thank you for your feedback!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = 'Failed to submit feedback';
      }
    } catch (_) {
      errorMessage.value = 'Network error';
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }
}

// Hello I am Tamim