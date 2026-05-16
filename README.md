# stayverz_flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


 mkdir -p lib/features/public_listings/data/models

## If you are getting any error when running flutter build then use it

```bash
flutter build apk --release --no-tree-shake-icons
```

## For checking deeplink for refer host

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://apix.stayverz.com/r/168095399910" com.stayverz.stayverz
```
