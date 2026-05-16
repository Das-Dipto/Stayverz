# Integration Points

## Overview

This document covers all third-party integrations and external services used in the Stayverz app.

---

## Firebase

### Firebase Cloud Messaging (FCM)

**Purpose:** Push notifications for new messages, bookings, and system alerts.

**Configuration:**
- `android/app/google-services.json` - Android config
- `ios/Runner/GoogleService-Info.plist` - iOS config

**Usage:**
```dart
// Initialize in main.dart
await Firebase.initializeApp();
await NotificationService().initFCM();

// Handle messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Handle foreground message
});
```

**Key Files:**
- `@/lib/services/notification_service.dart`
- `@/lib/features/notification/`

### Firebase Services Used

| Service | Purpose | Package |
|---------|---------|---------|
| Cloud Messaging | Push notifications | `firebase_messaging: ^15.2.7` |
| Core | Firebase initialization | `firebase_core: ^3.15.1` |

---

## Google Maps

### Google Maps Flutter

**Purpose:** Property location display, address search, and map-based browsing.

**Configuration:**
1. Get API key from Google Cloud Console
2. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>
```
3. Add to `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_API_KEY")
```

**Usage:**
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14,
  ),
  markers: markers,
  onMapCreated: (controller) => mapController = controller,
)
```

**Geocoding:**
```dart
// Address to coordinates
final locations = await locationFromAddress('Dhaka, Bangladesh');

// Coordinates to address
final placemarks = await placemarkFromCoordinates(lat, lng);
```

**Package:** `google_maps_flutter: ^2.12.1`, `geocoding: ^2.1.1`

---

## Payment Gateway

### SSLCommerz

**Purpose:** Process payments for bookings.

**Flow:**
1. Initiate payment via API
2. Open WebView with gateway URL
3. User completes payment
4. Receive callback/redirect
5. Verify payment status

**Implementation:**
```dart
// Initiate payment
final paymentData = await _repository.initiateSslcommerzPayment(
  bookingId: booking.id,
  amount: booking.totalAmount,
);

// Open payment WebView
Get.to(() => PaymentWebView(
  paymentUrl: paymentData.gatewayUrl,
  onSuccess: (tranId) => verifyPayment(tranId),
  onFailure: () => showPaymentFailed(),
));
```

**API Endpoint:** `POST /payments/initiate/sslcommerz`

---

## WebSocket

### Real-time Messaging

**Purpose:** Instant message delivery and typing indicators.

**Service:** `@/lib/features/messaging/data/services/websocket_service.dart`

**Connection Types:**
```dart
// Global events (presence, new messages)
connectGlobalRoom(authToken);

// Unread count updates
connectChatStats(authToken);

// Individual conversation
connectChatRoom(roomId, token);
```

**Package:** `web_socket_channel: ^3.0.3`

---

## Image Handling

### Cached Network Image

**Purpose:** Efficient image loading with caching.

**Usage:**
```dart
CachedNetworkImage(
  imageUrl: listing.photos.first,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 800,
)
```

**Package:** `cached_network_image: ^3.3.1`

### Image Picker

**Purpose:** Select/take photos for listings and profile.

```dart
// From gallery
final images = await ImagePicker().pickMultiImage();

// From camera
final photo = await ImagePicker().pickImage(source: ImageSource.camera);
```

**Package:** `image_picker: ^1.1.2`

### Image Compression

**Purpose:** Reduce upload size before sending to server.

```dart
final compressed = await FlutterImageCompress.compressWithFile(
  image.path,
  minWidth: 1080,
  minHeight: 1080,
  quality: 85,
);
```

**Package:** `flutter_image_compress: ^2.4.0`

---

## Storage

### SharedPreferences

**Purpose:** Local storage for auth tokens and user preferences.

**Implementation:** `@/lib/services/cache/cache_manager.dart`

```dart
// Store
await CacheManager.setToken(accessToken);
await CacheManager.setRoleName('host');

// Retrieve
final token = await CacheManager.getToken;
final role = CacheManager.roleName;
```

**Package:** `shared_preferences: ^2.5.3`

### GetStorage

**Purpose:** Lightweight key-value storage.

```dart
final box = GetStorage();
box.write('key', 'value');
final value = box.read('key');
```

**Package:** `get_storage: ^2.1.1`

---

## HTTP Client

### Dio

**Purpose:** HTTP requests with interceptors.

**Configuration:** `@/lib/services/network/api_client.dart`

**Features:**
- Request/response interceptors
- Token refresh handling
- Connectivity awareness
- Request cancellation
- Timeout handling (120s default)

**Package:** `dio: ^5.8.0+1`

---

## Charts

### FL Chart

**Purpose:** Financial reports with bar and pie charts.

**Usage:**
```dart
BarChart(
  BarChartData(
    barGroups: _generateBarGroups(),
    titlesData: FlTitlesData(...),
  ),
)

PieChart(
  PieChartData(
    sections: _generatePieSections(),
    centerSpaceRadius: 40,
  ),
)
```

**Package:** `fl_chart: ^0.71.0`

---

## Notifications

### Flutter Local Notifications

**Purpose:** Local notifications for reminders and alerts.

```dart
FlutterLocalNotificationsPlugin().show(
  id,
  'Title',
  'Body',
  NotificationDetails(
    android: AndroidNotificationDetails(...),
    iOS: DarwinNotificationDetails(),
  ),
);
```

**Package:** `flutter_local_notifications: ^19.3.0`

---

## Location

### Geolocator

**Purpose:** Get device location for "Near me" search.

```dart
// Get current position
final position = await Geolocator.getCurrentPosition();

// Check permission
final permission = await Geolocator.checkPermission();

// Calculate distance
final distance = Geolocator.distanceBetween(
  startLatitude, startLongitude,
  endLatitude, endLongitude,
);
```

**Package:** `geolocator: ^11.0.0`

---

## PDF Generation

### PDF + Printing

**Purpose:** Generate and print booking receipts.

```dart
final pdf = pw.Document();
pdf.addPage(pw.Page(
  build: (context) => pw.Text('Receipt'),
));

// Print
await Printing.layoutPdf(
  onLayout: (format) => pdf.save(),
);

// Share
await Printing.sharePdf(
  bytes: await pdf.save(),
  filename: 'receipt.pdf',
);
```

**Packages:**
- `pdf: ^3.11.3`
- `printing: ^5.14.2`

---

## Deep Linking

### Referral Links

**Purpose:** Track user referrals via deep links.

**URL Format:** `https://apix.stayverz.com/r/{code}`

**Handling:**
```dart
// Detected in SplashScreen
if (initialLink != null) {
  mainController.deepLinkReferer = extractReferralCode(initialLink);
}

// Used in AuthController
void fetchCode() async {
  if (mainController.deepLinkReferer?.isNotEmpty == true) {
    final response = await _repository.getReferralCode(
      mainController.deepLinkReferer!,
    );
    // Apply referral code
  }
}
```

**Testing:**
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://apix.stayverz.com/r/168095399910" \
  com.stayverz.stayverz
```

---

## App Updates

### Upgrader

**Purpose:** Prompt users to update when new version available.

```dart
UpgradeAlert(
  child: YourAppContent(),
  dialogStyle: UpgradeDialogStyle.material,
)
```

**Package:** `upgrader: ^12.5.0`

---

## Connectivity

### Connectivity Plus

**Purpose:** Monitor network connectivity state.

```dart
// Check connection
final result = await Connectivity().checkConnectivity();
final isOnline = result != ConnectivityResult.none;

// Listen for changes
Connectivity().onConnectivityChanged.listen((result) {
  isOnline = result != ConnectivityResult.none;
});
```

**Package:** `connectivity_plus: ^6.1.0`

---

## Summary Table

| Integration | Package | Purpose |
|-------------|---------|---------|
| Firebase | `firebase_messaging` | Push notifications |
| Google Maps | `google_maps_flutter` | Location/maps |
| Payments | SSLCommerz API | Booking payments |
| WebSocket | `web_socket_channel` | Real-time chat |
| Images | `cached_network_image` | Image loading |
| HTTP | `dio` | API requests |
| Storage | `shared_preferences` | Local storage |
| Charts | `fl_chart` | Financial reports |
| Location | `geolocator` | GPS services |
| PDF | `pdf`, `printing` | Receipts |
| Notifications | `flutter_local_notifications` | Local alerts |

---

## Configuration Checklist

For new development environment:

- [ ] Firebase project setup (`google-services.json`, `GoogleService-Info.plist`)
- [ ] Google Maps API key
- [ ] SSLCommerz merchant credentials
- [ ] WebSocket endpoints configured
- [ ] Push notification certificates (iOS)
- [ ] Deep linking domain verification

---

## Related Documentation

- [API Reference](./05-api-reference.md)
- [Setup Instructions](./03-setup-instructions.md)
- [Troubleshooting](./09-troubleshooting.md)
