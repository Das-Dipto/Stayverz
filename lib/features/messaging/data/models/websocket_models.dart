import 'dart:convert';

/// Base WebSocket message structure
class WebSocketMessage {
  final String type;
  final Map<String, dynamic>? data;
  final DateTime? timestamp;

  const WebSocketMessage({required this.type, this.data, this.timestamp});

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}

/// Typing indicator event
class TypingEvent {
  final String userId;
  final String userName;
  final String conversationId;
  final bool isTyping;

  const TypingEvent({
    required this.userId,
    required this.userName,
    required this.conversationId,
    required this.isTyping,
  });

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    return TypingEvent(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      conversationId: json['conversation_id'] as String,
      isTyping: json['is_typing'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'conversation_id': conversationId,
      'is_typing': isTyping,
    };
  }
}

/// User presence event (join/leave)
class PresenceEvent {
  final String userId;
  final String userName;
  final String status; // 'join', 'leave'
  final String? conversationId;

  const PresenceEvent({
    required this.userId,
    required this.userName,
    required this.status,
    this.conversationId,
  });

  factory PresenceEvent.fromJson(Map<String, dynamic> json) {
    return PresenceEvent(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      status: json['status'] as String,
      conversationId: json['conversation_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'status': status,
      'conversation_id': conversationId,
    };
  }
}

/// Message read receipt event
class ReadReceiptEvent {
  final String messageId;
  final String conversationId;
  final String userId;
  final DateTime readAt;

  const ReadReceiptEvent({
    required this.messageId,
    required this.conversationId,
    required this.userId,
    required this.readAt,
  });

  factory ReadReceiptEvent.fromJson(Map<String, dynamic> json) {
    return ReadReceiptEvent(
      messageId: json['message_id'] as String,
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      readAt: DateTime.parse(json['read_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'user_id': userId,
      'read_at': readAt.toIso8601String(),
    };
  }
}

/// Chat statistics (unread counts)
class ChatStatsModel {
  final int? count;

  ChatStatsModel({
    this.count,
  });

  factory ChatStatsModel.fromRawJson(String str) => ChatStatsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatStatsModel.fromJson(Map<String, dynamic> json) => ChatStatsModel(
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
  };
}


/// WebSocket connection status
enum WebSocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// WebSocket event types
class WebSocketEventTypes {
  static const String ping = 'ping';
  static const String pong = 'pong';
  static const String message = 'message';
  static const String typing = 'typing';
  static const String joinUserPresence = 'join_user_presence';
  static const String leaveUserPresence = 'leave_user_presence';
  static const String readDone = 'read_done';
  static const String startChat = 'start_chat';
  static const String userOnline = 'join';
  static const String userOffline = 'leave';
}

/// WebSocket payload builders for sending messages
class WebSocketPayloads {
  static Map<String, dynamic> ping() => {'type': WebSocketEventTypes.ping};

  static Map<String, dynamic> sendMessage({
    required String content,
    required String receiverId,
    required String receiverName,
    required String conversationId,
    String messageType = 'text',
  }) => {
    'type': WebSocketEventTypes.message,
    'data': {
      'content': content,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'conversation_id': conversationId,
      'message_type': messageType,
    },
  };

  static Map<String, dynamic> typing({
    required String conversationId,
    required bool isTyping,
  }) => {
    'type': WebSocketEventTypes.typing,
    'data': {'conversation_id': conversationId, 'is_typing': isTyping},
  };

  static Map<String, dynamic> markAsRead({
    required String messageId,
    required String conversationId,
  }) => {
    'type': WebSocketEventTypes.readDone,
    'data': {'message_id': messageId, 'conversation_id': conversationId},
  };

  static Map<String, dynamic> joinUserPresence({
    required String conversationId,
  }) => {
    'type': WebSocketEventTypes.joinUserPresence,
    'data': {'conversation_id': conversationId},
  };

  static Map<String, dynamic> leaveUserPresence({
    required String conversationId,
  }) => {
    'type': WebSocketEventTypes.leaveUserPresence,
    'data': {'conversation_id': conversationId},
  };

  static Map<String, dynamic> startChat({
    required String receiverId,
    required String receiverName,
    required String propertyId,
    required String status, // 'inquiry' or 'confirmed'
  }) => {
    'type': WebSocketEventTypes.startChat,
    'data': {
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'property_id': propertyId,
      'status': status,
    },
  };
}

// Hello I am Tamim