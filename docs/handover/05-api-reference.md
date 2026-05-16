# API Reference

## Overview

The Stayverz app communicates with three separate microservices:

| Service | Base URL | Purpose |
|---------|----------|---------|
| **Main API** | `https://apix.stayverz.com` | Core functionality |
| **Assistance API** | `https://api-assistance.stayverz.com` | Assistance services |
| **Messaging API** | `https://api-chat.stayverz.com` | Chat and WebSocket |

---

## Authentication

### JWT Token Management

All API requests require authentication via Bearer token:

```http
Authorization: Bearer <access_token>
```

### Token Refresh

When access token expires, the `TokenRefreshInterceptor` automatically:
1. Detects 401 response
2. Uses refresh token to get new access token
3. Retries original request
4. Updates stored tokens

---

## Main API

Base URL: `https://apix.stayverz.com/api/v1`

### Authentication

| Endpoint | Method | Request | Response |
|----------|--------|---------|----------|
| `/accounts/login/` | POST | `{username, password}` | `{token, refresh_token, user}` |
| `/accounts/register/` | POST | `{username, password, ...}` | `{token, user}` |
| `/accounts/user/profile/` | GET | - | `UserProfile` |

### Users

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/accounts/user/{id}/` | GET | Get user by ID |
| `/accounts/user/{id}/update/` | PUT | Update user profile |

### Organizations

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/organizations/` | GET/POST | List/Create organizations |
| `/organizations/join/` | POST | Request to join organization |
| `/organizations/{id}/students/` | GET | List organization students |

### Listings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/listings/` | GET | List host's listings |
| `/listings/` | POST | Create new listing |
| `/listings/{id}/` | GET | Get listing details |
| `/listings/{id}/` | PUT | Update listing |
| `/listings/{id}/calendar/` | GET | Get calendar |
| `/listings/{id}/calendar/` | PUT | Update calendar |
| `/listings/search/` | GET | Search public listings |

### Bookings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/bookings/` | GET | List bookings |
| `/bookings/` | POST | Create booking |
| `/bookings/{id}/` | GET | Get booking details |
| `/bookings/{id}/cancel/` | POST | Cancel booking |
| `/bookings/{id}/review/` | POST | Submit review |

### Finance

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/host/finance-report/` | GET | Get finance report |
| `/host/monthly-earnings/` | GET | Get monthly earnings |
| `/host/payout-breakdown/` | GET | Get payout breakdown |

### Referrals

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/referrals/my-link/` | GET | Get referral link |
| `/referrals/my-referrals/` | GET | Get referral list |
| `/referrals/balance/` | GET | Get referral balance |
| `/referrals/coupons/` | GET | Get coupons |
| `/referrals/coupons/{id}/claim/` | POST | Claim coupon |

### Notifications

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/notifications/user/notifications/` | GET | Get user notifications |

### Posts/Blog

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/posts/` | GET/POST | List/Create posts |

### Quick Replies

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/quick_reply/` | GET/POST | List/Create quick replies |

### Feedback

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/feedback/submit` | POST | Submit feedback |
| `/feedback/categories` | GET | Get categories |
| `/feedback/can-submit` | GET | Check submission eligibility |

---

## Assistance API

Base URL: `https://api-assistance.stayverz.com`

### Categories

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/assistance/categories` | GET | Get all categories |
| `/assistance/cancellation-polices` | GET | Get cancellation policies |

### Services

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/assistance/create-assistance` | POST | Create service |
| `/assistance/details/{id}` | GET | Get service (host view) |
| `/assistance/public-details/{id}` | GET | Get service (public view) |
| `/assistance/listings/{id}/` | PUT | Update service |
| `/assistance/listing-calendars/{id}/` | GET | Get calendar |
| `/assistance/search` | GET | Search services |

### Bookings

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/bookings` | POST | Create booking |
| `/assistance-host/list/` | GET | List host bookings |

### Finance

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/host/assistance-finance-report/` | GET | Get finance report |
| `/host/assistance-monthly-earnings/` | GET | Get monthly earnings |

### Payments

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/payments/initiate/sslcommerz` | POST | Initiate payment |

---

## Messaging API

Base URL: `https://api-chat.stayverz.com/api/v1`

### Chat Rooms

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/chat/user/rooms/` | GET | List chat rooms |
| `/chat/user/rooms/` | POST | Create room |
| `/chat/user/rooms/{id}/` | GET | Get room messages |
| `/chat/user/rooms/{id}/` | POST | Send message |

### Archive

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/chat/archive` | POST | Archive chat |
| `/chat/archive/archived/` | GET | List archived chats |

---

## WebSocket

Base URL: `wss://api-chat.stayverz.com/api/v1/ws/chat/`

### Connection URLs

| Connection | URL Format |
|------------|------------|
| Global Room | `/user/user-global-room/?token={token}` |
| Chat Stats | `/user/chat-stat/?token={token}` |
| Room Channel | `/user/{room_id}/?token={token}` |

### Message Format

### Incoming (Server → Client)

```json
{
  "type": "new_message",
  "data": {
    "id": "msg_uuid",
    "room_id": "room_uuid",
    "sender_id": "user_uuid",
    "content": "Message text",
    "timestamp": "2024-01-15T10:30:00Z",
    "message_type": "text"
  }
}
```

### Outgoing (Client → Server)

```json
{
  "action": "send_message",
  "room_id": "room_uuid",
  "content": "Hello!",
  "message_type": "text"
}
```

### Event Types

| Type | Description |
|------|-------------|
| `new_message` | New message received |
| `message_read` | Messages marked as read |
| `user_typing` | User typing indicator |
| `user_online` | User came online |
| `user_offline` | User went offline |
| `chat_stat` | Unread count update |

---

## Common Response Format

### Success Response

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional success message"
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message"
  }
}
```

### Paginated Response

```json
{
  "success": true,
  "data": [ ... ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 50,
    "per_page": 10
  }
}
```

---

## HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | OK | Success |
| 201 | Created | Resource created |
| 400 | Bad Request | Check request data |
| 401 | Unauthorized | Token expired/invalid |
| 403 | Forbidden | No permission |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Resource conflict (e.g., date already booked) |
| 422 | Unprocessable | Validation error |
| 500 | Server Error | Retry or contact support |

---

## Rate Limiting

API endpoints may be rate-limited. When limit exceeded:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

---

## CORS

APIs are configured for CORS. For development:

```dart
// Certificate override in main.dart
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
```

**⚠️ Remove for production**

---

## API Client Configuration

### Main API Client

```dart
// @/lib/services/network/api_client.dart
ApiClient.create()  // Uses ApiRoutes.apiBaseURL
```

### Messaging API Client

```dart
ApiClient.forMessaging()  // Uses ApiRoutes.messagingApiBaseURL
```

### Custom Base URL

```dart
ApiClient(
  baseUrl: 'https://custom-api.example.com',
  useInterceptors: true,
)
```

---

## Related Documentation

- [Integration Points](./06-integration-points.md)
- [Troubleshooting](./09-troubleshooting.md)
