import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer.dart';
import '../models/delivery_address.dart';
import '../models/delivery_order.dart';
import '../models/tenant.dart';
import '../models/category.dart';
import '../models/menu_item.dart';
import 'supabase_provider.dart';
import 'notifications_provider.dart';

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

/// Consumer's full delivery order list — realtime stream so status changes
/// (e.g. confirmed → delivering → delivered) update the UI instantly.
final consumerOrderHistoryProvider = StreamProvider<List<DeliveryOrder>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);

  final client = ref.watch(supabaseClientProvider);
  return client
      .from('delivery_orders')
      .stream(primaryKey: ['id'])
      .eq('customer_id', userId)
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => DeliveryOrder.fromJson(json)).toList());
});

/// Active delivery orders for the consumer (subset of the stream above).
final activeDeliveryOrdersProvider = StreamProvider<List<DeliveryOrder>>((ref) {
  return ref.watch(consumerOrderHistoryProvider.stream).map(
        (orders) => orders.where((o) => o.isActive).toList(),
      );
});

// ── Consumer in-app notification listener ───────────────────────────────────

/// Tracks the last-known status per order so we can detect changes.
final _consumerKnownStatusesProvider =
    StateProvider<Map<String, String>>((ref) {
  ref.watch(currentUserIdProvider); // reset on user change
  return {};
});

/// Watches the consumer's active orders realtime stream and fires a
/// [NotificationBell] notification whenever a status advances.
final consumerOrderNotificationListenerProvider = Provider<void>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return;

  ref.listen<AsyncValue<List<DeliveryOrder>>>(
    consumerOrderHistoryProvider,
    (_, next) {
      next.whenData((orders) {
        final known = Map<String, String>.from(
            ref.read(_consumerKnownStatusesProvider));
        bool changed = false;

        for (final order in orders) {
          final prev = known[order.id];
          if (prev != null && prev != order.status) {
            // Status advanced — fire bell notification
            ref.read(notificationsProvider.notifier).addNotification(
              title: 'Order #${order.orderNumber}',
              message: _consumerStatusMessage(order.status),
              type: 'order',
              orderId: order.id,
            );
          }
          known[order.id] = order.status;
          changed = true;
        }

        if (changed) {
          ref.read(_consumerKnownStatusesProvider.notifier).state = known;
        }
      });
    },
  );
});

String _consumerStatusMessage(String status) {
  switch (status) {
    case 'confirmed':
      return 'Your order has been accepted by the restaurant.';
    case 'preparing':
      return 'The restaurant is preparing your order.';
    case 'ready_for_delivery':
      return 'Your order is ready and waiting for the courier.';
    case 'out_for_delivery':
      return 'The courier is on the way!';
    case 'delivered':
      return 'Your order has been delivered. Enjoy!';
    case 'cancelled':
      return 'Your order has been cancelled.';
    case 'refunded':
      return 'A refund has been issued for your order.';
    default:
      return 'Order status updated.';
  }
}
