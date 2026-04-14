// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  logoUrl: json['logo_url'] as String?,
  coverImageUrl: json['cover_image_url'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  openingHours: json['opening_hours'] as Map<String, dynamic>?,
  settings: json['settings'] as Map<String, dynamic>?,
  deliveryEnabled: json['delivery_enabled'] as bool? ?? false,
  deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
  deliveryRadiusKm: (json['delivery_radius_km'] as num?)?.toDouble() ?? 5.0,
  deliveryMinOrder: (json['delivery_min_order'] as num?)?.toDouble() ?? 0,
  deliveryEstimatedTimeMin:
      (json['delivery_estimated_time_min'] as num?)?.toInt() ?? 45,
  stripeAccountId: json['stripe_account_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'cover_image_url': instance.coverImageUrl,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'opening_hours': instance.openingHours,
      'settings': instance.settings,
      'delivery_enabled': instance.deliveryEnabled,
      'delivery_fee': instance.deliveryFee,
      'delivery_radius_km': instance.deliveryRadiusKm,
      'delivery_min_order': instance.deliveryMinOrder,
      'delivery_estimated_time_min': instance.deliveryEstimatedTimeMin,
      'stripe_account_id': instance.stripeAccountId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
