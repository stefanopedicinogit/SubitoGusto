import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'notifications_panel.dart';
import '../../data/providers/providers.dart';
import '../../features/orders/manual_order_dialog.dart';

/// Desktop shell with sidebar and topbar
class AppShell extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const AppShell({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate order notification listener
    ref.watch(orderNotificationListenerProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _Sidebar(currentPath: currentPath),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Topbar
                _Topbar(currentPath: currentPath),
                // Content
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  final String currentPath;

  const _Sidebar({required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = ref.watch(tenantColorsProvider);
    final tenant = ref.watch(tenantProvider).valueOrNull;
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    // Role-based permissions
    final canManageMenu = currentUser?.canManageMenu ?? true;
    final canManageTables = currentUser?.canManageTables ?? true;
    final isAdmin = currentUser?.isAdmin ?? true;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkSurfaceLight : Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo header
          Container(
            height: 80,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primary,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            tenant?.logoInitial ?? 'T',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenant?.name ?? 'Ristorante',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        tenant?.name.split(' ').last ?? '',
                        style: theme.textTheme.titleLarge?.copyWith(
                              color: colors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: 'Dashboard',
                  path: '/',
                  currentPath: currentPath,
                ),
                _NavItem(
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long,
                  label: 'Ordini',
                  path: '/orders',
                  currentPath: currentPath,
                ),
                // Kitchen display hidden for now - accessible via /kitchen URL
                // _KitchenNavItem(currentPath: currentPath),
                if (canManageMenu) ...[
                  _NavItem(
                    icon: Icons.restaurant_menu_outlined,
                    selectedIcon: Icons.restaurant_menu,
                    label: 'Menu',
                    path: '/menu',
                    currentPath: currentPath,
                  ),
                  _NavItem(
                    icon: Icons.menu_book_outlined,
                    selectedIcon: Icons.menu_book,
                    label: 'Menu Fissi',
                    path: '/fixed-menus',
                    currentPath: currentPath,
                  ),
                ],
                if (canManageTables)
                  _NavItem(
                    icon: Icons.table_restaurant_outlined,
                    selectedIcon: Icons.table_restaurant,
                    label: 'Tavoli',
                    path: '/tables',
                    currentPath: currentPath,
                  ),
                if (currentUser?.canViewReports ?? false) ...[
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'REPORT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NavItem(
                    icon: Icons.analytics_outlined,
                    selectedIcon: Icons.analytics,
                    label: 'Statistiche',
                    path: '/analytics',
                    currentPath: currentPath,
                  ),
                ],
                if (isAdmin) ...[
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'AMMINISTRAZIONE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NavItem(
                    icon: Icons.people_outlined,
                    selectedIcon: Icons.people,
                    label: 'Utenti',
                    path: '/users',
                    currentPath: currentPath,
                  ),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: 'Impostazioni',
                    path: '/settings',
                    currentPath: currentPath,
                  ),
                ],
              ],
            ),
          ),
          // User section
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
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
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.fullName ?? 'Staff',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        currentUser?.roleDisplayName ?? 'Caricamento...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
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
                    if (confirm == true) {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }
                  },
                  tooltip: 'Esci',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;
  final String currentPath;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
    required this.currentPath,
  });

  bool get isSelected => currentPath == path || currentPath.startsWith('$path/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = ref.watch(tenantColorsProvider);
    final primaryColor = colors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Material(
        color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => context.go(path),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected ? primaryColor : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Topbar extends ConsumerWidget {
  final String currentPath;

  const _Topbar({required this.currentPath});

  String get _title {
    switch (currentPath) {
      case '/':
        return 'Dashboard';
      case '/orders':
        return 'Gestione Ordini';
      case '/menu':
        return 'Gestione Menu';
      case '/tables':
        return 'Gestione Tavoli';
      case '/users':
        return 'Gestione Utenti';
      case '/settings':
        return 'Impostazioni';
      case '/analytics':
        return 'Statistiche';
      case '/fixed-menus':
        return 'Menu Fissi';
      default:
        return 'SubitoGusto';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final canManageOrders = currentUser?.canManageOrders ?? true;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkSurfaceLight : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            _title,
            style: theme.textTheme.headlineSmall,
          ),
          const Spacer(),
          // Notification bell
          const NotificationBell(),
          const SizedBox(width: AppSpacing.sm),
          // Quick actions
          if (canManageOrders)
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ManualOrderDialog(),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nuovo Ordine'),
            ),
        ],
      ),
    );
  }
}

/// Kitchen display navigation item with special styling
class _KitchenNavItem extends ConsumerWidget {
  final String currentPath;

  const _KitchenNavItem({required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Material(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => context.push('/kitchen'),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Display Cucina',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: AppColors.gold.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
