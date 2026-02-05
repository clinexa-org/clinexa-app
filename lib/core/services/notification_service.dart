// core/services/notification_service.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import '../network/api_client.dart';
import '../constants/api_endpoints.dart';

/// Handles FCM push notifications and local notification display
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// Initialize the notification service
  Future<void> initialize() async {
    // 1. Request Permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Initialize Local Notifications (for foreground display)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(initSettings);

    // 3. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
  }

  /// Register device token with backend
  Future<void> registerDeviceToken() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _sendTokenToBackend(fcmToken);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_sendTokenToBackend);
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final platform = await _getPlatform();
      await _apiClient.post(
        ApiEndpoints.deviceToken,
        data: {
          'token': token,
          'platform': platform,
        },
      );
      debugPrint('FCM Token Registered');
    } catch (e) {
      debugPrint('Failed to send FCM token to backend: $e');
    }
  }

  Future<String> _getPlatform() async {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    }
    return 'unknown';
  }

  /// Start listening to real-time notifications from Firebase RTDB
  /// This replaces Socket.io for foreground updates on Vercel
  void listenToRealtimeNotifications(String userId) {
    if (userId.isEmpty) return;

    debugPrint(
        'NotificationService: Listening to RTDB notifications for user $userId');

    final ref = _database.ref('notifications/$userId');

    // Listen for new notifications added
    ref.limitToLast(1).onChildAdded.listen((event) {
      if (event.snapshot.value == null) return;

      try {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        // Check if notification is recent (within last minute)
        final createdAtStr = data['createdAt'];
        if (createdAtStr != null) {
          final createdAt = DateTime.parse(createdAtStr);
          if (DateTime.now().difference(createdAt).inMinutes > 2) {
            return; // Skip old notifications
          }
        }

        final title = data['title'] ?? 'New Notification';
        final body = data['body'] ?? '';

        debugPrint('NotificationService: Received RTDB notification: $title');

        _showLocalNotification(RemoteMessage(
          notification: RemoteNotification(title: title, body: body),
          data: data['data'] != null
              ? Map<String, dynamic>.from(data['data'])
              : {},
        ));
      } catch (e) {
        debugPrint('NotificationService: Error parsing RTDB data: $e');
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      _localNotifications.show(
        DateTime.now().millisecond,
        notification.title,
        notification.body,
        NotificationDetails(
          android: android != null
              ? const AndroidNotificationDetails(
                  'high_importance_channel',
                  'High Importance Notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                )
              : const AndroidNotificationDetails(
                  'high_importance_channel',
                  'High Importance Notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }
}
