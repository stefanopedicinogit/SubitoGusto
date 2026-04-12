import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import 'cart_provider.dart';

/// Cart bottom sheet for reviewing and submitting order
class CartSheet extends ConsumerStatefulWidget {
  const CartSheet({super.key});

  @override
  ConsumerState<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends ConsumerState<CartSheet> {
  bool _isSubmitting = false;
  String? _customerName;

  Future<void> _submitOrder() async {
    final cart = ref.read(cartProvider);
    if (cart.items.isEmpty || cart.tableId == null || cart.tenantId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final client = Supabase.instance.client;

      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      // Create order directly with Supabase to avoid empty ID issues
      final orderResponse = await client.from('orders').insert({
        'tenant_id': cart.tenantId,
        'table_id': cart.tableId,
        'order_number': orderNumber,
        'status': 'pending',
        'subtotal': cart.subtotal,
        'discount': 0,
        'total': cart.subtotal,
        'customer_name': _customerName,
      }).select().single();

      final createdOrder = Order.fromJson(orderResponse);

      // Create order items
      final orderItems = cart.items.map((cartItem) => {
        'order_id': createdOrder.id,
        'menu_item_id': cartItem.menuItem.id,
        'menu_item_name': cartItem.menuItem.name,
        'unit_price': cartItem.menuItem.price,
        'quantity': cartItem.quantity,
        'notes': cartItem.notes,
        'status': 'pending',
      }).toList();

      await client.from('order_items').insert(orderItems);

      // Clear cart
      ref.read(cartProvider.notifier).clear();

      if (mounted) {
        Navigator.of(context).pop();
        _showOrderConfirmation(createdOrder);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showOrderConfirmation(Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
        title: const Text('Ordine Inviato!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Il tuo ordine #${order.orderNumber} e stato ricevuto.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Totale: ${order.formatTotal()}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Riceverai il tuo ordine a breve.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Il tuo ordine',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    if (cart.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clear();
                        },
                        child: const Text('Svuota'),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: cart.isEmpty
                    ? _buildEmptyCart()
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: cart.items.length + 1, // +1 for name field
                        itemBuilder: (context, index) {
                          if (index == cart.items.length) {
                            return _buildCustomerNameField();
                          }
                          return _CartItemTile(
                            item: cart.items[index],
                            index: index,
                          );
                        },
                      ),
              ),
              // Bottom bar
              if (cart.isNotEmpty) _buildBottomBar(cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Il carrello e vuoto',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aggiungi piatti dal menu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Il tuo nome (opzionale)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            onChanged: (value) => _customerName = value.isEmpty ? null : value,
            decoration: const InputDecoration(
              hintText: 'Per facilitare la consegna',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Totale',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  cart.formatSubtotal(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Invia Ordine',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItem item;
  final int index;

  const _CartItemTile({
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                width: 60,
                height: 60,
                child: item.menuItem.imageUrl != null
                    ? Image.network(
                        item.menuItem.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppColors.cream,
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.menuItem.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.notes != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.formatTotalPrice(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (item.quantity > 1) {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(index, item.quantity - 1);
                    } else {
                      ref.read(cartProvider.notifier).removeItem(index);
                    }
                  },
                  visualDensity: VisualDensity.compact,
                  color: AppColors.textSecondary,
                ),
                Text(
                  '${item.quantity}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(index, item.quantity + 1);
                  },
                  visualDensity: VisualDensity.compact,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
