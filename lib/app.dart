import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/utils/responsive.dart';
import 'data/providers/settings_provider.dart';
import 'data/providers/tenant_theme_provider.dart';
import 'core/widgets/app_shell.dart';
import 'core/widgets/app_shell_mobile.dart';
import 'data/providers/supabase_provider.dart';
import 'features/auth/login_page.dart';
import 'features/auth/login_page_mobile.dart';
import 'features/auth/register_tenant_page.dart';
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
import 'features/fixed_menu/fixed_menu_management_page.dart';

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(supabaseAuthProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isScanRoute = state.matchedLocation.startsWith('/scan');

      // Allow scan routes without authentication (for customers)
      if (isScanRoute) {
        return null;
      }

      final auth = authState.valueOrNull;
      final isAuthenticated = auth?.isAuthenticated ?? false;

      // Redirect to login if not authenticated (except for register page)
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // Redirect to dashboard if authenticated and trying to access login/register
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
    routes: [
      // Login route (no shell)
      GoRoute(
        path: '/login',
        builder: (context, state) => _AdaptivePage(
          desktop: const LoginPage(),
          mobile: const LoginPageMobile(),
        ),
      ),

      // Register tenant route (no shell)
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterTenantPage(),
      ),

      // Customer scan route (no shell)
      GoRoute(
        path: '/scan/:qrCode',
        builder: (context, state) {
          final qrCode = state.pathParameters['qrCode'] ?? '';
          return ScanPage(qrCode: qrCode);
        },
      ),

      // Customer menu route (no shell)
      GoRoute(
        path: '/customer-menu',
        builder: (context, state) => const CustomerMenuPage(),
      ),

      // Kitchen display route (fullscreen, no shell)
      GoRoute(
        path: '/kitchen',
        builder: (context, state) => const KitchenDisplayPage(),
      ),

      // Staff routes with shell
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
            builder: (context, state) => const AnalyticsPage(),
          ),
          GoRoute(
            path: '/fixed-menus',
            builder: (context, state) => const FixedMenuManagementPage(),
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

    return MaterialApp.router(
      title: 'SubitoGusto',
      debugShowCheckedModeBanner: false,
      theme: tenantTheme.lightTheme,
      darkTheme: tenantTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
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
