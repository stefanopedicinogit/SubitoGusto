import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/consumer_providers.dart';
import 'delivery_cart_provider.dart';
import 'delivery_cart_sheet.dart';

/// Restaurant detail page with menu browsing for delivery
class RestaurantDetailPage extends ConsumerStatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantDetailPage> createState() =>
      _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends ConsumerState<RestaurantDetailPage> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final restaurantAsync = ref.watch(restaurantDetailProvider(widget.restaurantId));
    final categoriesAsync = ref.watch(restaurantCategoriesProvider(widget.restaurantId));
    final menuItemsAsync = ref.watch(restaurantMenuItemsProvider(widget.restaurantId));
    final cartItemCount = ref.watch(deliveryCartItemCountProvider);
    final cartTotal = ref.watch(deliveryCartTotalProvider);

    return Scaffold(
      body: restaurantAsync.when(
        data: (restaurant) {
          if (restaurant == null) {
            return const Center(child: Text('Ristorante non trovato'));
          }

          return CustomScrollView(
            slivers: [
              // App bar with restaurant info
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  onPressed: () => context.go('/marketplace'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover image
                      restaurant.coverImageUrl != null
                          ? Image.network(
                              restaurant.coverImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      // Restaurant info
                      Positioned(
                        bottom: AppSpacing.md,
                        left: AppSpacing.lg,
                        right: AppSpacing.lg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (restaurant.description != null)
                              Text(
                                restaurant.description!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: AppSpacing.sm),
                            // Delivery info chips
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: [
                                _InfoChip(
                                  icon: Icons.access_time,
                                  label: restaurant.estimatedTimeDisplay,
                                ),
                                _InfoChip(
                                  icon: Icons.delivery_dining,
                                  label: restaurant.formatDeliveryFee(),
                                ),
                                if (restaurant.deliveryMinOrder > 0)
                                  _InfoChip(
                                    icon: Icons.shopping_bag_outlined,
                                    label: 'Min. ${restaurant.formatMinOrder()}',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category chips
              SliverToBoxAdapter(
                child: categoriesAsync.when(
                  data: (categories) {
                    return Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isSelected = _selectedCategoryId == null;
                            return Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.sm),
                              child: FilterChip(
                                label: const Text('Tutti'),
                                selected: isSelected,
                                onSelected: (_) =>
                                    setState(() => _selectedCategoryId = null),
                              ),
                            );
                          }
                          final category = categories[index - 1];
                          final isSelected = _selectedCategoryId == category.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: FilterChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (_) =>
                                  setState(() => _selectedCategoryId = category.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 56),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),

              // Menu items
              menuItemsAsync.when(
                data: (allItems) {
                  final items = _selectedCategoryId == null
                      ? allItems
                      : allItems.where((i) => i.categoryId == _selectedCategoryId).toList();

                  if (items.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Nessun piatto disponibile',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _DeliveryMenuItemCard(
                          item: items[index],
                          restaurantId: widget.restaurantId,
                        ),
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

              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
      // Cart FAB
      floatingActionButton: cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const DeliveryCartSheet(),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Badge(
                label: Text('$cartItemCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: Text(
                '${cartTotal.toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}

/// Info chip for delivery details
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Menu item card for delivery ordering
class _DeliveryMenuItemCard extends ConsumerWidget {
  final MenuItem item;
  final String restaurantId;

  const _DeliveryMenuItemCard({
    required this.item,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));
    final restaurant = restaurantAsync.valueOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          // Could show detail sheet, for now just add to cart
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildImagePlaceholder(context),
                      )
                    : _buildImagePlaceholder(context),
              ),
              const SizedBox(width: AppSpacing.md),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
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
                              color: AppColors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
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
              // Price and add button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.formatPrice(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: () {
                      // Ensure cart is set to this restaurant
                      if (restaurant != null) {
                        ref.read(deliveryCartProvider.notifier).setRestaurant(
                              id: restaurantId,
                              name: restaurant.name,
                              deliveryFee: restaurant.deliveryFee,
                              deliveryMinOrder: restaurant.deliveryMinOrder,
                            );
                      }
                      ref.read(deliveryCartProvider.notifier).addItem(item);
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Icon(
        Icons.restaurant,
        color: AppColors.textSecondary,
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
