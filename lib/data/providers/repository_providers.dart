import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/supabase_repository.dart';
import 'supabase_provider.dart';
import 'settings_provider.dart';
import 'notifications_provider.dart';

// ============================================================================
// Repository Providers
// ============================================================================

/// Tenant repository provider
final tenantRepositoryProvider = Provider<SupabaseRepository<Tenant>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseRepository<Tenant>(
    client: client,
    tableName: 'tenants',
    fromJson: Tenant.fromJson,
    toJson: (t) => t.toJson(),
  );
});

/// Category repository provider
final categoryRepositoryProvider = Provider<SupabaseRepository<Category>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<Category>(
    client: client,
    tableName: 'categories',
    fromJson: Category.fromJson,
    toJson: (c) => c.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

/// MenuItem repository provider
final menuItemRepositoryProvider = Provider<SupabaseRepository<MenuItem>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<MenuItem>(
    client: client,
    tableName: 'menu_items',
    fromJson: MenuItem.fromJson,
    toJson: (m) => m.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

/// Table repository provider
final tableRepositoryProvider = Provider<SupabaseRepository<RestaurantTable>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<RestaurantTable>(
    client: client,
    tableName: 'tables',
    fromJson: RestaurantTable.fromJson,
    toJson: (t) => t.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

/// Order repository provider
final orderRepositoryProvider = Provider<SupabaseRepository<Order>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<Order>(
    client: client,
    tableName: 'orders',
    fromJson: Order.fromJson,
    toJson: (o) => o.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

/// OrderItem repository provider
final orderItemRepositoryProvider = Provider<SupabaseRepository<OrderItem>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseRepository<OrderItem>(
    client: client,
    tableName: 'order_items',
    fromJson: OrderItem.fromJson,
    toJson: (oi) => oi.toJson(),
  );
});

/// User repository provider
final userRepositoryProvider = Provider<SupabaseRepository<AppUser>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<AppUser>(
    client: client,
    tableName: 'users',
    fromJson: AppUser.fromJson,
    toJson: (u) => u.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

// ============================================================================
// Data Providers (FutureProvider)
// ============================================================================

/// Current tenant provider
final tenantProvider = FutureProvider<Tenant?>((ref) async {
  final tenantId = ref.watch(currentTenantIdProvider);
  if (tenantId == null) return null;

  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getById(tenantId);
});

/// Tenant by ID provider (for customer-facing pages)
final tenantByIdProvider = FutureProvider.family<Tenant?, String>((ref, tenantId) async {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getById(tenantId);
});

/// Categories list provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  ref.watch(supabaseAuthProvider); // Refresh on auth change
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getAll(orderBy: 'sort_order');
});

/// Active categories provider
final activeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories.where((c) => c.isActive).toList();
});

/// Menu items provider
final menuItemsProvider = FutureProvider<List<MenuItem>>((ref) async {
  ref.watch(supabaseAuthProvider);
  final repo = ref.watch(menuItemRepositoryProvider);
  return repo.getAll(orderBy: 'sort_order');
});

/// Active menu items provider
final activeMenuItemsProvider = FutureProvider<List<MenuItem>>((ref) async {
  final items = await ref.watch(menuItemsProvider.future);
  return items.where((m) => m.isActive && m.isAvailable).toList();
});

/// Menu items by category provider
final menuItemsByCategoryProvider = FutureProvider.family<List<MenuItem>, String>((ref, categoryId) async {
  final items = await ref.watch(menuItemsProvider.future);
  return items.where((m) => m.categoryId == categoryId).toList();
});

/// Tables provider
final tablesProvider = FutureProvider<List<RestaurantTable>>((ref) async {
  ref.watch(supabaseAuthProvider);
  final repo = ref.watch(tableRepositoryProvider);
  return repo.getAll(orderBy: 'name');
});

/// Active tables provider
final activeTablesProvider = FutureProvider<List<RestaurantTable>>((ref) async {
  final tables = await ref.watch(tablesProvider.future);
  return tables.where((t) => t.isActive).toList();
});

/// Orders provider (active orders)
final activeOrdersProvider = FutureProvider<List<Order>>((ref) async {
  ref.watch(supabaseAuthProvider);
  final repo = ref.watch(orderRepositoryProvider);
  return repo.query(
    inList: {'status': ['pending', 'confirmed', 'preparing', 'ready']},
    orderBy: 'created_at',
    ascending: false,
  );
});

/// All orders provider
final ordersProvider = FutureProvider<List<Order>>((ref) async {
  ref.watch(supabaseAuthProvider);
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getAll(orderBy: 'created_at', ascending: false);
});

/// Order items by order provider
final orderItemsByOrderProvider = FutureProvider.family<List<OrderItem>, String>((ref, orderId) async {
  final repo = ref.watch(orderItemRepositoryProvider);
  return repo.query(equals: {'order_id': orderId}, orderBy: 'created_at');
});

// ============================================================================
// Stream Providers (Realtime)
// ============================================================================

/// Realtime orders stream
final ordersStreamProvider = StreamProvider<List<Order>>((ref) {
  ref.watch(supabaseAuthProvider); // Refresh stream on auth change
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('orders')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => Order.fromJson(json)).toList());
});

/// Realtime active orders stream
final activeOrdersStreamProvider = StreamProvider<List<Order>>((ref) {
  final ordersAsync = ref.watch(ordersStreamProvider);
  return ordersAsync.when(
    data: (orders) => Stream.value(
      orders.where((o) => o.isActive).toList(),
    ),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

/// Realtime tables stream
final tablesStreamProvider = StreamProvider<List<RestaurantTable>>((ref) {
  ref.watch(supabaseAuthProvider); // Refresh stream on auth change
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('tables')
      .stream(primaryKey: ['id'])
      .order('name', ascending: true)
      .map((data) => data.map((json) => RestaurantTable.fromJson(json)).toList());
});

/// Realtime categories stream
final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  ref.watch(supabaseAuthProvider); // Refresh stream on auth change
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('categories')
      .stream(primaryKey: ['id'])
      .order('sort_order')
      .map((data) {
        final categories = data.map((json) => Category.fromJson(json)).toList();
        // Sort by sortOrder ascending (Antipasti first, Bevande last)
        categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return categories;
      });
});

/// Realtime menu items stream
final menuItemsStreamProvider = StreamProvider<List<MenuItem>>((ref) {
  ref.watch(supabaseAuthProvider); // Refresh stream on auth change
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('menu_items')
      .stream(primaryKey: ['id'])
      .order('sort_order')
      .map((data) => data.map((json) => MenuItem.fromJson(json)).toList());
});

// ============================================================================
// Single Item Providers
// ============================================================================

/// Single category provider
final categoryProvider = FutureProvider.family<Category?, String>((ref, id) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getById(id);
});

/// Single menu item provider
final menuItemProvider = FutureProvider.family<MenuItem?, String>((ref, id) async {
  final repo = ref.watch(menuItemRepositoryProvider);
  return repo.getById(id);
});

/// Single table provider
final tableProvider = FutureProvider.family<RestaurantTable?, String>((ref, id) async {
  final repo = ref.watch(tableRepositoryProvider);
  return repo.getById(id);
});

/// Table by QR code provider
final tableByQrCodeProvider = FutureProvider.family<RestaurantTable?, String>((ref, qrCode) async {
  final repo = ref.watch(tableRepositoryProvider);
  final tables = await repo.query(equals: {'qr_code': qrCode});
  return tables.isEmpty ? null : tables.first;
});

/// Single order provider
final orderProvider = FutureProvider.family<Order?, String>((ref, id) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getById(id);
});

/// Current user provider
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final repo = ref.watch(userRepositoryProvider);
  return repo.getById(userId);
});

/// Users list provider (for admin user management)
final usersListProvider = FutureProvider<List<AppUser>>((ref) async {
  ref.watch(supabaseAuthProvider); // Refresh on auth change
  final repo = ref.watch(userRepositoryProvider);
  return repo.getAll(orderBy: 'created_at', ascending: false);
});

// ============================================================================
// Order Notification Listener
// ============================================================================

/// Tracks known order IDs to detect new orders
final _knownOrderIdsProvider = StateProvider<Set<String>>((ref) {
  // Reset known IDs when auth changes
  ref.watch(supabaseAuthProvider);
  return {};
});

/// Order notification listener - watches for new orders and triggers notifications
final orderNotificationListenerProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider);
  final authState = ref.watch(supabaseAuthProvider);

  // Clear notifications when auth changes (logout/login)
  ref.listen<AsyncValue<AuthState>>(supabaseAuthProvider, (previous, next) {
    final prevUser = previous?.valueOrNull?.user?.id;
    final nextUser = next.valueOrNull?.user?.id;
    if (prevUser != nextUser) {
      // User changed - clear notifications and known IDs
      ref.read(notificationsProvider.notifier).clearAll();
      ref.read(_knownOrderIdsProvider.notifier).state = {};
    }
  });

  if (!settings.orderNotifications) return;
  if (authState.valueOrNull?.isAuthenticated != true) return;

  ref.listen<AsyncValue<List<Order>>>(ordersStreamProvider, (previous, next) {
    next.whenData((orders) async {
      final knownIds = ref.read(_knownOrderIdsProvider);
      final currentIds = orders.map((o) => o.id).toSet();

      // Find new pending orders
      for (final order in orders) {
        if (!knownIds.contains(order.id) && order.status == 'pending') {
          // This is a new order - trigger notification
          ref.read(notificationsProvider.notifier).addNotification(
            title: 'Nuovo Ordine',
            message: 'Ordine #${order.orderNumber} - ${order.total.toStringAsFixed(2)}€',
            type: 'order',
            orderId: order.id,
          );

          // Auto-confirm order if enabled
          if (settings.autoConfirmOrders) {
            try {
              final orderRepo = ref.read(orderRepositoryProvider);
              await orderRepo.update(
                order.id,
                order.copyWith(status: 'confirmed'),
              );
            } catch (e) {
              // Silently fail - order will remain pending
            }
          }
        }
      }

      // Update known IDs
      ref.read(_knownOrderIdsProvider.notifier).state = currentIds;
    });
  });
});
