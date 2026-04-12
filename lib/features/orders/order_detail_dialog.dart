import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/models/order_item.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';

/// Dialog to show order details with items
class OrderDetailDialog extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailDialog({super.key, required this.order});

  @override
  ConsumerState<OrderDetailDialog> createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends ConsumerState<OrderDetailDialog> {
  bool _isLoading = false;
  List<OrderItem> _items = [];
  RestaurantTable? _table;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Load order items
      final itemsResponse = await Supabase.instance.client
          .from('order_items')
          .select()
          .eq('order_id', widget.order.id)
          .order('created_at');

      _items = (itemsResponse as List)
          .map((json) => OrderItem.fromJson(json))
          .toList();

      // Load table info
      final tableResponse = await Supabase.instance.client
          .from('tables')
          .select()
          .eq('id', widget.order.tableId)
          .maybeSingle();

      if (tableResponse != null) {
        _table = RestaurantTable.fromJson(tableResponse);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore caricamento: $e'),
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

      if (mounted) {
        Navigator.of(context).pop(true);
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
        setState(() => _isLoading = false);
      }
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
        return 'Conferma Ordine';
      case 'confirmed':
        return 'Inizia Preparazione';
      case 'preparing':
        return 'Segna come Pronto';
      case 'ready':
        return 'Segna come Servito';
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

  Color _getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.table_restaurant,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _table?.name ?? 'Caricamento...',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: _getStatusColor(order.status),
                      ),
                    ),
                    child: Text(
                      order.statusDisplayName,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: _isLoading && _items.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _items.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.xl),
                            child: Text('Nessun piatto nell\'ordine'),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final primaryColor = Theme.of(context).colorScheme.primary;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                    primaryColor.withValues(alpha: 0.1),
                                child: Text(
                                  '${item.quantity}x',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                item.menuItemName,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: item.notes != null && item.notes!.isNotEmpty
                                  ? Text(
                                      item.notes!,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : null,
                              trailing: Text(
                                item.formatTotalPrice(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          },
                        ),
            ),
            // Footer with total and actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Column(
                children: [
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Totale',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        order.formatTotal(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (order.notes != null && order.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.note, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              order.notes!,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  // Actions
                  Row(
                    children: [
                      if (order.canBeCancelled)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Annulla Ordine'),
                                        content: const Text(
                                            'Sei sicuro di voler annullare questo ordine?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(false),
                                            child: const Text('No'),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: AppColors.error,
                                            ),
                                            child: const Text('Sì, Annulla'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await _updateStatus('cancelled');
                                    }
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            child: const Text('Annulla'),
                          ),
                        ),
                      if (order.canBeCancelled)
                        const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _isLoading || order.status == 'served'
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
                      ),
                    ],
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
