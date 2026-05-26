import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/consumer_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Shell wrapper for consumer app with bottom navigation
class ConsumerShell extends ConsumerWidget {
  final Widget child;

  const ConsumerShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/consumer/favorites')) return 1;
    if (location.startsWith('/consumer/orders')) return 2;
    if (location.startsWith('/consumer/profile')) return 3;
    return 0; // marketplace
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/marketplace');
        break;
      case 1:
        context.go('/consumer/favorites');
        break;
      case 2:
        context.go('/consumer/orders');
        break;
      case 3:
        context.go('/consumer/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate consumer order status notification listener
    ref.watch(consumerOrderNotificationListenerProvider);

    final currentIndex = _currentIndex(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: l10n.navMarketplace,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.navFavorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
