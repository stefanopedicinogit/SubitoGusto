import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/models/delivery_order.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import 'order_detail_dialog.dart';

/// Orders management page for desktop
class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersStreamProvider);
    final deliveryOrdersAsync = ref.watch(staffDeliveryOrdersStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter tabs
          Card(
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  switch (index) {
                    case 0:
                      _selectedStatus = 'all';
                      break;
                    case 1:
                      _selectedStatus = 'pending';
                      break;
                    case 2:
                      _selectedStatus = 'preparing';
                      break;
                    case 3:
                      _selectedStatus = 'ready';
                      break;
                    case 4:
                      _selectedStatus = 'delivery';
                      break;
                  }
                });
              },
              tabs: [
                const Tab(text: 'Tutti'),
                const Tab(text: 'In Attesa'),
                const Tab(text: 'In Preparazione'),
                const Tab(text: 'Pronti'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delivery_dining, size: 18),
                      const SizedBox(width: 6),
                      const Text('Consegne'),
                      // Active delivery orders badge
                      deliveryOrdersAsync.when(
                        data: (orders) {
                          final active = orders.where((o) => o.isActive).length;
                          if (active == 0) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.burgundy,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$active',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Content
          Expanded(
            child: _selectedStatus == 'delivery'
                ? _buildDeliveryOrders(deliveryOrdersAsync)
                : _buildDineInOrders(ordersAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildDineInOrders(AsyncValue<List<Order>> ordersAsync) {
    return ordersAsync.when(
      data: (orders) {
        final filteredOrders = _selectedStatus == 'all'
            ? orders.where((o) => o.isActive).toList()
            : orders.where((o) => o.status == _selectedStatus).toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nessun ordine trovato',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
          ),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return _OrderCard(order: order);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Errore: $e')),
    );
  }

  Widget _buildDeliveryOrders(AsyncValue<List<DeliveryOrder>> deliveryOrdersAsync) {
    return deliveryOrdersAsync.when(
      data: (orders) {
        final activeOrders = orders.where((o) => o.isActive).toList();
        final completedOrders = orders
            .where((o) => o.isDelivered || o.isCancelled || o.isRefunded)
            .take(20)
            .toList();

        if (activeOrders.isEmpty && completedOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 80,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nessun ordine delivery',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeOrders.isNotEmpty) ...[
                Text(
                  'Ordini attivi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) =>
                      _DeliveryOrderCard(order: activeOrders[index]),
                ),
              ],
              if (completedOrders.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Completati di recente',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: completedOrders.length,
                  itemBuilder: (context, index) =>
                      _DeliveryOrderCard(order: completedOrders[index]),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Errore: $e')),
    );
  }
}

// =============================================================================
// Dine-in Order Card (existing)
// =============================================================================

class _OrderCard extends ConsumerStatefulWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  ConsumerState<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<_OrderCard> {
  bool _isLoading = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      final updates = <String, dynamic>{
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (newStatus == 'confirmed') {
        updates['confirmed_at'] = DateTime.now().toIso8601String();
      } else if (newStatus == 'served' || newStatus == 'cancelled') {
        updates['completed_at'] = DateTime.now().toIso8601String();
      }

      await Supabase.instance.client
          .from('orders')
          .update(updates)
          .eq('id', widget.order.id);

      ref.invalidate(ordersStreamProvider);
      ref.invalidate(ordersProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ordine ${_getStatusLabel(newStatus)}'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annulla Ordine'),
        content: Text('Sei sicuro di voler annullare l\'ordine ${widget.order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sì, Annulla'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateStatus('cancelled');
    }
  }

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return 'confirmed';
      case 'confirmed':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'served';
      default:
        return currentStatus;
    }
  }

  String _getNextActionText(String status) {
    switch (status) {
      case 'pending':
        return 'Conferma';
      case 'confirmed':
        return 'Prepara';
      case 'preparing':
        return 'Pronto';
      case 'ready':
        return 'Servito';
      default:
        return 'Azione';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'confermato';
      case 'preparing':
        return 'in preparazione';
      case 'ready':
        return 'pronto';
      case 'served':
        return 'servito';
      case 'cancelled':
        return 'annullato';
      default:
        return status;
    }
  }

  String _getTableName(List<RestaurantTable> tables) {
    for (final t in tables) {
      if (t.id == widget.order.tableId) {
        return t.name;
      }
    }
    return 'Tavolo -';
  }

  void _openDetails() {
    showDialog(
      context: context,
      builder: (context) => OrderDetailDialog(order: widget.order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final tablesStream = ref.watch(tablesStreamProvider);

    final tableName = tablesStream.when(
      data: (tables) => _getTableName(tables),
      loading: () => 'Caricamento...',
      error: (_, __) => 'Tavolo -',
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openDetails,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderNumber,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  _StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.table_restaurant, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    tableName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.formatTotal(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      if (order.canBeCancelled)
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: _isLoading ? null : _cancelOrder,
                          tooltip: 'Annulla',
                        ),
                      const SizedBox(width: AppSpacing.xs),
                      FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () => _updateStatus(_getNextStatus(order.status)),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_getNextActionText(order.status)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Delivery Order Card (new)
// =============================================================================

class _DeliveryOrderCard extends ConsumerStatefulWidget {
  final DeliveryOrder order;

  const _DeliveryOrderCard({required this.order});

  @override
  ConsumerState<_DeliveryOrderCard> createState() => _DeliveryOrderCardState();
}

class _DeliveryOrderCardState extends ConsumerState<_DeliveryOrderCard> {
  bool _isLoading = false;

  Future<void> _updateDeliveryStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      final updates = <String, dynamic>{
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (newStatus == 'confirmed') {
        updates['confirmed_at'] = DateTime.now().toIso8601String();
      } else if (newStatus == 'delivered') {
        updates['delivered_at'] = DateTime.now().toIso8601String();
      }

      await Supabase.instance.client
          .from('delivery_orders')
          .update(updates)
          .eq('id', widget.order.id);

      ref.invalidate(staffDeliveryOrdersStreamProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ordine ${_deliveryStatusLabel(newStatus)}'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelDeliveryOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annulla Ordine Delivery'),
        content: Text(
            'Sei sicuro di voler annullare l\'ordine #${widget.order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sì, Annulla'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateDeliveryStatus('cancelled');
    }
  }

  String _getNextDeliveryStatus(String current) {
    switch (current) {
      case 'pending':
        return 'confirmed';
      case 'confirmed':
        return 'preparing';
      case 'preparing':
        return 'ready_for_delivery';
      case 'ready_for_delivery':
        return 'out_for_delivery';
      case 'out_for_delivery':
        return 'delivered';
      default:
        return current;
    }
  }

  String _getNextDeliveryActionText(String status) {
    switch (status) {
      case 'pending':
        return 'Conferma';
      case 'confirmed':
        return 'Prepara';
      case 'preparing':
        return 'Pronto';
      case 'ready_for_delivery':
        return 'In consegna';
      case 'out_for_delivery':
        return 'Consegnato';
      default:
        return 'Azione';
    }
  }

  String _deliveryStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'confermato';
      case 'preparing':
        return 'in preparazione';
      case 'ready_for_delivery':
        return 'pronto per la consegna';
      case 'out_for_delivery':
        return 'in consegna';
      case 'delivered':
        return 'consegnato';
      case 'cancelled':
        return 'annullato';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isCompleted = order.isDelivered || order.isCancelled || order.isRefunded;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.delivery_dining,
                        size: 18, color: AppColors.burgundy),
                    const SizedBox(width: 6),
                    Text(
                      '#${order.orderNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                _DeliveryStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Address
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryFullAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (order.deliveryNotes != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      order.deliveryNotes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (order.notes != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.notes, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.notes!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            // Payment status
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  order.isPaid ? Icons.check_circle : Icons.pending,
                  size: 14,
                  color: order.isPaid ? AppColors.success : AppColors.statusPending,
                ),
                const SizedBox(width: 4),
                Text(
                  order.isPaid ? 'Pagato' : 'Pagamento in attesa',
                  style: TextStyle(
                    fontSize: 12,
                    color: order.isPaid ? AppColors.success : AppColors.statusPending,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Divider(),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.formatTotal(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (!isCompleted)
                  Row(
                    children: [
                      if (order.isPending || order.isConfirmed)
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: _isLoading ? null : _cancelDeliveryOrder,
                          tooltip: 'Annulla',
                        ),
                      const SizedBox(width: AppSpacing.xs),
                      FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () => _updateDeliveryStatus(
                                _getNextDeliveryStatus(order.status)),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_getNextDeliveryActionText(order.status)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Status Chips
// =============================================================================

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        _getLabel(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getColor(),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'preparing':
        return AppColors.statusPreparing;
      case 'ready':
        return AppColors.statusReady;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getLabel() {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'confirmed':
        return 'Confermato';
      case 'preparing':
        return 'In preparazione';
      case 'ready':
        return 'Pronto';
      default:
        return status;
    }
  }
}

class _DeliveryStatusChip extends StatelessWidget {
  final String status;

  const _DeliveryStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        _getLabel(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getColor(),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'preparing':
        return AppColors.statusPreparing;
      case 'ready_for_delivery':
        return AppColors.statusReady;
      case 'out_for_delivery':
        return AppColors.burgundy;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
      case 'refunded':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getLabel() {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'confirmed':
        return 'Confermato';
      case 'preparing':
        return 'In preparazione';
      case 'ready_for_delivery':
        return 'Pronto';
      case 'out_for_delivery':
        return 'In consegna';
      case 'delivered':
        return 'Consegnato';
      case 'cancelled':
        return 'Annullato';
      case 'refunded':
        return 'Rimborsato';
      default:
        return status;
    }
  }
}
