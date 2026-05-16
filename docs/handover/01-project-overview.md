# Stayverz Flutter App - Project Overview

## Executive Summary

Stayverz is a vacation rental management platform built with Flutter, supporting both **Hosts** (property owners/managers) and **Guests** (travelers seeking accommodations). The app enables property listing management, booking workflows, real-time messaging, and financial reporting.

**Current Version:** 1.0.11+39  
**Flutter SDK:** 3.7.2+  
**Dart:** 3.0.0+

---

## User Roles

### Host
- Property listing creation and management
- Availability calendar control
- Guest messaging and communication
- Revenue tracking and financial reports
- Booking request approval/denial

**Navigation Flow:** Today → Inbox → Calendar → Finance → Menu

### Guest
- Browse and search property listings
- Wishlist management
- Trip booking and management
- Messaging with hosts
- Profile and account settings

**Navigation Flow:** Explore → Wishlist → Trips → Inbox → Profile

---

## Technology Stack

| Category | Technology | Purpose |
|----------|------------|---------|
| **Framework** | Flutter 3.7.2+ | Cross-platform UI |
| **Language** | Dart 3.0.0+ | Programming language |
| **State Management** | GetX 4.7.3 | Reactive state, DI, navigation |
| **HTTP Client** | Dio 5.8.0+1 | API requests |
| **Local Storage** | SharedPreferences 2.5.3 | Token and data caching |
| **WebSocket** | web_socket_channel 3.0.3 | Real-time messaging |
| **Notifications** | Firebase Messaging 15.2.7 | Push notifications |
| **Maps** | Google Maps Flutter 2.12.1 | Location services |
| **Charts** | fl_chart 0.71.0 | Financial reports |
| **Images** | cached_network_image 3.3.1 | Image caching |

---

## Key Features

### 1. Authentication System
- Phone/email login with OTP verification
- JWT token management with automatic refresh
- Role-based navigation (host vs guest)
- Session persistence with secure storage

### 2. Property Listings (Host)
- Create/edit property details
- Upload and manage property images
- Set pricing and availability
- Manage booking settings

### 3. Booking System
- **Instant Booking:** Immediate confirmation
- **Assistance Booking:** Manual approval workflow
- Payment integration via SSLCommerz
- Booking history and status tracking

### 4. Real-time Messaging
- WebSocket-based chat (migrating from WebView)
- Unread message count badges
- Message threading by conversation
- Support for media sharing

### 5. Financial Management
- Revenue tracking dashboard
- Monthly analytics with pie charts
- Payout management
- Transaction history

### 6. Assistance Services
- Service creation for hosts
- Public service browsing for guests
- Schedule-based bookings
- Category management

---

## API Architecture

The app communicates with three separate API services:

| Service | Base URL | Purpose |
|---------|----------|---------|
| **Main API** | `https://apix.stayverz.com` | Core functionality (auth, listings, bookings) |
| **Assistance API** | `https://api-assistance.stayverz.com` | Assistance service management |
| **Messaging API** | `https://api-chat.stayverz.com` | Real-time chat and WebSocket |

**WebSocket URLs:**
- Chat: `wss://api-chat.stayverz.com/api/v1/ws/chat/`

---

## Project Structure

```
lib/
├── core/                  # Core infrastructure
│   ├── bindings/         # Dependency injection
│   ├── constants/        # Routes, colors, API endpoints
│   ├── error/           # Error handling
│   ├── middleware/      # Auth & connectivity guards
│   └── utils/           # Utility functions
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── booking/        # Booking workflows
│   ├── listing/        # Property listings
│   ├── messaging/      # Chat and messaging
│   ├── finance_report/ # Financial analytics
│   ├── assistance_service/ # Assistance services
│   ├── profile/        # User profiles
│   ├── public_listings/ # Public browsing
│   ├── reservation/    # Reservation management
│   ├── wishlist/       # Wishlist functionality
│   ├── notification/   # Push notifications
│   ├── blog/           # Blog content
│   ├── splash/         # Splash screen
│   └── user_feedback/  # User feedback feature
├── services/           # Global services
│   ├── cache/         # Cache management
│   └── network/       # API client, WebSocket
├── controllers/        # Global controllers
├── views/             # Legacy views (migrating)
└── widgets/           # Shared widgets
```

---

## Architecture Pattern

**MVVM + GetX**

- **Models:** Data structures in `/data/models/`
- **Views:** UI screens using `GetView<Controller>`
- **ViewModels (Controllers):** Business logic in `/controllers/`
- **Repositories:** Data access layer with interface/implementation pattern
- **Bindings:** Dependency injection configuration

---

## Known Issues & Workarounds

1. **Android Build:** Requires `--no-tree-shake-icons` flag due to custom font icons
2. **WebView Messaging:** Temporary implementation using WebView, being migrated to native WebSocket
3. **Certificate Override:** `MyHttpOverrides` disables certificate validation for development
4. **NDK Version:** Android NDK 27.0.12077973 required

---

## Next Steps for New Developers

1. Read [02-architecture-guide.md](./02-architecture-guide.md) for detailed architecture
2. Follow [03-setup-instructions.md](./03-setup-instructions.md) for environment setup
3. Review feature-specific guides in `04-feature-guides/`
4. Check [09-troubleshooting.md](./09-troubleshooting.md) for common issues
