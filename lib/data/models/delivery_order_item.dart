import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_order_item.freezed.dart';
part 'delivery_order_item.g.dart';

@freezed
class DeliveryOrderItem with _$DeliveryOrderItem {
  const DeliveryOrderItem._();

  const factory DeliveryOrderItem({
    required String id,
    @JsonKey(name: 'delivery_order_id') required String deliveryOrderId,
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
  }) = _DeliveryOrderItem;

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderItemFromJson(json);

  /// Whether this is a fixed menu item
  bool get isFixedMenu => fixedMenuId != null;

  /// Total price for this line item
  double get totalPrice => unitPrice * quantity;

  /// Format total price with currency
  String formatTotalPrice([String currency = '€']) =>
      '$currency ${totalPrice.toStringAsFixed(2)}';
}
