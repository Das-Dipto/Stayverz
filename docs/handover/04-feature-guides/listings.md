# Property Listings

## Overview

The listings feature manages property creation, editing, and browsing. Hosts can create and manage their property listings, while Guests can browse and search available properties.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/listing/controllers/listing_controller.dart` | Listing CRUD operations |
| `@/lib/features/listing/repositories/listing_repository_interface.dart` | Repository interface |
| `@/lib/features/listing/presentation/create_listing/create_listing_screen.dart` | Create/edit listing UI |
| `@/lib/features/listing/presentation/views/my_listing/my_listing_screen.dart` | Host's listings view |
| `@/lib/features/listing/models/listing_model.dart` | Listing data structure |
| `@/lib/features/public_listings/controllers/public_listings_controller.dart` | Public browsing |
| `@/lib/features/public_listings/presentation/views/public_listings_view.dart` | Public listings UI |

### Dependencies

```
ListingController
  ├── ListingRepositoryInterface (listing API)
  ├── ErrorDisplayManager (error UI)
  └── Google Maps (location services)
```

---

## Host Listings Management

### Create Listing Flow

1. **Basic Info:** Title, description, property type
2. **Location:** Address selection with Google Maps
3. **Amenities:** Select available amenities
4. **Photos:** Upload property images
5. **Pricing:** Set nightly rate, cleaning fee
6. **Availability:** Set available dates
7. **House Rules:** Set guest policies
8. **Review & Publish**

```dart
// Create listing
Future<void> createListing({
  required String title,
  required String description,
  required ListingType type,
  required Address address,
  required List<String> amenities,
  required List<File> photos,
  required double pricePerNight,
  required int maxGuests,
}) async {
  isLoadingg.value = true;
  try {
    final listing = await _repository.createListing(
      title: title,
      description: description,
      type: type,
      address: address,
      amenities: amenities,
      photos: photos,
      pricePerNight: pricePerNight,
      maxGuests: maxGuests,
    );
    
    Fluttertoast.showToast(msg: 'Listing created successfully');
    Get.off(() => MyListingScreen());
  } finally {
    isLoadingg.value = false;
  }
}
```

### My Listings

```dart
// State
final RxList<ListingModel> listings = <ListingModel>[].obs;
final RxList<CoHostListingData> coHostListings = <CoHostListingData>[].obs;
final RxInt currentPage = 1.obs;
final RxInt totalPages = 1.obs;

// Load listings with pagination
Future<void> fetchHostListings({bool refresh = false}) async {
  if (refresh) {
    currentPage.value = 1;
    listings.clear();
  }
  
  isHostListingLoading.value = true;
  final response = await _repository.getHostListings(
    page: currentPage.value,
  );
  
  listings.addAll(response.data);
  totalPages.value = response.meta?.totalPages ?? 1;
  currentPage.value++;
  isHostListingLoading.value = false;
}
```

---

## Public Listings (Guest View)

### Browse & Search

```dart
class PublicListingsController extends GetxController {
  final RxList<ListingModel> listings = <ListingModel>[].obs;
  final Rx<SearchFilters> filters = SearchFilters().obs;
  
  // Search with filters
  Future<void> searchListings() async {
    final results = await _repository.searchListings(
      location: filters.value.location,
      checkIn: filters.value.checkIn,
      checkOut: filters.value.checkOut,
      guests: filters.value.guestCount,
      minPrice: filters.value.minPrice,
      maxPrice: filters.value.maxPrice,
      amenities: filters.value.amenities,
    );
    listings.value = results;
  }
}
```

### Search Filters

- **Location:** City, neighborhood, or "Near me" (uses GPS)
- **Dates:** Check-in and check-out
- **Guests:** Number of guests
- **Price Range:** Min/max price per night
- **Amenities:** WiFi, Pool, Kitchen, etc.
- **Property Type:** House, Apartment, Villa, etc.

---

## Calendar Management

### Availability Calendar

```dart
// Calendar state
RxList<DateTime> selectedDates = <DateTime>[].obs;
Rx<CalendarResponse?> calendarResponse = Rx<CalendarResponse?>(null);

// Load calendar data
Future<void> loadCalendar(String listingId) async {
  isCalendarLoading.value = true;
  calendarResponse.value = await _repository.getCalendar(listingId);
  isCalendarLoading.value = false;
}

// Update availability
Future<void> updateAvailability({
  required String listingId,
  required List<DateTime> dates,
  required bool isAvailable,
  double? customPrice,
}) async {
  await _repository.updateCalendar(
    listingId: listingId,
    dates: dates,
    isAvailable: isAvailable,
    customPrice: customPrice,
  );
}
```

### Special Pricing

Set custom prices for specific dates:

```dart
// Apply seasonal pricing
await _repository.setCustomPrice(
  listingId: listingId,
  startDate: DateTime(2024, 12, 20),
  endDate: DateTime(2024, 12, 31),
  price: 200.0, // Holiday rate
);
```

---

## Listing Details

### Property Information

```dart
class ListingDetailsModel {
  final String id;
  final String title;
  final String description;
  final ListingType type;
  final Address address;
  final List<String> amenities;
  final List<String> photos;
  final double pricePerNight;
  final int maxGuests;
  final int bedrooms;
  final int beds;
  final int bathrooms;
  final HostInfo host;
  final List<ReviewModel> reviews;
  final double rating;
}
```

### Location Services

```dart
// Get current location
Future<Position> getCurrentLocation() async {
  final position = await Geolocator.getCurrentPosition();
  return position;
}

// Search address suggestions
Future<List<MapSuggestion>> getAddressSuggestions(String query) async {
  return await _repository.getMapSuggestions(query);
}

// Geocode address to coordinates
Future<LatLng> geocodeAddress(String address) async {
  final locations = await locationFromAddress(address);
  return LatLng(locations.first.latitude, locations.first.longitude);
}
```

---

## Image Management

### Upload Photos

```dart
// Pick images from gallery
Future<void> pickImages() async {
  final images = await ImagePicker().pickMultiImage();
  selectedImages.addAll(images);
}

// Upload to server
Future<List<String>> uploadImages(List<File> images) async {
  final urls = <String>[];
  for (final image in images) {
    final url = await _repository.uploadImage(image);
    urls.add(url);
  }
  return urls;
}
```

### Image Caching

Uses `cached_network_image` for efficient loading:

```dart
CachedNetworkImage(
  imageUrl: listing.photos.first,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

## Amenities

### Available Amenities

| Category | Amenities |
|----------|-----------|
| **Essentials** | WiFi, TV, Kitchen, Washer, Dryer |
| **Features** | Pool, Hot tub, Free parking, EV charger |
| **Location** | Beachfront, Ski-in/Ski-out, Waterfront |
| **Safety** | Smoke alarm, Carbon monoxide alarm |

### Amenity Model

```dart
class AmenityModel {
  final String id;
  final String name;
  final String iconUrl;
  final AmenityCategory category;
}
```

---

## Listing States

| State | Description |
|-------|-------------|
| `draft` | Incomplete listing, not published |
| `pending` | Submitted for review |
| `active` | Published and bookable |
| `paused` | Temporarily not accepting bookings |
| `inactive` | Delisted by host or admin |

---

## Co-Host Management

```dart
// Add co-host
Future<void> addCoHost({
  required String listingId,
  required String coHostEmail,
  required CoHostPermissions permissions,
}) async {
  await _repository.addCoHost(
    listingId: listingId,
    email: coHostEmail,
    permissions: permissions,
  );
}

// Co-host permissions
class CoHostPermissions {
  final bool canEditListing;
  final bool canManageCalendar;
  final bool canViewBookings;
  final bool canMessageGuests;
}
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/listings/` | GET | List host's listings |
| `/api/v1/listings/` | POST | Create new listing |
| `/api/v1/listings/{id}/` | GET | Get listing details |
| `/api/v1/listings/{id}/` | PUT | Update listing |
| `/api/v1/listings/{id}/calendar/` | GET | Get calendar |
| `/api/v1/listings/{id}/calendar/` | PUT | Update calendar |
| `/api/v1/listings/search/` | GET | Search public listings |
| `/api/v1/amenities/` | GET | List all amenities |

---

## Error Handling

### Common Errors

| Error | Handling |
|-------|----------|
| Invalid address | Show address validation error |
| Image upload failed | Retry or show error toast |
| Calendar conflict | Show conflicting dates |
| Geocoding failed | Allow manual coordinate entry |

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [Booking System](./booking-system.md)
- [API Reference](../05-api-reference.md)
