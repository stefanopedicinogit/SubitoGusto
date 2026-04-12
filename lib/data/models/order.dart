import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'table_id') required String tableId,
    @JsonKey(name: 'order_number') required String orderNumber,
    @Default('pending') String status,
    @Default(0) double subtotal,
    @Default(0) double discount,
    @Default(0) double total,
    String? notes,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  // Status checks
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isServed => status == 'served';
  bool get isPaid => status == 'paid';
  bool get isCancelled => status == 'cancelled';

  /// Check if order is active (not completed or cancelled)
  bool get isActive =>
      ['pending', 'confirmed', 'preparing', 'ready'].contains(status);

  /// Check if order can be modified
  bool get canBeModified => isPending;

  /// Check if order can be cancelled
  bool get canBeCancelled => isPending || isConfirmed;

  /// Get display status in Italian
  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'confirmed':
        return 'Confermato';
      case 'preparing':
        return 'In preparazione';
      case 'ready':
        return 'Pronto';
      case 'served':
        return 'Servito';
      case 'paid':
        return 'Pagato';
      case 'cancelled':
        return 'Annullato';
      default:
        return status;
    }
  }

  /// Format total with currency
  String formatTotal([String currency = '€']) =>
      '$currency ${total.toStringAsFixed(2)}';

  /// Calculate discount percentage if any
  double get discountPercentage =>
      subtotal > 0 ? (discount / subtotal) * 100 : 0;
}
