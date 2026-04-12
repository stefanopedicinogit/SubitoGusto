import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/providers.dart';
import 'category_dialog.dart';
import 'menu_item_dialog.dart';

/// Menu management page for desktop
class MenuManagementPage extends ConsumerStatefulWidget {
  const MenuManagementPage({super.key});

  @override
  ConsumerState<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends ConsumerState<MenuManagementPage> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    // Use streams for realtime updates
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final menuItemsAsync = ref.watch(menuItemsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories sidebar
          SizedBox(
            width: 280,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categorie',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const CategoryDialog(),
                            );
                          },
                          tooltip: 'Nuova categoria',
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: categoriesAsync.when(
                      data: (categories) {
                        if (categories.isEmpty) {
                          return const Center(
                            child: Text('Nessuna categoria'),
                          );
                        }
                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                _selectedCategoryId == category.id;
                            final primaryColor = Theme.of(context).colorScheme.primary;
                            return ListTile(
                              selected: isSelected,
                              selectedTileColor:
                                  primaryColor.withValues(alpha: 0.1),
                              leading: category.imageUrl != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(category.imageUrl!),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          primaryColor.withValues(alpha: 0.1),
                                      child: Icon(
                                        Icons.restaurant_menu,
                                        color: primaryColor,
                                      ),
                                    ),
                              title: Text(category.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    Icon(Icons.check,
                                        color: primaryColor),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CategoryDialog(category: category),
                                      );
                                    },
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedCategoryId = category.id;
                                });
                              },
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
          const SizedBox(width: AppSpacing.lg),
          // Menu items grid
          Expanded(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Piatti',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                              tooltip: 'Cerca',
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            FilledButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => MenuItemDialog(
                                    initialCategoryId: _selectedCategoryId,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Nuovo Piatto'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: menuItemsAsync.when(
                      data: (items) {
                        final filteredItems = _selectedCategoryId != null
                            ? items
                                .where(
                                    (i) => i.categoryId == _selectedCategoryId)
                                .toList()
                            : items;

                        if (filteredItems.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Nessun piatto',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                FilledButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => MenuItemDialog(
                                        initialCategoryId: _selectedCategoryId,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Aggiungi piatto'),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) =>
                              _MenuItemCard(item: filteredItems[index]),
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
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => MenuItemDialog(menuItem: item),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Builder(
                      builder: (context) => Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.formatPrice(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          children: [
                            if (!item.isAvailable)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
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
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      MenuItemDialog(menuItem: item),
                                );
                              },
                              tooltip: 'Modifica',
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
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
}
