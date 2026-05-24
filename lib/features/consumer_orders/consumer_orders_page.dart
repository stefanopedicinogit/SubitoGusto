import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/order_status_label.dart';
import '../../core/widgets/language_switcher.dart';
import '../../core/widgets/notifications_panel.dart';
import '../../core/widgets/skeletons.dart';
import '../../data/models/delivery_order.dart';
import '../../data/providers/consumer_providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer order history page
class ConsumerOrdersPage extends ConsumerWidget {
  const ConsumerOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrdersAsync = ref.watch(activeDeliveryOrdersProvider);
    final historyAsync = ref.watch(consumerOrderHistoryProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l.ordersTitle),
          ],
        ),
        centerTitle: false,
        actions: const [LanguageSwitcher(), NotificationBell()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(consumerOrderHistoryProvider);
          ref.invalidate(activeDeliveryOrdersProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Active orders section
            activeOrdersAsync.when(
              data: (activeOrders) {
                if (activeOrders.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.xs,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(
                        l.ordersActive,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...activeOrders.map((order) => _OrderCard(
                          order: order,
                          isActive: true,
                          onTap: () =>
                              context.push('/consumer/orders/${order.id}'),
                        )),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Order history section
            historyAsync.when(
              data: (orders) {
                final pastOrders =
                    orders.where((o) => !o.isActive).toList();

                if (orders.isEmpty) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l.ordersEmpty,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l.ordersEmptyHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (pastOrders.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.xs,
                        bottom: AppSpacing.sm,
                      ),
                      child: Text(
                        l.ordersHistory,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ...pastOrders.map((order) => _OrderCard(
                          order: order,
                          isActive: false,
                          onTap: () =>
                              context.push('/consumer/orders/${order.id}'),
                        )),
                  ],
                );
              },
              loading: () => const OrderListSkeleton(),
              error: (e, _) => Center(child: Text(humanizeError(e, context))),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final DeliveryOrder order;
  final bool isActive;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatusBadge(status: order.status),
                  const Spacer(),
                  Text(
                    timeago.format(order.createdAt, locale: 'it'),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ordine #${order.orderNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    order.formatTotal(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.deliveryFullAddress,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color textColor) = switch (status) {
      'pending' => (Colors.orange.shade50, Colors.orange.shade700),
      'confirmed' => (Colors.blue.shade50, Colors.blue.shade700),
      'preparing' => (Colors.amber.shade50, Colors.amber.shade700),
      'ready_for_delivery' => (Colors.teal.shade50, Colors.teal.shade700),
      'out_for_delivery' => (Colors.indigo.shade50, Colors.indigo.shade700),
      'delivered' => (Colors.green.shade50, Colors.green.shade700),
      'cancelled' => (Colors.red.shade50, Colors.red.shade700),
      'refunded' => (Colors.grey.shade100, Colors.grey.shade700),
      _ => (Colors.grey.shade100, Colors.grey.shade700),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        localizedOrderStatus(context, status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
