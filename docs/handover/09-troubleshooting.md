# Troubleshooting Guide

## Common Issues and Solutions

---

## Build Issues

### IconTreeShakerException

**Error:**
```
This tool cannot process icon fonts with multiple fonts in a single family
```

**Solution:**
Add `--no-tree-shake-icons` flag to build commands:

```bash
flutter build apk --release --no-tree-shake-icons
flutter build appbundle --release --no-tree-shake-icons
```

**Note:** This is configured in `android/app/build.gradle.kts`:
```kotlin
project.extra.set("extraFrontEndOptions", listOf("--no-tree-shake-icons"))
```

But command-line flag is still required for reliable builds.

---

### NDK Version Mismatch

**Error:**
```
NDK version mismatch or NDK not configured
```

**Solution:**
NDK version is already configured in `@/android/app/build.gradle.kts`:
```kotlin
ndkVersion = "27.0.12077973"
```

If you need a different version:
1. Install the required NDK via Android Studio SDK Manager
2. Update the version in `build.gradle.kts`
3. Clean and rebuild:
```bash
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
flutter build apk --release --no-tree-shake-icons
```

---

### Gradle Sync Failed

**Error:**
```
Gradle sync failed / Could not resolve all dependencies
```

**Solution:**
```bash
# Clean gradle cache
cd android
./gradlew clean
./gradlew build --refresh-dependencies

# Or delete lock files and regenerate
rm -f pubspec.lock
rm -f android/app/*.lock
flutter pub get
```

---

### CocoaPods Error (iOS)

**Error:**
```
CocoaPods not installed or not in PATH
```

**Solution:**
```bash
# Install CocoaPods
sudo gem install cocoapods

# Update pod repo
cd ios
pod repo update
pod install
```

---

## Runtime Issues

### Circular Dependency Error

**Error:**
```
GetX circular dependency detected
Infinite loop of instance creation
```

**Cause:**
A controller or service tries to access another dependency that's still being initialized.

**Solution:**
1. Review dependency chain in bindings
2. Avoid `Get.find()` in constructors if creating circular references
3. Use lazy initialization or method-level dependency resolution

**Known Issue Fixed:**
Previously `RequestInterceptor` had circular dependency with `MainController`. Fixed by removing unused dependency.

---

### WebSocket Connection Failed

**Error:**
```
WebSocketException: Connection refused
```

**Solutions:**
1. Check internet connectivity
2. Verify WebSocket URL in `@/lib/core/constants/api_routes.dart`:
```dart
static String get chatWebSocketUrl => 'wss://api-chat.stayverz.com/api/v1/ws/chat/';
```
3. Check if token is valid
4. Review firewall/proxy settings

**Debug:**
```bash
flutter logs | grep "WebSocket"
```

---

### API 401 Unauthorized

**Error:**
```
DioException: 401 Unauthorized
```

**Solutions:**
1. Token may be expired - auto-refresh should handle this
2. Check if user is logged in:
```dart
print(Get.find<MainController>().isLogin.value);
print(Get.find<MainController>().accessToken.value);
```
3. Verify token in cache:
```dart
print(await CacheManager.getToken);
```
4. Try logout and login again

---

### Image Loading Failed

**Error:**
```
Failed to load image
```

**Solutions:**
1. Check image URL is valid
2. Ensure internet connection
3. Check if image domain is in network_security_config.xml (Android)
4. Clear image cache:
```dart
CachedNetworkImage.evictFromCache(imageUrl);
```

---

## Flutter/Dart Issues

### Version Mismatch

**Error:**
```
The current Dart SDK version does not match
```

**Solution:**
```bash
# Check versions
flutter --version
dart --version

# Update Flutter
flutter upgrade

# If using fvm
fvm use 3.7.2
fvm flutter --version
```

---

### Dependencies Conflict

**Error:**
```
Because every version of X depends on Y and no versions of Y match...
```

**Solution:**
```bash
# Get detailed dependency tree
flutter pub deps

# Update dependencies
flutter pub upgrade

# Or force resolution
flutter pub get --no-precompile
```

---

### Analysis Errors

**Error:**
Linting errors in `flutter analyze`

**Solution:**
1. Check `@/analysis_options.yaml` for configured rules
2. Fix issues or add ignore comments:
```dart
// ignore: avoid_print
print('debug message');

// ignore_for_file: unused_import
```

3. Run formatter:
```bash
dart format .
```

---

## Device/Emulator Issues

### App Not Installing

**Error:**
```
Failed to install APK
```

**Solutions:**
1. Uninstall existing app:
```bash
adb uninstall com.stayverz.stayverz
```
2. Clear build cache:
```bash
flutter clean
flutter pub get
```
3. Check device storage space

---

### Hot Reload Not Working

**Error:**
Hot reload doesn't update UI

**Solutions:**
1. Check for compilation errors in terminal
2. Hot restart instead:
```bash
flutter hot-restart
# or press Shift+R
```
3. Rebuild completely:
```bash
flutter clean
flutter run
```

---

## Platform-Specific Issues

### Android

#### Permission Denied

**Error:**
```
Permission denied for camera/storage/location
```

**Solution:**
Permissions are declared in `AndroidManifest.xml`. Ensure runtime permissions are requested:
```dart
final status = await Permission.camera.request();
if (status.isGranted) {
  // Use camera
}
```

#### Release Build Crashes

**Error:**
App crashes only in release mode

**Solutions:**
1. Check proguard rules
2. Verify all native libraries are included
3. Test with:
```bash
flutter run --release
```

---

### iOS

#### Build Failed: Signing

**Error:**
```
Code signing failed
```

**Solution:**
1. Open Xcode
2. Select project → Signing & Capabilities
3. Select your team
4. Update bundle identifier if needed

#### iOS Simulator Issues

**Error:**
App doesn't run on simulator

**Solution:**
```bash
# Clean build
cd ios
rm -rf build/
rm -rf Pods/
rm Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

---

## Cache Issues

### Clear All Caches

```bash
# Flutter cache
flutter clean

# Gradle cache (Android)
cd android && ./gradlew clean && cd ..

# iOS cache
cd ios
rm -rf build/
rm -rf Pods/
rm Podfile.lock
pod install --repo-update
cd ..

# Pub cache
flutter pub cache clean
flutter pub get

# Delete generated files
rm -rf .dart_tool/
rm -rf build/
```

### Reset Simulator/Device

```bash
# Android
adb shell pm clear com.stayverz.stayverz

# iOS Simulator
# Device → Erase All Content and Settings
```

---

## Debugging Tips

### Enable Debug Logging

```dart
// In main.dart before runApp
debugPrint('Debug message');

// Or use Logger
final logger = Get.find<Logger>();
logger.d('Debug message');
logger.e('Error message');
```

### Check Network Requests

```bash
# View network logs
flutter logs | grep "Dio"
```

Or use DevTools:
```bash
flutter pub global activate devtools
dart devtools
```

### GetX Debugging

```dart
// Print registered dependencies
print(Get.isRegistered<ApiClient>());
print(Get.isRegistered<MainController>());

// Print all registered instances
Get.printInfo();
```

---

## Common Error Messages Quick Reference

| Error | Quick Fix |
|-------|-----------|
| `Binding not found` | Check binding registration order |
| `Null check operator on null` | Add null checks, use `?.` operator |
| `RenderFlex overflowed` | Wrap in SingleChildScrollView or adjust layout |
| `setState called after dispose` | Add `mounted` check before setState |
| `Could not find the correct provider` | Verify GetView/GetWidget usage |
| `Bad state: Stream has already been listened to` | Use broadcast streams or `.asBroadcastStream()` |

---

## Getting Help

If issue persists:

1. **Check existing issues:** Search git history and memory system
2. **Flutter doctor:** Run `flutter doctor -v` for environment check
3. **Logs:** Check full stack trace with `flutter run -v`
4. **Isolate:** Create minimal reproduction case

---

## Related Documentation

- [Setup Instructions](./03-setup-instructions.md)
- [Integration Points](./06-integration-points.md)
