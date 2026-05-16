import 'dart:convert';

/// Payload for message notifications
class MessagePayload {
  final String conversationId;
  final String messageId;
  final String senderId;
  final String? senderName;
  final String? title;
  final String? body;
  final DateTime? timestamp;
  final Map<String, dynamic>? additionalData;

  MessagePayload({
    required this.conversationId,
    required this.messageId,
    required this.senderId,
    this.senderName,
    this.title,
    this.body,
    this.additionalData,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory MessagePayload.fromJson(String json) {
    try {
      final map = Map<String, dynamic>.from(jsonDecode(json));
      return MessagePayload(
        conversationId: map['conversationId']?.toString() ?? 'unknown',
        messageId: map['messageId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: map['senderId']?.toString() ?? 'unknown',
        senderName: map['senderName']?.toString(),
        title: map['title']?.toString(),
        body: map['body']?.toString(),
        timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp'] as String) 
          : null,
        additionalData: map['additionalData'] is Map ? Map<String, dynamic>.from(map['additionalData']) : null,
      );
    } catch (e) {
      // Fallback for legacy or malformed payloads
      return MessagePayload(
        conversationId: 'unknown',
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'unknown',
        title: 'New Message',
        body: 'You have a new message',
      );
    }
  }

  factory MessagePayload.fromRemoteMessage(Map<String, dynamic> message) {
    return MessagePayload(
      conversationId: message['conversationId']?.toString() ?? 'unknown',
      messageId: message['messageId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: message['senderId']?.toString() ?? 'unknown',
      senderName: message['senderName']?.toString(),
      title: message['notification']?['title']?.toString(),
      body: message['notification']?['body']?.toString(),
      additionalData: message['data'] is Map ? Map<String, dynamic>.from(message['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'messageId': messageId,
        'senderId': senderId,
        if (senderName != null) 'senderName': senderName,
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (additionalData != null) ...additionalData!,
      };
}

// Hello I am Tamim