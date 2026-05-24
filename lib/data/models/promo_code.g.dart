// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromoCodeImpl _$$PromoCodeImplFromJson(Map<String, dynamic> json) =>
    _$PromoCodeImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      tenantId: json['tenant_id'] as String?,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      minOrder: (json['min_order'] as num?)?.toDouble() ?? 0,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: json['valid_until'] == null
          ? null
          : DateTime.parse(json['valid_until'] as String),
      maxUses: (json['max_uses'] as num?)?.toInt(),
      usesCount: (json['uses_count'] as num?)?.toInt() ?? 0,
      perCustomerLimit: (json['per_customer_limit'] as num?)?.toInt() ?? 1,
      active: json['active'] as bool? ?? true,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PromoCodeImplToJson(_$PromoCodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'tenant_id': instance.tenantId,
      'type': instance.type,
      'value': instance.value,
      'min_order': instance.minOrder,
      'valid_from': instance.validFrom.toIso8601String(),
      'valid_until': instance.validUntil?.toIso8601String(),
      'max_uses': instance.maxUses,
      'uses_count': instance.usesCount,
      'per_customer_limit': instance.perCustomerLimit,
      'active': instance.active,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
