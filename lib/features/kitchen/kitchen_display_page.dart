import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/models/order_item.dart';
import '../../data/providers/providers.dart';

/// Kitchen Display Page - Fullscreen view optimized for kitchen monitors
class KitchenDisplayPage extends ConsumerStatefulWidget {
  const KitchenDisplayPage({super.key});

  @override
  ConsumerState<KitchenDisplayPage> createState() => _KitchenDisplayPageState();
}

class _KitchenDisplayPageState extends ConsumerState<KitchenDisplayPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Set<String> _knownOrderIds = {};
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh UI every 30 seconds to update time displays
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _playNewOrderSound() async {
    try {
      final settings = ref.read(settingsProvider);
      if (settings.soundAlerts) {
        await _audioPlayer.play(AssetSource('sounds/notification_1.wav'));
      }
    } catch (e) {
      // Sound file might not exist
    }
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    try {
      final repo = ref.read(orderRepositoryProvider);
      await repo.update(
        order.id,
        order.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Orders grid
            Expanded(
              child: ordersAsync.when(
                data: (allOrders) {
                  // Filter for kitchen-relevant orders
                  final kitchenOrders = allOrders
                      .where((o) => ['confirmed', 'preparing', 'ready'].contains(o.status))
                      .toList();

                  // Check for new confirmed orders
                  final currentIds = kitchenOrders.map((o) => o.id).toSet();
                  final newConfirmedOrders = kitchenOrders
                      .where((o) => o.isConfirmed && !_knownOrderIds.contains(o.id))
                      .toList();

                  if (newConfirmedOrders.isNotEmpty) {
                    _playNewOrderSound();
                  }
                  _knownOrderIds = currentIds;

                  if (kitchenOrders.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildOrdersGrid(kitchenOrders);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Errore di connessione',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.darkText,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '$e',
                        style: TextStyle(color: AppColors.darkTextSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkSurfaceLight),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
            tooltip: 'Torna indietro',
          ),
          const SizedBox(width: AppSpacing.md),
          // Title
          const Icon(Icons.restaurant, color: AppColors.gold, size: 32),
          const SizedBox(width: AppSpacing.md),
          Text(
            'CUCINA',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
          ),
          const Spacer(),
          // Legend
          _buildLegendChip('Confermato', AppColors.statusConfirmed),
          const SizedBox(width: AppSpacing.md),
          _buildLegendChip('In preparazione', AppColors.statusPreparing),
          const SizedBox(width: AppSpacing.md),
          _buildLegendChip('Pronto', AppColors.statusReady),
          const SizedBox(width: AppSpacing.lg),
          // Clock
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Text(
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendChip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 120,
            color: AppColors.success.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Nessun ordine in coda',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.darkText,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Gli ordini appariranno qui quando verranno confermati',
            style: TextStyle(color: AppColors.darkTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersGrid(List<Order> orders) {
    // Sort: confirmed first (newest), then preparing, then ready
    final statusPriority = {'confirmed': 0, 'preparing': 1, 'ready': 2};
    orders.sort((a, b) {
      final priorityCompare =
          (statusPriority[a.status] ?? 99).compareTo(statusPriority[b.status] ?? 99);
      if (priorityCompare != 0) return priorityCompare;
      return a.createdAt.compareTo(b.createdAt); // Oldest first within same status
    });

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate columns based on width
          final width = constraints.maxWidth;
          int crossAxisCount = 3;
          if (width < 900) crossAxisCount = 2;
          if (width < 600) crossAxisCount = 1;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _KitchenOrderCard(
                order: orders[index],
                onStatusChange: _updateOrderStatus,
              );
            },
          );
        },
      ),
    );
  }
}

/// Individual order card for kitchen display
class _KitchenOrderCard extends ConsumerWidget {
  final Order order;
  final Function(Order, String) onStatusChange;

  const _KitchenOrderCard({
    required this.order,
    required this.onStatusChange,
  });

  Color get _statusColor {
    switch (order.status) {
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'preparing':
        return AppColors.statusPreparing;
      case 'ready':
        return AppColors.statusReady;
      default:
        return AppColors.darkSurfaceLight;
    }
  }

  String get _nextStatus {
    switch (order.status) {
      case 'confirmed':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'served';
      default:
        return order.status;
    }
  }

  String get _nextStatusLabel {
    switch (order.status) {
      case 'confirmed':
        return 'INIZIA PREPARAZIONE';
      case 'preparing':
        return 'SEGNA PRONTO';
      case 'ready':
        return 'SERVITO';
      default:
        return '';
    }
  }

  IconData get _nextStatusIcon {
    switch (order.status) {
      case 'confirmed':
        return Icons.play_arrow;
      case 'preparing':
        return Icons.check;
      case 'ready':
        return Icons.done_all;
      default:
        return Icons.arrow_forward;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsAsync = ref.watch(orderItemsByOrderProvider(order.id));
    final tablesAsync = ref.watch(tablesStreamProvider);
    final waitingMinutes = DateTime.now().difference(order.createdAt).inMinutes;

    // Determine if order is taking too long (> 15 min for confirmed, > 25 for preparing)
    final isUrgent = (order.isConfirmed && waitingMinutes > 15) ||
        (order.isPreparing && waitingMinutes > 25);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isUrgent ? AppColors.error : _statusColor,
          width: isUrgent ? 3 : 2,
        ),
        boxShadow: isUrgent
            ? [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg - 2),
              ),
            ),
            child: Row(
              children: [
                // Order number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.darkText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Table name
                      tablesAsync.when(
                        data: (tables) {
                          final table = tables.firstWhere(
                            (t) => t.id == order.tableId,
                            orElse: () => tables.first,
                          );
                          return Row(
                            children: [
                              const Icon(Icons.table_restaurant,
                                  size: 16, color: AppColors.gold),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                table.name,
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                // Time indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isUrgent
                        ? AppColors.error.withValues(alpha: 0.2)
                        : AppColors.darkSurfaceLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: isUrgent ? AppColors.error : AppColors.darkTextSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${waitingMinutes}m',
                        style: TextStyle(
                          color: isUrgent ? AppColors.error : AppColors.darkTextSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Order items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: orderItemsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Nessun piatto',
                        style: TextStyle(color: AppColors.darkTextSecondary),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _OrderItemRow(item: item);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Errore: $e',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ),
          // Notes
          if (order.notes != null && order.notes!.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sticky_note_2, size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      order.notes!,
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          // Action button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ElevatedButton.icon(
              onPressed: () => onStatusChange(order, _nextStatus),
              style: ElevatedButton.styleFrom(
                backgroundColor: _statusColor,
                foregroundColor: AppColors.charcoal,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              icon: Icon(_nextStatusIcon),
              label: Text(
                _nextStatusLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single order item row
class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quantity badge
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.burgundy.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          alignment: Alignment.center,
          child: Text(
            '${item.quantity}x',
            style: const TextStyle(
              color: AppColors.burgundyLight,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Item details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.menuItemName,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              if (item.notes != null && item.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    item.notes!,
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
