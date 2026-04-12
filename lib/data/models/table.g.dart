// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantTableImpl(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  name: json['name'] as String,
  qrCode: json['qr_code'] as String,
  capacity: (json['capacity'] as num?)?.toInt() ?? 4,
  zone: json['zone'] as String?,
  status: json['status'] as String? ?? 'available',
  isActive: json['is_active'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$RestaurantTableImplToJson(
  _$RestaurantTableImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'name': instance.name,
  'qr_code': instance.qrCode,
  'capacity': instance.capacity,
  'zone': instance.zone,
  'status': instance.status,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
