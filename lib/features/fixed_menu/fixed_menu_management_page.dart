import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/providers/providers.dart';
import 'fixed_menu_dialog.dart';
import 'fixed_menu_courses_dialog.dart';

/// Fixed Menu Management Page
class FixedMenuManagementPage extends ConsumerWidget {
  const FixedMenuManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menusAsync = ref.watch(fixedMenusStreamProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu Fissi',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Gestisci i menu a prezzo fisso del ristorante',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuovo Menu'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Content
            Expanded(
              child: menusAsync.when(
                data: (menus) {
                  if (menus.isEmpty) {
                    return _buildEmptyState(context, ref);
                  }
                  return _buildMenuGrid(context, ref, menus);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text('Errore: $e'),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(fixedMenusStreamProvider),
                        child: const Text('Riprova'),
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

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Nessun menu fisso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Crea il tuo primo menu a prezzo fisso',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => _showCreateDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Crea Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, WidgetRef ref, List<FixedMenu> menus) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return _FixedMenuCard(menu: menus[index]);
      },
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const FixedMenuDialog(),
    );
  }
}

/// Card for displaying a fixed menu
class _FixedMenuCard extends ConsumerWidget {
  final FixedMenu menu;

  const _FixedMenuCard({required this.menu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');
    final coursesAsync = ref.watch(fixedMenuCoursesProvider(menu.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image or color
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: menu.isActive
                      ? [AppColors.burgundy, AppColors.burgundyLight]
                      : [Colors.grey.shade400, Colors.grey.shade500],
                ),
              ),
              child: Stack(
                children: [
                  if (menu.imageUrl != null)
                    Positioned.fill(
                      child: Image.network(
                        menu.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Row(
                      children: [
                        _buildChip(menu.availableFor == 'lunch'
                            ? 'Pranzo'
                            : menu.availableFor == 'dinner'
                                ? 'Cena'
                                : 'Sempre'),
                        if (!menu.isActive) ...[
                          const SizedBox(width: AppSpacing.xs),
                          _buildChip('Inattivo', isWarning: true),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.sm,
                    left: AppSpacing.md,
                    child: Text(
                      currencyFormat.format(menu.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (menu.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        menu.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    // Courses count
                    coursesAsync.when(
                      data: (courses) => Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${courses.length} portate',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => _showCoursesDialog(context),
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Portate'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.warning.withValues(alpha: 0.9)
            : Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isWarning ? AppColors.charcoal : Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FixedMenuDialog(menu: menu),
    );
  }

  void _showCoursesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FixedMenuCoursesDialog(menu: menu),
    );
  }
}
