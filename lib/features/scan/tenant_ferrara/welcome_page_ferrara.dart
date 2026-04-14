import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/table.dart';
import '../../../data/providers/providers.dart';
import '../../cart/cart_provider.dart';
import 'customer_menu_page_ferrara.dart';

const _accent = Color(0xFF6599A4);

/// Ferrara tenant welcome page.
/// Full-screen background image with just the "Inizia a ordinare" button
/// near the bottom.
class WelcomePageFerrara extends ConsumerStatefulWidget {
  final RestaurantTable table;

  const WelcomePageFerrara({super.key, required this.table});

  @override
  ConsumerState<WelcomePageFerrara> createState() => _WelcomePageFerraraState();
}

class _WelcomePageFerraraState extends ConsumerState<WelcomePageFerrara> {
  bool _isStarting = false;

  Future<void> _startDinner() async {
    setState(() => _isStarting = true);

    try {
      await Supabase.instance.client
          .from('tables')
          .update({'status': 'occupied'})
          .eq('id', widget.table.id);

      ref.invalidate(tablesStreamProvider);
      ref.invalidate(tablesProvider);

      ref.read(cartProvider.notifier).setTable(
            widget.table.id,
            widget.table.name,
            widget.table.tenantId,
          );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CustomerMenuPageFerrara(),
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
        setState(() => _isStarting = false);
      }
    }
  }

  RestaurantTable _findTable(List<RestaurantTable> tables) {
    for (final t in tables) {
      if (t.id == widget.table.id) return t;
    }
    return widget.table;
  }

  @override
  Widget build(BuildContext context) {
    final tablesStream = ref.watch(tablesStreamProvider);

    final currentTable = tablesStream.when(
      data: (tables) => _findTable(tables),
      loading: () => widget.table,
      error: (_, __) => widget.table,
    );

    final isOccupied = currentTable.status == 'occupied';
    final isReserved = currentTable.status == 'reserved';
    final isUnavailable = isOccupied || isReserved;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage('https://zmeyhbfibzfyocynbznj.supabase.co/storage/v1/object/public/tenant-assets/ferrara/thumbnail.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const Spacer(flex: 12),
                if (isUnavailable) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: (Colors.black)
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: (isReserved ? Colors.amber : Colors.orange)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isReserved ? Icons.no_meals : Icons.info_outline,
                          color: isReserved ? Colors.amber : Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          isReserved
                              ? 'Questo tavolo è prenotato'
                              : 'Questo tavolo è già occupato',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Richiedi assistenza al personale',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isStarting ? null : _startDinner,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _accent,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          side: const BorderSide(color: _accent, width: 6),
                        ),
                      ),
                      child: _isStarting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _accent,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.restaurant_menu, size: 24),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Inizia ad ordinare',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
