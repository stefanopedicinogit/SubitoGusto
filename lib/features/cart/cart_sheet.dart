import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/order.dart';
import '../../data/providers/supabase_provider.dart';
import '../../l10n/generated/app_localizations.dart';
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
    if (cart.isEmpty || cart.tableId == null || cart.tenantId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final client = Supabase.instance.client;

      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      // If the diner is signed in as a consumer, link the order to their
      // customer profile so it shows up in their order history.
      final auth = ref.read(supabaseAuthProvider).valueOrNull;
      final consumerId =
          (auth?.isAuthenticated == true && auth?.isConsumer == true)
              ? auth?.user?.id
              : null;

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
        if (consumerId != null) 'customer_id': consumerId,
      }).select().single();

      final createdOrder = Order.fromJson(orderResponse);

      // Create order items (regular + fixed menus)
      final orderItems = <Map<String, dynamic>>[];

      // Regular items
      for (final cartItem in cart.items) {
        orderItems.add({
          'order_id': createdOrder.id,
          'menu_item_id': cartItem.menuItem.id,
          'menu_item_name': cartItem.menuItem.name,
          'unit_price': cartItem.menuItem.price,
          'quantity': cartItem.quantity,
          'notes': cartItem.notes,
          'status': 'pending',
        });
      }

      // Fixed menu items (menu_item_id is null, fixed_menu_id is set)
      for (final fixedItem in cart.fixedMenuItems) {
        final selectionSummary = fixedItem.selection.selections.values
            .map((s) => s.choiceName)
            .join(', ');
        orderItems.add({
          'order_id': createdOrder.id,
          'menu_item_name': fixedItem.selection.fixedMenuName,
          'unit_price': fixedItem.selection.totalPrice,
          'quantity': fixedItem.quantity,
          'notes': fixedItem.notes ?? selectionSummary,
          'status': 'pending',
          'fixed_menu_id': fixedItem.selection.fixedMenuId,
          'fixed_menu_selections': fixedItem.selection.toJson(),
        });
      }

      if (orderItems.isNotEmpty) {
        await client.from('order_items').insert(orderItems);
      }

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
            content: Text(humanizeError(e, context)),
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
      builder: (context) {
        final l = AppLocalizations.of(context);
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
          title: Text(l.cartOrderSubmittedTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.cartOrderSubmittedMessage(order.orderNumber),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.cartOrderSubmittedTotal(order.formatTotal()),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.cartOrderSubmittedFooter,
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
              child: Text(l.cartOk),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final l = AppLocalizations.of(context);

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
                      l.cartTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    if (cart.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clear();
                        },
                        child: Text(l.cartClear),
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
                        itemCount: cart.items.length +
                            cart.fixedMenuItems.length +
                            1, // +1 for name field
                        itemBuilder: (context, index) {
                          // Regular items first
                          if (index < cart.items.length) {
                            return _CartItemTile(
                              item: cart.items[index],
                              index: index,
                            );
                          }
                          // Then fixed menu items
                          final fixedIndex = index - cart.items.length;
                          if (fixedIndex < cart.fixedMenuItems.length) {
                            return _FixedMenuCartItemTile(
                              item: cart.fixedMenuItems[fixedIndex],
                              index: fixedIndex,
                            );
                          }
                          // Last: name field
                          return _buildCustomerNameField();
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
    final l = AppLocalizations.of(context);
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
            l.cartEmpty,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.cartEmptyHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerNameField() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.cartCustomerNameLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            onChanged: (value) => _customerName = value.isEmpty ? null : value,
            decoration: InputDecoration(
              hintText: l.cartCustomerNameHint,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartState cart) {
    final l = AppLocalizations.of(context);
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
                  l.checkoutTotal,
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
                    : Text(
                        l.cartSubmit,
                        style: const TextStyle(
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

class _FixedMenuCartItemTile extends ConsumerWidget {
  final FixedMenuCartItem item;
  final int index;

  const _FixedMenuCartItemTile({
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
            // Icon for fixed menu
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                width: 60,
                height: 60,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).colorScheme.primary,
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
                    item.selection.fixedMenuName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (item.notes != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 3,
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
                          .updateFixedMenuQuantity(index, item.quantity - 1);
                    } else {
                      ref.read(cartProvider.notifier).removeFixedMenu(index);
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
                        .updateFixedMenuQuantity(index, item.quantity + 1);
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
