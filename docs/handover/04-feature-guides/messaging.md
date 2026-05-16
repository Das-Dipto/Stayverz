# Messaging System

## Overview

The messaging system provides real-time chat functionality between Hosts and Guests. Currently transitioning from a temporary WebView implementation to a native WebSocket-based solution.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/messaging/controllers/inbox_controller.dart` | Chat rooms list, unread counts |
| `@/lib/features/messaging/controllers/conversation_controller.dart` | Individual conversation management |
| `@/lib/features/messaging/data/services/websocket_service.dart` | WebSocket connection management |
| `@/lib/features/messaging/data/repositories/messaging_repository.dart` | API and WebSocket operations |
| `@/lib/features/messaging/data/models/chat_room_model.dart` | Chat room data structure |
| `@/lib/features/messaging/data/models/chat_message_models.dart` | Message data structures |
| `@/lib/features/messaging/presentation/views/message_conversation_page.dart` | Conversation UI |

### Dependencies

```
InboxController
  ├── MessagingRepository (chat rooms, WebSocket)
  └── MainController (user context)

ConversationController
  ├── MessagingRepository (messages, WebSocket)
  └── WebSocketService (real-time connection)
```

---

## WebSocket Architecture

### Connection Types

| Connection | URL | Purpose |
|------------|-----|---------|
| **Global Room** | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/user-global-room/?token={token}` | Global events, presence |
| **Chat Stats** | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/chat-stat/?token={token}` | Unread counts |
| **Room Channel** | `wss://api-chat.stayverz.com/api/v1/ws/chat/user/{roomId}/?token={token}` | Individual chat room |

### WebSocketService

**`@/lib/features/messaging/data/services/websocket_service.dart`**

Manages WebSocket lifecycle:

```dart
class WebSocketService extends GetxService {
  // Connection management
  void connectGlobalRoom(String authToken);
  void connectChatStats(String authToken);
  void connectChatRoom(String roomId, String token);
  
  // Stream access
  Stream<Map<String, dynamic>> get globalEventStream;
  Stream<Map<String, dynamic>> get chatStatsStream;
  
  // Lifecycle
  void disconnect();
  void reconnect();
}
```

---

## Inbox Controller

### Responsibilities

**`@/lib/features/messaging/controllers/inbox_controller.dart`**

1. **Chat Rooms List:** Load and display user's chat rooms
2. **Unread Counts:** Track total unread messages
3. **Tab Filtering:** Filter by All, Unread, Guest, Stayverz
4. **Quick Replies:** Manage quick reply templates
5. **Archived Chats:** Handle archived conversations

### Key State Variables

```dart
final _chatRooms = <ChatRoomData>[].obs;           // All chat rooms
final _filteredChatRooms = <ChatRoomData>[].obs;   // Filtered by tab
final _totalUnreadCount = 0.obs;                   // Global unread count
final _connectionStatus = WebSocketStatus.disconnected.obs;
final _myQuickReply = <QuickReplyData>[].obs;    // Quick reply templates
```

### Tab Types

```dart
enum InboxTabType { all, unread, guest, stayverz }
```

---

## Conversation Controller

### Responsibilities

**`@/lib/features/messaging/controllers/conversation_controller.dart`**

1. **Message Management:** Load, send, receive messages
2. **Typing Indicators:** Show/hide typing status
3. **Message Status:** Track sent, delivered, read states
4. **Pagination:** Load older messages on scroll
5. **Real-time Updates:** Handle incoming WebSocket messages

### Key Methods

```dart
// Load conversation history
Future<void> loadMessages(String conversationId);

// Send message
Future<void> sendMessage({
  required String content,
  String? messageType, // 'text', 'image', 'file'
});

// Handle incoming WebSocket message
void _handleIncomingMessage(Map<String, dynamic> data);

// Mark messages as read
Future<void> markAsRead(String conversationId);
```

---

## Stream Architecture

### InboxController Streams

```dart
// Chat stats (unread counts)
_chatStatsSubscription = _repository.chatStatsStream.listen(
  (stats) {
    _totalUnreadCount.value = stats['count'] ?? 0;
    _updateUnreadCounts(stats);
  },
);

// Global events (user presence, new messages)
_globalEventSubscription = _repository.globalEventStream.listen(
  (message) => _handleGlobalEvent(message),
);
```

### Event Types

| Event | Description |
|-------|-------------|
| `new_message` | New message received |
| `message_read` | Messages marked as read |
| `user_typing` | User typing indicator |
| `user_online` | User came online |
| `user_offline` | User went offline |

---

## Data Models

### ChatRoomModel

```dart
class ChatRoomData {
  final String id;
  final String name;
  final String? avatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isArchived;
  final List<Participant> participants;
}
```

### ChatMessage

```dart
class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final DateTime timestamp;
  final MessageStatus status; // sent, delivered, read
  final MessageType type; // text, image, file
}
```

---

## WebSocket Message Format

### Incoming Message

```json
{
  "type": "new_message",
  "data": {
    "id": "msg_123",
    "room_id": "room_456",
    "sender_id": "user_789",
    "content": "Hello!",
    "timestamp": "2024-01-15T10:30:00Z",
    "message_type": "text"
  }
}
```

### Outgoing Message

```json
{
  "action": "send_message",
  "room_id": "room_456",
  "content": "Hello!",
  "message_type": "text"
}
```

---

## UI Components

### Inbox Screen

**`@/lib/features/messaging/presentation/views/inbox_page.dart`**

- Tab bar for filtering (All, Unread, Guest, Stayverz)
- Chat room list with last message preview
- Unread count badges
- Archive/unarchive actions

### Conversation Screen

**`@/lib/features/messaging/presentation/views/message_conversation_page.dart`**

- Message bubble list
- Text input with send button
- Quick reply chips
- Typing indicator
- Message status indicators (sent, delivered, read)

---

## Quick Replies

Hosts can create and use quick reply templates:

```dart
// Load quick replies
Future<void> loadQuickReplies();

// Create new quick reply
Future<void> createQuickReply({
  required String title,
  required String content,
});

// Use quick reply in conversation
void useQuickReply(String content) {
  messageController.text = content;
}
```

---

## Archive Functionality

```dart
// Archive a chat room
Future<void> archiveChat(String roomId);

// Unarchive a chat room
Future<void> unarchiveChat(String roomId);

// Load archived chats (paginated)
Future<void> loadArchivedChats({bool refresh = false});
```

---

## Migration Status

### Temporary WebView Implementation

Files to be removed after WebSocket migration:
- `@/lib/views/home_root/home/inbox/webview_inbox_screen.dart`
- `@/lib/views/home_root/home/inbox/webview_inbox_conversation_screen.dart`

### Native WebSocket Implementation

Current implementation uses:
- `@/lib/features/messaging/data/services/websocket_service.dart`
- `@/lib/features/messaging/presentation/views/inbox_page.dart`
- `@/lib/features/messaging/presentation/views/message_conversation_page.dart`

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/chat/user/rooms/` | GET | List chat rooms |
| `/api/v1/chat/user/rooms/{id}/` | GET | Get room messages |
| `/api/v1/chat/user/rooms/{id}/` | POST | Send message |
| `/api/v1/chat/archive` | POST | Archive chat |
| `/api/v1/chat/archive/archived/` | GET | List archived chats |
| `/api/v1/quick_reply/` | GET/POST | Quick replies |

---

## Error Handling

### Connection Errors

```dart
ever(_connectionStatus, (status) {
  if (status == WebSocketStatus.error) {
    _handleError('Connection lost. Attempting to reconnect...');
    _scheduleReconnect();
  }
});
```

### Stream Error Handling

```dart
_chatStatsSubscription = _repository.chatStatsStream.listen(
  (stats) => _updateStats(stats),
  onError: (error) {
    if (kDebugMode) {
      print('Chat stats error: $error');
    }
  },
);
```

---

## Testing

### WebSocket Testing
1. Login with test account
2. Open inbox - connection should establish
3. Send message - should appear in real-time
4. Check unread count - should update

### Debug Commands
```bash
# Check WebSocket connectivity
flutter logs | grep "WebSocket"
```

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [API Reference](../05-api-reference.md)
- [Integration Points](../06-integration-points.md)
