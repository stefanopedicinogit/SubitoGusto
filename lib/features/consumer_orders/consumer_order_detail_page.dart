import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/order_status_label.dart';
import '../../core/widgets/rating_stars.dart';
import '../../data/models/delivery_order.dart';
import '../../data/models/delivery_order_item.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/reviews_provider.dart';
import '../../data/providers/supabase_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../reviews/review_prompt_dialog.dart';

/// Provider to fetch a single delivery order by ID (realtime)
final deliveryOrderDetailProvider =
    StreamProvider.family<DeliveryOrder?, String>((ref, orderId) {
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('delivery_orders')
      .stream(primaryKey: ['id'])
      .eq('id', orderId)
      .map((data) {
    if (data.isEmpty) return null;
    return DeliveryOrder.fromJson(data.first);
  });
});

/// Provider to fetch order items
final deliveryOrderItemsProvider =
    FutureProvider.family<List<DeliveryOrderItem>, String>((ref, orderId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('delivery_order_items')
      .select()
      .eq('delivery_order_id', orderId)
      .order('created_at');

  return (data as List).map((json) => DeliveryOrderItem.fromJson(json)).toList();
});

/// Consumer order detail page with status timeline
class ConsumerOrderDetailPage extends ConsumerWidget {
  final String orderId;

  const ConsumerOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(deliveryOrderDetailProvider(orderId));
    final itemsAsync = ref.watch(deliveryOrderItemsProvider(orderId));
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.ordersDetailTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/consumer/orders');
            }
          },
        ),
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return Center(child: Text(l.ordersNotFound));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  l.ordersNumber(order.orderNumber),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  order.formatTotal(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              timeago.format(order.createdAt, locale: 'it'),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Status timeline
                    _SectionTitle(title: l.ordersStatusSection),
                    _StatusTimeline(order: order),
                    const SizedBox(height: AppSpacing.lg),

                    // Order items
                    _SectionTitle(title: l.ordersItemsSection),
                    itemsAsync.when(
                      data: (items) => Card(
                        child: Column(
                          children: [
                            ...items.map((item) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      '${item.quantity}x',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  title: Text(item.menuItemName),
                                  subtitle: item.notes != null
                                      ? Text(
                                          item.notes!,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                  trailing: Text(
                                    item.formatTotalPrice(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(l.ordersItemsLoadError),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Price breakdown
                    _SectionTitle(title: l.ordersSummarySection),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            _PriceRow(
                              label: l.checkoutSubtotal,
                              value:
                                  '€ ${order.subtotal.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            _PriceRow(
                              label: l.checkoutDelivery,
                              value:
                                  '€ ${order.deliveryFee.toStringAsFixed(2)}',
                            ),
                            if (order.discount > 0) ...[
                              const SizedBox(height: AppSpacing.xs),
                              _PriceRow(
                                label: l.checkoutDiscount,
                                value:
                                    '-€ ${order.discount.toStringAsFixed(2)}',
                              ),
                            ],
                            const Divider(height: AppSpacing.lg),
                            _PriceRow(
                              label: l.checkoutTotal,
                              value: order.formatTotal(),
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Delivery address
                    _SectionTitle(title: l.ordersAddressSection),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(order.deliveryFullAddress),
                        subtitle: order.deliveryNotes != null
                            ? Text(order.deliveryNotes!)
                            : null,
                      ),
                    ),

                    if (order.notes != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _SectionTitle(title: l.ordersNotesSection),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(order.notes!),
                        ),
                      ),
                    ],
                    // Review CTA / display — only meaningful for delivered orders.
                    if (order.status == 'delivered') ...[
                      const SizedBox(height: AppSpacing.lg),
                      _ReviewSection(tenantId: order.tenantId),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final DeliveryOrder order;

  const _StatusTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final steps = [
      _TimelineStep(
        label: l.statusPending,
        icon: Icons.receipt_long,
        isCompleted: true,
        isActive: order.isPending,
        timestamp: order.createdAt,
      ),
      _TimelineStep(
        label: l.statusConfirmed,
        icon: Icons.check_circle,
        isCompleted: !order.isPending,
        isActive: order.isConfirmed,
        timestamp: order.confirmedAt,
      ),
      _TimelineStep(
        label: l.statusPreparing,
        icon: Icons.restaurant,
        isCompleted: order.isPreparing ||
            order.isReadyForDelivery ||
            order.isOutForDelivery ||
            order.isDelivered,
        isActive: order.isPreparing,
      ),
      _TimelineStep(
        label: l.statusOutForDelivery,
        icon: Icons.delivery_dining,
        isCompleted: order.isOutForDelivery || order.isDelivered,
        isActive: order.isOutForDelivery || order.isReadyForDelivery,
      ),
      _TimelineStep(
        label: l.statusDelivered,
        icon: Icons.home,
        isCompleted: order.isDelivered,
        isActive: order.isDelivered,
        timestamp: order.deliveredAt,
      ),
    ];

    if (order.isCancelled || order.isRefunded) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.cancel,
                color: AppColors.error,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                order.isCancelled ? 'Ordine annullato' : 'Ordine rimborsato',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              _buildStep(context, steps[i]),
              if (i < steps.length - 1)
                _buildConnector(steps[i].isCompleted),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, _TimelineStep step) {
    final color = step.isCompleted
        ? AppColors.success
        : step.isActive
            ? Theme.of(context).colorScheme.primary
            : AppColors.textSecondary.withValues(alpha: 0.4);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: step.isCompleted || step.isActive
                ? color.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(step.icon, size: 18, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            step.label,
            style: TextStyle(
              fontWeight:
                  step.isActive ? FontWeight.bold : FontWeight.normal,
              color: step.isCompleted || step.isActive
                  ? null
                  : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
        if (step.timestamp != null)
          Text(
            timeago.format(step.timestamp!, locale: 'it'),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildConnector(bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(left: 17),
      child: Container(
        width: 2,
        height: 24,
        color: isCompleted
            ? AppColors.success
            : AppColors.textSecondary.withValues(alpha: 0.2),
      ),
    );
  }
}

class _TimelineStep {
  final String label;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;
  final DateTime? timestamp;

  const _TimelineStep({
    required this.label,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
    this.timestamp,
  });
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

/// Shown on delivered-order detail. If the customer hasn't reviewed yet,
/// renders a "Lascia recensione" button. If they have, displays their
/// existing rating with an edit affordance.
class _ReviewSection extends ConsumerWidget {
  final String tenantId;

  const _ReviewSection({required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myReviewAsync = ref.watch(
        myReviewForTargetProvider(ReviewTargetKey('restaurant', tenantId)));
    final tenantAsync = ref.watch(restaurantDetailProvider(tenantId));
    final l = AppLocalizations.of(context);

    return myReviewAsync.when(
      data: (review) {
        final tenant = tenantAsync.valueOrNull;
        final tenantName = tenant?.name ?? '';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: review == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.reviewLeaveTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l.reviewLeaveSubtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: tenantName.isEmpty
                            ? null
                            : () => ReviewPromptDialog.show(
                                  context,
                                  tenantId: tenantId,
                                  tenantName: tenantName,
                                ),
                        icon: const Icon(Icons.star_outline),
                        label: Text(l.reviewLeaveButton),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.reviewMine,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            RatingStarsRow(
                              rating: review.rating,
                              size: 20,
                            ),
                            if (review.comment != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                review.comment!,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: tenantName.isEmpty
                            ? null
                            : () => ReviewPromptDialog.show(
                                  context,
                                  tenantId: tenantId,
                                  tenantName: tenantName,
                                ),
                        child: Text(l.reviewEdit),
                      ),
                    ],
                  ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
