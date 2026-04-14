import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme/app_theme.dart';
import '../../data/models/delivery_order.dart';
import '../../data/models/delivery_order_item.dart';
import '../../data/providers/supabase_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio ordine'),
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
            return const Center(child: Text('Ordine non trovato'));
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
                                  'Ordine #${order.orderNumber}',
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
                    _SectionTitle(title: 'Stato ordine'),
                    _StatusTimeline(order: order),
                    const SizedBox(height: AppSpacing.lg),

                    // Order items
                    _SectionTitle(title: 'Articoli'),
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
                      error: (_, __) => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Text('Impossibile caricare gli articoli'),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Price breakdown
                    _SectionTitle(title: 'Riepilogo'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            _PriceRow(
                              label: 'Subtotale',
                              value:
                                  '€ ${order.subtotal.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            _PriceRow(
                              label: 'Consegna',
                              value:
                                  '€ ${order.deliveryFee.toStringAsFixed(2)}',
                            ),
                            if (order.discount > 0) ...[
                              const SizedBox(height: AppSpacing.xs),
                              _PriceRow(
                                label: 'Sconto',
                                value:
                                    '-€ ${order.discount.toStringAsFixed(2)}',
                              ),
                            ],
                            const Divider(height: AppSpacing.lg),
                            _PriceRow(
                              label: 'Totale',
                              value: order.formatTotal(),
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Delivery address
                    _SectionTitle(title: 'Indirizzo di consegna'),
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
                      _SectionTitle(title: 'Note'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(order.notes!),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
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
    final steps = [
      _TimelineStep(
        label: 'Ordine ricevuto',
        icon: Icons.receipt_long,
        isCompleted: true,
        isActive: order.isPending,
        timestamp: order.createdAt,
      ),
      _TimelineStep(
        label: 'Confermato',
        icon: Icons.check_circle,
        isCompleted: !order.isPending,
        isActive: order.isConfirmed,
        timestamp: order.confirmedAt,
      ),
      _TimelineStep(
        label: 'In preparazione',
        icon: Icons.restaurant,
        isCompleted: order.isPreparing ||
            order.isReadyForDelivery ||
            order.isOutForDelivery ||
            order.isDelivered,
        isActive: order.isPreparing,
      ),
      _TimelineStep(
        label: 'In consegna',
        icon: Icons.delivery_dining,
        isCompleted: order.isOutForDelivery || order.isDelivered,
        isActive: order.isOutForDelivery || order.isReadyForDelivery,
      ),
      _TimelineStep(
        label: 'Consegnato',
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
            ? AppColors.burgundy
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
