import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'notifications_panel.dart';
import '../../data/providers/providers.dart';
import '../../features/orders/manual_order_dialog.dart';

/// Mobile shell with AppBar, Drawer and BottomNavigation
class AppShellMobile extends ConsumerWidget {
  final Widget child;
  final String currentPath;
  final bool showBottomNav;

  const AppShellMobile({
    super.key,
    required this.child,
    required this.currentPath,
    this.showBottomNav = true,
  });

  String get _title {
    switch (currentPath) {
      case '/':
        return 'Dashboard';
      case '/orders':
        return 'Ordini';
      case '/menu':
        return 'Menu';
      case '/tables':
        return 'Tavoli';
      case '/users':
        return 'Utenti';
      case '/settings':
        return 'Impostazioni';
      default:
        return 'SubitoGusto';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate order notification listener
    ref.watch(orderNotificationListenerProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final canManageMenu = currentUser?.canManageMenu ?? true;
    final canManageTables = currentUser?.canManageTables ?? true;
    final canManageOrders = currentUser?.canManageOrders ?? true;

    // Build bottom nav items based on permissions
    final navItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Ordini',
      ),
    ];

    if (canManageMenu) {
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu_outlined),
        activeIcon: Icon(Icons.restaurant_menu),
        label: 'Menu',
      ));
    }

    if (canManageTables) {
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.table_restaurant_outlined),
        activeIcon: Icon(Icons.table_restaurant),
        label: 'Tavoli',
      ));
    }

    // Calculate current index based on available items
    int getCurrentIndex() {
      if (currentPath.startsWith('/orders')) return 1;
      if (currentPath.startsWith('/menu') && canManageMenu) return 2;
      if (currentPath.startsWith('/tables') && canManageTables) {
        return canManageMenu ? 3 : 2;
      }
      return 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: const [
          NotificationBell(),
        ],
      ),
      drawer: _MobileDrawer(currentPath: currentPath),
      body: child,
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: getCurrentIndex(),
              onTap: (index) {
                if (index == 0) {
                  context.go('/');
                } else if (index == 1) {
                  context.go('/orders');
                } else if (index == 2) {
                  if (canManageMenu) {
                    context.go('/menu');
                  } else if (canManageTables) {
                    context.go('/tables');
                  }
                } else if (index == 3 && canManageTables) {
                  context.go('/tables');
                }
              },
              items: navItems,
            )
          : null,
      floatingActionButton: canManageOrders
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ManualOrderDialog(),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _MobileDrawer extends ConsumerWidget {
  final String currentPath;

  const _MobileDrawer({required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(tenantColorsProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    // Role-based permissions
    final canManageMenu = currentUser?.canManageMenu ?? true;
    final canManageTables = currentUser?.canManageTables ?? true;
    final isAdmin = currentUser?.isAdmin ?? true;

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: colors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: tenant?.logoUrl != null
                      ? Image.network(
                          tenant!.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              tenant.logoInitial,
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            tenant?.logoInitial ?? 'T',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  tenant?.name ?? 'Ristorante',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  currentUser?.roleDisplayName ?? 'Staff',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  path: '/',
                  currentPath: currentPath,
                ),
                _DrawerItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Ordini',
                  path: '/orders',
                  currentPath: currentPath,
                ),
                // Kitchen display hidden for now - accessible via /kitchen URL
                // _KitchenDrawerItem(),
                if (canManageMenu) ...[
                  _DrawerItem(
                    icon: Icons.restaurant_menu_outlined,
                    label: 'Menu',
                    path: '/menu',
                    currentPath: currentPath,
                  ),
                  _DrawerItem(
                    icon: Icons.menu_book_outlined,
                    label: 'Menu Fissi',
                    path: '/fixed-menus',
                    currentPath: currentPath,
                  ),
                ],
                if (canManageTables)
                  _DrawerItem(
                    icon: Icons.table_restaurant_outlined,
                    label: 'Tavoli',
                    path: '/tables',
                    currentPath: currentPath,
                  ),
                if (currentUser?.canViewReports ?? false) ...[
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.analytics_outlined,
                    label: 'Statistiche',
                    path: '/analytics',
                    currentPath: currentPath,
                  ),
                ],
                if (isAdmin) ...[
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.people_outlined,
                    label: 'Utenti',
                    path: '/users',
                    currentPath: currentPath,
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Impostazioni',
                    path: '/settings',
                    currentPath: currentPath,
                  ),
                ],
                _DrawerItem(
                  icon: Icons.help_outline,
                  label: 'Aiuto',
                  path: '/help',
                  currentPath: currentPath,
                ),
              ],
            ),
          ),
          // Footer
          const Divider(height: 1),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              child: currentUser?.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        currentUser!.avatarUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      currentUser?.initials ?? 'S',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            title: Text(currentUser?.fullName ?? 'Staff'),
            subtitle: Text(currentUser?.roleDisplayName ?? 'Caricamento...'),
            trailing: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Esci'),
                    content: const Text('Sei sicuro di voler uscire?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annulla'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Esci'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _DrawerItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final String path;
  final String currentPath;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.currentPath,
  });

  bool get isSelected => currentPath == path || currentPath.startsWith('$path/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = ref.watch(tenantColorsProvider);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colors.primary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? colors.primary : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: colors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
    );
  }
}

/// Kitchen display drawer item with special styling
class _KitchenDrawerItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.restaurant,
            color: AppColors.gold,
            size: 20,
          ),
        ),
        title: const Text(
          'Display Cucina',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.open_in_new,
          size: 16,
          color: AppColors.gold.withValues(alpha: 0.7),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        onTap: () {
          Navigator.pop(context);
          context.push('/kitchen');
        },
      ),
    );
  }
}
