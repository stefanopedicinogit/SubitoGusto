import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import 'delivery_cart_provider.dart';

/// Bottom sheet showing the delivery cart
class DeliveryCartSheet extends ConsumerWidget {
  const DeliveryCartSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(deliveryCartProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Il tuo ordine',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (cart.restaurantName != null)
                        Text(
                          cart.restaurantName!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                    ],
                  ),
                ),
                if (cart.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.read(deliveryCartProvider.notifier).clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Svuota',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Items
          if (cart.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Il carrello è vuoto',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          else ...[
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _CartItemTile(
                    item: item,
                    onQuantityChanged: (qty) {
                      ref
                          .read(deliveryCartProvider.notifier)
                          .updateQuantity(index, qty);
                    },
                    onRemove: () {
                      ref.read(deliveryCartProvider.notifier).removeItem(index);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // Totals
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _TotalRow(
                    label: 'Subtotale',
                    value: cart.formatSubtotal(),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _TotalRow(
                    label: 'Consegna',
                    value: cart.formatDeliveryFee(),
                  ),
                  const Divider(height: AppSpacing.lg),
                  _TotalRow(
                    label: 'Totale',
                    value: cart.formatTotal(),
                    isBold: true,
                  ),
                  if (!cart.meetsMinOrder) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Mancano € ${cart.amountToMinOrder.toStringAsFixed(2)} per l\'ordine minimo',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: cart.meetsMinOrder
                          ? () {
                              Navigator.of(context).pop();
                              context.go('/checkout');
                            }
                          : null,
                      icon: const Icon(Icons.payment),
                      label: Text(
                        'Vai al pagamento - ${cart.formatTotal()}',
                      ),
                      style: FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final DeliveryCartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quantity controls
          Column(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () => onQuantityChanged(item.quantity + 1),
                  icon: const Icon(Icons.add, size: 16),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () {
                    if (item.quantity <= 1) {
                      onRemove();
                    } else {
                      onQuantityChanged(item.quantity - 1);
                    }
                  },
                  icon: Icon(
                    item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
                    size: 16,
                    color: item.quantity <= 1 ? AppColors.error : null,
                  ),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: item.quantity <= 1
                          ? AppColors.error.withValues(alpha: 0.5)
                          : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (item.notes != null)
                  Text(
                    item.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          // Price
          Text(
            '€ ${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _TotalRow({
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
