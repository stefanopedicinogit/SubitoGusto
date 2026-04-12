import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import 'table_dialog.dart';

/// Tables management page for mobile
class TablesPageMobile extends ConsumerWidget {
  const TablesPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates
    final tablesAsync = ref.watch(tablesStreamProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(tablesStreamProvider);
      },
      child: tablesAsync.when(
        data: (tables) {
          if (tables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.table_restaurant,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nessun tavolo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: tables.length,
            itemBuilder: (context, index) =>
                _TableCardMobile(table: tables[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}

class _TableCardMobile extends StatelessWidget {
  final RestaurantTable table;

  const _TableCardMobile({required this.table});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _showTableBottomSheet(context);
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status indicator
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const Spacer(),
              // Table icon
              Builder(
                builder: (context) {
                  final primaryColor = Theme.of(context).colorScheme.primary;
                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.table_restaurant,
                      size: 32,
                      color: primaryColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                table.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${table.capacity} posti',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              // Status text
              Text(
                _getStatusLabel(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (table.status) {
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

  String _getStatusLabel() {
    switch (table.status) {
      case 'available':
        return 'Libero';
      case 'occupied':
        return 'Occupato';
      case 'reserved':
        return 'Prenotato';
      default:
        return table.status;
    }
  }

  void _showTableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // QR Code
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
                const SizedBox(height: AppSpacing.lg),
                Text(
                  table.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people,
                        size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${table.capacity} posti',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funzione in arrivo'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Scarica QR'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => TableDialog(table: table),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifica'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
