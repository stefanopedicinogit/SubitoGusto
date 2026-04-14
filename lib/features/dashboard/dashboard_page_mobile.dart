import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/providers/providers.dart';

/// Dashboard page for mobile
class DashboardPageMobile extends ConsumerWidget {
  const DashboardPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates
    final ordersStream = ref.watch(ordersStreamProvider);
    final ordersAsync = ordersStream.when(
      data: (orders) => AsyncValue.data(orders.where((o) => o.isActive).toList()),
      loading: () => const AsyncValue<List<Order>>.loading(),
      error: (e, st) => AsyncValue<List<Order>>.error(e, st),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ordersStreamProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test button - Vista Cliente
            Card(
              color: AppColors.gold.withValues(alpha: 0.1),
              child: ListTile(
                leading: const Icon(Icons.qr_code, color: AppColors.gold),
                title: const Text('Test Vista Cliente'),
                subtitle: const Text('Simula scansione QR'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showTableSelector(context),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
              children: [
                _StatCardMobile(
                  title: 'Ordini Attivi',
                  value: ordersAsync.when(
                    data: (orders) => orders.length.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary,
                ),
                _StatCardMobile(
                  title: 'In Preparazione',
                  value: ordersAsync.when(
                    data: (orders) =>
                        orders.where((o) => o.isPreparing).length.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.restaurant,
                  color: AppColors.warning,
                ),
                _StatCardMobile(
                  title: 'Pronti',
                  value: ordersAsync.when(
                    data: (orders) =>
                        orders.where((o) => o.isReady).length.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.check_circle,
                  color: AppColors.success,
                ),
                _StatCardMobile(
                  title: 'In Attesa',
                  value: ordersAsync.when(
                    data: (orders) =>
                        orders.where((o) => o.isPending).length.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.hourglass_empty,
                  color: AppColors.gold,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Recent orders section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordini Recenti',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Vedi tutti'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Nessun ordine attivo',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(
                            _getStatusIcon(order.status),
                            color: _getStatusColor(order.status),
                          ),
                        ),
                        title: Text(
                          order.orderNumber,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status)
                                      .withValues(alpha: 0.2),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  order.statusDisplayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: _getStatusColor(order.status),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          order.formatTotal(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        onTap: () {
                          // TODO: Navigate to order details
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text('Errore: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.done_all;
      default:
        return Icons.receipt;
    }
  }

  void _showTableSelector(BuildContext context) {
    final tables = ['TBL001', 'TBL002', 'TBL003', 'TBL004', 'TBL005', 'TBL006', 'TBLFERRARA'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Seleziona un tavolo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final qrCode = tables[index];
                    final tableName = qrCode == 'TBLFERRARA' ? 'Tavolo Ferrara' : 'Tavolo ${index + 1}';
                    return ListTile(
                      leading: const Icon(Icons.table_restaurant),
                      title: Text(tableName),
                      subtitle: Text('QR: $qrCode'),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/scan/$qrCode');
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCardMobile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCardMobile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 20),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
