import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/distance.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/tenant.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/favorites_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer favorites page with a toggle between liked restaurants and items.
class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

enum _FavoritesTab { restaurants, items }

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  _FavoritesTab _tab = _FavoritesTab.restaurants;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l.favoritesTitle),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SegmentedButton<_FavoritesTab>(
              segments: [
                ButtonSegment(
                  value: _FavoritesTab.restaurants,
                  label: Text(l.favoritesRestaurants),
                  icon: const Icon(Icons.storefront_outlined),
                ),
                ButtonSegment(
                  value: _FavoritesTab.items,
                  label: Text(l.favoritesItems),
                  icon: const Icon(Icons.restaurant_menu_outlined),
                ),
              ],
              selected: {_tab},
              onSelectionChanged: (selection) =>
                  setState(() => _tab = selection.first),
            ),
          ),
          Expanded(
            child: _tab == _FavoritesTab.restaurants
                ? const _FavoriteRestaurantsList()
                : const _FavoriteItemsList(),
          ),
        ],
      ),
    );
  }
}

class _FavoriteRestaurantsList extends ConsumerWidget {
  const _FavoriteRestaurantsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final restaurantsAsync = ref.watch(favoriteRestaurantsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(favoriteRestaurantsProvider);
        ref.invalidate(favoriteRestaurantIdsProvider);
      },
      child: restaurantsAsync.when(
        data: (restaurants) {
          if (restaurants.isEmpty) {
            return _EmptyState(
              icon: Icons.favorite_border,
              title: l.favoritesNoRestaurants,
              subtitle: l.favoritesNoRestaurantsHint,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            itemCount: restaurants.length,
            itemBuilder: (context, index) =>
                _FavoriteRestaurantCard(restaurant: restaurants[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
    );
  }
}

class _FavoriteItemsList extends ConsumerWidget {
  const _FavoriteItemsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final itemsAsync = ref.watch(favoriteMenuItemsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(favoriteMenuItemsProvider);
        ref.invalidate(favoriteMenuItemIdsProvider);
      },
      child: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(
              icon: Icons.favorite_border,
              title: l.favoritesNoItems,
              subtitle: l.favoritesNoItemsHint,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _FavoriteMenuItemCard(favorite: items[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
    );
  }
}

class _FavoriteRestaurantCard extends ConsumerWidget {
  final Tenant restaurant;
  const _FavoriteRestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultAddress = ref.watch(defaultDeliveryAddressProvider);
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        onTap: () => context.go('/marketplace/${restaurant.id}'),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                  ),
                  child: restaurant.coverImageUrl != null
                      ? Image.network(
                          restaurant.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _placeholder(context, restaurant.logoInitial),
                        )
                      : _placeholder(context, restaurant.logoInitial),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (restaurant.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          restaurant.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.formatEstimatedTotal(distanceKm),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Icon(Icons.delivery_dining,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.formatDeliveryFee(),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _HeartButton(
                isLiked: true,
                onTap: () => ref
                    .read(favoritesControllerProvider)
                    .removeFavoriteRestaurant(restaurant.id),
              ),
            ),
            if (restaurant.vacationMode)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _VacationBadge(),
              )
            else if (!restaurant.hasStripeAccount)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _UnavailableBadge(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, String initial) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _FavoriteMenuItemCard extends ConsumerWidget {
  final FavoriteMenuItem favorite;
  const _FavoriteMenuItemCard({required this.favorite});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final MenuItem item = favorite.item;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => context.go('/marketplace/${favorite.restaurantId}'),
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
                        errorBuilder: (_, __, ___) => _imagePlaceholder(context),
                      )
                    : _imagePlaceholder(context),
              ),
              const SizedBox(width: AppSpacing.md),
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
                    const SizedBox(height: 2),
                    Text(
                      favorite.restaurantName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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
                    Text(
                      item.formatPrice(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(favoritesControllerProvider)
                    .removeFavoriteMenuItem(item.id),
                icon: const Icon(Icons.favorite, color: Colors.red),
                tooltip: l.favoritesRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Icon(Icons.restaurant, color: AppColors.textSecondary),
    );
  }
}

class _UnavailableBadge extends StatelessWidget {
  const _UnavailableBadge();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        l.restaurantUnavailableBadge,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _VacationBadge extends StatelessWidget {
  const _VacationBadge();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.beach_access, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            l.restaurantVacationBadge,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const _HeartButton({required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Icon(
          icon,
          size: 80,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
