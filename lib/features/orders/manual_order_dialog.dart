import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/order.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';

/// Dialog for staff to create manual orders
class ManualOrderDialog extends ConsumerStatefulWidget {
  const ManualOrderDialog({super.key});

  @override
  ConsumerState<ManualOrderDialog> createState() => _ManualOrderDialogState();
}

class _ManualOrderDialogState extends ConsumerState<ManualOrderDialog> {
  RestaurantTable? _selectedTable;
  final List<_OrderLineItem> _items = [];
  final _customerNameController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  double get _total => _items.fold(0, (sum, item) => sum + item.total);

  @override
  void dispose() {
    _customerNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_selectedTable == null || _items.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final client = Supabase.instance.client;

      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      // Create order
      final orderResponse = await client.from('orders').insert({
        'tenant_id': _selectedTable!.tenantId,
        'table_id': _selectedTable!.id,
        'order_number': orderNumber,
        'status': 'confirmed', // Staff orders are auto-confirmed
        'subtotal': _total,
        'discount': 0,
        'total': _total,
        'customer_name': _customerNameController.text.trim().isEmpty
            ? null
            : _customerNameController.text.trim(),
        'notes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      }).select().single();

      final createdOrder = Order.fromJson(orderResponse);

      // Create order items
      final orderItems = _items.map((item) => {
        'order_id': createdOrder.id,
        'menu_item_id': item.menuItem.id,
        'menu_item_name': item.menuItem.name,
        'unit_price': item.menuItem.price,
        'quantity': item.quantity,
        'notes': item.notes,
        'status': 'pending',
      }).toList();

      await client.from('order_items').insert(orderItems);

      // Update table status to occupied
      await client
          .from('tables')
          .update({'status': 'occupied'})
          .eq('id', _selectedTable!.id);

      // Invalidate providers
      ref.invalidate(ordersStreamProvider);
      ref.invalidate(tablesStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ordine $orderNumber creato'),
            backgroundColor: AppColors.success,
          ),
        );
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

  void _addItem(MenuItem menuItem) {
    setState(() {
      final existingIndex = _items.indexWhere((i) => i.menuItem.id == menuItem.id);
      if (existingIndex >= 0) {
        _items[existingIndex].quantity++;
      } else {
        _items.add(_OrderLineItem(menuItem: menuItem));
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider);
    final menuItemsAsync = ref.watch(menuItemsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Nuovo Ordine Manuale',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Menu items
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seleziona Piatti',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: menuItemsAsync.when(
                            data: (items) {
                              final activeItems = items.where((i) => i.isActive && i.isAvailable).toList();
                              return categoriesAsync.when(
                                data: (categories) {
                                  return DefaultTabController(
                                    length: categories.length,
                                    child: Column(
                                      children: [
                                        TabBar(
                                          isScrollable: true,
                                          tabs: categories.map((c) => Tab(text: c.name)).toList(),
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            children: categories.map((category) {
                                              final categoryItems = activeItems
                                                  .where((i) => i.categoryId == category.id)
                                                  .toList();
                                              return ListView.builder(
                                                padding: const EdgeInsets.all(AppSpacing.sm),
                                                itemCount: categoryItems.length,
                                                itemBuilder: (context, index) {
                                                  final item = categoryItems[index];
                                                  return Card(
                                                    child: ListTile(
                                                      leading: item.imageUrl != null
                                                          ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(AppRadius.sm),
                                                              child: Image.network(
                                                                item.imageUrl!,
                                                                width: 48,
                                                                height: 48,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 48,
                                                              height: 48,
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context).scaffoldBackgroundColor,
                                                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                                              ),
                                                              child: const Icon(Icons.restaurant),
                                                            ),
                                                      title: Text(item.name),
                                                      subtitle: Text(item.formatPrice()),
                                                      trailing: IconButton(
                                                        icon: const Icon(Icons.add_circle),
                                                        color: Theme.of(context).colorScheme.primary,
                                                        onPressed: () => _addItem(item),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => Center(child: Text('Errore: $e')),
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Errore: $e')),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Right: Order summary
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riepilogo Ordine',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Table selector
                          tablesAsync.when(
                            data: (tables) {
                              final availableTables = tables.where((t) => t.isActive).toList();
                              return DropdownButtonFormField<RestaurantTable>(
                                value: _selectedTable,
                                decoration: const InputDecoration(
                                  labelText: 'Tavolo *',
                                  prefixIcon: Icon(Icons.table_restaurant),
                                ),
                                items: availableTables.map((table) {
                                  return DropdownMenuItem(
                                    value: table,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: table.status == 'available'
                                                ? AppColors.success
                                                : table.status == 'occupied'
                                                    ? AppColors.error
                                                    : AppColors.warning,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(table.name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (table) {
                                  setState(() => _selectedTable = table);
                                },
                              );
                            },
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) => Text('Errore: $e'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Customer name
                          TextField(
                            controller: _customerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Cliente (opzionale)',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Items list
                          Expanded(
                            child: _items.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nessun piatto selezionato',
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _items.length,
                                    itemBuilder: (context, index) {
                                      final item = _items[index];
                                      return ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                          child: Text(
                                            '${item.quantity}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item.menuItem.name,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          '${item.total.toStringAsFixed(2)} EUR',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                                          onPressed: () => _removeItem(index),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const Divider(),
                          // Notes
                          TextField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Note ordine',
                              prefixIcon: Icon(Icons.note),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Totale',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '${_total.toStringAsFixed(2)} EUR',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            child: FilledButton.icon(
                              onPressed: _selectedTable == null || _items.isEmpty || _isSubmitting
                                  ? null
                                  : _submitOrder,
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check),
                              label: Text(_isSubmitting ? 'Creazione...' : 'Crea Ordine'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderLineItem {
  final MenuItem menuItem;
  int quantity;
  String? notes;

  _OrderLineItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  double get total => menuItem.price * quantity;
}
