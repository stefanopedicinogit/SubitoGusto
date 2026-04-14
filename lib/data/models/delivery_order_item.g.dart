// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryOrderItemImpl _$$DeliveryOrderItemImplFromJson(
  Map<String, dynamic> json,
) => _$DeliveryOrderItemImpl(
  id: json['id'] as String,
  deliveryOrderId: json['delivery_order_id'] as String,
  menuItemId: json['menu_item_id'] as String?,
  menuItemName: json['menu_item_name'] as String,
  unitPrice: (json['unit_price'] as num).toDouble(),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  notes: json['notes'] as String?,
  status: json['status'] as String? ?? 'pending',
  fixedMenuId: json['fixed_menu_id'] as String?,
  fixedMenuSelections: json['fixed_menu_selections'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$DeliveryOrderItemImplToJson(
  _$DeliveryOrderItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'delivery_order_id': instance.deliveryOrderId,
  'menu_item_id': instance.menuItemId,
  'menu_item_name': instance.menuItemName,
  'unit_price': instance.unitPrice,
  'quantity': instance.quantity,
  'notes': instance.notes,
  'status': instance.status,
  'fixed_menu_id': instance.fixedMenuId,
  'fixed_menu_selections': instance.fixedMenuSelections,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
