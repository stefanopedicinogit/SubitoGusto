import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import '../cart/cart_provider.dart';

/// Default welcome page shown after scanning QR code.
/// Tenant-specific welcome pages live in their own subfolder
/// (e.g. tenant_ferrara/welcome_page_ferrara.dart).
class WelcomePage extends ConsumerStatefulWidget {
  final RestaurantTable table;

  const WelcomePage({super.key, required this.table});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  bool _isStarting = false;

  Future<void> _startDinner() async {
    setState(() => _isStarting = true);

    try {
      // Update table status to occupied
      await Supabase.instance.client
          .from('tables')
          .update({'status': 'occupied'})
          .eq('id', widget.table.id);

      // Invalidate tables stream to refresh data
      ref.invalidate(tablesStreamProvider);
      ref.invalidate(tablesProvider);

      // Set table in cart
      ref.read(cartProvider.notifier).setTable(
            widget.table.id,
            widget.table.name,
            widget.table.tenantId,
          );

      if (mounted) {
        // Navigate to customer menu
        context.push('/customer-menu');
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
      if (t.id == widget.table.id) {
        return t;
      }
    }
    return widget.table;
  }

  @override
  Widget build(BuildContext context) {
    // Watch table stream for realtime status updates
    final tablesStream = ref.watch(tablesStreamProvider);

    // Fetch tenant data
    final tenantAsync = ref.watch(tenantByIdProvider(widget.table.tenantId));
    final tenant = tenantAsync.valueOrNull;

    // Find the current table from the stream to get fresh status
    final currentTable = tablesStream.when(
      data: (tables) => _findTable(tables),
      loading: () => widget.table,
      error: (_, __) => widget.table,
    );

    final isOccupied = currentTable.status == 'occupied';
    final isReserved = currentTable.status == 'reserved';
    final isUnavailable = isOccupied || isReserved;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              // Tenant logo/name
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: tenant?.logoUrl != null
                    ? Image.network(
                        tenant!.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            tenant.logoInitial,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          tenant?.logoInitial ?? 'T',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Welcome text
              const Text(
                'Benvenuto da',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                tenant?.name ?? 'Ristorante',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Table info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isUnavailable
                        ? (isReserved ? Colors.amber : Colors.orange).withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isUnavailable
                          ? (isReserved ? Icons.no_meals : Icons.no_meals)
                          : Icons.table_restaurant,
                      color: isUnavailable
                          ? (isReserved ? Colors.amber : Colors.orange)
                          : Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      currentTable.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (isUnavailable) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: (isReserved ? Colors.amber : Colors.orange).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          isReserved ? 'PRENOTATO' : 'OCCUPATO',
                          style: TextStyle(
                            color: isReserved ? Colors.amber : Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${currentTable.capacity} posti',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        if (currentTable.zone != null) ...[
                          const SizedBox(width: AppSpacing.lg),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            currentTable.zone!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Unavailable message or Start button
              if (isUnavailable) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: (isReserved ? Colors.amber : Colors.orange).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: (isReserved ? Colors.amber : Colors.orange).withValues(alpha: 0.5),
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
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: _isStarting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_menu, size: 24),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'Inizia a ordinare',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Info text
                Text(
                  'Scansiona il menu, ordina e paga dal tuo telefono',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
