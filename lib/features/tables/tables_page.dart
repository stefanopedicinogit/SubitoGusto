import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import 'table_dialog.dart';

/// Tables management page for desktop
class TablesPage extends ConsumerWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates
    final tablesAsync = ref.watch(tablesStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gestisci i tavoli del ristorante',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const TableDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Nuovo Tavolo'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Tables grid
          Expanded(
            child: tablesAsync.when(
              data: (tables) {
                if (tables.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_restaurant,
                          size: 80,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Nessun tavolo configurato',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const TableDialog(),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Aggiungi il primo tavolo'),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: tables.length,
                  itemBuilder: (context, index) =>
                      _TableCard(table: tables[index]),
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

class _TableCard extends ConsumerWidget {
  final RestaurantTable table;

  const _TableCard({required this.table});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChip(status: table.status),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        showDialog(
                          context: context,
                          builder: (context) => TableDialog(table: table),
                        );
                        break;
                      case 'qr':
                        _showQrCodeDialog(context);
                        break;
                      case 'delete':
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Elimina Tavolo'),
                            content: Text(
                              'Sei sicuro di voler eliminare "${table.name}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Annulla'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                child: const Text('Elimina'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final repo = ref.read(tableRepositoryProvider);
                          await repo.delete(table.id);
                          ref.invalidate(tablesProvider);
                          ref.invalidate(tablesStreamProvider);
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: AppSpacing.sm),
                          Text('Modifica'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'qr',
                      child: Row(
                        children: [
                          Icon(Icons.qr_code),
                          SizedBox(width: AppSpacing.sm),
                          Text('Mostra QR'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.error),
                          SizedBox(width: AppSpacing.sm),
                          Text('Elimina',
                              style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // QR Code preview
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: table.qrCodeUrl,
                version: QrVersions.auto,
                size: 100,
              ),
            ),
            const Spacer(),
            // Table info
            Text(
              table.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${table.capacity} posti',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                if (table.zone != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    table.zone!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(table.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: table.qrCodeUrl,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SelectableText(
              table.qrCodeUrl,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chiudi'),
          ),
        ],
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getLabel(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _getColor(),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case 'available':
        return AppColors.success;
      case 'occupied':
        return AppColors.error;
      case 'reserved':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getLabel() {
    switch (status) {
      case 'available':
        return 'Libero';
      case 'occupied':
        return 'Occupato';
      case 'reserved':
        return 'Prenotato';
      default:
        return status;
    }
  }
}
