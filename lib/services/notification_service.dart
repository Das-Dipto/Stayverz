import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<String?> initFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Init local notifications
      await _initializeLocalNotifications();

      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken == null) {
            return null;
          }
        }
      }

      // FCM Token
      String? token = await _firebaseMessaging.getToken();

      // Listen for foreground messages
      listenToMessages();

      return token;
    }
    return null;
  }

  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings, iOS: darwinInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Create a notification channel (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications that require full text display.',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications that require full text display.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            // This is the key missing piece - BigTextStyle for full text display
            styleInformation: BigTextStyleInformation(
              notification.body ?? '',
              htmlFormatBigText: true,
              contentTitle: notification.title,
              htmlFormatContentTitle: true,
              // summaryText: 'Stayverz',
              htmlFormatSummaryText: true,
            ),
            enableLights: true,
            enableVibration: true,
            playSound: true,
            showWhen: true,
            when: DateTime.now().millisecondsSinceEpoch,
            usesChronometer: false,
            fullScreenIntent: false,
            category: AndroidNotificationCategory.message,
            visibility: NotificationVisibility.public,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            subtitle: notification.title,
            threadIdentifier: 'stayverz_notifications',
            attachments: null,
            badgeNumber: null,
          ),
        ),
      );
    }
  }
}

// Hello I am Tamim