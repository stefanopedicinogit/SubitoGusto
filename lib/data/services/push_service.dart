import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Background message handler — must be a top-level function.
/// Fires when a push arrives while the app is terminated or backgrounded.
/// No need to display anything here; FCM auto-shows the notification on Android
/// and iOS. We just keep the function so the engine wakes up cleanly.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Intentionally empty — system tray notification is displayed by the OS.
}

/// Singleton that owns the FCM lifecycle for the consumer app.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  bool _initialized = false;
  String? _currentToken;
  String? _registeredForUserId;

  /// One-time setup of background handler + token-refresh listener.
  /// Idempotent — safe to call multiple times.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // If the device rotates the token (uninstall/reinstall, app data clear, etc.)
    // we re-upsert under the currently logged-in user.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _currentToken = newToken;
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        _upsertToken(userId, newToken);
      }
    });
  }

  /// Request OS permission and register a device token for [userId].
  /// Call this after consumer login or on app start if already logged in.
  Future<void> registerForUser(String userId) async {
    if (_registeredForUserId == userId && _currentToken != null) return;

    try {
      // Web push needs the VAPID key passed to getToken().
      // Mobile ignores it.
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Push permission denied');
        return;
      }

      final vapidKey = kIsWeb ? dotenv.env['COPPIA_CHIAVI_FIREBASE'] : null;
      final token = await FirebaseMessaging.instance.getToken(
        vapidKey: vapidKey,
      );

      if (token == null) {
        debugPrint('Push token was null');
        return;
      }

      _currentToken = token;
      _registeredForUserId = userId;
      await _upsertToken(userId, token);
    } catch (e) {
      debugPrint('PushService.registerForUser error: $e');
    }
  }

  /// Remove this device's token from the server. Call on logout AND on any
  /// auth state that isn't a logged-in consumer (e.g. staff login on a
  /// browser that previously hosted a consumer session — otherwise the
  /// stale token keeps receiving consumer pushes).
  ///
  /// If we never cached the token (first time we're called this session) we
  /// ask FCM for the device's current token so we know which row to delete.
  Future<void> unregister() async {
    _registeredForUserId = null;
    String? token = _currentToken;
    if (token == null) {
      try {
        final vapidKey = kIsWeb ? dotenv.env['COPPIA_CHIAVI_FIREBASE'] : null;
        token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
      } catch (e) {
        debugPrint('PushService.unregister: getToken failed: $e');
      }
    }
    if (token == null) return;
    try {
      await Supabase.instance.client
          .from('push_tokens')
          .delete()
          .eq('token', token);
      // ignore: avoid_print
      print('[PushService] unregistered token (deleted DB row)');
    } catch (e) {
      debugPrint('PushService.unregister error: $e');
    }
    // Clear cached token so a future registerForUser does a clean register.
    _currentToken = null;
  }

  /// Register a staff (tenant user) device for push notifications.
  /// Saves the FCM token to `users.fcm_token` so the Stripe webhook can
  /// notify all staff browsers when a new delivery order arrives.
  Future<void> registerForStaff(String userId) async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[PushService] staff push permission denied');
        return;
      }

      final vapidKey = kIsWeb ? dotenv.env['COPPIA_CHIAVI_FIREBASE'] : null;
      final token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
      if (token == null) {
        debugPrint('[PushService] staff push token was null');
        return;
      }

      _currentToken = token;
      await Supabase.instance.client
          .from('users')
          .update({'fcm_token': token})
          .eq('id', userId);
      // ignore: avoid_print
      print('[PushService] staff fcm_token saved for $userId');
    } catch (e) {
      debugPrint('[PushService] registerForStaff error: $e');
    }
  }

  /// Clear the FCM token from the staff user row on logout.
  Future<void> unregisterStaff(String userId) async {
    try {
      await Supabase.instance.client
          .from('users')
          .update({'fcm_token': null})
          .eq('id', userId);
    } catch (e) {
      debugPrint('[PushService] unregisterStaff error: $e');
    }
  }

  Future<void> _upsertToken(String userId, String token) async {
    final platform = _platformName();
    try {
      await Supabase.instance.client.from('push_tokens').upsert(
        {
          'customer_id': userId,
          'token': token,
          'platform': platform,
          'last_seen_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'token',
      );
      // ignore: avoid_print
      print('[PushService] token upserted for $userId ($platform)');
    } catch (e) {
      // ignore: avoid_print
      print('[PushService] upsert FAILED: $e');
    }
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'web'; // fallback
  }
}
