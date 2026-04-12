import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/fixed_menu.dart';

/// Cart item with quantity
class CartItem {
  final MenuItem menuItem;
  final int quantity;
  final String? notes;

  const CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => menuItem.price * quantity;

  String formatTotalPrice([String currency = '€']) =>
      '$currency ${totalPrice.toStringAsFixed(2)}';
}

/// Fixed menu cart item with selections
class FixedMenuCartItem {
  final FixedMenuSelection selection;
  final int quantity;
  final String? notes; // Summary of selections

  const FixedMenuCartItem({
    required this.selection,
    this.quantity = 1,
    this.notes,
  });

  FixedMenuCartItem copyWith({
    FixedMenuSelection? selection,
    int? quantity,
    String? notes,
  }) {
    return FixedMenuCartItem(
      selection: selection ?? this.selection,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => selection.totalPrice * quantity;

  String formatTotalPrice([String currency = '€']) =>
      '$currency ${totalPrice.toStringAsFixed(2)}';
}

/// Cart state
class CartState {
  final String? tableId;
  final String? tableName;
  final String? tenantId;
  final List<CartItem> items;
  final List<FixedMenuCartItem> fixedMenuItems;
  final bool isSubmitting;
  final String? error;

  const CartState({
    this.tableId,
    this.tableName,
    this.tenantId,
    this.items = const [],
    this.fixedMenuItems = const [],
    this.isSubmitting = false,
    this.error,
  });

  CartState copyWith({
    String? tableId,
    String? tableName,
    String? tenantId,
    List<CartItem>? items,
    List<FixedMenuCartItem>? fixedMenuItems,
    bool? isSubmitting,
    String? error,
  }) {
    return CartState(
      tableId: tableId ?? this.tableId,
      tableName: tableName ?? this.tableName,
      tenantId: tenantId ?? this.tenantId,
      items: items ?? this.items,
      fixedMenuItems: fixedMenuItems ?? this.fixedMenuItems,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  int get itemCount {
    final regularCount = items.fold(0, (sum, item) => sum + item.quantity);
    final fixedCount = fixedMenuItems.fold(0, (sum, item) => sum + item.quantity);
    return regularCount + fixedCount;
  }

  double get subtotal {
    final regularTotal = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final fixedTotal = fixedMenuItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    return regularTotal + fixedTotal;
  }

  String formatSubtotal([String currency = '€']) =>
      '$currency ${subtotal.toStringAsFixed(2)}';

  bool get isEmpty => items.isEmpty && fixedMenuItems.isEmpty;

  bool get isNotEmpty => items.isNotEmpty || fixedMenuItems.isNotEmpty;
}

/// Cart notifier for state management
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  /// Set table info when customer scans QR
  void setTable(String tableId, String tableName, String tenantId) {
    state = state.copyWith(
      tableId: tableId,
      tableName: tableName,
      tenantId: tenantId,
    );
  }

  /// Add item to cart
  void addItem(MenuItem menuItem, {int quantity = 1, String? notes}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.menuItem.id == menuItem.id && item.notes == notes,
    );

    if (existingIndex >= 0) {
      // Update quantity if item exists
      final updatedItems = [...state.items];
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(menuItem: menuItem, quantity: quantity, notes: notes),
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

  /// Update item notes
  void updateNotes(int index, String? notes) {
    if (index < 0 || index >= state.items.length) return;

    final updatedItems = [...state.items];
    updatedItems[index] = updatedItems[index].copyWith(notes: notes);
    state = state.copyWith(items: updatedItems);
  }

  /// Add fixed menu to cart
  void addFixedMenu(FixedMenuSelection selection, String? selectionNotes) {
    state = state.copyWith(
      fixedMenuItems: [
        ...state.fixedMenuItems,
        FixedMenuCartItem(selection: selection, notes: selectionNotes),
      ],
    );
  }

  /// Update fixed menu quantity
  void updateFixedMenuQuantity(int index, int quantity) {
    if (index < 0 || index >= state.fixedMenuItems.length) return;

    if (quantity <= 0) {
      removeFixedMenu(index);
      return;
    }

    final updatedItems = [...state.fixedMenuItems];
    updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);
    state = state.copyWith(fixedMenuItems: updatedItems);
  }

  /// Remove fixed menu from cart
  void removeFixedMenu(int index) {
    if (index < 0 || index >= state.fixedMenuItems.length) return;

    final updatedItems = [...state.fixedMenuItems];
    updatedItems.removeAt(index);
    state = state.copyWith(fixedMenuItems: updatedItems);
  }

  /// Clear cart
  void clear() {
    state = CartState(
      tableId: state.tableId,
      tableName: state.tableName,
      tenantId: state.tenantId,
    );
  }

  /// Set submitting state
  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  /// Set error
  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}

/// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Cart item count provider (for badges)
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

/// Cart total provider
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});
