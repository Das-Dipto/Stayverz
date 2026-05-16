import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/user_feedback/controllers/user_feedback_controller.dart';

import '../../../widgets/own_app_bar.dart';
import '../controllers/app_feed_back.dart';

class GiveUserFeedbackScreen extends GetView<UserFeedbackControllerStyab> {
  const GiveUserFeedbackScreen({super.key});
  static const String route = '/give-user-feedback';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 90,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Give Feedback',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF090909),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.27,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40), // Balance the back button
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Section
            _buildRatingSection(),
            const SizedBox(height: 32),

            // Category Section
            _buildCategorySection(),
            const SizedBox(height: 32),

            // Feedback Text Section
            _buildFeedbackSection(),
            const SizedBox(height: 16),

            // Error Message
            _buildErrorMessage(),
            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),
            const SizedBox(height: 20),

            // Note Section
            _buildNoteSection(),
          ],
        ),
      ),
    );
  }

  // Get star color based on rating
  Color _getStarColor(int starNumber, int currentRating) {
    if (starNumber > currentRating) {
      return const Color(0xFFE0E0E0); // Gray for unselected
    }

    // Dynamic color based on rating level
    if (currentRating <= 2) {
      return const Color(0xFFFF5252); // Red for poor (1-2 stars)
    } else if (currentRating == 3) {
      return const Color(0xFFFF9800); // Orange for average (3 stars)
    } else if (currentRating == 4) {
      return const Color(0xFFFFC107); // Amber for good (4 stars)
    } else {
      return const Color(0xFF4CAF50); // Green for excellent (5 stars)
    }
  }

  // Get rating label
  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  // Get rating background color
  Color _getRatingBackgroundColor(int rating) {
    if (rating <= 2) {
      return const Color(0xFFFFEBEE); // Light red
    } else if (rating == 3) {
      return const Color(0xFFFFF3E0); // Light orange
    } else if (rating == 4) {
      return const Color(0xFFFFF9C4); // Light amber
    } else {
      return const Color(0xFFE8F5E9); // Light green
    }
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you rate your experience?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF090909),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            // Star Rating Row
            Obx(() {
              final currentRating = controller.rating.value??0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNumber = index + 1;
                  final isSelected = starNumber <= currentRating;

                  return GestureDetector(
                    onTap: () => controller.setRating(starNumber),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        size: 40,
                        color: _getStarColor(starNumber, currentRating),
                      ),
                    ),
                  );
                }),
              );
            }),
            const SizedBox(height: 12),

            // Rating Label Display
            Obx(() {
              final currentRating = controller.rating.value;

              return currentRating > 0
                  ? AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getRatingBackgroundColor(currentRating),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$currentRating/5 - ${_getRatingLabel(currentRating)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getStarColor(currentRating, currentRating),
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF090909),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final selectedCat = controller.selectedCategory.value;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.categories.map((category) {
              final isSelected = selectedCat == category;

              return GestureDetector(
                onTap: () => controller.setCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: ShapeDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryColor : const Color(0xFFE0E0E0),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: isSelected
                        ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Feedback',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller.feedbackController,
          maxLines: 5,
          maxLength: 500,
          onChanged: (_) {}, // you can connect a callback if needed
          decoration: InputDecoration(
            hintText: 'Tell us more about your experience...',
            hintStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0), // light gray border
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blueGrey, // border color when focused
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            counterStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,
            ),
          ),
        )


      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final isEnabled = controller.isSubmitEnabled;

      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isEnabled ? controller.submitFeedback : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            disabledBackgroundColor: const Color(0xFFE0E0E0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isEnabled ? 2 : 0,
          ),
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Text(
            'Submit Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildErrorMessage() {
    RxInt datetee=0.obs;
    return Obx(() {
      datetee.value=0;

      final message = controller.errorMessage.value;

      if (message.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }


  Widget _buildNoteSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your feedback helps us improve the app and provide better service.',
              style: TextStyle(
                color: const Color(0xFF666666),
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
// Hello I am Tamim