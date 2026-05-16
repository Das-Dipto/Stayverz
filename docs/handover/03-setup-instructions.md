# Stayverz Flutter App - Setup Instructions

## Prerequisites

### Required Software
- **Flutter SDK:** 3.7.2 or higher
- **Dart SDK:** 3.0.0 or higher (included with Flutter)
- **Android Studio:** Latest stable version (for Android builds)
- **Xcode:** 15.0+ (for iOS builds, macOS only)
- **Git:** For version control

### System Requirements
- **macOS:** 12.0+ (for iOS development)
- **Windows/Linux:** Windows 10+ or modern Linux distribution
- **RAM:** 8GB minimum, 16GB recommended
- **Storage:** 10GB free space minimum

---

## Environment Setup

### 1. Install Flutter

```bash
# macOS (using Homebrew)
brew install flutter

# Or download from https://docs.flutter.dev/get-started/install

# Verify installation
flutter doctor
```

### 2. Install IDE

**Android Studio (Recommended):**
1. Download from https://developer.android.com/studio
2. Install Flutter and Dart plugins
3. Configure Android SDK

**VS Code (Alternative):**
1. Install VS Code
2. Install Flutter and Dart extensions
3. Configure Flutter SDK path

### 3. Configure Android SDK

```bash
# Check Android SDK path
flutter config --android-sdk /path/to/android/sdk

# Accept licenses
flutter doctor --android-licenses
```

### 4. Configure iOS (macOS only)

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios && pod install
```

---

## Project Setup

### 1. Clone Repository

```bash
cd /path/to/your/projects
git clone <repository-url>
cd stayverz_flutter_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

The app uses Firebase for push notifications. Configuration files are pre-included:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

**Note:** These are tied to the production Firebase project. For development, you may need to create your own Firebase project and replace these files.

### 4. Verify Setup

```bash
flutter doctor -v
```

Expected output should show:
- [✓] Flutter (Channel stable)
- [✓] Android toolchain
- [✓] Xcode (if on macOS)
- [✓] Chrome (for web)
- [✓] Android Studio

---

## Running the App

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Build Commands

**Android:**
```bash
# Debug build
flutter build apk

# Release build (REQUIRED FLAG due to custom fonts)
flutter build apk --release --no-tree-shake-icons

# App bundle for Play Store
flutter build appbundle --release --no-tree-shake-icons
```

**iOS:**
```bash
# Debug build
flutter build ios

# Release build
flutter build ios --release
```

---

## Environment Configuration

### API Base URLs

API endpoints are configured in:
**`@/lib/core/constants/api_routes.dart`**

```dart
// Production URLs
static const String baseURL = 'https://apix.stayverz.com';
static const String assistanceBaseURL = 'https://api-assistance.stayverz.com';
static const String messagingBaseURL = 'https://api-chat.stayverz.com';

// Development URLs (commented out)
// static const String baseURL = 'http://192.168.8.156:8000';
```

**To switch to development:**
1. Comment out production URLs
2. Uncomment development URLs
3. Hot restart the app

### Certificate Override (Development)

**`@/lib/main.dart`** includes `MyHttpOverrides` that disables SSL certificate validation:

```dart
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Applied in main()
HttpOverrides.global = MyHttpOverrides();
```

**⚠️ Remove this for production builds.**

---

## Common Setup Issues

### Issue: `IconTreeShakerException`
**Error:** "This tool cannot process icon fonts with multiple fonts in a single family"

**Solution:**
```bash
# Add --no-tree-shake-icons flag to build commands
flutter build apk --release --no-tree-shake-icons
flutter build appbundle --release --no-tree-shake-icons
```

### Issue: NDK Version Mismatch
**Error:** "NDK version mismatch" or "NDK not configured"

**Solution:**
Already configured in `android/app/build.gradle.kts`:
```kotlin
ndkVersion = "27.0.12077973"
```

If different NDK required, update this value.

### Issue: CocoaPods Error (iOS)
**Error:** "CocoaPods not installed or not in PATH"

**Solution:**
```bash
sudo gem install cocoapods
cd ios && pod install
```

### Issue: Gradle Sync Failed
**Solution:**
```bash
cd android
./gradlew clean
./gradlew build
```

### Issue: Flutter/Dart Version Mismatch
**Solution:**
```bash
# Check versions
flutter --version
dart --version

# Update Flutter
flutter upgrade

# If using fvm (Flutter Version Management)
fvm use 3.7.2
```

---

## IDE Configuration

### Android Studio

1. **Open Project:** File → Open → Select `stayverz_flutter_app`
2. **Enable Dart Analysis:** View → Tool Windows → Dart Analysis
3. **Configure Device:** Tools → Device Manager
4. **Run Configuration:** Select main.dart, choose target device

### VS Code

1. **Open Project:** File → Open Folder
2. **Launch Configuration:** Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Stayverz Debug",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart"
    }
  ]
}
```

---

## Verification Checklist

After setup, verify:

- [ ] `flutter doctor` shows all checks passed
- [ ] App runs in debug mode on Android emulator/device
- [ ] App runs in debug mode on iOS simulator/device (macOS)
- [ ] Login screen appears (indicates navigation works)
- [ ] No compilation errors
- [ ] Hot reload works (make a small change and save)

---

## Deep Link Testing

Test referral deep links on Android:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://apix.stayverz.com/r/168095399910" com.stayverz.stayverz
```

---

## Next Steps

1. Read [02-architecture-guide.md](./02-architecture-guide.md) to understand the codebase
2. Review feature-specific guides in `04-feature-guides/`
3. Check [05-api-reference.md](./05-api-reference.md) for API details
4. See [09-troubleshooting.md](./09-troubleshooting.md) for common issues
