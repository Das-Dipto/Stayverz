# Recent Changes & Migration Notes

## Overview

This document tracks recent significant changes, new features, and ongoing migrations in the Stayverz codebase.

---

## User Feedback Feature (Latest)

### Implementation Date: Recent

**New Feature:** Complete user feedback system allowing users to submit ratings and feedback about the app experience.

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

### Key Features
- 5-star rating system
- Category selection (Bug Report, Feature Request, etc.)
- Text feedback (10-500 characters)
- API integration with fallback to default categories
- Form validation and error handling

### API Endpoints
- `POST /api/feedback/submit` - Submit feedback
- `GET /api/feedback/categories` - Get categories
- `GET /api/feedback/can-submit` - Check eligibility

### Route
- `/give-user-feedback` - Access via menu

---

## Model Serialization Updates

### Implementation Date: Recent

**Change:** Added `toJson()` methods to multiple models for proper serialization.

### Affected Files

| File | Changes |
|------|---------|
| `@/lib/features/profile/models/profile_details_model.dart` | Added `toJson()` |
| `@/lib/features/profile/models/review_model.dart` | Added `toJson()` with nested models |
| `@/lib/data/models/listing_model.dart` | Added `toJson()` |

### Reason
Resolved compilation errors when `ProfileModel.toJson()` tried to serialize nested models that lacked `toJson()` implementations.

### Example
```dart
// Before (error)
class ProfileDetailsModel {
  // ... fields
  // No toJson() - causes error when ProfileModel.toJson() is called
}

// After (fixed)
class ProfileDetailsModel {
  // ... fields
  Map<String, dynamic> toJson() => {
    'field1': field1,
    'field2': field2,
  };
}
```

---

## WebSocket Migration (In Progress)

### Status: Ongoing

**Objective:** Replace temporary WebView messaging with native WebSocket implementation.

### Temporary WebView Files (To Be Removed)

- `@/lib/views/home_root/home/inbox/webview_inbox_screen.dart`
- `@/lib/views/home_root/home/inbox/webview_inbox_conversation_screen.dart`

### Native Implementation (Current)

```
lib/features/messaging/
├── data/
│   ├── services/
│   │   └── websocket_service.dart     # WebSocket connection management
│   ├── models/
│   │   ├── chat_room_model.dart
│   │   ├── chat_message_models.dart
│   │   └── websocket_models.dart
│   └── repositories/
│       └── messaging_repository.dart
├── controllers/
│   ├── inbox_controller.dart          # Chat rooms list
│   └── conversation_controller.dart # Individual chat
└── presentation/
    ├── views/
    │   ├── inbox_page.dart            # Native inbox UI
    │   └── message_conversation_page.dart
```

### WebSocket Connections

| Connection | URL | Purpose |
|------------|-----|---------|
| Global Room | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/user-global-room/?token={token}` | Global events |
| Chat Stats | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/chat-stat/?token={token}` | Unread counts |
| Room Channel | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/{roomId}/?token={token}` | Chat room |

### Migration Checklist

- [x] WebSocket service implementation
- [x] Inbox controller with stream handling
- [x] Conversation controller
- [x] Native inbox UI
- [x] Message conversation UI
- [ ] Remove WebView screens (after full testing)
- [ ] Archive/unarchive functionality
- [ ] Quick replies integration

---

## Circular Dependency Fix

### Issue Description

**Problem:** Circular dependency in DI chain:
```
MainController -> AuthRepository -> ApiClient -> RequestInterceptor -> MainController
```

**Symptoms:**
- Infinite GetX instance creation logs
- Skipped frames warning
- App freezes

### Solution

**File:** `@/lib/services/network/interceptors/request_interceptor.dart`

**Change:** Removed unused `MainController` dependency:
```dart
// REMOVED:
// final MainController _mainController = Get.find<MainController>();
```

**Also removed:** Unused imports for `get` and `main_controller.dart`

### Prevention

- Avoid `Get.find()` in field initializers that create circular refs
- Review dependency chains before adding new dependencies
- Use lazy initialization when possible

---

## Finance Report Pie Chart Updates

### Change

**File:** `@/lib/features/finance_report/presentation/finance_screen.dart`

Added color coding for pie chart sections based on month names:

```dart
color _getColorForMonth(String? monthName) {
  switch (monthName?.toLowerCase()) {
    case 'january': return Colors.blue;
    case 'february': return Colors.green;
    case 'march': return Colors.orange;
    // ... etc
  }
}
```

**Default Behavior:**
- When all booking amounts are zero or data unavailable: display `Colors.grey.shade300`
- Otherwise: assign specific color per month

---

## HTTP Client Pattern Update

### Implementation Pattern

**Guideline:** All repositories must use the project's `ApiClient` (not custom `HttpRequests` class).

### Correct Implementation

```dart
// In repository_impl.dart
final ApiClient _apiClient = Get.find<ApiClient>();

// In binding.dart
if (!Get.isRegistered<ApiClient>()) {
  throw Exception('ApiClient must be registered before this binding');
}
```

### Key Points

1. `ApiClient` registered by `NetworkBinding` (global dependency)
2. Feature bindings only check existence, never register
3. Repositories depend on `ApiClient` for all HTTP operations
4. No string-based type names in `Get.isRegistered` checks

---

## Android Build Configuration

### NDK Version Update

**File:** `@/android/app/build.gradle.kts`

```kotlin
ndkVersion = "27.0.12077973"
```

Updated to match plugin requirements.

### Tree Shake Icons Flag

**Configuration:**
```kotlin
project.extra.set("extraFrontEndOptions", listOf("--no-tree-shake-icons"))
```

**Command-line required:**
```bash
flutter build apk --release --no-tree-shake-icons
flutter build appbundle --release --no-tree-shake-icons
```

**Reason:** Custom font icons (`OwnIcons.ttf`) cause IconTreeShakerException without this flag.

---

## Dependency Injection Fix

### Issue

`HttpRequests` not found error in Profile feature.

### Solution

**File:** `@/lib/features/profile/bindings/profile_binding.dart`

Register `HttpRequests` before `ProfileRepositoryImpl`:

```dart
@override
void dependencies() {
  // Register HttpRequests BEFORE repository
  Get.lazyPut<HttpRequests>(
    () => HttpRequests(),
    fenix: true,
  );
  
  // Then register repository (which depends on HttpRequests)
  Get.lazyPut<ProfileRepositoryInterface>(
    () => ProfileRepositoryImpl(),
    fenix: true,
  );
}
```

**Rule:** Dependencies must be registered before dependents.

---

## Feature Module Migration

### Ongoing Migration

Moving legacy views from `@/lib/views/` to `@/lib/features/*`:

| Legacy Path | New Path | Status |
|-------------|----------|--------|
| `views/home_root/home/inbox/` | `features/messaging/` | Migrated |
| `views/home_root/menu_screen/` | `features/profile/` | In Progress |
| `views/home_root/booking/` | `features/booking/` | Migrated |

### Pattern

Feature-first architecture:
```
features/feature_name/
├── bindings/
├── controllers/
├── data/
│   ├── models/
│   └── repositories/
└── presentation/
    └── views/
```

---

## Known Issues

### Current Workarounds

| Issue | Workaround | Status |
|-------|-----------|--------|
| IconTreeShakerException | Use `--no-tree-shake-icons` flag | Permanent (custom fonts) |
| Certificate validation | `MyHttpOverrides` disables SSL check | Remove for production |
| WebView messaging | Native WebSocket in progress | Migration ongoing |

---

## Upcoming Changes

### Planned

1. **Complete WebSocket migration** - Remove WebView screens
2. **Profile module migration** - Move to feature structure
3. **Code Connect integration** - Figma-to-code mapping
4. **Test coverage** - Add unit and widget tests

---

## Related Documentation

- [Architecture Guide](./02-architecture-guide.md)
- [Feature Guides](./04-feature-guides/)
- [Troubleshooting](./09-troubleshooting.md)
