import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order.dart';
import '../../data/providers/providers.dart';

/// Dashboard page for desktop
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates
    final ordersStream = ref.watch(ordersStreamProvider);
    final ordersAsync = ordersStream.when(
      data: (orders) => AsyncValue.data(orders.where((o) => o.isActive).toList()),
      loading: () => const AsyncValue<List<Order>>.loading(),
      error: (e, st) => AsyncValue<List<Order>>.error(e, st),
    );
    final currentTenantId = ref.watch(currentTenantIdProvider);
    final authState = ref.watch(supabaseAuthProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Debug info - remove in production
          if (currentTenantId == null)
            Card(
              color: AppColors.error.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenant ID non configurato',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.error,
                                ),
                          ),
                          Text(
                            'User ID: ${authState.valueOrNull?.user?.id ?? "N/A"}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Text(
                            'Aggiungi un record nella tabella "users" con il tenant_id corretto.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (currentTenantId == null) const SizedBox(height: AppSpacing.md),
          // Test button - Vista Cliente
          Card(
            color: AppColors.gold.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.qr_code, color: AppColors.gold),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Vista Cliente',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Simula la scansione QR di un tavolo',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Seleziona tavolo'),
                    items: const [
                      DropdownMenuItem(value: 'TBL001', child: Text('Tavolo 1')),
                      DropdownMenuItem(value: 'TBL002', child: Text('Tavolo 2')),
                      DropdownMenuItem(value: 'TBL003', child: Text('Tavolo 3')),
                      DropdownMenuItem(value: 'TBL004', child: Text('Tavolo 4')),
                      DropdownMenuItem(value: 'TBL005', child: Text('Tavolo 5')),
                      DropdownMenuItem(value: 'TBL006', child: Text('Tavolo 6')),
                      DropdownMenuItem(value: 'TBLFERRARA', child: Text('Tavolo Ferrara')),
                    ],
                    onChanged: (qrCode) {
                      if (qrCode != null) {
                        context.push('/scan/$qrCode');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Stats cards row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Ordini Attivi',
                  value: ordersAsync.when(
                    data: (orders) => orders.length.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
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
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
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
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
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
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Recent orders
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ordini Recenti',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Vedi tutti'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: ordersAsync.when(
                        data: (orders) {
                          if (orders.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  Text(
                                    'Nessun ordine attivo',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: orders.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _getStatusColor(order.status)
                                          .withValues(alpha: 0.2),
                                  child: Icon(
                                    _getStatusIcon(order.status),
                                    color: _getStatusColor(order.status),
                                  ),
                                ),
                                title: Text(order.orderNumber),
                                subtitle: Text(order.statusDisplayName),
                                trailing: Text(
                                  order.formatTotal(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Errore: $e')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: color),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
