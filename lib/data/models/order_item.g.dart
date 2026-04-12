// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      menuItemId: json['menu_item_id'] as String,
      menuItemName: json['menu_item_name'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'menu_item_id': instance.menuItemId,
      'menu_item_name': instance.menuItemName,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
