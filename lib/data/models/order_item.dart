import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const OrderItem._();

  const factory OrderItem({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'menu_item_id') String? menuItemId,
    @JsonKey(name: 'menu_item_name') required String menuItemName,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @Default(1) int quantity,
    String? notes,
    @Default('pending') String status,
    @JsonKey(name: 'fixed_menu_id') String? fixedMenuId,
    @JsonKey(name: 'fixed_menu_selections') Map<String, dynamic>? fixedMenuSelections,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Whether this is a fixed menu order item
  bool get isFixedMenu => fixedMenuId != null;

  /// Calculate total price for this item
  double get totalPrice => unitPrice * quantity;

  /// Format total price with currency
  String formatTotalPrice([String currency = '€']) =>
      '$currency ${totalPrice.toStringAsFixed(2)}';

  /// Format unit price with currency
  String formatUnitPrice([String currency = '€']) =>
      '$currency ${unitPrice.toStringAsFixed(2)}';

  // Status checks
  bool get isPending => status == 'pending';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isServed => status == 'served';

  /// Get display status in Italian
  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'preparing':
        return 'In preparazione';
      case 'ready':
        return 'Pronto';
      case 'served':
        return 'Servito';
      default:
        return status;
    }
  }
}
