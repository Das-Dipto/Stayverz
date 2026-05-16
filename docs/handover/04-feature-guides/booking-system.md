# Booking System

## Overview

The booking system manages property reservations with two workflows: **Instant Booking** (immediate confirmation) and **Assistance Booking** (requires host approval). Supports both property bookings and assistance service bookings.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/booking/controllers/booking_controller.dart` | Booking state and operations |
| `@/lib/features/booking/data/repositories/booking_repository_impl.dart` | API calls for bookings |
| `@/lib/features/booking/data/models/booking_model.dart` | Booking data structures |
| `@/lib/features/booking/data/models/booking_details_model.dart` | Detailed booking info |
| `@/lib/features/booking/presentation/views/book_and_go_screen.dart` | Booking creation UI |
| `@/lib/features/booking/presentation/views/host_instant_booking_screen.dart` | Host booking management |

### Dependencies

```
BookingController
  ├── BookingRepositoryInterface (booking API)
  ├── MainController (user context)
  └── ErrorDisplayManager (error UI)
```

---

## Booking Types

### 1. Property Bookings

Standard property reservations:

```dart
// In BookingController
final RxList<BookingModel> bookings = <BookingModel>[].obs;
final RxList<BookingModel> upcomingTrips = <BookingModel>[].obs;
final RxList<BookingModel> pastTrips = <BookingModel>[].obs;
final RxList<BookingModel> canceledTrips = <BookingModel>[].obs;
final RxList<BookingModel> ongoingTrips = <BookingModel>[].obs;
```

### 2. Assistance Bookings

Service-based bookings:

```dart
final RxList<AssistanceTrip> bookingsAssistance = <AssistanceTrip>[].obs;
final RxList<AssistanceTrip> upcomingAssistanceTrips = <AssistanceTrip>[].obs;
```

---

## Booking Flows

### Instant Booking (Guest)

1. **Select Property** - Browse and select listing
2. **Select Dates** - Calendar date picker
3. **Guest Details** - Number of guests, special requests
4. **Review & Pay** - Payment via SSLCommerz
5. **Confirmation** - Immediate booking confirmation

```dart
// Create instant booking
Future<void> createBooking({
  required String listingId,
  required DateTime checkIn,
  required DateTime checkOut,
  required int guestCount,
  String? specialRequests,
}) async {
  final booking = await _repository.createBooking(
    listingId: listingId,
    checkIn: checkIn,
    checkOut: checkOut,
    guestCount: guestCount,
    specialRequests: specialRequests,
  );
  
  // Navigate to payment or confirmation
  Get.to(() => PaymentScreen(booking: booking));
}
```

### Assistance Booking (Guest)

1. **Select Service** - Browse assistance categories
2. **Select Schedule** - Available time slots
3. **Fill Form** - Reservation details
4. **Submit Request** - Send to host for approval
5. **Await Confirmation** - Host reviews and approves/denies

### Host Booking Management

Hosts can:
- View all bookings for their properties
- Approve/deny assistance requests
- View booking details and guest info
- Manage calendar availability

---

## Coupon System

### User Coupons

```dart
// Available coupons
final RxList<UserCoupon> userCoupons = <UserCoupon>[].obs;

// Coupon balance
final Rxn<UserCouponBalance> userCouponBalance = Rxn<UserCouponBalance>();

// Apply coupon
Future<void> applyCoupon(String code) async {
  final result = await _repository.applyCoupon(code);
  decrasePrice.value = result.discountAmount;
}
```

### Coupon Flow

1. User enters coupon code
2. System validates and calculates discount
3. Discount applied to booking total
4. Coupon marked as used after successful booking

---

## Review System

Guests can leave reviews after completing bookings:

```dart
// Review data
final Rx<BookingDetails?> bookingDetails = Rx<BookingDetails?>();

// Submit review
Future<void> submitReview({
  required String bookingId,
  required double rating,
  required String comment,
}) async {
  isSubmittingReview.value = true;
  try {
    await _repository.submitReview(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );
    Fluttertoast.showToast(msg: 'Review submitted successfully');
  } finally {
    isSubmittingReview.value = false;
  }
}
```

---

## Data Models

### BookingModel

```dart
class BookingModel {
  final String id;
  final String listingId;
  final String guestId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guestCount;
  final BookingStatus status; // pending, confirmed, cancelled, completed
  final double totalAmount;
  final String? specialRequests;
  final DateTime createdAt;
}
```

### BookingDetails

```dart
class BookingDetails {
  final BookingModel booking;
  final ListingModel listing;
  final UserModel guest;
  final List<ReviewModel> reviews;
  final PaymentInfo payment;
}
```

### AssistanceTrip

```dart
class AssistanceTrip {
  final String id;
  final String assistanceId;
  final String guestId;
  final DateTime scheduledDate;
  final String timeSlot;
  final AssistanceStatus status;
  final double amount;
}
```

---

## Booking Statuses

| Status | Description |
|--------|-------------|
| `pending` | Awaiting host approval (assistance only) |
| `confirmed` | Booking confirmed, payment received |
| `ongoing` | Guest currently staying / service in progress |
| `completed` | Stay finished / service delivered |
| `cancelled` | Booking cancelled by guest or host |
| `refunded` | Payment refunded |

---

## Pagination

```dart
// Pagination state
final RxBool hasMore = true.obs;
final RxInt currentPage = RxInt(1);
final int pageSize = 10;

// Load more bookings
Future<void> loadMoreBookings() async {
  if (!hasMore.value || isLoading.value) return;
  
  final newBookings = await _repository.fetchBookings(
    page: currentPage.value,
    pageSize: pageSize,
  );
  
  if (newBookings.length < pageSize) {
    hasMore.value = false;
  }
  
  bookings.addAll(newBookings);
  currentPage.value++;
}
```

---

## Payment Integration

### SSLCommerz

Payment processing via SSLCommerz gateway:

```dart
Future<void> initiatePayment(BookingModel booking) async {
  final paymentData = await _repository.initiateSslcommerzPayment(
    bookingId: booking.id,
    amount: booking.totalAmount,
  );
  
  // Open payment gateway
  Get.to(() => PaymentWebView(
    paymentUrl: paymentData.gatewayUrl,
    onSuccess: _handlePaymentSuccess,
    onFailure: _handlePaymentFailure,
  ));
}
```

---

## Host Booking Actions

```dart
// Approve assistance booking
Future<void> approveBooking(String bookingId) async {
  await _repository.updateBookingStatus(
    bookingId: bookingId,
    status: BookingStatus.confirmed,
  );
}

// Deny assistance booking
Future<void> denyBooking(String bookingId, String reason) async {
  await _repository.updateBookingStatus(
    bookingId: bookingId,
    status: BookingStatus.cancelled,
    cancellationReason: reason,
  );
}
```

---

## API Endpoints

### Property Bookings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/bookings/` | GET | List bookings |
| `/api/v1/bookings/` | POST | Create booking |
| `/api/v1/bookings/{id}/` | GET | Get booking details |
| `/api/v1/bookings/{id}/cancel/` | POST | Cancel booking |
| `/api/v1/bookings/{id}/review/` | POST | Submit review |

### Assistance Bookings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/assistance/bookings/` | GET | List assistance bookings |
| `/api/v1/assistance/bookings/` | POST | Create assistance booking |
| `/api/v1/payments/initiate/sslcommerz` | POST | Initiate payment |

### Coupons

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/coupons/` | GET | List user coupons |
| `/api/v1/coupons/apply/` | POST | Apply coupon |
| `/api/v1/coupons/balance/` | GET | Get coupon balance |

---

## Error Handling

### Common Errors

| Error | Handling |
|-------|----------|
| Dates unavailable | Show calendar with unavailable dates marked |
| Payment failed | Retry payment or cancel booking |
| Coupon invalid | Show error message, clear coupon field |
| Booking conflict | Show alternative dates |

### Network Errors

```dart
try {
  await _repository.createBooking(data);
} on DioException catch (e) {
  if (e.response?.statusCode == 409) {
    _errorDisplay.showError('Dates already booked');
  } else {
    _errorDisplay.showError('Network error. Please try again.');
  }
}
```

---

## Testing

### Test Scenarios

1. **Create Instant Booking:**
   - Select dates, guests, complete flow
   - Verify payment processing
   - Check booking appears in trips

2. **Create Assistance Booking:**
   - Select service and schedule
   - Submit request
   - Verify host receives notification

3. **Host Actions:**
   - Approve/deny assistance requests
   - View booking calendar
   - Check revenue reports

4. **Cancellation:**
   - Cancel as guest
   - Verify refund processed
   - Check status updated

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [API Reference](../05-api-reference.md)
- [Assistance Service](./assistance-service.md)
