# Stayverz Flutter App - Handover Documentation

Complete documentation for external development teams to understand, maintain, and extend the Stayverz vacation rental application.

---

## Quick Navigation

### Getting Started
1. [Project Overview](./01-project-overview.md) - Executive summary, tech stack, user roles
2. [Architecture Guide](./02-architecture-guide.md) - MVVM + GetX patterns, project structure
3. [Setup Instructions](./03-setup-instructions.md) - Environment setup, build commands

### Feature Documentation
4. [Authentication](./04-feature-guides/authentication.md) - Login, JWT, role-based navigation
5. [Booking System](./04-feature-guides/booking-system.md) - Instant & assistance booking, payments
6. [Messaging](./04-feature-guides/messaging.md) - WebSocket chat, real-time messaging
7. [Listings](./04-feature-guides/listings.md) - Property management, public browsing
8. [Finance Reports](./04-feature-guides/finance-reports.md) - Revenue tracking, analytics
9. [Assistance Service](./04-feature-guides/assistance-service.md) - Additional services
10. [User Feedback](./04-feature-guides/user-feedback.md) - Feedback submission

### Technical Reference
11. [API Reference](./05-api-reference.md) - All endpoints, WebSocket URLs
12. [Integration Points](./06-integration-points.md) - Firebase, Maps, Payments
13. [Troubleshooting](./09-troubleshooting.md) - Common issues and solutions
14. [Recent Changes](./10-recent-changes.md) - Latest updates, migrations

---

## Project at a Glance

| | |
|---|---|
| **App Name** | Stayverz |
| **Version** | 1.0.11+39 |
| **Platform** | iOS, Android |
| **Framework** | Flutter 3.7.2+ |
| **Language** | Dart 3.0.0+ |
| **Architecture** | MVVM + GetX |
| **State Management** | GetX |
| **Networking** | Dio |
| **Local Storage** | SharedPreferences |

### User Roles

| Role | Description | Navigation |
|------|-------------|------------|
| **Host** | Property owners/managers | Today → Inbox → Calendar → Finance → Menu |
| **Guest** | Travelers seeking accommodations | Explore → Wishlist → Trips → Inbox → Profile |

### API Services

| Service | URL | Purpose |
|---------|-----|---------|
| Main API | `https://apix.stayverz.com` | Core functionality |
| Assistance API | `https://api-assistance.stayverz.com` | Additional services |
| Messaging API | `https://api-chat.stayverz.com` | Chat & WebSocket |

---

## Key Features

1. **Authentication** - Phone/email with OTP, JWT tokens
2. **Property Listings** - Create/edit properties, availability calendar
3. **Bookings** - Instant and assistance booking workflows
4. **Messaging** - Real-time WebSocket chat
5. **Finance** - Revenue tracking, payouts, reports
6. **Assistance Services** - Tours, activities, experiences
7. **User Feedback** - Rating and feedback submission

---

## Architecture Highlights

### MVVM + GetX Pattern

```
Model → Repository → Controller → View (GetView)
```

### Dependency Injection Flow

```
main()
  └── MainBinding()
        └── CoreBinding()
              ├── ApiClient
              ├── AuthRepository
              ├── WebSocketService
              └── ...
        └── MainController
```

### Project Structure

```
lib/
├── core/           # Constants, bindings, middleware
├── features/       # Feature modules (auth, booking, etc.)
├── services/       # Cache, network, notifications
├── controllers/    # Global controllers
└── widgets/        # Shared widgets
```

---

## Quick Commands

### Development

```bash
# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Check dependencies
flutter doctor -v
```

### Build (Important Flags)

```bash
# Android APK
flutter build apk --release --no-tree-shake-icons

# Android App Bundle
flutter build appbundle --release --no-tree-shake-icons

# iOS
flutter build ios --release
```

### Maintenance

```bash
# Clean cache
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Format code
dart format .
```

---

## Important Notes

### Build Requirements

1. **Always use `--no-tree-shake-icons`** for Android builds (custom font icons)
2. **NDK 27.0.12077973** configured in `android/app/build.gradle.kts`
3. **Remove `MyHttpOverrides`** for production (disables SSL validation)

### Current Migrations

- **WebSocket Migration:** Replacing WebView messaging with native WebSocket
- **Feature Migration:** Moving views from `/views/` to `/features/*`
- **Model Updates:** Adding `toJson()` methods for serialization

### Known Issues

| Issue | Workaround | Status |
|-------|-----------|--------|
| IconTreeShakerException | Use `--no-tree-shake-icons` flag | Permanent |
| SSL Override | `MyHttpOverrides` class | Remove for prod |
| WebView Messaging | Native WebSocket in progress | Migrating |

---

## For New Developers

### First Steps

1. Read [Project Overview](./01-project-overview.md)
2. Follow [Setup Instructions](./03-setup-instructions.md)
3. Review [Architecture Guide](./02-architecture-guide.md)
4. Study feature guides for your assigned area
5. Check [Troubleshooting](./09-troubleshooting.md) when stuck

### Key Patterns to Know

1. **GetX State Management:** Use `.obs` variables and `Obx()` widgets
2. **Repository Pattern:** Interface/Implementation separation
3. **Dependency Injection:** `Get.lazyPut()` and `Get.find()`
4. **Navigation:** Named routes with `Get.toNamed()`

### Code Style

- Follow existing patterns in the codebase
- Use `GetView<Controller>` for screens
- Handle errors via `ErrorDisplayManager`
- Add `toJson()` to new models
- Document public APIs with comments

---

## Support & Resources

### Documentation

- **Flutter:** https://docs.flutter.dev/
- **GetX:** https://pub.dev/packages/get
- **Dio:** https://pub.dev/packages/dio

### Project Resources

- **API Routes:** `@/lib/core/constants/api_routes.dart`
- **App Routes:** `@/lib/core/constants/app_routes.dart`
- **Main Binding:** `@/lib/core/bindings/main_binding.dart`
- **Main Controller:** `@/lib/controllers/main_controller.dart`

### Testing

```bash
# Test deep links
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://apix.stayverz.com/r/168095399910" \
  com.stayverz.stayverz
```

---

## Document Versions

| Document | Last Updated | Status |
|----------|--------------|--------|
| README | Apr 2025 | Current |
| Project Overview | Apr 2025 | Current |
| Architecture Guide | Apr 2025 | Current |
| Setup Instructions | Apr 2025 | Current |
| Feature Guides | Apr 2025 | Current |
| API Reference | Apr 2025 | Current |
| Integration Points | Apr 2025 | Current |
| Troubleshooting | Apr 2025 | Current |
| Recent Changes | Apr 2025 | Current |

---

## Contact

For questions or clarifications about this documentation, refer to:
- Code comments in key files
- Existing memory system entries
- Architecture decision records

---

**End of Handover Documentation**
