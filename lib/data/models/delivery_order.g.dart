// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryOrderImpl _$$DeliveryOrderImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryOrderImpl(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      customerId: json['customer_id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String? ?? 'pending',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      deliveryStreet: json['delivery_street'] as String,
      deliveryCity: json['delivery_city'] as String,
      deliveryPostalCode: json['delivery_postal_code'] as String,
      deliveryProvince: json['delivery_province'] as String?,
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble(),
      deliveryNotes: json['delivery_notes'] as String?,
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
      estimatedDeliveryAt: json['estimated_delivery_at'] == null
          ? null
          : DateTime.parse(json['estimated_delivery_at'] as String),
    );

Map<String, dynamic> _$$DeliveryOrderImplToJson(_$DeliveryOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'customer_id': instance.customerId,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'delivery_fee': instance.deliveryFee,
      'discount': instance.discount,
      'total': instance.total,
      'notes': instance.notes,
      'delivery_street': instance.deliveryStreet,
      'delivery_city': instance.deliveryCity,
      'delivery_postal_code': instance.deliveryPostalCode,
      'delivery_province': instance.deliveryProvince,
      'delivery_latitude': instance.deliveryLatitude,
      'delivery_longitude': instance.deliveryLongitude,
      'delivery_notes': instance.deliveryNotes,
      'stripe_payment_intent_id': instance.stripePaymentIntentId,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'estimated_delivery_at': instance.estimatedDeliveryAt?.toIso8601String(),
    };
