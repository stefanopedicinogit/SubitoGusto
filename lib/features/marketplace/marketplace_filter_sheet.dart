import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'marketplace_filters.dart';

/// Modal bottom sheet for setting filters + sort.
class MarketplaceFilterSheet extends ConsumerWidget {
  const MarketplaceFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const MarketplaceFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final filters = ref.watch(marketplaceFiltersProvider);
    final notifier = ref.read(marketplaceFiltersProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  l.filterSheetTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (filters.hasAnyFilter)
                  TextButton(
                    onPressed: () => notifier.reset(),
                    child: Text(l.filterSheetReset),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Sort
            _SectionLabel(l.filterSheetSortBy),
            Wrap(
              spacing: AppSpacing.sm,
              children: MarketplaceSort.values.map((s) {
                return ChoiceChip(
                  label: Text(s.label(context)),
                  selected: filters.sort == s,
                  onSelected: (sel) {
                    if (sel) notifier.update(filters.copyWith(sort: s));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Cuisine type
            _SectionLabel(l.filterSheetCuisineType),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                ChoiceChip(
                  label: Text(l.commonAll),
                  selected: filters.cuisineType == null,
                  onSelected: (sel) {
                    if (sel) {
                      notifier.update(filters.copyWith(cuisineType: null));
                    }
                  },
                ),
                ...kCuisineValues.map((v) {
                  return ChoiceChip(
                    label: Text(labelForCuisine(context, v)),
                    selected: filters.cuisineType == v,
                    onSelected: (sel) {
                      notifier.update(filters.copyWith(
                        cuisineType: sel ? v : null,
                      ));
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Dietary tags
            _SectionLabel(l.filterSheetDietary),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: kDietaryValues.map((v) {
                final selected = filters.dietaryTags.contains(v);
                return FilterChip(
                  label: Text(labelForDietary(context, v)),
                  selected: selected,
                  onSelected: (sel) {
                    final next = Set<String>.from(filters.dietaryTags);
                    if (sel) {
                      next.add(v);
                    } else {
                      next.remove(v);
                    }
                    notifier.update(filters.copyWith(dietaryTags: next));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Max delivery time
            _SectionLabel(l.filterSheetMaxTime),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l.commonAny),
                  selected: filters.maxDeliveryTimeMin == null,
                  onSelected: (sel) {
                    if (sel) {
                      notifier.update(
                          filters.copyWith(maxDeliveryTimeMin: null));
                    }
                  },
                ),
                for (final min in [30, 45, 60])
                  ChoiceChip(
                    label: Text(l.filterSheetMaxMin(min)),
                    selected: filters.maxDeliveryTimeMin == min,
                    onSelected: (sel) {
                      notifier.update(filters.copyWith(
                        maxDeliveryTimeMin: sel ? min : null,
                      ));
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Free delivery
            _SectionLabel(l.filterSheetDelivery),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.filterSheetFreeOnly),
              value: filters.freeDeliveryOnly,
              onChanged: (v) =>
                  notifier.update(filters.copyWith(freeDeliveryOnly: v)),
            ),
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.filterSheetShowResults),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}
