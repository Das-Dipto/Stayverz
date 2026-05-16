# Assistance Service

## Overview

The assistance service feature allows Hosts to offer additional services (tours, activities, experiences) to Guests. It operates as a separate microservice with its own API and booking flow.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/assistance_service/controllers/assistance_service_controller.dart` | Service management |
| `@/lib/features/assistance_service/repositories/assistance_service_repository_impl.dart` | API operations |
| `@/lib/features/assistance_service/presentation/views/create_assistance/create_assistance_service_screen.dart` | Create service UI |
| `@/lib/features/assistance_service/presentation/views/public_assistance_details_screen.dart` | Public service view |
| `@/lib/features/assistance_service/models/assistance_listing_response_model.dart` | Data models |

### Service Architecture

```
Assistance Service
├── Separate API: https://api-assistance.stayverz.com
├── Categories and subcategories
├── Schedule-based bookings
├── Host approval workflow
└── Independent payment processing
```

---

## Host: Creating Services

### Service Creation Flow

1. **Service Info:**
   - Title and description
   - Category selection (with subcategories)
   - Pricing model (fixed, per person, per hour)

2. **Schedule Setup:**
   - Available dates and time slots
   - Duration per slot
   - Maximum participants per slot
   - Buffer time between bookings

3. **Media:**
   - Upload service photos
   - Cover image selection

4. **Location:**
   - Meeting point address
   - Map coordinates
   - Pickup options

5. **Policies:**
   - Cancellation policy
   - Age restrictions
   - What to bring

6. **Publish**

```dart
Future<void> createAssistanceService({
  required String title,
  required String description,
  required String categoryId,
  required String? subCategoryId,
  required double price,
  required PricingType pricingType,
  required List<ScheduleSlot> schedule,
  required List<File> photos,
  required Address meetingPoint,
  required CancellationPolicy policy,
}) async {
  isLoading.value = true;
  try {
    final service = await _repository.createAssistance(
      title: title,
      description: description,
      categoryId: categoryId,
      // ... other params
    );
    
    Fluttertoast.showToast(msg: 'Service created successfully');
    Get.offAllNamed(AppRoute.host);
  } finally {
    isLoading.value = false;
  }
}
```

---

## Service Categories

### Category Structure

```dart
class AssistanceCategory {
  final String id;
  final String name;
  final String iconUrl;
  final List<AssistanceSubCategory> subCategories;
}

class AssistanceSubCategory {
  final String id;
  final String name;
  final String parentId;
}
```

### Available Categories

| Category | Subcategories |
|----------|---------------|
| **Tours** | City tours, Food tours, Adventure tours |
| **Activities** | Water sports, Hiking, Cycling |
| **Experiences** | Cooking classes, Workshops, Cultural |
| **Transport** | Airport pickup, Car rental, Transfers |

---

## Guest: Browsing & Booking

### Public Service View

```dart
// Browse services by category
Future<void> browseByCategory(String categoryId) async {
  isLoading.value = true;
  assistanceListings.value = await _repository.getAssistanceByCategory(
    categoryId: categoryId,
    page: currentPage.value,
  );
  isLoading.value = false;
}

// Search services
Future<void> searchAssistance(String query) async {
  final results = await _repository.searchAssistance(
    query: query,
    location: selectedLocation.value,
    date: selectedDate.value,
    guests: guestCount.value,
  );
  searchResults.value = results;
}
```

### Service Details

```dart
class AssistanceDetailsModel {
  final String id;
  final String title;
  final String description;
  final HostInfo host;
  final double price;
  final PricingType pricingType;
  final List<String> photos;
  final Address meetingPoint;
  final List<ScheduleSlot> availableSlots;
  final CancellationPolicy cancellationPolicy;
  final List<ReviewModel> reviews;
  final double rating;
}
```

---

## Schedule-Based Booking

### Time Slot Selection

```dart
class ScheduleSlot {
  final String id;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int maxParticipants;
  final int bookedCount;
  final bool isAvailable;
  
  int get availableSpots => maxParticipants - bookedCount;
}
```

### Booking Flow

1. **Select Service** - Browse and choose assistance
2. **Select Date** - View available dates
3. **Select Time Slot** - Choose from available slots
4. **Enter Details** - Guest count, special requests
5. **Submit Request** - Request sent to host
6. **Host Approval** - Host confirms or denies
7. **Payment** - Guest pays after approval
8. **Confirmation** - Booking confirmed

```dart
Future<void> createAssistanceBooking({
  required String assistanceId,
  required String slotId,
  required int guestCount,
  required DateTime date,
  String? specialRequests,
}) async {
  final booking = await _repository.createAssistanceBooking(
    assistanceId: assistanceId,
    slotId: slotId,
    guestCount: guestCount,
    date: date,
    specialRequests: specialRequests,
  );
  
  // Navigate to payment screen
  Get.to(() => AssistancePaymentScreen(booking: booking));
}
```

---

## Pricing Models

### Pricing Types

```dart
enum PricingType {
  fixed,        // Flat rate for the service
  perPerson,    // Price per participant
  perHour,      // Hourly rate
}
```

### Price Calculation

```dart
double calculateTotalPrice({
  required PricingType type,
  required double basePrice,
  required int guestCount,
  required int hours,
}) {
  switch (type) {
    case PricingType.fixed:
      return basePrice;
    case PricingType.perPerson:
      return basePrice * guestCount;
    case PricingType.perHour:
      return basePrice * hours;
  }
}
```

---

## Host: Managing Bookings

### Assistance Host Dashboard

```dart
// Load assistance bookings
Future<void> fetchAssistanceHostBookings() async {
  isLoading.value = true;
  final bookings = await _repository.getAssistanceHostBookings(
    status: selectedStatus.value, // pending, confirmed, completed
    page: currentPage.value,
  );
  hostBookings.value = bookings;
  isLoading.value = false;
}
```

### Booking Actions

```dart
// Approve booking request
Future<void> approveAssistanceBooking(String bookingId) async {
  await _repository.updateAssistanceBookingStatus(
    bookingId: bookingId,
    status: AssistanceBookingStatus.confirmed,
  );
  Fluttertoast.showToast(msg: 'Booking approved');
}

// Deny booking request
Future<void> denyAssistanceBooking(String bookingId, String reason) async {
  await _repository.updateAssistanceBookingStatus(
    bookingId: bookingId,
    status: AssistanceBookingStatus.cancelled,
    cancellationReason: reason,
  );
  Fluttertoast.showToast(msg: 'Booking denied');
}
```

---

## Cancellation Policies

### Policy Types

| Policy | Description |
|--------|-------------|
| **Flexible** | Full refund up to 24 hours before |
| **Moderate** | Full refund up to 5 days before |
| **Strict** | 50% refund up to 7 days before |
| **Non-refundable** | No refunds |

```dart
class CancellationPolicy {
  final String id;
  final String name;
  final String description;
  final Duration refundWindow;
  final double refundPercentage;
}
```

---

## Reviews & Ratings

### Assistance Reviews

```dart
class AssistanceReviewModel {
  final String id;
  final String bookingId;
  final String guestId;
  final double rating; // 1-5 stars
  final String comment;
  final DateTime createdAt;
  final List<String> photos; // Optional photo reviews
}
```

### Submit Review

```dart
Future<void> submitAssistanceReview({
  required String bookingId,
  required double rating,
  required String comment,
  List<File>? photos,
}) async {
  await _repository.submitAssistanceReview(
    bookingId: bookingId,
    rating: rating,
    comment: comment,
    photos: photos,
  );
}
```

---

## API Endpoints

### Base URL
```
https://api-assistance.stayverz.com
```

### Categories

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/assistance/categories` | GET | List all categories |
| `/assistance/cancellation-polices` | GET | Get cancellation policies |

### Services

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/assistance/create-assistance` | POST | Create new service |
| `/assistance/details/{id}` | GET | Get service details (host view) |
| `/assistance/public-details/{id}` | GET | Get service details (public view) |
| `/assistance/listings/{id}/` | PUT | Update service |
| `/assistance/listing-calendars/{id}/` | GET | Get service calendar |
| `/assistance/search` | GET | Search services |

### Bookings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/bookings` | POST | Create booking |
| `/assistance-host/list/` | GET | List host's assistance bookings |

### Payments

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/payments/initiate/sslcommerz` | POST | Initiate payment |

---

## Integration with Main App

### Navigation

Assistance service screens are accessible from:
- Host: Menu → Assistance Services
- Guest: Explore → Assistance Services

### Shared Components

- **Host/Guest detection:** Uses `MainController.uType`
- **Authentication:** Same JWT token as main app
- **Payment:** SSLCommerz integration shared with property bookings
- **Messaging:** Chat with assistance host through main messaging system

---

## Testing

### Test Scenarios

1. **Create Service (Host):**
   - Fill all required fields
   - Upload photos
   - Set schedule
   - Publish and verify in list

2. **Book Service (Guest):**
   - Browse services
   - Select date and time
   - Submit booking request
   - Complete payment

3. **Manage Bookings (Host):**
   - View pending requests
   - Approve/deny bookings
   - Check calendar updates

4. **Cancellation:**
   - Cancel as guest
   - Verify refund policy applied
   - Check host notification

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [Booking System](./booking-system.md)
- [Finance Reports](./finance-reports.md)
- [API Reference](../05-api-reference.md)
