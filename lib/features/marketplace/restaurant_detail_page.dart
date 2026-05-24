import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/distance.dart';
import '../../core/utils/error_messages.dart';
import '../../core/widgets/rating_stars.dart';
import '../../core/widgets/skeletons.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/favorites_provider.dart';
import '../../data/providers/reviews_provider.dart';
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
    final favoriteRestaurantIds =
        ref.watch(favoriteRestaurantIdsProvider).valueOrNull ??
            const <String>{};
    final isRestaurantLiked =
        favoriteRestaurantIds.contains(widget.restaurantId);
    final defaultAddress = ref.watch(defaultDeliveryAddressProvider);

    return Scaffold(
      body: restaurantAsync.when(
        data: (restaurant) {
          if (restaurant == null) {
            return Center(child: Text(AppLocalizations.of(context).restaurantNotFound));
          }

          final double? distanceKm = (defaultAddress?.latitude != null &&
                  defaultAddress?.longitude != null &&
                  restaurant.hasCoordinates)
              ? haversineKm(
                  defaultAddress!.latitude!,
                  defaultAddress.longitude!,
                  restaurant.latitude!,
                  restaurant.longitude!,
                )
              : null;

          final canAcceptOrders =
              restaurant.hasStripeAccount && !restaurant.vacationMode;

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
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isRestaurantLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isRestaurantLiked ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => ref
                        .read(favoritesControllerProvider)
                        .toggleRestaurant(widget.restaurantId),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover image
                      restaurant.coverImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: restaurant.coverImageUrl!,
                              fit: BoxFit.cover,
                              memCacheHeight: 800,
                              maxHeightDiskCache: 800,
                              placeholder: (_, __) => _coverFallback(context),
                              errorWidget: (_, __, ___) => _coverFallback(context),
                            )
                          : _coverFallback(context),
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
                            Consumer(builder: (context, ref, _) {
                              final aggAsync = ref.watch(reviewAggregateProvider(
                                  ReviewTargetKey(
                                      'restaurant', widget.restaurantId)));
                              final agg = aggAsync.valueOrNull;
                              final hasReviews =
                                  agg != null && agg.reviewCount > 0;
                              return Wrap(
                                spacing: AppSpacing.sm,
                                children: [
                                  if (hasReviews)
                                    _InfoChip(
                                      icon: Icons.star,
                                      label:
                                          '${agg.avgRating.toStringAsFixed(1)} (${agg.reviewCount})',
                                    ),
                                  _InfoChip(
                                    icon: Icons.access_time,
                                    label:
                                        restaurant.formatEstimatedTotal(distanceKm),
                                  ),
                                  _InfoChip(
                                    icon: Icons.delivery_dining,
                                    label: restaurant.formatDeliveryFee(),
                                  ),
                                  if (restaurant.deliveryMinOrder > 0)
                                    _InfoChip(
                                      icon: Icons.shopping_bag_outlined,
                                      label:
                                          'Min. ${restaurant.formatMinOrder()}',
                                    ),
                                ],
                              );
                            }),
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

              // Banner when restaurant can't take orders
              if (!canAcceptOrders)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          restaurant.vacationMode
                              ? Icons.beach_access
                              : Icons.info_outline,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            restaurant.vacationMode
                                ? 'Questo ristorante è temporaneamente in vacanza e non accetta ordini'
                                : 'Questo ristorante non accetta ancora ordini online',
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          canAcceptOrders: canAcceptOrders,
                        ),
                        childCount: items.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: MenuItemListSkeleton(),
                ),
                error: (e, _) => SliverFillRemaining(
                  child: Center(child: Text(humanizeError(e, context))),
                ),
              ),

              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const _RestaurantDetailSkeleton(),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
      // Cart FAB (hidden when restaurant can't take orders)
      floatingActionButton: cartItemCount > 0 &&
              (restaurantAsync.valueOrNull?.hasStripeAccount ?? false) &&
              !(restaurantAsync.valueOrNull?.vacationMode ?? false)
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

Widget _coverFallback(BuildContext context) {
  return Container(
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
  );
}

/// Full-page skeleton shown while restaurant detail loads.
class _RestaurantDetailSkeleton extends StatelessWidget {
  const _RestaurantDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: const [
        SliverToBoxAdapter(
          child: SizedBox(height: 220),
        ),
        SliverToBoxAdapter(child: MenuItemListSkeleton()),
      ],
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
  final bool canAcceptOrders;

  const _DeliveryMenuItemCard({
    required this.item,
    required this.restaurantId,
    required this.canAcceptOrders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));
    final restaurant = restaurantAsync.valueOrNull;
    final favoriteItemIds =
        ref.watch(favoriteMenuItemIdsProvider).valueOrNull ??
            const <String>{};
    final isLiked = favoriteItemIds.contains(item.id);
    final itemAggregates = ref
            .watch(itemAggregatesForRestaurantProvider(restaurantId))
            .valueOrNull ??
        const {};
    final itemAgg = itemAggregates[item.id];

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
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        memCacheWidth: 288,
                        memCacheHeight: 288,
                        maxWidthDiskCache: 288,
                        maxHeightDiskCache: 288,
                        placeholder: (_, __) => _buildImagePlaceholder(context),
                        errorWidget: (_, __, ___) =>
                            _buildImagePlaceholder(context),
                      )
                    : _buildImagePlaceholder(context),
              ),
              const SizedBox(width: AppSpacing.md),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => ref
                              .read(favoritesControllerProvider)
                              .toggleMenuItem(
                                menuItemId: item.id,
                                tenantId: restaurantId,
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 22,
                              color: isLiked
                                  ? Colors.red
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
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
                    if (itemAgg != null && itemAgg.reviewCount > 0) ...[
                      const SizedBox(height: AppSpacing.xs),
                      RatingStars(
                        rating: itemAgg.avgRating,
                        count: itemAgg.reviewCount,
                        size: 14,
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
                    onPressed: !canAcceptOrders
                        ? null
                        : () {
                            // Ensure cart is set to this restaurant
                            if (restaurant != null) {
                              ref
                                  .read(deliveryCartProvider.notifier)
                                  .setRestaurant(
                                    id: restaurantId,
                                    name: restaurant.name,
                                    deliveryFee: restaurant.deliveryFee,
                                    deliveryMinOrder:
                                        restaurant.deliveryMinOrder,
                                  );
                            }
                            ref
                                .read(deliveryCartProvider.notifier)
                                .addItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context).menuItemAdded(item.name)),
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
