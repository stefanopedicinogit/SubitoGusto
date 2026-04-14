import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/delivery_address.dart';

/// Delivery cart item
class DeliveryCartItem {
  final MenuItem menuItem;
  final int quantity;
  final String? notes;

  const DeliveryCartItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  DeliveryCartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? notes,
  }) {
    return DeliveryCartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => menuItem.price * quantity;
}

/// Delivery cart state
class DeliveryCartState {
  /// Restaurant this cart belongs to
  final String? restaurantId;
  final String? restaurantName;
  final double deliveryFee;
  final double deliveryMinOrder;
  final List<DeliveryCartItem> items;
  final DeliveryAddress? deliveryAddress;

  const DeliveryCartState({
    this.restaurantId,
    this.restaurantName,
    this.deliveryFee = 0,
    this.deliveryMinOrder = 0,
    this.items = const [],
    this.deliveryAddress,
  });

  DeliveryCartState copyWith({
    String? restaurantId,
    String? restaurantName,
    double? deliveryFee,
    double? deliveryMinOrder,
    List<DeliveryCartItem>? items,
    DeliveryAddress? deliveryAddress,
  }) {
    return DeliveryCartState(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryMinOrder: deliveryMinOrder ?? this.deliveryMinOrder,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + deliveryFee;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  /// Whether the minimum order amount is met
  bool get meetsMinOrder => subtotal >= deliveryMinOrder;

  /// How much more is needed to meet minimum
  double get amountToMinOrder =>
      meetsMinOrder ? 0 : deliveryMinOrder - subtotal;

  String formatSubtotal([String currency = '€']) =>
      '$currency ${subtotal.toStringAsFixed(2)}';

  String formatTotal([String currency = '€']) =>
      '$currency ${total.toStringAsFixed(2)}';

  String formatDeliveryFee([String currency = '€']) =>
      deliveryFee > 0 ? '$currency ${deliveryFee.toStringAsFixed(2)}' : 'Gratis';
}

/// Delivery cart notifier
class DeliveryCartNotifier extends StateNotifier<DeliveryCartState> {
  DeliveryCartNotifier() : super(const DeliveryCartState());

  /// Set the restaurant for this cart. Clears items if switching restaurants.
  void setRestaurant({
    required String id,
    required String name,
    required double deliveryFee,
    required double deliveryMinOrder,
  }) {
    if (state.restaurantId != null && state.restaurantId != id) {
      // Switching restaurant — clear cart
      state = DeliveryCartState(
        restaurantId: id,
        restaurantName: name,
        deliveryFee: deliveryFee,
        deliveryMinOrder: deliveryMinOrder,
      );
    } else {
      state = state.copyWith(
        restaurantId: id,
        restaurantName: name,
        deliveryFee: deliveryFee,
        deliveryMinOrder: deliveryMinOrder,
      );
    }
  }

  /// Add item to cart
  void addItem(MenuItem menuItem, {int quantity = 1, String? notes}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.menuItem.id == menuItem.id && item.notes == notes,
    );

    if (existingIndex >= 0) {
      final updatedItems = [...state.items];
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          DeliveryCartItem(menuItem: menuItem, quantity: quantity, notes: notes),
        ],
      );
    }
  }

  /// Update item quantity
  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= state.items.length) return;

    if (quantity <= 0) {
      removeItem(index);
      return;
    }

    final updatedItems = [...state.items];
    updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);
    state = state.copyWith(items: updatedItems);
  }

  /// Remove item from cart
  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;

    final updatedItems = [...state.items];
    updatedItems.removeAt(index);
    state = state.copyWith(items: updatedItems);
  }

  /// Set delivery address
  void setDeliveryAddress(DeliveryAddress address) {
    state = state.copyWith(deliveryAddress: address);
  }

  /// Clear cart
  void clear() {
    state = const DeliveryCartState();
  }
}

/// Delivery cart provider
final deliveryCartProvider =
    StateNotifierProvider<DeliveryCartNotifier, DeliveryCartState>((ref) {
  return DeliveryCartNotifier();
});

/// Delivery cart item count (for badges)
final deliveryCartItemCountProvider = Provider<int>((ref) {
  return ref.watch(deliveryCartProvider).itemCount;
});

/// Delivery cart total
final deliveryCartTotalProvider = Provider<double>((ref) {
  return ref.watch(deliveryCartProvider).total;
});
