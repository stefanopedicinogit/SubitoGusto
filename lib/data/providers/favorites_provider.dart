import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/menu_item.dart';
import '../models/tenant.dart';
import 'supabase_provider.dart';

/// A liked menu item paired with its restaurant info for display.
class FavoriteMenuItem {
  final MenuItem item;
  final String restaurantId;
  final String restaurantName;

  const FavoriteMenuItem({
    required this.item,
    required this.restaurantId,
    required this.restaurantName,
  });
}

// ============================================================================
// ID sets (fast O(1) lookups for heart-icon state)
// ============================================================================

/// IDs of restaurants the current consumer has favorited.
///
/// Exposed as an [AsyncNotifier] so [FavoritesController] can update the set
/// optimistically (tap → icon flips immediately, no network round-trip).
class FavoriteRestaurantIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return const <String>{};

    final client = ref.watch(supabaseClientProvider);
    final data = await client
        .from('customer_favorite_restaurants')
        .select('tenant_id')
        .eq('customer_id', userId);

    return (data as List).map((row) => row['tenant_id'] as String).toSet();
  }

  void overwrite(Set<String> next) => state = AsyncData(next);
}

final favoriteRestaurantIdsProvider = AsyncNotifierProvider<
    FavoriteRestaurantIdsNotifier, Set<String>>(
  FavoriteRestaurantIdsNotifier.new,
);

/// IDs of menu items the current consumer has favorited.
class FavoriteMenuItemIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return const <String>{};

    final client = ref.watch(supabaseClientProvider);
    final data = await client
        .from('customer_favorite_items')
        .select('menu_item_id')
        .eq('customer_id', userId);

    return (data as List).map((row) => row['menu_item_id'] as String).toSet();
  }

  void overwrite(Set<String> next) => state = AsyncData(next);
}

final favoriteMenuItemIdsProvider = AsyncNotifierProvider<
    FavoriteMenuItemIdsNotifier, Set<String>>(
  FavoriteMenuItemIdsNotifier.new,
);

// ============================================================================
// Full lists for the Preferiti page
// ============================================================================

/// Restaurants the current consumer has favorited (newest first).
final favoriteRestaurantsProvider =
    FutureProvider<List<Tenant>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const <Tenant>[];

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('customer_favorite_restaurants')
      .select('created_at, tenants!inner(*)')
      .eq('customer_id', userId)
      .order('created_at', ascending: false);

  return (data as List)
      .map((row) => Tenant.fromJson(row['tenants'] as Map<String, dynamic>))
      .toList();
});

/// Menu items the current consumer has favorited (newest first), with the
/// restaurant they belong to.
final favoriteMenuItemsProvider =
    FutureProvider<List<FavoriteMenuItem>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const <FavoriteMenuItem>[];

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('customer_favorite_items')
      .select('created_at, menu_items!inner(*), tenants!inner(id, name)')
      .eq('customer_id', userId)
      .order('created_at', ascending: false);

  return (data as List).map((row) {
    final item = MenuItem.fromJson(row['menu_items'] as Map<String, dynamic>);
    final tenant = row['tenants'] as Map<String, dynamic>;
    return FavoriteMenuItem(
      item: item,
      restaurantId: tenant['id'] as String,
      restaurantName: tenant['name'] as String,
    );
  }).toList();
});

// ============================================================================
// Mutation controller
// ============================================================================

class FavoritesController {
  FavoritesController(this._ref);
  final Ref _ref;

  Future<void> toggleRestaurant(String tenantId) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) return;
    final client = _ref.read(supabaseClientProvider);
    final notifier = _ref.read(favoriteRestaurantIdsProvider.notifier);

    final current = _ref.read(favoriteRestaurantIdsProvider).valueOrNull ??
        const <String>{};
    final wasLiked = current.contains(tenantId);
    final next = wasLiked
        ? (current.toSet()..remove(tenantId))
        : (current.toSet()..add(tenantId));
    notifier.overwrite(next);

    try {
      if (wasLiked) {
        await client
            .from('customer_favorite_restaurants')
            .delete()
            .eq('customer_id', userId)
            .eq('tenant_id', tenantId);
      } else {
        await client.from('customer_favorite_restaurants').insert({
          'customer_id': userId,
          'tenant_id': tenantId,
        });
      }
      _ref.invalidate(favoriteRestaurantsProvider);
    } catch (_) {
      notifier.overwrite(current);
    }
  }

  Future<void> toggleMenuItem({
    required String menuItemId,
    required String tenantId,
  }) async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) return;
    final client = _ref.read(supabaseClientProvider);
    final notifier = _ref.read(favoriteMenuItemIdsProvider.notifier);

    final current =
        _ref.read(favoriteMenuItemIdsProvider).valueOrNull ?? const <String>{};
    final wasLiked = current.contains(menuItemId);
    final next = wasLiked
        ? (current.toSet()..remove(menuItemId))
        : (current.toSet()..add(menuItemId));
    notifier.overwrite(next);

    try {
      if (wasLiked) {
        await client
            .from('customer_favorite_items')
            .delete()
            .eq('customer_id', userId)
            .eq('menu_item_id', menuItemId);
      } else {
        await client.from('customer_favorite_items').insert({
          'customer_id': userId,
          'menu_item_id': menuItemId,
          'tenant_id': tenantId,
        });
      }
      _ref.invalidate(favoriteMenuItemsProvider);
    } catch (_) {
      notifier.overwrite(current);
    }
  }
}

final favoritesControllerProvider = Provider<FavoritesController>(
  (ref) => FavoritesController(ref),
);
