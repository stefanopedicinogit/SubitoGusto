import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Hide gotrue's AuthState so it doesn't shadow our app-level AuthState.
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../app.dart' show appRootNavigatorKey;
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/notifications_provider.dart';
import '../../data/providers/supabase_provider.dart';
import '../../data/services/push_service.dart';
import '../../features/reviews/review_prompt_dialog.dart';

/// Global key used by [PushHandler] to surface foreground messages as
/// SnackBars regardless of which screen the user is on.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Mounted once near the root of the app. Owns three things:
///  1. Auth-driven token registration/unregistration.
///  2. Foreground FCM messages → SnackBar.
///  3. Background/terminated tap → navigation to the order detail page.
class PushHandler extends ConsumerStatefulWidget {
  final Widget child;

  const PushHandler({super.key, required this.child});

  @override
  ConsumerState<PushHandler> createState() => _PushHandlerState();
}

class _PushHandlerState extends ConsumerState<PushHandler> {
  @override
  void initState() {
    super.initState();

    // App was launched by tapping a notification while terminated.
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleTap(message);
      }
    }).catchError((Object e) {
      debugPrint('getInitialMessage error: $e');
      return null;
    });

    // Tap while app is backgrounded (not terminated).
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // Message arrives while app is in the foreground.
    FirebaseMessaging.onMessage.listen(_handleForeground);

    // Process the *current* auth state on first build (ref.listen only
    // fires on subsequent changes, so a cached session would otherwise miss
    // registration). Defer to post-frame to avoid reading providers in initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleAuth(ref.read(supabaseAuthProvider));
    });
  }

  void _handleTap(RemoteMessage message) {
    final orderId = message.data['order_id'] as String?;
    if (orderId == null || !mounted) return;
    // Defer to the next frame so GoRouter is fully ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.push('/consumer/orders/$orderId');
    });
  }

  void _handleForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    final orderId = message.data['order_id'] as String?;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        duration: const Duration(seconds: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.title != null)
              Text(
                notification.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (notification.body != null) Text(notification.body!),
          ],
        ),
        action: orderId == null
            ? null
            : SnackBarAction(
                label: 'Vedi',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  if (mounted) {
                    context.push('/consumer/orders/$orderId');
                  }
                },
              ),
      ),
    );

    // Persist into the in-app notifications panel so the bell shows an
    // unread badge and the user can re-open the message later.
    ref.read(notificationsProvider.notifier).addNotification(
          title: notification.title ?? 'Notifica',
          message: notification.body ?? '',
          type: 'order',
          orderId: orderId,
        );

    // Refresh the order streams so badges/lists update immediately.
    ref.invalidate(activeDeliveryOrdersProvider);

    // If this push announced a delivered order, prompt the customer to
    // rate the restaurant. Fire-and-forget; failures are silent.
    if (message.data['status'] == 'delivered' && orderId != null) {
      _maybePromptReview(orderId);
    }
  }

  /// Looks up the order's tenant + name and shows the review prompt.
  /// Diagnostic prints (kept in release for now while we shake this out).
  Future<void> _maybePromptReview(String orderId) async {
    // ignore: avoid_print
    print('[ReviewPrompt] entry for order $orderId');
    try {
      final client = Supabase.instance.client;
      final order = await client
          .from('delivery_orders')
          .select('tenant_id')
          .eq('id', orderId)
          .maybeSingle();
      if (order == null) {
        // ignore: avoid_print
        print('[ReviewPrompt] aborted: order row not found / RLS denied');
        return;
      }
      if (!mounted) {
        // ignore: avoid_print
        print('[ReviewPrompt] aborted: widget unmounted after order fetch');
        return;
      }
      final tenantId = order['tenant_id'] as String;

      final tenant = await client
          .from('tenants')
          .select('name')
          .eq('id', tenantId)
          .maybeSingle();
      if (tenant == null) {
        // ignore: avoid_print
        print('[ReviewPrompt] aborted: tenant row not found / RLS denied');
        return;
      }
      if (!mounted) return;
      final tenantName = tenant['name'] as String;
      // ignore: avoid_print
      print('[ReviewPrompt] resolved tenant "$tenantName" — scheduling sheet');

      // Slight delay so the SnackBar animates in first; otherwise the modal
      // route can swallow the user's attention before they see the toast.
      Future.delayed(const Duration(milliseconds: 600), () {
        final ctx = appRootNavigatorKey.currentContext;
        if (ctx == null) {
          // ignore: avoid_print
          print('[ReviewPrompt] aborted: root navigator context is null');
          return;
        }
        // ignore: avoid_print
        print('[ReviewPrompt] showing modal sheet now');
        ReviewPromptDialog.show(
          ctx,
          tenantId: tenantId,
          tenantName: tenantName,
        );
      });
    } catch (e, st) {
      // ignore: avoid_print
      print('[ReviewPrompt] threw: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    // React to subsequent auth changes (login/logout during the session).
    // Initial state is handled by the post-frame callback in initState.
    ref.listen<AsyncValue<AuthState>>(
      supabaseAuthProvider,
      (prev, next) => _handleAuth(next),
    );

    return widget.child;
  }

  void _handleAuth(AsyncValue<AuthState> snapshot) {
    final auth = snapshot.valueOrNull;
    debugPrint(
      'PushHandler auth tick: authed=${auth?.isAuthenticated} consumer=${auth?.isConsumer} staff=${auth?.isStaff} uid=${auth?.user?.id}',
    );
    if (auth == null) return;

    if (auth.isAuthenticated && auth.isConsumer && auth.user != null) {
      // Consumer login — register device in push_tokens.
      // Also clear any stale staff token from this device.
      PushService.instance.registerForUser(auth.user!.id);
    } else if (auth.isAuthenticated && auth.isStaff && auth.user != null) {
      // Staff login — remove any consumer token from this device, then
      // register this browser in users.fcm_token for new-order notifications.
      PushService.instance.unregister();
      PushService.instance.registerForStaff(auth.user!.id);
    } else {
      // Logged out — clean up both token stores.
      PushService.instance.unregister();
    }
  }
}
