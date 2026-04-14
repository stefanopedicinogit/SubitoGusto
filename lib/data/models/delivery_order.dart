import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_order.freezed.dart';
part 'delivery_order.g.dart';

@freezed
class DeliveryOrder with _$DeliveryOrder {
  const DeliveryOrder._();

  const factory DeliveryOrder({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'order_number') required String orderNumber,
    @Default('pending') String status,
    @Default(0) double subtotal,
    @JsonKey(name: 'delivery_fee') @Default(0) double deliveryFee,
    @Default(0) double discount,
    @Default(0) double total,
    String? notes,
    // Delivery address snapshot
    @JsonKey(name: 'delivery_street') required String deliveryStreet,
    @JsonKey(name: 'delivery_city') required String deliveryCity,
    @JsonKey(name: 'delivery_postal_code') required String deliveryPostalCode,
    @JsonKey(name: 'delivery_province') String? deliveryProvince,
    @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,
    @JsonKey(name: 'delivery_notes') String? deliveryNotes,
    // Payment
    @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    // Timestamps
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'estimated_delivery_at') DateTime? estimatedDeliveryAt,
  }) = _DeliveryOrder;

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderFromJson(json);

  // Status checks
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReadyForDelivery => status == 'ready_for_delivery';
  bool get isOutForDelivery => status == 'out_for_delivery';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isRefunded => status == 'refunded';

  /// Whether the order is still active (not completed or cancelled)
  bool get isActive =>
      !isDelivered && !isCancelled && !isRefunded;

  // Payment checks
  bool get isPaid => paymentStatus == 'paid';
  bool get isPaymentFailed => paymentStatus == 'failed';

  /// Full delivery address
  String get deliveryFullAddress =>
      '$deliveryStreet, $deliveryPostalCode $deliveryCity';

  /// Format total with currency
  String formatTotal([String currency = '€']) =>
      '$currency ${total.toStringAsFixed(2)}';

  /// Status display name in Italian
  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'confirmed':
        return 'Confermato';
      case 'preparing':
        return 'In preparazione';
      case 'ready_for_delivery':
        return 'Pronto per la consegna';
      case 'out_for_delivery':
        return 'In consegna';
      case 'delivered':
        return 'Consegnato';
      case 'cancelled':
        return 'Annullato';
      case 'refunded':
        return 'Rimborsato';
      default:
        return status;
    }
  }
}
