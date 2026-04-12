import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/app_theme.dart';
import '../../data/providers/notifications_provider.dart';

/// Notification bell icon with badge
class NotificationBell extends ConsumerWidget {
  final Color? iconColor;
  final double? iconSize;

  const NotificationBell({
    super.key,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return IconButton(
      icon: Badge(
        isLabelVisible: unreadCount > 0,
        label: Text(
          unreadCount > 99 ? '99+' : '$unreadCount',
          style: const TextStyle(fontSize: 10),
        ),
        child: Icon(
          unreadCount > 0 ? Icons.notifications_active : Icons.notifications_outlined,
          color: iconColor,
          size: iconSize,
        ),
      ),
      onPressed: () => _showNotificationsPanel(context),
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => NotificationsPanel(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

/// Notifications panel showing all notifications
class NotificationsPanel extends ConsumerWidget {
  final ScrollController? scrollController;

  const NotificationsPanel({super.key, this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);
    final notifications = notificationsState.notifications;

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Notifiche',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (notifications.isNotEmpty) ...[
                  TextButton(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).markAllAsRead();
                    },
                    child: const Text('Segna tutte lette'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).clearAll();
                    },
                    tooltip: 'Cancella tutto',
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Notifications list
          if (notifications.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nessuna notifica',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Le notifiche appariranno qui',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationTile(
                    notification: notification,
                    onTap: () {
                      ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                      if (notification.orderId != null) {
                        Navigator.pop(context);
                        context.go('/orders');
                      }
                    },
                    onDismiss: () {
                      ref.read(notificationsProvider.notifier).removeNotification(notification.id);
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        tileColor: notification.isRead ? null : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(context).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getTypeIcon(),
            color: _getTypeColor(context),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              timeago.format(notification.timestamp, locale: 'it'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case 'order':
        return Icons.receipt_long;
      case 'system':
        return Icons.settings;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(BuildContext context) {
    switch (notification.type) {
      case 'order':
        return Theme.of(context).colorScheme.primary;
      case 'system':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return AppColors.textSecondary;
    }
  }
}
