import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/main_controller.dart';
import 'package:stayverz_flutter_app/features/user_feedback/models/user_feedback_model.dart';
import 'package:stayverz_flutter_app/features/user_feedback/repositories/user_feedback_repository_interface.dart';

class UserFeedbackController extends GetxController {
  final UserFeedbackRepositoryInterface _repository;

  UserFeedbackController(this._repository);

  // Form controllers
  final TextEditingController feedbackController = TextEditingController();

  // Reactive variables
  final RxInt rating = 0.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool canSubmit = true.obs;
  final RxBool isFormValid = false.obs;

  // Predefined categories as fallback
  final List<String> _defaultCategories = [
    'Bug Report',
    'Feature Request', 
    'General Feedback',
    'Performance',
    'User Interface',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeCategories();
    _loadCategories();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }

  void _initializeCategories() {
    categories.value = _defaultCategories;
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _repository.getFeedbackCategories();
      if (response.isSuccess && response.data != null) {
        categories.value = response.data!;
      }
    } catch (e) {
      // Keep default categories if API fails
    }
  }

  void setRating(int value) {
    if (value >= 1 && value <= 5) {
      rating.value = value;
      _updateFormValidation();
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    _updateFormValidation();
  }

  void _updateFormValidation() {
    // Clear error first
    errorMessage.value = '';
    
    // Check all validation conditions without setting error messages
    final hasRating = rating.value > 0;
    final hasCategory = selectedCategory.value.isNotEmpty;
    final hasFeedback = feedbackController.text.trim().isNotEmpty;
    final hasMinLength = feedbackController.text.trim().length >= 10;
    final hasMaxLength = feedbackController.text.trim().length <= 500;
    
    isFormValid.value = hasRating && hasCategory && hasFeedback && hasMinLength && hasMaxLength;
  }

  void updateValidation() {
    _updateFormValidation();
  }

  void _clearError() {
    errorMessage.value = '';
  }

  bool _validateForm() {
    if (rating.value == 0) {
      errorMessage.value = 'Please select a rating';
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      errorMessage.value = 'Please select a category';
      return false;
    }

    if (feedbackController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your feedback';
      return false;
    }

    if (feedbackController.text.trim().length < 10) {
      errorMessage.value = 'Feedback must be at least 10 characters';
      return false;
    }

    if (feedbackController.text.trim().length > 500) {
      errorMessage.value = 'Feedback must be less than 500 characters';
      return false;
    }

    return true;
  }

  Future<void> submitFeedback() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      _clearError();

      final mainController = Get.find<MainController>();
      
      final feedback = UserFeedbackModel(
        rating: rating.value,
        category: selectedCategory.value,
        feedback: feedbackController.text.trim(),
        createdAt: DateTime.now(),
        userId: mainController.userId.value.isNotEmpty ? mainController.userId.value : null,
        userType: mainController.uType.value.isNotEmpty ? mainController.uType.value : null,
      );

      final response = await _repository.submitFeedback(feedback);

      if (response.isSuccess) {
        Fluttertoast.showToast(
          msg: "Thank you for your feedback!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        
        // Reset form
        _resetForm();
        
        // Go back
        Get.back();
      } else {
        errorMessage.value = response.message ?? 'Failed to submit feedback';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    rating.value = 0;
    selectedCategory.value = '';
    feedbackController.clear();
    errorMessage.value = '';
    isFormValid.value = false;
  }

  String get feedbackText => feedbackController.text;
  int get characterCount => feedbackText.length;
  bool get isSubmitEnabled => !isLoading.value && isFormValid.value;
}

// Hello I am Tamim