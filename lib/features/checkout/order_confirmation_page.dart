import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/distance.dart';
import '../../core/utils/order_status_label.dart';
import '../../data/models/delivery_order.dart';
import '../../data/models/tenant.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/supabase_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// Provider to fetch a single delivery order by ID
final deliveryOrderByIdProvider =
    FutureProvider.family<DeliveryOrder?, String>((ref, orderId) async {
  final client = ref.watch(supabaseClientProvider);
  final result = await client
      .from('delivery_orders')
      .select()
      .eq('id', orderId)
      .maybeSingle();
  if (result == null) return null;
  return DeliveryOrder.fromJson(result);
});

/// Order confirmation page shown after successful payment
class OrderConfirmationPage extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(deliveryOrderByIdProvider(orderId));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: orderAsync.when(
                  data: (order) {
                    if (order == null) return _buildContent(context, null, null);
                    final tenantAsync =
                        ref.watch(restaurantDetailProvider(order.tenantId));
                    return _buildContent(
                      context,
                      order,
                      tenantAsync.valueOrNull == null
                          ? null
                          : _formatEta(order, tenantAsync.valueOrNull!),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _buildContent(context, null, null),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatEta(DeliveryOrder order, Tenant tenant) {
    final double? distanceKm = (order.deliveryLatitude != null &&
            order.deliveryLongitude != null &&
            tenant.hasCoordinates)
        ? haversineKm(
            tenant.latitude!,
            tenant.longitude!,
            order.deliveryLatitude!,
            order.deliveryLongitude!,
          )
        : null;
    return tenant.formatEstimatedTotal(distanceKm);
  }

  Widget _buildContent(BuildContext context, DeliveryOrder? order, String? eta) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 60,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Text(
          l.orderConfirmedTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),

        Text(
          l.orderConfirmedSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Order details card
        if (order != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.receipt_long,
                    label: l.orderConfirmedOrder,
                    value: '#${order.id.substring(0, 8).toUpperCase()}',
                  ),
                  const Divider(height: AppSpacing.lg),
                  _DetailRow(
                    icon: Icons.euro,
                    label: l.orderConfirmedTotal,
                    value: '\u20ac ${order.total.toStringAsFixed(2)}',
                  ),
                  const Divider(height: AppSpacing.lg),
                  if (eta != null) ...[
                    _DetailRow(
                      icon: Icons.access_time,
                      label: l.orderConfirmedEta,
                      value: eta,
                    ),
                    const Divider(height: AppSpacing.lg),
                  ],
                  _DetailRow(
                    icon: Icons.location_on,
                    label: l.orderConfirmedDelivery,
                    value: order.deliveryFullAddress,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _DetailRow(
                    icon: Icons.info_outline,
                    label: l.orderConfirmedStatus,
                    value: localizedOrderStatus(context, order.status),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.xl),

        // Action buttons
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.go('/consumer/orders'),
            icon: const Icon(Icons.list_alt),
            label: Text(l.orderConfirmedSeeOrders),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/marketplace'),
            icon: const Icon(Icons.storefront),
            label: Text(l.orderConfirmedBackToMarketplace),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
