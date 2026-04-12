// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  tableId: json['table_id'] as String,
  orderNumber: json['order_number'] as String,
  status: json['status'] as String? ?? 'pending',
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
  discount: (json['discount'] as num?)?.toDouble() ?? 0,
  total: (json['total'] as num?)?.toDouble() ?? 0,
  notes: json['notes'] as String?,
  customerName: json['customer_name'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  confirmedAt: json['confirmed_at'] == null
      ? null
      : DateTime.parse(json['confirmed_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'table_id': instance.tableId,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total': instance.total,
      'notes': instance.notes,
      'customer_name': instance.customerName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };
