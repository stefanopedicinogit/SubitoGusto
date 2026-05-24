import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/utils/responsive.dart';
import 'data/providers/locale_provider.dart';
import 'data/providers/settings_provider.dart';
import 'data/providers/tenant_theme_provider.dart';
import 'core/widgets/app_shell.dart';
import 'core/widgets/app_shell_mobile.dart';
import 'core/widgets/push_handler.dart';
import 'l10n/generated/app_localizations.dart';
import 'data/providers/supabase_provider.dart';
import 'features/auth/login_page.dart';
import 'features/auth/login_page_mobile.dart';
import 'features/auth/register_tenant_page.dart';
import 'features/auth/register_tenant_page_mobile.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/dashboard/dashboard_page_mobile.dart';
import 'features/menu/menu_management_page.dart';
import 'features/menu/menu_management_page_mobile.dart';
import 'features/orders/orders_page.dart';
import 'features/orders/orders_page_mobile.dart';
import 'features/tables/tables_page.dart';
import 'features/tables/tables_page_mobile.dart';
import 'features/settings/settings_page.dart';
import 'features/settings/settings_page_mobile.dart';
import 'features/scan/scan_page.dart';
import 'features/scan/customer_menu_page.dart';
import 'features/users/users_page.dart';
import 'features/kitchen/kitchen_display_page.dart';
import 'features/analytics/analytics_page.dart';
import 'features/analytics/analytics_page_mobile.dart';
import 'features/fixed_menu/fixed_menu_management_page.dart';
import 'features/consumer_auth/consumer_login_page.dart';
import 'features/consumer_auth/consumer_login_page_mobile.dart';
import 'features/consumer_auth/consumer_register_page.dart';
import 'features/consumer_auth/consumer_register_page_mobile.dart';
import 'features/consumer_shell/consumer_shell.dart';
import 'features/marketplace/marketplace_page.dart';
import 'features/marketplace/restaurant_detail_page.dart';
import 'features/consumer_orders/consumer_orders_page.dart';
import 'features/consumer_orders/consumer_order_detail_page.dart';
import 'features/consumer_favorites/favorites_page.dart';
import 'features/consumer_profile/consumer_profile_page.dart';
import 'features/consumer_profile/addresses_page.dart';
import 'features/consumer_profile/location_prompt_page.dart';
import 'features/checkout/checkout_page.dart';
import 'features/checkout/order_confirmation_page.dart';
import 'features/promo_codes/promo_codes_page.dart';

/// Staff routes that require authentication
const _staffRoutes = {'/', '/orders', '/menu', '/tables', '/settings', '/users', '/analytics', '/fixed-menus', '/kitchen', '/promo-codes'};

/// Routes that are always public (no auth required) or consumer routes
bool _isPublicRoute(String location) {
  return location.startsWith('/scan') ||
      location.startsWith('/customer-menu') ||
      location.startsWith('/consumer/') ||
      location.startsWith('/marketplace') ||
      location.startsWith('/checkout') ||
      location.startsWith('/order-confirmation');
}

/// Router provider
/// Converts a stream into a ChangeNotifier for GoRouter.refreshListenable
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}

/// Root navigator key — exposed so non-route code (FCM handlers, deep links)
/// can show modals/sheets that need a Navigator above them in the tree.
final GlobalKey<NavigatorState> appRootNavigatorKey =
    GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.read(supabaseClientProvider).auth.onAuthStateChange;

  return GoRouter(
    initialLocation: '/consumer/login',
    debugLogDiagnostics: true,
    navigatorKey: appRootNavigatorKey,
    refreshListenable: _GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final auth = ref.read(supabaseAuthProvider).valueOrNull;
      final isAuthenticated = auth?.isAuthenticated ?? false;
      final isStaff = auth?.isStaff ?? false;
      final isConsumer = auth?.isConsumer ?? false;

      // Public routes: scan, customer-menu, consumer auth, marketplace
      if (_isPublicRoute(location)) {
        // QR-flow handoff: authenticated consumer landing on an auth page
        // with an explicit returnTo (e.g. ?returnTo=/scan/X) should be sent
        // to that target. Without returnTo we stay on the auth page so the
        // user must explicitly sign in instead of being silently redirected.
        if (isAuthenticated && isConsumer &&
            (location == '/consumer/login' || location == '/consumer/register')) {
          final returnTo = state.uri.queryParameters['returnTo'];
          if (returnTo != null && returnTo.isNotEmpty) {
            return returnTo;
          }
        }
        return null;
      }

      // Staff login/register pages: never auto-redirect away. If the user
      // navigates here they must explicitly authenticate, even if a stale
      // session is still loaded.
      if (location == '/login' || location == '/register') {
        return null;
      }

      // Staff-only routes require staff auth
      if (_staffRoutes.contains(location) || location == '/') {
        if (!isAuthenticated) return '/login';
        if (isConsumer) return '/marketplace';
        return null;
      }

      // Default: require some auth
      if (!isAuthenticated) return '/login';
      return null;
    },
    routes: [
      // ====================================================================
      // Staff auth routes (no shell)
      // ====================================================================
      GoRoute(
        path: '/login',
        builder: (context, state) => _AdaptivePage(
          desktop: const LoginPage(),
          mobile: const LoginPageMobile(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => _AdaptivePage(
          desktop: const RegisterTenantPage(),
          mobile: const RegisterTenantPageMobile(),
        ),
      ),

      // ====================================================================
      // Consumer auth routes (no shell)
      // ====================================================================
      GoRoute(
        path: '/consumer/login',
        builder: (context, state) => _AdaptivePage(
          desktop: const ConsumerLoginPage(),
          mobile: const ConsumerLoginPageMobile(),
        ),
      ),
      GoRoute(
        path: '/consumer/register',
        builder: (context, state) => _AdaptivePage(
          desktop: const ConsumerRegisterPage(),
          mobile: const ConsumerRegisterPageMobile(),
        ),
      ),
      GoRoute(
        path: '/consumer/location',
        builder: (context, state) => const LocationPromptPage(),
      ),

      // ====================================================================
      // QR / dine-in routes (no shell, no auth)
      // ====================================================================
      GoRoute(
        path: '/scan/:qrCode',
        builder: (context, state) {
          final qrCode = state.pathParameters['qrCode'] ?? '';
          return ScanPage(qrCode: qrCode);
        },
      ),
      GoRoute(
        path: '/customer-menu',
        builder: (context, state) => const CustomerMenuPage(),
      ),

      // ====================================================================
      // Kitchen display (fullscreen, no shell)
      // ====================================================================
      GoRoute(
        path: '/kitchen',
        builder: (context, state) => const KitchenDisplayPage(),
      ),

      // ====================================================================
      // Consumer routes with ConsumerShell
      // ====================================================================
      ShellRoute(
        builder: (context, state, child) => ConsumerShell(child: child),
        routes: [
          GoRoute(
            path: '/marketplace',
            builder: (context, state) => const MarketplacePage(),
          ),
          GoRoute(
            path: '/marketplace/:restaurantId',
            builder: (context, state) {
              final restaurantId = state.pathParameters['restaurantId'] ?? '';
              return RestaurantDetailPage(restaurantId: restaurantId);
            },
          ),
          GoRoute(
            path: '/consumer/favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: '/consumer/orders',
            builder: (context, state) => const ConsumerOrdersPage(),
          ),
          GoRoute(
            path: '/consumer/orders/:orderId',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId'] ?? '';
              return ConsumerOrderDetailPage(orderId: orderId);
            },
          ),
          GoRoute(
            path: '/consumer/profile',
            builder: (context, state) => const ConsumerProfilePage(),
          ),
          GoRoute(
            path: '/consumer/addresses',
            builder: (context, state) => const AddressesPage(),
          ),
        ],
      ),

      // ====================================================================
      // Checkout routes (consumer, no shell)
      // ====================================================================
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/order-confirmation/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return OrderConfirmationPage(orderId: orderId);
        },
      ),

      // ====================================================================
      // Staff routes with adaptive shell
      // ====================================================================
      ShellRoute(
        builder: (context, state, child) {
          return _AdaptiveShellWrapper(
            currentPath: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => _AdaptivePage(
              desktop: const DashboardPage(),
              mobile: const DashboardPageMobile(),
            ),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => _AdaptivePage(
              desktop: const OrdersPage(),
              mobile: const OrdersPageMobile(),
            ),
          ),
          GoRoute(
            path: '/menu',
            builder: (context, state) => _AdaptivePage(
              desktop: const MenuManagementPage(),
              mobile: const MenuManagementPageMobile(),
            ),
          ),
          GoRoute(
            path: '/tables',
            builder: (context, state) => _AdaptivePage(
              desktop: const TablesPage(),
              mobile: const TablesPageMobile(),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => _AdaptivePage(
              desktop: const SettingsPage(),
              mobile: const SettingsPageMobile(),
            ),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => _AdaptivePage(
              desktop: const AnalyticsPage(),
              mobile: const AnalyticsPageMobile(),
            ),
          ),
          GoRoute(
            path: '/fixed-menus',
            builder: (context, state) => const FixedMenuManagementPage(),
          ),
          GoRoute(
            path: '/promo-codes',
            builder: (context, state) => const PromoCodesPage(),
          ),
        ],
      ),
    ],
  );
});

/// Main App widget
class SubitoGustoApp extends ConsumerWidget {
  const SubitoGustoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    final tenantTheme = ref.watch(tenantThemeProvider);

    // Determine theme mode
    final ThemeMode themeMode;
    switch (settings.theme) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
        themeMode = ThemeMode.system;
        break;
      default:
        themeMode = ThemeMode.light;
    }

    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'SubitoGusto',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: tenantTheme.lightTheme,
      darkTheme: tenantTheme.darkTheme,
      themeMode: themeMode,
      // i18n
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => PushHandler(child: child ?? const SizedBox()),
    );
  }
}

/// Adaptive page wrapper - shows desktop or mobile version based on screen size
class _AdaptivePage extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;

  const _AdaptivePage({
    required this.desktop,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.useMobileLayout(context)) {
      return mobile;
    }
    return desktop;
  }
}

/// Adaptive shell wrapper - wraps content with appropriate shell
class _AdaptiveShellWrapper extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const _AdaptiveShellWrapper({
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.useMobileLayout(context)) {
      return AppShellMobile(
        currentPath: currentPath,
        child: child,
      );
    }
    return AppShell(
      currentPath: currentPath,
      child: child,
    );
  }
}
