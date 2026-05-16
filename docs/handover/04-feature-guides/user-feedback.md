# User Feedback Feature

## Overview

The user feedback feature allows users to submit ratings and feedback about the app experience. This helps the product team gather insights for improvements.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/user_feedback/controllers/user_feedback_controller.dart` | Form handling and submission |
| `@/lib/features/user_feedback/repositories/user_feedback_repository_impl.dart` | API operations |
| `@/lib/features/user_feedback/presentation/give_user_feedback_screen.dart` | Feedback form UI |
| `@/lib/features/user_feedback/models/user_feedback_model.dart` | Data model |
| `@/lib/features/user_feedback/bindings/user_feedback_binding.dart` | Dependency injection |

### Dependencies

```
UserFeedbackController
  ├── UserFeedbackRepositoryInterface (feedback API)
  ├── MainController (user context)
  └── Form validation logic
```

---

## Implementation Details

### Controller State

```dart
class UserFeedbackController extends GetxController {
  // Form controllers
  final TextEditingController feedbackController = TextEditingController();

  // Reactive variables
  final RxInt rating = 0.obs;                          // 1-5 stars
  final RxString selectedCategory = ''.obs;           // Feedback category
  final RxBool isLoading = false.obs;                 // Submission state
  final RxList<String> categories = <String>[].obs;  // Available categories
  final RxBool isFormValid = false.obs;               // Validation state
}
```

### Form Validation

```dart
void _updateFormValidation() {
  final hasRating = rating.value > 0;
  final hasCategory = selectedCategory.value.isNotEmpty;
  final feedbackLength = feedbackController.text.length;
  final hasValidFeedback = feedbackLength >= 10 && feedbackLength <= 500;
  
  isFormValid.value = hasRating && hasCategory && hasValidFeedback;
}
```

**Validation Rules:**
- Rating: Required (1-5 stars)
- Category: Required (must select one)
- Feedback: 10-500 characters

---

## Categories

### Default Categories

```dart
final List<String> _defaultCategories = [
  'Bug Report',
  'Feature Request', 
  'General Feedback',
  'Performance',
  'User Interface',
  'Other'
];
```

### Dynamic Categories

Categories can be fetched from the API:

```dart
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
```

---

## Submission Flow

### Submit Feedback

```dart
Future<void> submitFeedback() async {
  if (!isFormValid.value) {
    _setValidationError();
    return;
  }

  isLoading.value = true;
  
  try {
    final feedback = UserFeedbackModel(
      rating: rating.value,
      category: selectedCategory.value,
      feedback: feedbackController.text,
      userId: mainController.userId.value,
      timestamp: DateTime.now(),
    );
    
    final response = await _repository.submitFeedback(feedback);
    
    if (response.isSuccess) {
      Fluttertoast.showToast(msg: 'Thank you for your feedback!');
      _resetForm();
      Get.back();
    } else {
      errorMessage.value = response.errorMessage ?? 'Failed to submit feedback';
    }
  } catch (e) {
    errorMessage.value = 'An error occurred. Please try again.';
  } finally {
    isLoading.value = false;
  }
}
```

### Form Reset

```dart
void _resetForm() {
  rating.value = 0;
  selectedCategory.value = '';
  feedbackController.clear();
  errorMessage.value = '';
  isFormValid.value = false;
}
```

---

## Data Model

### UserFeedbackModel

```dart
class UserFeedbackModel {
  final int rating;              // 1-5 star rating
  final String category;         // Selected category
  final String feedback;         // User feedback text
  final String? userId;          // Optional user ID
  final DateTime timestamp;      // Submission time
  final String? deviceInfo;      // Optional device info
  final String? appVersion;      // Optional app version

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'category': category,
    'feedback': feedback,
    'user_id': userId,
    'timestamp': timestamp.toIso8601String(),
    'device_info': deviceInfo,
    'app_version': appVersion,
  };
}
```

---

## UI Components

### GiveUserFeedbackScreen

```dart
class GiveUserFeedbackScreen extends GetView<UserFeedbackController> {
  static const String route = '/give-user-feedback';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Give Feedback')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Rating section
            _buildRatingSection(),
            
            // Category selection
            _buildCategorySection(),
            
            // Feedback text field
            _buildFeedbackInput(),
            
            // Character counter
            _buildCharacterCounter(),
            
            // Submit button
            _buildSubmitButton(),
            
            // Info note
            _buildInfoNote(),
          ],
        ),
      ),
    );
  }
}
```

### Rating Widget

```dart
Widget _buildRatingSection() {
  return Obx(() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return IconButton(
        icon: Icon(
          index < controller.rating.value 
              ? Icons.star 
              : Icons.star_border,
          color: Colors.amber,
        ),
        onPressed: () => controller.setRating(index + 1),
      );
    }),
  ));
}
```

---

## Route Integration

### App Route

```dart
// In main.dart or route configuration
GetPage(
  name: GiveUserFeedbackScreen.route,
  page: () => GiveUserFeedbackScreen(),
  binding: UserFeedbackBinding(),
)
```

### Navigation

```dart
// Navigate to feedback screen
Get.toNamed(GiveUserFeedbackScreen.route);

// Or from menu
ListTile(
  leading: Icon(Icons.feedback_outlined),
  title: Text('Give Feedback'),
  onTap: () => Get.toNamed(GiveUserFeedbackScreen.route),
)
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/feedback/submit` | POST | Submit feedback |
| `/api/v1/feedback/categories` | GET | Get available categories |
| `/api/v1/feedback/can-submit` | GET | Check if user can submit |

---

## Usage Limits

The API may enforce rate limiting:

```dart
Future<bool> canSubmitFeedback() async {
  final response = await _repository.canSubmitFeedback();
  return response.data ?? true;
}
```

---

## Error Handling

### Common Errors

| Error | Handling |
|-------|----------|
| Network error | Show retry option |
| Validation error | Highlight invalid fields |
| Rate limited | Show "try again later" message |
| Server error | Generic error toast |

### Validation Error Display

```dart
void _setValidationError() {
  if (rating.value == 0) {
    errorMessage.value = 'Please select a rating';
  } else if (selectedCategory.value.isEmpty) {
    errorMessage.value = 'Please select a category';
  } else if (feedbackController.text.length < 10) {
    errorMessage.value = 'Feedback must be at least 10 characters';
  } else if (feedbackController.text.length > 500) {
    errorMessage.value = 'Feedback must be less than 500 characters';
  }
}
```

---

## Testing

### Test Scenarios

1. **Submit Valid Feedback:**
   - Select 5-star rating
   - Choose "Feature Request" category
   - Enter 50-character feedback
   - Submit successfully

2. **Validation Errors:**
   - Submit without rating → Show error
   - Submit without category → Show error
   - Enter < 10 characters → Show error
   - Enter > 500 characters → Show error and truncate

3. **Network Failure:**
   - Turn off internet
   - Submit feedback
   - Verify error message shown
   - Retry button functional

4. **Category Fallback:**
   - Block categories API
   - Verify default categories shown

---

## Implementation Notes

### Recent Implementation

The user feedback feature was recently implemented following the project's established MVVM + GetX patterns:

1. **Repository Pattern:** Interface/Implementation separation
2. **GetX State Management:** Reactive variables with Obx
3. **Form Validation:** Client-side validation before API call
4. **Error Handling:** Graceful fallbacks for API failures
5. **UI Design:** Consistent with app design language

### Files Created

```
lib/features/user_feedback/
├── bindings/
│   └── user_feedback_binding.dart
├── controllers/
│   └── user_feedback_controller.dart
├── models/
│   └── user_feedback_model.dart
├── presentation/
│   └── give_user_feedback_screen.dart
└── repositories/
    ├── user_feedback_repository_interface.dart
    └── user_feedback_repository_impl.dart
```

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [API Reference](../05-api-reference.md)
