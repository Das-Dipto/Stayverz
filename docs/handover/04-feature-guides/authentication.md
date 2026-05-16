# Authentication System

## Overview

The authentication system supports phone/email login with OTP verification, JWT token management, and role-based navigation for Host and Guest users.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/auth/controllers/auth_controller.dart` | Login/logout logic, form handling |
| `@/lib/features/auth/repositories/auth_repository.dart` | API calls for auth operations |
| `@/lib/features/auth/repositories/auth_repository_interface.dart` | Repository interface |
| `@/lib/features/auth/views/login_view.dart` | Login screen UI |
| `@/lib/features/auth/views/signup_screen.dart` | Registration screen UI |
| `@/lib/features/auth/models/user_model.dart` | User data structure |
| `@/lib/core/middleware/auth_guard.dart` | Route protection middleware |
| `@/lib/services/cache/cache_manager.dart` | Token storage and retrieval |

### Dependencies

```
AuthController
  ├── AuthRepositoryInterface (login/logout API)
  ├── MainController (global auth state)
  ├── ErrorDisplayManager (error UI)
  └── CacheManager (token storage)
```

---

## Login Flow

### 1. User Input
```dart
// In AuthController
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final _selectedRole = 'guest'.obs; // 'host' or 'guest'
```

### 2. Login Process
```dart
Future<void> login() async {
  isLoading.value = true;
  try {
    final user = await _repository.login(
      phoneController.text,
      passwordController.text,
    );
    
    // Update global state
    await _mainController.updateUserData(
      user.id,
      user.token,
      user.userType,
      name: user.name,
      email: user.email,
    );
    
    // Navigate based on role
    if (user.userType == 'host') {
      Get.offAllNamed(AppRoute.host);
    } else {
      Get.offAllNamed(AppRoute.guest);
    }
  } finally {
    isLoading.value = false;
  }
}
```

### 3. Token Storage
```dart
// CacheManager stores tokens in SharedPreferences
static Future<bool> setToken(String tokenValue) async => 
    await _saveToCache(CacheKeys.token.name, tokenValue);

static Future<bool> setRefreshToken(String refreshTokenValue) async => 
    await _saveToCache(CacheKeys.refreshToken.name, refreshTokenValue);
```

---

## Session Management

### Token Persistence

**Stored in SharedPreferences:**
- `token` - Access token
- `refreshToken` - Refresh token
- `role` - User type ('host' or 'guest')
- `userId` - User identifier
- `username` - Cached credentials
- `password` - Cached credentials (⚠️ for auto-login convenience)

### Session Restoration

**`@/lib/main.dart`**
```dart
Future<void> _restoreAppState(SharedPreferences prefs) async {
  final token = prefs.getString(CacheKeys.token.name);
  if (token != null && token.isNotEmpty) {
    mainControl.accessToken.value = token;
    mainControl.isLogin.value = true;
    mainControl.uType.value = prefs.getString(CacheKeys.role.name) ?? '';
    // ... restore other user data
  }
}
```

---

## AuthGuard Middleware

**`@/lib/core/middleware/auth_guard.dart`**

Protects routes by checking authentication:

```dart
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final mainControl = Get.find<MainController>();
    
    // Check if logged in
    if (mainControl.isLogin.value && 
        mainControl.accessToken.value.isNotEmpty) {
      return null; // Allow access
    }
    
    // Try to restore from cache
    final token = CacheManager.prefs?.getString(CacheKeys.token.name);
    if (token != null && token.isNotEmpty) {
      // Restore session and allow access
      mainControl.accessToken(token);
      mainControl.isLogin.value = true;
      return null;
    }
    
    // Redirect to login
    return const RouteSettings(name: AppRoute.login);
  }
}
```

---

## User Roles

### Role Detection

**In MainController:**
```dart
RxString uType = RxString(''); // 'host' or 'guest'
```

**Navigation Decision:**
```dart
final String initialRoute = mainControl.isLogin.value
    ? (mainControl.uType.value == 'host' ? AppRoute.host : AppRoute.guest)
    : AppRoute.guest;
```

### Host vs Guest Navigation

| Role | Home Screen | Navigation Flow |
|------|-------------|-----------------|
| **Host** | `HostBottomNavigationBarView` | Today → Inbox → Calendar → Finance → Menu |
| **Guest** | `GuestBottomNavigationBarView` | Explore → Wishlist → Trips → Inbox → Profile |

---

## Logout Process

```dart
Future<void> logout() async {
  // Clear cache
  await CacheManager.removeToken();
  await CacheManager.removeRefreshToken();
  await CacheManager.setRoleName('');
  
  // Reset global state
  mainControl.isLogin.value = false;
  mainControl.accessToken.value = '';
  mainControl.uType.value = '';
  
  // Navigate to login
  Get.offAllNamed(AppRoute.login);
}
```

---

## Referral System

Deep link handling for referral codes:

```dart
void fetchCode() async {
  if ((_mainController.deepLinkReferer ?? '').isEmpty) {
    return;
  }
  
  final response = await _repository.getReferralCode(
    _mainController.deepLinkReferer!,
  );
  
  if (response != null) {
    referCode.value = response.data?.code?.meta?.referCode ?? '';
    _selectedRole.value = response.data?.code?.meta?.referrerType ?? '';
  }
}
```

---

## Error Handling

### Common Errors

| Error | Handling |
|-------|----------|
| Invalid credentials | Show toast notification |
| Network error | Display connectivity error dialog |
| Token expired | Auto-refresh or redirect to login |
| Server error | Display error message via ErrorDisplayManager |

### Error Listener

```dart
void _listenToErrorMessages() {
  ever(errorMessage, (String? message) {
    if (message != null && message.isNotEmpty) {
      _errorDisplay.showError(message);
    }
  });
}
```

---

## Testing Authentication

### Test Credentials
Use test accounts provided by the backend team.

### Deep Link Testing
```bash
# Test referral link
adb shell am start -W -a android.intent.action.VIEW -d "https://apix.stayverz.com/r/168095399910" com.stayverz.stayverz
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/accounts/login/` | POST | User login |
| `/api/v1/accounts/register/` | POST | User registration |
| `/api/v1/accounts/user/profile/` | GET | Get user profile |
| `/api/v1/referrals/my-link/` | GET | Get referral link |
| `/referral-code/{code}/` | GET | Validate referral code |

---

## Security Notes

1. **Token Storage:** Tokens stored in SharedPreferences (not encrypted). Consider using `flutter_secure_storage` for production.
2. **Certificate Override:** `MyHttpOverrides` disables SSL validation in development - **remove for production**.
3. **Auto-login:** Credentials cached for convenience - consider security implications.
4. **Token Refresh:** Automatic token refresh handled by `TokenRefreshInterceptor`.

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [Setup Instructions](../03-setup-instructions.md)
- [API Reference](../05-api-reference.md)
