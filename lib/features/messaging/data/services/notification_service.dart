import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/message_payload.dart' as models;

/// Callback for when a notification is received while the app is in the foreground
typedef OnNotificationReceived = void Function(NotificationResponse response);

/// Callback for when a notification is tapped while the app is in the background/terminated
typedef OnNotificationTapped = void Function(models.MessagePayload payload);

/// Service for handling both local and push notifications
class NotificationService extends GetxService {
  static const String _channelId = 'stayverz_messaging_channel';
  static const String _channelName = 'Stayverz Messaging';
  static const String _channelDescription = 'Notifications for new messages';

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _onNotificationClick = Rxn<models.MessagePayload>();
  Stream<models.MessagePayload> get onNotificationClick => _onNotificationClick.stream.where((event) => event != null).cast<models.MessagePayload>();

  /// Initialize the notification service
  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    return this;
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // For iOS 10+, we don't need to provide a callback for local notifications
    // as the plugin handles them automatically
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android 8.0+
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
        playSound: true,
        showBadge: true,
        enableVibration: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      final result = await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result == true;
    } else if (Platform.isAndroid) {
      return true;
    }
    return false;
  }

  /// Handle notification tap
  /// 
  /// [response] contains the notification response including the payload.
  /// The payload can be either a JSON-encoded String or a Map<String, dynamic>.
  void _onNotificationTapped(NotificationResponse response) {
    try {
      final payload = response.payload;
      if (payload == null) return;
      
      // Helper function to convert dynamic to JSON string
      String _convertToJsonString(dynamic data) {
        if (data == null) {
          throw const FormatException('Notification payload is null');
        }
        
        if (data is String) {
          // If it's already a string, it should be a JSON string
          return data;
        }
        
        if (data is Map) {
          // If it's a Map, convert it to a JSON string
          return jsonEncode(data);
        }
        
        throw FormatException('Unsupported payload type: ${data.runtimeType}');
      }
      
      // Process the payload
      try {
        final jsonString = _convertToJsonString(payload);
        final messagePayload = models.MessagePayload.fromJson(jsonString);
        _onNotificationClick.value = messagePayload;
      } catch (e) {
        if (kDebugMode) {
        }
        rethrow;
      }
    } catch (e) {
      if (kDebugMode) {
      }
    }
  }

  /// Handle local notification on iOS
  /// 
  /// [payload] can be either a JSON-encoded String or a Map<String, dynamic>
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    dynamic payload,
  ) {
    if (payload != null) {
      try {
        String payloadJson;
        
        if (payload is String) {
          // If it's already a string, use it directly
          payloadJson = payload;
        } else if (payload is Map) {
          // Convert map to JSON string
          payloadJson = jsonEncode(payload);
        } else {
          throw FormatException('Unsupported payload type: ${payload.runtimeType}');
        }
        
        // Parse the JSON string to MessagePayload
        _onNotificationClick.value = models.MessagePayload.fromJson(payloadJson);
      } catch (e) {
        if (kDebugMode) {
        }
      }
    }
  }

  /// Show a local notification for a new message
  Future<void> showMessageNotification({
    required String title,
    required String body,
    required models.MessagePayload payload,
  }) async {
    try {
      // Convert the payload to a JSON string
      final payloadJson = jsonEncode(payload.toJson());
      
      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      final iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Ensure the payload is a String before passing it to the plugin
      await _localNotificationsPlugin.show(
        payload.conversationId.hashCode,
        title,
        body,
        details,
        payload: payloadJson,
      );
    } catch (e) {
      if (kDebugMode) {
      }
      rethrow;
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  /// Clear a specific notification by id
  Future<void> clearNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  /// Clear all notifications for a conversation
  Future<void> clearConversationNotifications(String conversationId) async {
    await _localNotificationsPlugin.cancel(conversationId.hashCode);
  }

  /// Clean up resources
  @override
  void onClose() {
    _localNotificationsPlugin.cancelAll();
    super.onClose();
  }
}

// Hello I am Tamim