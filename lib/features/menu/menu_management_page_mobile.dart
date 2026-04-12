import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/category.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/providers.dart';
import 'category_dialog.dart';
import 'menu_item_dialog.dart';

/// Menu management page for mobile
class MenuManagementPageMobile extends ConsumerWidget {
  const MenuManagementPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(categoriesStreamProvider);
        ref.invalidate(menuItemsStreamProvider);
      },
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nessuna categoria',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CategoryDialog(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Aggiungi categoria'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(category: category);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for realtime updates and filter by category
    final menuItemsStream = ref.watch(menuItemsStreamProvider);
    final menuItemsAsync = menuItemsStream.whenData(
      (items) => items.where((item) => item.categoryId == category.id).toList(),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => CategoryDialog(category: category),
            );
          },
          child: category.imageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(category.imageUrl!),
                )
              : CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        title: Text(category.name),
        subtitle: menuItemsAsync.when(
          data: (items) => Text('${items.length} piatti'),
          loading: () => const Text('...'),
          error: (_, __) => const Text('0 piatti'),
        ),
        children: [
          menuItemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MenuItemDialog(
                            initialCategoryId: category.id,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Aggiungi piatto'),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...items.map((item) {
                    return ListTile(
                      leading: item.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: Image.network(
                                item.imageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                color: AppColors.textSecondary,
                              ),
                            ),
                      title: Text(item.name),
                      subtitle: Row(
                        children: [
                          Text(item.formatPrice()),
                          if (!item.isAvailable) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                'Esaurito',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.error,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => MenuItemDialog(menuItem: item),
                          );
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => MenuItemDialog(menuItem: item),
                        );
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MenuItemDialog(
                            initialCategoryId: category.id,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Aggiungi piatto'),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text('Errore: $e'),
            ),
          ),
        ],
      ),
    );
  }
}
