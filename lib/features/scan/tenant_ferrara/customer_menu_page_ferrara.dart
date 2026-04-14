import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/providers/providers.dart';
import '../../cart/cart_provider.dart';
import '../../cart/cart_sheet.dart';
import '../../cart/menu_item_detail_sheet.dart';
import '../../fixed_menu/fixed_menu_customer_card.dart';

const _accent = Color(0xFF6599A4);

/// Ferrara tenant customer menu page.
class CustomerMenuPageFerrara extends ConsumerStatefulWidget {
  const CustomerMenuPageFerrara({super.key});

  @override
  ConsumerState<CustomerMenuPageFerrara> createState() =>
      _CustomerMenuPageFerraraState();
}

class _CustomerMenuPageFerraraState
    extends ConsumerState<CustomerMenuPageFerrara> {
  String? _selectedCategoryId;
  bool _showingFixedMenus = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);
    final categoriesStream = ref.watch(categoriesStreamProvider);
    final menuItemsStream = ref.watch(menuItemsStreamProvider);
    final fixedMenusAsync = ref.watch(availableFixedMenusProvider);

    final categoriesAsync = categoriesStream.whenData(
      (cats) => cats.where((c) => c.isActive).toList(),
    );
    final menuItemsAsync = menuItemsStream.whenData(
      (items) => items.where((m) => m.isActive && m.isAvailable).toList(),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _accent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              cart.tableName ?? 'Menu',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage('https://zmeyhbfibzfyocynbznj.supabase.co/storage/v1/object/public/tenant-assets/ferrara/breadcumb.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        _accent.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: const SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Ferrara',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Scegli i tuoi piatti preferiti',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Categories
          SliverToBoxAdapter(
            child: categoriesAsync.when(
              data: (categories) {
                final hasFixedMenus =
                    fixedMenusAsync.valueOrNull?.isNotEmpty ?? false;
                final totalChips =
                    categories.length + 1 + (hasFixedMenus ? 1 : 0);

                return Container(
                  height: 120,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    itemCount: totalChips,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected =
                            _selectedCategoryId == null && !_showingFixedMenus;
                        return _CategoryChipFerrara(
                          name: 'Tutti',
                          emoji: '🍽️',
                          isSelected: isSelected,
                          onTap: () => setState(() {
                            _selectedCategoryId = null;
                            _showingFixedMenus = false;
                          }),
                        );
                      }

                      if (hasFixedMenus && index == 1) {
                        return _CategoryChipFerrara(
                          name: 'Menu Fissi',
                          emoji: '📋',
                          isSelected: _showingFixedMenus,
                          isSpecial: true,
                          onTap: () => setState(() {
                            _showingFixedMenus = true;
                            _selectedCategoryId = null;
                          }),
                        );
                      }

                      final categoryIndex =
                          hasFixedMenus ? index - 2 : index - 1;
                      if (categoryIndex < 0 ||
                          categoryIndex >= categories.length) {
                        return const SizedBox.shrink();
                      }

                      final category = categories[categoryIndex];
                      final isSelected =
                          _selectedCategoryId == category.id &&
                              !_showingFixedMenus;
                      return _CategoryChipFerrara(
                        name: category.name,
                        imageUrl: category.imageUrl,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          _selectedCategoryId = category.id;
                          _showingFixedMenus = false;
                        }),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(height: 120),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          // Fixed menus or regular menu items
          if (_showingFixedMenus)
            fixedMenusAsync.when(
              data: (fixedMenus) {
                if (fixedMenus.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: 64,
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Nessun menu fisso disponibile',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          FixedMenuCustomerCard(menu: fixedMenus[index]),
                      childCount: fixedMenus.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Errore: $e')),
              ),
            )
          else
            menuItemsAsync.when(
              data: (allItems) {
                final categories = categoriesAsync.valueOrNull ?? [];
                final categoryOrderMap = {
                  for (final cat in categories) cat.id: cat.sortOrder
                };

                var items = _selectedCategoryId == null
                    ? allItems.toList()
                    : allItems
                        .where(
                            (item) => item.categoryId == _selectedCategoryId)
                        .toList();

                items.sort((a, b) {
                  final catOrderA = categoryOrderMap[a.categoryId] ?? 999;
                  final catOrderB = categoryOrderMap[b.categoryId] ?? 999;
                  if (catOrderA != catOrderB) {
                    return catOrderA.compareTo(catOrderB);
                  }
                  return a.sortOrder.compareTo(b.sortOrder);
                });

                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
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
                            _selectedCategoryId == null
                                ? 'Menu non disponibile'
                                : 'Nessun piatto in questa categoria',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _MenuItemCardFerrara(item: items[index]),
                      childCount: items.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Errore: $e')),
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CartSheet(),
                );
              },
              backgroundColor: _accent,
              icon: Badge(
                label: Text('$cartItemCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: Text(
                '${ref.watch(cartTotalProvider).toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}

class _CategoryChipFerrara extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? emoji;
  final bool isSelected;
  final bool isSpecial;
  final VoidCallback onTap;

  const _CategoryChipFerrara({
    required this.name,
    this.imageUrl,
    this.emoji,
    required this.isSelected,
    this.isSpecial = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isSpecial ? AppColors.gold : _accent;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : AppColors.textSecondary,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildPlaceholder(accentColor),
                      )
                    : _buildPlaceholder(accentColor),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              width: 70,
              child: Text(
                name,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? accentColor : null,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Color color) {
    return Container(
      color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
      child: Center(
        child: Text(
          emoji ?? _getEmoji(),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  String _getEmoji() {
    switch (name.toLowerCase()) {
      case 'antipasti':
        return '🥗';
      case 'primi piatti':
      case 'primi':
        return '🍝';
      case 'secondi piatti':
      case 'secondi':
        return '🥩';
      case 'contorni':
        return '🥬';
      case 'dolci':
      case 'dessert':
        return '🍰';
      case 'bevande':
      case 'drinks':
        return '🍷';
      default:
        return '🍽️';
    }
  }
}

class _MenuItemCardFerrara extends ConsumerWidget {
  final MenuItem item;

  const _MenuItemCardFerrara({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => MenuItemDetailSheet(item: item),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    if (item.tags.isNotEmpty)
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: item.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              _getTagEmoji(tag),
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.formatPrice(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _accent,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} aggiunto'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTagEmoji(String tag) {
    switch (tag) {
      case 'vegetariano':
        return '🥬';
      case 'vegano':
        return '🌱';
      case 'gluten_free':
        return '🌾';
      case 'piccante':
        return '🌶️';
      case 'chefs_choice':
        return '⭐';
      default:
        return '🏷️';
    }
  }
}
