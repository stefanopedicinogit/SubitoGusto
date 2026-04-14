import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/models/delivery_order.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import 'order_detail_dialog.dart';

/// Orders page for mobile
class OrdersPageMobile extends ConsumerStatefulWidget {
  const OrdersPageMobile({super.key});

  @override
  ConsumerState<OrdersPageMobile> createState() => _OrdersPageMobileState();
}

class _OrdersPageMobileState extends ConsumerState<OrdersPageMobile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryOrdersAsync = ref.watch(staffDeliveryOrdersStreamProvider);

    return Column(
      children: [
        // Tabs: Sala / Consegne
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Sala'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delivery_dining, size: 18),
                    const SizedBox(width: 6),
                    const Text('Consegne'),
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _DineInOrdersList(),
              _DeliveryOrdersList(),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Dine-in orders list (existing logic)
// =============================================================================

class _DineInOrdersList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersStreamProvider);
    final ordersAsync = ordersStream.whenData(
      (orders) => orders.where((o) => o.isActive).toList(),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ordersStreamProvider);
      },
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nessun ordine attivo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCardMobile(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}

// =============================================================================
// Delivery orders list (new)
// =============================================================================

class _DeliveryOrdersList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryAsync = ref.watch(staffDeliveryOrdersStreamProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(staffDeliveryOrdersStreamProvider);
      },
      child: deliveryAsync.when(
        data: (orders) {
          final activeOrders = orders.where((o) => o.isActive).toList();
          final completedOrders = orders
              .where((o) => o.isDelivered || o.isCancelled || o.isRefunded)
              .take(10)
              .toList();

          if (activeOrders.isEmpty && completedOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delivery_dining,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nessun ordine delivery',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (activeOrders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Ordini attivi',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...activeOrders
                    .map((o) => _DeliveryOrderCardMobile(order: o)),
              ],
              if (completedOrders.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Completati di recente',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                ...completedOrders
                    .map((o) => _DeliveryOrderCardMobile(order: o)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}

// =============================================================================
// Dine-in order card (existing)
// =============================================================================

class _OrderCardMobile extends ConsumerStatefulWidget {
  final Order order;

  const _OrderCardMobile({required this.order});

  @override
  ConsumerState<_OrderCardMobile> createState() => _OrderCardMobileState();
}

class _OrderCardMobileState extends ConsumerState<_OrderCardMobile> {
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
      ref.invalidate(activeOrdersProvider);

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
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
                  const Icon(
                    Icons.table_restaurant,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    tableName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
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
                          visualDensity: VisualDensity.compact,
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
// Delivery order card mobile (new)
// =============================================================================

class _DeliveryOrderCardMobile extends ConsumerStatefulWidget {
  final DeliveryOrder order;

  const _DeliveryOrderCardMobile({required this.order});

  @override
  ConsumerState<_DeliveryOrderCardMobile> createState() =>
      _DeliveryOrderCardMobileState();
}

class _DeliveryOrderCardMobileState
    extends ConsumerState<_DeliveryOrderCardMobile> {
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
    final isCompleted =
        order.isDelivered || order.isCancelled || order.isRefunded;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
                const Icon(Icons.location_on,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryFullAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (order.notes != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.notes,
                      size: 14, color: AppColors.textSecondary),
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
            // Payment + total
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  order.isPaid ? Icons.check_circle : Icons.pending,
                  size: 14,
                  color:
                      order.isPaid ? AppColors.success : AppColors.statusPending,
                ),
                const SizedBox(width: 4),
                Text(
                  order.isPaid ? 'Pagato' : 'In attesa',
                  style: TextStyle(
                    fontSize: 12,
                    color: order.isPaid
                        ? AppColors.success
                        : AppColors.statusPending,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  order.formatTotal(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            // Actions
            if (!isCompleted) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order.isPending || order.isConfirmed)
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.error),
                      onPressed: _isLoading ? null : _cancelDeliveryOrder,
                      tooltip: 'Annulla',
                      visualDensity: VisualDensity.compact,
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
