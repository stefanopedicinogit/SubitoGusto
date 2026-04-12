import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/providers/providers.dart';
import 'fixed_menu_selection_sheet.dart';

/// Card displaying a fixed menu for customers
class FixedMenuCustomerCard extends ConsumerWidget {
  final FixedMenu menu;

  const FixedMenuCustomerCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(fixedMenuCoursesProvider(menu.id));

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showSelectionSheet(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient or image
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ],
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
                  // Overlay gradient for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Price badge
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        menu.formatPrice(),
                        style: const TextStyle(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Availability badge
                  if (menu.availableFor != 'all')
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              menu.availableFor == 'lunch'
                                  ? Icons.wb_sunny
                                  : Icons.nightlight,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              menu.availableFor == 'lunch' ? 'Pranzo' : 'Cena',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Title
                  Positioned(
                    bottom: AppSpacing.md,
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Text(
                      menu.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(blurRadius: 4, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (menu.description != null) ...[
                    Text(
                      menu.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  // Courses preview
                  coursesAsync.when(
                    data: (courses) => Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: courses.map((course) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCourseIcon(course.name),
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _showSelectionSheet(context),
                      icon: const Icon(Icons.touch_app, size: 18),
                      label: const Text('Scegli le portate'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCourseIcon(String courseName) {
    final name = courseName.toLowerCase();
    if (name.contains('antipast')) return Icons.tapas;
    if (name.contains('prim')) return Icons.ramen_dining;
    if (name.contains('second')) return Icons.restaurant;
    if (name.contains('contorn')) return Icons.eco;
    if (name.contains('dolc') || name.contains('dessert')) return Icons.cake;
    if (name.contains('bevand') || name.contains('drink')) return Icons.local_bar;
    return Icons.restaurant_menu;
  }

  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixedMenuSelectionSheet(menu: menu),
    );
  }
}
