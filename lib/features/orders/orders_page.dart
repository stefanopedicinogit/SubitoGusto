import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use stream for realtime updates
    final ordersAsync = ref.watch(ordersStreamProvider);

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
                  }
                });
              },
              tabs: const [
                Tab(text: 'Tutti'),
                Tab(text: 'In Attesa'),
                Tab(text: 'In Preparazione'),
                Tab(text: 'Pronti'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Orders grid
          Expanded(
            child: ordersAsync.when(
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
            ),
          ),
        ],
      ),
    );
  }
}

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

      // Add timestamp for specific status changes
      if (newStatus == 'confirmed') {
        updates['confirmed_at'] = DateTime.now().toIso8601String();
      } else if (newStatus == 'served' || newStatus == 'cancelled') {
        updates['completed_at'] = DateTime.now().toIso8601String();
      }

      await Supabase.instance.client
          .from('orders')
          .update(updates)
          .eq('id', widget.order.id);

      // Invalidate orders stream to refresh data
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
