import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/distance.dart';
import '../../core/utils/error_messages.dart';
import '../../core/widgets/language_switcher.dart';
import '../../core/widgets/notifications_panel.dart';
import '../../core/widgets/rating_stars.dart';
import '../../core/widgets/skeletons.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../data/models/review_aggregate.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/favorites_provider.dart';
import '../../data/providers/reviews_provider.dart';
import 'marketplace_filter_sheet.dart';
import 'marketplace_filters.dart';

/// Marketplace page showing delivery-enabled restaurants
class MarketplacePage extends ConsumerStatefulWidget {
  const MarketplacePage({super.key});

  @override
  ConsumerState<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends ConsumerState<MarketplacePage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  bool _bypassRadius = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(marketplaceRestaurantsProvider);
    final addressesAsync = ref.watch(deliveryAddressesProvider);
    final defaultAddress = ref.watch(defaultDeliveryAddressProvider);
    final favoriteIds =
        ref.watch(favoriteRestaurantIdsProvider).valueOrNull ??
            const <String>{};
    final aggregates =
        ref.watch(allRestaurantAggregatesProvider).valueOrNull ?? const {};
    final filters = ref.watch(marketplaceFiltersProvider);
    final consumerLat = defaultAddress?.latitude;
    final consumerLng = defaultAddress?.longitude;
    final l = AppLocalizations.of(context);

    if (addressesAsync.hasValue && addressesAsync.value!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/consumer/location');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l.marketplaceSearchHint,
                  border: InputBorder.none,
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value.trim().toLowerCase()),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Text('SubitoGusto'),
                ],
              ),
        centerTitle: false,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _stopSearch,
              )
            : null,
        actions: [
          if (!_isSearching) const LanguageSwitcher(),
          if (!_isSearching) const NotificationBell(),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ),
          if (!_isSearching)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  tooltip: l.marketplaceFilters,
                  onPressed: () => MarketplaceFilterSheet.show(context),
                ),
                if (filters.activeCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${filters.activeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          if (defaultAddress != null)
            Material(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
              child: InkWell(
                onTap: () => context.go('/consumer/location'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.marketplaceDeliveringTo,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              defaultAddress.fullAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l.marketplaceChangeAddress,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: restaurantsAsync.when(
              data: (restaurants) {
          if (restaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l.marketplaceEmpty,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.marketplaceEmptyHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          final filtered = _searchQuery.isEmpty
              ? restaurants
              : restaurants.where((r) {
                  final name = r.name.toLowerCase();
                  final desc = (r.description ?? '').toLowerCase();
                  return name.contains(_searchQuery) ||
                      desc.contains(_searchQuery);
                }).toList();

          final canMeasure = consumerLat != null && consumerLng != null;
          final allWithDistance = filtered
              .map((r) {
                final km = canMeasure && r.hasCoordinates
                    ? haversineKm(
                        consumerLat,
                        consumerLng,
                        r.latitude!,
                        r.longitude!,
                      )
                    : null;
                return (restaurant: r, km: km);
              })
              .toList();
          if (canMeasure) {
            allWithDistance.sort((a, b) {
              if (a.km == null && b.km == null) return 0;
              if (a.km == null) return 1;
              if (b.km == null) return -1;
              return a.km!.compareTo(b.km!);
            });
          }
          final inRange = allWithDistance.where((entry) {
            if (!canMeasure) return true;
            final km = entry.km;
            if (km == null) return false;
            return km <= entry.restaurant.deliveryRadiusKm;
          }).toList();
          final outOfRange = allWithDistance.where((entry) {
            if (!canMeasure) return false;
            final km = entry.km;
            if (km == null) return false;
            return km > entry.restaurant.deliveryRadiusKm;
          }).toList();
          final missingCoords = allWithDistance
              .where((entry) => !entry.restaurant.hasCoordinates)
              .toList();
          final rawWithDistance =
              _bypassRadius ? allWithDistance : inRange;

          // Apply user-selected filters (cuisine, dietary, time, fee).
          final withDistance = rawWithDistance.where((entry) {
            final r = entry.restaurant;
            if (filters.cuisineType != null &&
                r.cuisineType != filters.cuisineType) {
              return false;
            }
            if (filters.dietaryTags.isNotEmpty &&
                !filters.dietaryTags.every(r.dietaryTags.contains)) {
              return false;
            }
            if (filters.maxDeliveryTimeMin != null &&
                r.estimatedTotalMinutes(entry.km) >
                    filters.maxDeliveryTimeMin!) {
              return false;
            }
            if (filters.freeDeliveryOnly && r.deliveryFee > 0) {
              return false;
            }
            return true;
          }).toList();

          // Apply sort. Distance-sort is the default and matches the existing
          // pre-sort; other sorts override it here.
          switch (filters.sort) {
            case MarketplaceSort.distance:
              break;
            case MarketplaceSort.deliveryTime:
              withDistance.sort((a, b) {
                final ta = a.restaurant.estimatedTotalMinutes(a.km);
                final tb = b.restaurant.estimatedTotalMinutes(b.km);
                return ta.compareTo(tb);
              });
              break;
            case MarketplaceSort.rating:
              withDistance.sort((a, b) {
                final ra = aggregates[a.restaurant.id]?.avgRating ?? 0;
                final rb = aggregates[b.restaurant.id]?.avgRating ?? 0;
                return rb.compareTo(ra); // desc
              });
              break;
            case MarketplaceSort.price:
              withDistance.sort((a, b) =>
                  a.restaurant.deliveryFee.compareTo(b.restaurant.deliveryFee));
              break;
          }

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l.marketplaceNoResults(_searchQuery),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          if (withDistance.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Icon(
                    Icons.location_off_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l.marketplaceNoneInZone,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (outOfRange.isNotEmpty) ...[
                    Text(
                      l.marketplaceOutsideRadius,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...outOfRange.take(5).map((entry) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: _DiagnosticRow(
                            name: entry.restaurant.name,
                            detail:
                                '${formatKm(entry.km!)} (raggio ${entry.restaurant.deliveryRadiusKm.toStringAsFixed(1)} km)',
                          ),
                        )),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.marketplaceGeolocationHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (missingCoords.isNotEmpty) ...[
                    Text(
                      l.marketplaceMissingCoords,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...missingCoords.take(5).map((entry) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: _DiagnosticRow(
                            name: entry.restaurant.name,
                            detail: 'coordinate mancanti',
                          ),
                        )),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (outOfRange.isNotEmpty || missingCoords.isNotEmpty) ...[
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          setState(() => _bypassRadius = true),
                      icon: const Icon(Icons.visibility_outlined),
                      label: Text(l.marketplaceShowAll),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  FilledButton.icon(
                    onPressed: () => context.go('/consumer/location'),
                    icon: const Icon(Icons.edit_location_alt_outlined),
                    label: Text(l.marketplaceChangeAddress),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: withDistance.length,
            itemBuilder: (context, index) {
              final restaurant = withDistance[index].restaurant;
              final distanceKm = withDistance[index].km;
              final isLiked = favoriteIds.contains(restaurant.id);
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: InkWell(
                  onTap: () => context.go('/marketplace/${restaurant.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover image or placeholder
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                            ),
                            child: restaurant.coverImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: restaurant.coverImageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                    memCacheHeight: 540,
                                    maxHeightDiskCache: 540,
                                    placeholder: (_, __) =>
                                        _buildPlaceholder(context, restaurant.logoInitial),
                                    errorWidget: (_, __, ___) =>
                                        _buildPlaceholder(context, restaurant.logoInitial),
                                  )
                                : _buildPlaceholder(context, restaurant.logoInitial),
                          ),
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: _FavoriteHeartButton(
                              isLiked: isLiked,
                              onTap: () => ref
                                  .read(favoritesControllerProvider)
                                  .toggleRestaurant(restaurant.id),
                            ),
                          ),
                          if (restaurant.vacationMode)
                            const Positioned(
                              top: AppSpacing.sm,
                              left: AppSpacing.sm,
                              child: _VacationBadge(),
                            )
                          else if (!restaurant.hasStripeAccount)
                            const Positioned(
                              top: AppSpacing.sm,
                              left: AppSpacing.sm,
                              child: _UnavailableBadge(),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    restaurant.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                _AggregateBadge(
                                    aggregate: aggregates[restaurant.id]),
                              ],
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
                            // Delivery info row
                            Row(
                              children: [
                                if (distanceKm != null) ...[
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatKm(distanceKm),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                ],
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.formatEstimatedTotal(distanceKm),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Icon(
                                  Icons.delivery_dining,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.formatDeliveryFee(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (restaurant.deliveryMinOrder > 0) ...[
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    'Min. ${restaurant.formatMinOrder()}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const RestaurantListSkeleton(),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String initial) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _UnavailableBadge extends StatelessWidget {
  const _UnavailableBadge();

  @override
  Widget build(BuildContext context) {
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
        AppLocalizations.of(context).restaurantUnavailableBadge,
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
            AppLocalizations.of(context).restaurantVacationBadge,
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

class _DiagnosticRow extends StatelessWidget {
  final String name;
  final String detail;

  const _DiagnosticRow({required this.name, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteHeartButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const _FavoriteHeartButton({required this.isLiked, required this.onTap});

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

/// Compact star+number badge for a card. Shows "Nuovo" when a tenant has 0
/// reviews so cards don't shift layout once ratings start coming in.
class _AggregateBadge extends StatelessWidget {
  final ReviewAggregate? aggregate;

  const _AggregateBadge({required this.aggregate});

  @override
  Widget build(BuildContext context) {
    final agg = aggregate;
    if (agg == null || agg.reviewCount == 0) {
      return const NoRatingChip();
    }
    return RatingStars(rating: agg.avgRating, count: agg.reviewCount);
  }
}
