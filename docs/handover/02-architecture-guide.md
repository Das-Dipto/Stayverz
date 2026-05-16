# Stayverz Flutter App - Architecture Guide

## Architecture Overview

The Stayverz app follows **MVVM (Model-View-ViewModel)** architecture with **GetX** for state management, dependency injection, and navigation.

---

## Core Principles

### 1. MVVM Pattern
- **Model:** Data structures and business logic
- **View:** UI widgets (stateless where possible)
- **ViewModel (Controller):** Mediates between View and Model, handles business logic

### 2. GetX State Management
- Reactive programming with `.obs` (Rx) variables
- `Obx()` widgets for automatic UI updates
- `GetView<Controller>` for type-safe controller access

### 3. Repository Pattern
- Interface/Implementation separation
- `ApiClient` for all HTTP operations
- Centralized error handling

### 4. Dependency Injection
- `Get.lazyPut()` for lazy initialization
- `Get.put()` for immediate singletons
- `fenix: true` for persistence across route changes

---

## Dependency Injection Flow

```
main()
  └── MainBinding()
        └── CoreBinding()
              ├── ErrorDisplayManager (singleton)
              ├── Logger (lazy)
              ├── ConnectivityService (singleton)
              ├── ApiClient (lazy)
              ├── ConnectivityController (singleton)
              ├── AuthRepository (lazy)
              ├── AuthRepositoryInterface → AuthRepository
              ├── AuthController (lazy)
              ├── WebSocketService (lazy)
              ├── NotificationService (lazy)
              ├── MessagingRepository (lazy)
              ├── BookingBinding()
              ├── ReservationBinding()
              ├── FinanceReportBinding()
              └── ProfileBinding()
        └── MainController (lazy, depends on AuthRepositoryInterface)
```

---

## Key Files

### Entry Point
**`@/lib/main.dart`**
- App initialization
- Firebase setup
- Binding initialization
- Session restoration
- Route determination based on auth state

```dart
// MainController is accessed globally via mainControl
late final MainController mainControl;

// Route determination
final String initialRoute = mainControl.isLogin.value
    ? (mainControl.uType.value == 'host' ? AppRoute.host : AppRoute.guest)
    : AppRoute.guest;
```

### Core Bindings

**`@/lib/core/bindings/main_binding.dart`**
- Entry point for all dependency injection
- Initializes CoreBinding then MainController

**`@/lib/core/bindings/core_binding.dart`**
- Registers all core services
- Order matters: dependencies must be registered before dependents

### Global Controller

**`@/lib/controllers/main_controller.dart`**
Central application state:
- Authentication state (`isLogin`, `accessToken`, `refreshToken`)
- User information (`userId`, `userName`, `email`, `uType`)
- Navigation state (`buttonNavigationBarIndex`)
- Connectivity state (`isInternetAvailable`)

```dart
// Key reactive variables
RxBool isLogin = RxBool(false);
RxString uType = RxString(''); // 'host' or 'guest'
RxString accessToken = RxString('');
RxInt buttonNavigationBarIndex = RxInt(2);
```

---

## State Management Patterns

### Reactive Variables
```dart
// In Controller
final isLoading = false.obs;
final userList = <UserModel>[].obs;
final selectedUser = Rxn<UserModel>();

// In View
Obx(() => controller.isLoading.value 
    ? CircularProgressIndicator() 
    : UserListView(users: controller.userList),
);
```

### GetView Pattern
```dart
class ExampleScreen extends GetView<ExampleController> {
  @override
  Widget build(BuildContext context) {
    // Access controller via `controller` property
    return Scaffold(
      body: Obx(() => Text(controller.someValue.value)),
    );
  }
}
```

### Controller Lifecycle
```dart
class ExampleController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Initialize data, set up listeners
  }

  @override
  void onReady() {
    super.onReady();
    // Called after widget is rendered
  }

  @override
  void onClose() {
    // Clean up resources, cancel subscriptions
    super.onClose();
  }
}
```

---

## Repository Pattern Implementation

### Interface
```dart
abstract class AuthRepositoryInterface {
  Future<UserModel> login(String username, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}
```

### Implementation
```dart
class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;
  
  AuthRepository(this._apiClient);
  
  @override
  Future<UserModel> login(String username, String password) async {
    final response = await _apiClient.post(
      ApiRoutes.login,
      data: {'username': username, 'password': password},
    );
    return UserModel.fromJson(response.data);
  }
}
```

### Registration
```dart
// In CoreBinding
Get.lazyPut<AuthRepository>(
  () => AuthRepository(Get.find<ApiClient>()),
  fenix: true,
);
Get.lazyPut<AuthRepositoryInterface>(
  () => Get.find<AuthRepository>(),
  fenix: true,
);
```

---

## Navigation System

### Named Routes
**`@/lib/core/constants/app_routes.dart`**
```dart
class AppRoute {
  static const String login = '/login';
  static const String host = '/host';
  static const String guest = '/guest';
  static const String publicListings = '/public-listings';
  
  static Map<String, Widget Function(BuildContext)> routes = {
    login: (context) => LoginView(),
    host: (context) => const HostBottomNavigationBarView(),
    guest: (context) => const GuestBottomNavigationBarView(),
  };
}
```

### Navigation Methods
```dart
// Navigate to route
Get.toNamed(AppRoute.login);

// Navigate with arguments
Get.toNamed(AppRoute.blogDetails, arguments: blogData);

// Replace current route
Get.offNamed(AppRoute.host);

// Clear stack and navigate
Get.offAllNamed(AppRoute.guest);

// Go back
Get.back();
```

---

## Network Layer

### ApiClient
**`@/lib/services/network/api_client.dart`**
- Dio-based HTTP client
- Interceptors for logging, token refresh, connectivity
- Factory methods for different API services:
  - `ApiClient.create()` - Main API
  - `ApiClient.forMessaging()` - Messaging API

### Interceptors
1. **RequestInterceptor** - Adds auth headers
2. **ErrorInterceptor** - Handles HTTP errors
3. **ResponseInterceptor** - Processes responses
4. **TokenRefreshInterceptor** - Handles token refresh
5. **ConnectivityInterceptor** - Checks network state

---

## Feature Module Structure

Each feature follows this structure:
```
features/feature_name/
├── bindings/
│   └── feature_binding.dart
├── controllers/
│   └── feature_controller.dart
├── data/
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       ├── feature_repository_interface.dart
│       └── feature_repository_impl.dart
└── presentation/
    └── views/
        └── feature_screen.dart
```

### Feature Binding Example
```dart
class FeatureBinding implements Bindings {
  @override
  void dependencies() {
    // Register ApiClient if needed
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before this binding');
    }
    
    // Register repository
    Get.lazyPut<FeatureRepositoryInterface>(
      () => FeatureRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    
    // Register controller
    Get.lazyPut<FeatureController>(
      () => FeatureController(Get.find<FeatureRepositoryInterface>()),
      fenix: true,
    );
  }
}
```

---

## Error Handling

### Global Error Display
**`@/lib/services/network/error_display_manager.dart`**
- Centralized error display
- Shows error dialogs/bottom sheets
- Accessible via `Get.find<ErrorDisplayManager>()`

### Repository Error Pattern
```dart
try {
  final response = await _apiClient.get(url);
  return Right(response.data);
} on DioException catch (e) {
  return Left(ErrorHandler.handle(e));
}
```

---

## Best Practices

### Do's
1. Use `GetView<Controller>` for screens
2. Keep controllers focused on single responsibility
3. Use `.obs` for reactive state
4. Cancel subscriptions in `onClose()`
5. Use `fenix: true` for persistent dependencies
6. Handle errors at repository level
7. Use `const` constructors where possible

### Don'ts
1. Don't use `setState` (use GetX instead)
2. Don't access repositories directly from views
3. Don't create circular dependencies
4. Don't register `ApiClient` in feature bindings
5. Don't hardcode API URLs (use `ApiRoutes`)

---

## Migration Notes

### Views to Features
Legacy views in `@/lib/views/` are being migrated to `@/lib/features/*/presentation/views/`. New features should follow the feature-first structure.

### WebView to WebSocket
The messaging system is transitioning from WebView (`webview_inbox_screen.dart`) to native WebSocket implementation. New code should use the WebSocket service.
