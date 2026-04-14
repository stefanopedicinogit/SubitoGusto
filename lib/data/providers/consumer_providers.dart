import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer.dart';
import '../models/delivery_address.dart';
import '../models/delivery_order.dart';
import '../models/tenant.dart';
import '../models/category.dart';
import '../models/menu_item.dart';
import 'supabase_provider.dart';

// ============================================================================
// Customer Profile
// ============================================================================

/// Current consumer's profile
final customerProfileProvider = FutureProvider<Customer?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('customers')
      .select()
      .eq('id', userId)
      .maybeSingle();

  if (data == null) return null;
  return Customer.fromJson(data);
});

// ============================================================================
// Delivery Addresses
// ============================================================================

/// Consumer's saved delivery addresses
final deliveryAddressesProvider = FutureProvider<List<DeliveryAddress>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('delivery_addresses')
      .select()
      .eq('customer_id', userId)
      .order('is_default', ascending: false)
      .order('created_at', ascending: false);

  return (data as List).map((json) => DeliveryAddress.fromJson(json)).toList();
});

/// Consumer's default delivery address
final defaultDeliveryAddressProvider = Provider<DeliveryAddress?>((ref) {
  final addresses = ref.watch(deliveryAddressesProvider).valueOrNull ?? [];
  if (addresses.isEmpty) return null;
  return addresses.firstWhere(
    (a) => a.isDefault,
    orElse: () => addresses.first,
  );
});

// ============================================================================
// Marketplace
// ============================================================================

/// All delivery-enabled restaurants (no tenant filtering)
final marketplaceRestaurantsProvider = FutureProvider<List<Tenant>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('tenants')
      .select()
      .eq('delivery_enabled', true)
      .order('name');

  return (data as List).map((json) => Tenant.fromJson(json)).toList();
});

/// Menu categories for a specific restaurant
final restaurantCategoriesProvider =
    FutureProvider.family<List<Category>, String>((ref, restaurantId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('categories')
      .select()
      .eq('tenant_id', restaurantId)
      .eq('is_active', true)
      .order('sort_order');

  return (data as List).map((json) => Category.fromJson(json)).toList();
});

/// Menu items for a specific restaurant
final restaurantMenuItemsProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, restaurantId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('menu_items')
      .select()
      .eq('tenant_id', restaurantId)
      .eq('is_active', true)
      .eq('is_available', true)
      .order('sort_order');

  return (data as List).map((json) => MenuItem.fromJson(json)).toList();
});

/// Single restaurant detail
final restaurantDetailProvider =
    FutureProvider.family<Tenant?, String>((ref, restaurantId) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('tenants')
      .select()
      .eq('id', restaurantId)
      .maybeSingle();

  if (data == null) return null;
  return Tenant.fromJson(data);
});

// ============================================================================
// Consumer Orders
// ============================================================================

/// Consumer's delivery order history
final consumerOrderHistoryProvider = FutureProvider<List<DeliveryOrder>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('delivery_orders')
      .select()
      .eq('customer_id', userId)
      .order('created_at', ascending: false);

  return (data as List).map((json) => DeliveryOrder.fromJson(json)).toList();
});

/// Active delivery orders for the consumer (realtime)
final activeDeliveryOrdersProvider = StreamProvider<List<DeliveryOrder>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);

  final client = ref.watch(supabaseClientProvider);
  return client
      .from('delivery_orders')
      .stream(primaryKey: ['id'])
      .eq('customer_id', userId)
      .map((data) => data
          .map((json) => DeliveryOrder.fromJson(json))
          .where((o) => o.isActive)
          .toList());
});
