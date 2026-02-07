import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'env.dart';

/// Firebase configuration and initialization helper
class FirebaseConfig {
  static FirebaseAnalytics? _analytics;

  /// Get Firebase Analytics instance
  static FirebaseAnalytics? get analytics => _analytics;

  /// Initialize Firebase services
  static Future<void> initialize() async {
    if (!Env.firebaseEnabled) {
      debugPrint('Firebase is disabled via environment');
      return;
    }

    try {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');

      // Initialize Analytics
      _analytics = FirebaseAnalytics.instance;

      // Configure Crashlytics
      await _setupCrashlytics();

      // Setup messaging
      await _setupMessaging();
    } catch (e, stack) {
      debugPrint('Firebase initialization failed: $e\n$stack');
    }
  }

  /// Configure Crashlytics error handling
  static Future<void> _setupCrashlytics() async {
    // Pass Flutter errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass platform errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Disable crashlytics in debug mode
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    debugPrint('Crashlytics configured (enabled: ${!kDebugMode})');
  }

  /// Setup Firebase Cloud Messaging
  static Future<void> _setupMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('FCM Permission status: ${settings.authorizationStatus}');

    // Get FCM token
    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      // TODO: Send new token to your backend
    });
  }

  /// Get the current FCM token
  static Future<String?> getFCMToken() async {
    if (!Env.firebaseEnabled) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  /// Log a custom analytics event
  static Future<void> logEvent(String name,
      {Map<String, Object>? parameters}) async {
    if (_analytics == null) return;
    await _analytics!.logEvent(name: name, parameters: parameters);
  }

  /// Set the current user ID for analytics
  static Future<void> setUserId(String? userId) async {
    if (_analytics == null) return;
    await _analytics!.setUserId(id: userId);
  }
}
