import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/order.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import '../../l10n/generated/app_localizations.dart';

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
  int get _totalQty => _items.fold(0, (sum, item) => sum + item.quantity);

  @override
  void dispose() {
    _customerNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_selectedTable == null || _items.isEmpty) return;

    setState(() => _isSubmitting = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

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
        navigator.pop(true);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Ordine $orderNumber creato'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
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
    if (Responsive.isMobile(context)) {
      return _buildMobile(context);
    }
    return _buildDesktop(context);
  }

  // -------------------- Desktop layout --------------------

  Widget _buildDesktop(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final dialogWidth = screen.width < 940 ? screen.width * 0.95 : 900.0;
    final dialogHeight = screen.height < 740 ? screen.height * 0.95 : 700.0;

    return Dialog(
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
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
                  AppLocalizations.of(context).manualOrderTitle,
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
                          AppLocalizations.of(context).manualOrderSelectItems,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(child: _buildMenuSection(context)),
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
                            AppLocalizations.of(context).checkoutSummary,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildTableSelector(context),
                          const SizedBox(height: AppSpacing.md),
                          _buildCustomerField(context),
                          const SizedBox(height: AppSpacing.md),
                          Expanded(child: _buildCartItemsList(context, shrinkWrap: false)),
                          const Divider(),
                          _buildNotesField(context),
                          const SizedBox(height: AppSpacing.md),
                          _buildTotalRow(context),
                          const SizedBox(height: AppSpacing.md),
                          _buildSubmitButton(context),
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

  // -------------------- Mobile layout --------------------

  Widget _buildMobile(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog.fullscreen(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(l10n.manualOrderTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.restaurant_menu),
                  text: l10n.manualOrderSelectItems,
                ),
                Tab(
                  icon: Badge(
                    isLabelVisible: _totalQty > 0,
                    label: Text('$_totalQty'),
                    backgroundColor: colorScheme.primary,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  text: l10n.checkoutSummary,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildMenuSection(context),
              _buildMobileCartTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCartTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableSelector(context),
                const SizedBox(height: AppSpacing.md),
                _buildCustomerField(context),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppLocalizations.of(context).manualOrderSelectItems,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildCartItemsList(context, shrinkWrap: true),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                _buildNotesField(context),
              ],
            ),
          ),
        ),
        // Sticky bottom bar with total + submit
        Material(
          elevation: 8,
          color: Theme.of(context).cardColor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTotalRow(context),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------- Shared building blocks --------------------

  Widget _buildMenuSection(BuildContext context) {
    final menuItemsAsync = ref.watch(menuItemsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return menuItemsAsync.when(
      data: (items) {
        final activeItems = items.where((i) => i.isActive && i.isAvailable).toList();
        return categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context).menuMgmtEmptyCategories),
              );
            }
            return DefaultTabController(
              key: ValueKey('tabs-${categories.length}-${categories.first.id}'),
              length: categories.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: categories.map((c) => Tab(text: c.name)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: categories.map((category) {
                        final categoryItems = activeItems
                            .where((i) => i.categoryId == category.id)
                            .toList();
                        if (categoryItems.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context).menuMgmtEmptyCategories,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          itemCount: categoryItems.length,
                          itemBuilder: (context, index) {
                            return _buildMenuItemCard(context, categoryItems[index]);
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
    );
  }

  Widget _buildMenuItemCard(BuildContext context, MenuItem item) {
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
  }

  Widget _buildTableSelector(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider);
    return tablesAsync.when(
      data: (tables) {
        final availableTables = tables.where((t) => t.isActive).toList();
        return DropdownButtonFormField<RestaurantTable>(
          value: _selectedTable,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).manualOrderTable,
            prefixIcon: const Icon(Icons.table_restaurant),
          ),
          selectedItemBuilder: (context) => availableTables.map((table) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                table.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
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
                  Expanded(
                    child: Text(
                      table.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
    );
  }

  Widget _buildCustomerField(BuildContext context) {
    return TextField(
      controller: _customerNameController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).manualOrderCustomer,
        prefixIcon: const Icon(Icons.person),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).orderDetailNotes,
        prefixIcon: const Icon(Icons.note),
      ),
      maxLines: 2,
    );
  }

  Widget _buildCartItemsList(BuildContext context, {required bool shrinkWrap}) {
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: Text(
            AppLocalizations.of(context).manualOrderEmptyCart,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 14,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
    );
  }

  Widget _buildTotalRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context).checkoutTotal,
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
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
        label: Text(_isSubmitting
            ? AppLocalizations.of(context).checkoutProcessing
            : AppLocalizations.of(context).manualOrderSubmit),
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
