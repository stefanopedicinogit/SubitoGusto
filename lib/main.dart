import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app.dart';
import 'data/services/push_service.dart';
import 'firebase_options.dart';

void main() async {
  // Use path URL strategy on web (removes /#/ from URLs)
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Stripe (mobile only — web uses Stripe.js via Checkout redirect)
  final stripeKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  if (!kIsWeb && stripeKey.isNotEmpty && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android)) {
    Stripe.publishableKey = stripeKey;
    Stripe.merchantIdentifier = 'merchant.com.subitogusto';
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialize Firebase (for FCM push notifications).
  // Tolerate failure — if firebase_options.dart isn't present yet, the app
  // still runs, just without push.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await PushService.instance.initialize();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  // Initialize timeago with Italian locale
  timeago.setLocaleMessages('it', timeago.ItMessages());

  runApp(
    const ProviderScope(
      child: SubitoGustoApp(),
    ),
  );
}
