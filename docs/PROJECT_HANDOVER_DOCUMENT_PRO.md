# Stayverz Flutter Application - Technical Handover Documentation

## Executive Summary

This document serves as the official technical handover for the Stayverz Flutter Application, a comprehensive room booking and rental platform. The application has been developed using the Flutter framework, enabling cross-platform deployment on both iOS and Android devices. This platform facilitates seamless interaction between property owners (Hosts) and renters (Guests) through an intuitive mobile interface, complete with real-time messaging, secure payment processing, and comprehensive property management capabilities.

The Stayverz platform represents a significant undertaking in the property rental technology sector, offering a dual-role architecture that allows users to function both as service providers and consumers within the same ecosystem. This document provides a thorough technical overview, architectural insights, and operational guidelines to ensure a smooth transition and ongoing maintenance of the application.

---

## 1. Project Specifications and Technical Overview

### 1.1 Application Metadata

| Attribute | Specification |
|-----------|-------------|
| **Application Name** | Stayverz |
| **Development Framework** | Flutter (Dart) |
| **Target Platforms** | iOS, Android |
| **Current Version** | 1.0.11+39 |
| **Minimum SDK Version** | Flutter 3.7.2 |
| **Package Identifier** | stayverz_flutter_app |
| **Application Category** | Property Rental & Booking Platform |
| **Distribution Model** | Private Deployment |

### 1.2 Platform Architecture

The Stayverz application employs a sophisticated dual-role architecture designed to accommodate two distinct user personas within a unified codebase. The platform supports simultaneous Host and Guest accounts, enabling users to seamlessly transition between renting properties and listing their own accommodations. This architectural decision eliminates the need for separate applications while maintaining clear functional boundaries between user roles.

The application's core value proposition lies in its ability to facilitate end-to-end property rental transactions, encompassing property discovery, real-time communication, secure payment processing, and comprehensive booking management. The platform integrates with multiple backend services, including RESTful APIs for core functionality and WebSocket connections for real-time messaging capabilities.

---

## 2. System Architecture and Design Philosophy

### 2.1 Architectural Framework

The Stayverz application adheres to Clean Architecture principles, implemented through a feature-first modular structure. This architectural approach ensures clear separation of concerns, facilitating maintainability, scalability, and comprehensive testability. The application employs the following architectural patterns:

- **State Management**: GetX framework provides reactive state management, dependency injection, and route management
- **Presentation Layer**: Flutter widgets implementing Material Design principles
- **Business Logic Layer**: Controller classes encapsulating application logic
- **Data Layer**: Repository pattern for API communication and local caching

### 2.2 Directory Structure and Organization

The codebase follows a meticulously organized structure that promotes code reusability and maintainability:

```
lib/
├── components/          # Reusable UI components across features
├── controllers/         # Global application controllers
│   ├── main_controller.dart
│   ├── profile_controller.dart
│   └── connectivity_controller.dart
├── core/               # Fundamental infrastructure
│   ├── base/            # Abstract base classes
│   ├── bindings/        # Dependency injection configuration
│   ├── constants/       # Application-wide constants
│   ├── error/          # Error handling infrastructure
│   ├── localization/    # Internationalization resources
│   ├── middleware/      # Navigation guards and interceptors
│   └── utils/          # Utility functions and extensions
├── features/           # Feature modules (14 major features)
├── services/           # Cross-cutting services
│   ├── cache/          # Persistent storage management
│   ├── network/        # HTTP client and connectivity
│   └── notification_service.dart
├── views/              # Screen-level widgets and navigation
└── widgets/            # Atomic and molecular UI components
```

---

## 3. Core Feature Modules and Functionality

### 3.1 Authentication and Identity Management

The authentication system implements a sophisticated dual-role registration mechanism that simultaneously creates both Host and Guest accounts upon user registration. This approach ensures seamless role switching without requiring separate login credentials.

**Key Implementation Details:**
- Phone number-based authentication with OTP verification
- JWT token architecture with automatic refresh mechanisms
- Username format: `{phone_number}_host` and `{phone_number}_guest`
- Secure token persistence via encrypted SharedPreferences
- Referral code integration supporting deep link activation

The authentication flow encompasses initial registration, OTP validation, JWT token issuance, and role-based navigation routing. Session management maintains authentication state across application lifecycle events, with automatic token refresh interceptors ensuring uninterrupted API access.

### 3.2 Property Listing Management

The listing management feature provides Hosts with comprehensive tools for property advertisement and availability management. This module supports complex property configurations, including multi-image galleries, dynamic pricing structures, and calendar-based availability controls.

**Functional Capabilities:**
- Complete CRUD operations for property listings
- Multi-image upload with compression and caching
- Dynamic pricing configuration with seasonal adjustments
- Calendar-based availability management with blocking capabilities
- Amenity categorization and filtering
- Property status management (active, inactive, under maintenance)

The listing module integrates with cloud storage services for image persistence and implements sophisticated caching strategies to optimize loading performance.

### 3.3 Property Discovery and Search

The public listings feature enables Guests to discover available accommodations through an intuitive search and filtering interface. This module incorporates geospatial search capabilities, advanced filtering mechanisms, and comprehensive property detail presentation.

**User Experience Features:**
- Location-based search with map integration
- Multi-criteria filtering (price, amenities, availability)
- High-resolution image galleries with zoom capabilities
- Property reviews and rating aggregation
- Map-based property visualization
- Wishlist functionality for saved properties

### 3.4 Reservation and Booking System

The booking system accommodates two distinct reservation models: standard inquiry-based bookings and instant confirmation bookings. This dual-mode approach provides flexibility for Hosts while offering convenience for Guests seeking immediate confirmation.

**Booking Process Components:**
- Multi-step booking wizard with guest information collection
- Date range selection with availability validation
- Guest count configuration (adults, children, infants)
- Special request accommodation
- Service fee calculation and breakdown
- Payment gateway integration
- Booking status tracking and lifecycle management

### 3.5 Real-Time Communication Infrastructure

The messaging system implements WebSocket-based real-time communication, enabling instantaneous message delivery between Hosts and Guests. This infrastructure supports rich messaging features, including file sharing, typing indicators, and message read receipts.

**Technical Implementation:**
- WebSocket connection management with automatic reconnection
- Conversation threading linked to specific bookings
- Unread message count tracking
- Online presence indicators
- File attachment support
- System message integration for booking updates

The messaging architecture utilizes three distinct WebSocket endpoints: global status monitoring, individual conversation channels, and cross-device synchronization.

### 3.6 Assistance Services Marketplace

The assistance services feature extends the platform beyond accommodation booking, enabling Hosts to offer additional services such as transportation, guided tours, and specialized experiences. This marketplace functionality creates additional revenue opportunities for Hosts while enhancing the Guest experience.

**Marketplace Capabilities:**
- Service categorization and browsing
- Scheduled booking for time-based services
- Service review and rating system
- Integrated payment processing
- Host service portfolio management

### 3.7 Financial Reporting and Analytics

The finance report module provides Hosts with comprehensive analytical tools for tracking earnings, monitoring booking statistics, and managing payout schedules. This feature implements data visualization components for intuitive financial performance assessment.

**Reporting Features:**
- Earnings aggregation with date range filtering
- Booking conversion analytics
- Payout tracking and status monitoring
- Interactive chart visualizations
- PDF report generation for accounting purposes

---

## 4. Data Management and API Integration

### 4.1 API Architecture

The application communicates with backend services through a RESTful API architecture, utilizing the Dio HTTP client for request management. The API layer implements a sophisticated interceptor chain for cross-cutting concerns:

1. **TokenRefreshInterceptor**: Automatic JWT token refresh on 401 responses
2. **RequestInterceptor**: Header injection and request formatting
3. **ResponseInterceptor**: Response normalization and error standardization
4. **ConnectivityInterceptor**: Network availability validation
5. **ErrorInterceptor**: Comprehensive error handling and user feedback
6. **LogInterceptor**: Development and debugging support

### 4.2 Service Endpoints

| Service | Base URL | Purpose |
|---------|----------|---------|
| Core API | `https://apix.stayverz.com` | Primary application services |
| Messaging API | `https://api-chat.stayverz.com` | Chat and real-time services |
| WebSocket | `wss://api-chat.stayverz.com/api/v1/ws/` | Real-time communication |

### 4.3 Local Data Persistence

The application implements a multi-tier caching strategy utilizing SharedPreferences for lightweight data and GetStorage for complex object persistence. The CacheManager service provides a unified interface for data persistence operations, managing authentication tokens, user preferences, and application state.

---

## 5. User Interface and Navigation

### 5.1 Navigation Architecture

The application implements a hierarchical navigation structure utilizing GetX routing with middleware-based route protection. The navigation model distinguishes between authenticated and public routes, with automatic redirection based on authentication state.

**Primary Route Configuration:**
- `/login` - Authentication interface
- `/host` - Host dashboard (authenticated)
- `/guest` - Guest dashboard (public/authenticated)
- `/public-listings` - Property discovery
- `/blog-details` - Content viewing

### 5.2 Bottom Navigation Structure

**Host Interface:**
1. Dashboard - Overview and quick actions
2. Listings - Property management
3. Bookings - Reservation management
4. Messages - Communication center
5. Menu - Settings and additional options

**Guest Interface:**
1. Home - Featured properties and recommendations
2. Search - Discovery and filtering
3. Bookings - Reservation tracking
4. Messages - Host communication
5. Profile - Account management

---

## 6. Third-Party Integrations and Dependencies

### 6.1 Critical Dependencies

| Package | Version | Functional Purpose |
|---------|---------|-------------------|
| `get` | ^4.7.3 | State management and routing |
| `dio` | ^5.8.0+1 | HTTP client and API communication |
| `firebase_core` | ^3.15.1 | Firebase platform integration |
| `firebase_messaging` | ^15.2.7 | Push notification delivery |
| `google_maps_flutter` | ^2.12.1 | Map visualization and location |
| `web_socket_channel` | ^3.0.3 | Real-time messaging infrastructure |
| `shared_preferences` | ^2.5.3 | Local data persistence |
| `cached_network_image` | ^3.3.1 | Image loading and caching |

### 6.2 Integration Points

- **Firebase Cloud Messaging**: Push notification delivery and in-app message handling
- **Google Maps**: Property location visualization and geospatial search
- **Payment Gateway**: Secure transaction processing (implementation details confidential)
- **Cloud Storage**: Image and file asset persistence
- **WebSocket Server**: Real-time messaging infrastructure

---

## 7. Development and Deployment Guidelines

### 7.1 Build Configuration

**Development Execution:**
```bash
flutter run --debug
```

**Production Build (Android):**
```bash
flutter build apk --release --no-tree-shake-icons
```

**Production Build (iOS):**
```bash
flutter build ios --release
```

### 7.2 Version Management Protocol

Version specification follows semantic versioning principles encoded in `pubspec.yaml`:
- Format: `version: [major].[minor].[patch]+[build]`
- Current: `1.0.11+39`
- Android mapping: versionName (1.0.11), versionCode (39)
- iOS mapping: CFBundleShortVersionString, CFBundleVersion

### 7.3 Deep Link Implementation

The application supports referral-based deep linking for user acquisition:
- URL Format: `https://apix.stayverz.com/r/{referral_code}`
- Testing Command: `adb shell am start -W -a android.intent.action.VIEW -d "https://apix.stayverz.com/r/{code}" com.stayverz.stayverz`

---

## 8. Quality Assurance and Testing Framework

### 8.1 Testing Checklist

The following scenarios require comprehensive validation during development and deployment:

- [ ] User registration and authentication flow
- [ ] Host/Guest role switching functionality
- [ ] Property listing CRUD operations
- [ ] Image upload and gallery management
- [ ] Booking workflow (standard and instant)
- [ ] Payment processing integration
- [ ] Real-time messaging functionality
- [ ] Push notification delivery
- [ ] Offline mode handling
- [ ] Deep link referral activation
- [ ] Calendar availability management
- [ ] Financial report generation

### 8.2 Code Quality Standards

Development must adhere to established patterns within the codebase:
- Consistent utilization of GetX for state management
- Implementation of resource cleanup in controller `onClose()` methods
- Reactive variable implementation using `RxBool`, `RxString`, `Rxn<T>` types
- Comprehensive error handling with user-appropriate feedback
- Proper stream subscription management to prevent memory leaks

---

## 9. Maintenance and Operational Considerations

### 9.1 WebSocket Connection Management

WebSocket connections require careful lifecycle management to ensure optimal performance and resource utilization. All stream subscriptions must be explicitly cancelled within controller disposal methods to prevent memory leaks and application instability.

### 9.2 API Communication Best Practices

- Standard API operations: `ApiClient.create()`
- Messaging API operations: `ApiClient.forMessaging()`
- Comprehensive error handling for network failures
- Graceful degradation during connectivity interruptions

### 9.3 Security Considerations

- JWT token storage in encrypted SharedPreferences
- HTTPS-only API communication
- Input validation on all user-facing forms
- Secure handling of payment information (PCI compliance)

---

## 10. Support and Documentation Resources

### 10.1 Technical Documentation

- **WebSocket Protocol**: `docs/architecture/_ws_chat_user_chat-stat_.md`
- **Messaging Architecture**: `docs/architecture/inbox_controller_streams.md`
- **API Reference**: Available through backend documentation portal

### 10.2 Critical File Locations

| Component | File Path |
|-----------|-----------|
| Application Entry | `lib/main.dart` |
| Route Definitions | `lib/core/constants/app_routes.dart` |
| API Client | `lib/services/network/api_client.dart` |
| Main Controller | `lib/controllers/main_controller.dart` |
| Authentication | `lib/features/auth/controllers/auth_controller.dart` |
| Cache Manager | `lib/services/cache/cache_manager.dart` |
| WebSocket Service | `lib/features/messaging/data/services/websocket_service.dart` |

---

## 11. Conclusion and Transition Notes

This handover documentation provides a comprehensive technical overview of the Stayverz Flutter Application, encompassing architectural decisions, feature implementations, and operational guidelines. The development team has implemented industry best practices throughout the codebase, ensuring maintainability and scalability for future enhancements.

The receiving development team should thoroughly review the architecture documentation, establish local development environments, and conduct comprehensive testing of all feature modules before engaging in further development activities. The existing test cases and documentation within the `docs/architecture/` directory provide additional context for specific implementation details.

For technical inquiries or clarification requests, please refer to the annotated code documentation and inline comments throughout the codebase, which provide implementation-specific guidance for complex functionality.

---

**Document Classification**: Technical Handover  
**Version**: 1.0  
**Prepared**: April 2026  
**Word Count**: Approximately 2,000 words  
**Recipient**: Client Development Team
