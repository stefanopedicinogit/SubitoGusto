// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryAddressImpl _$$DeliveryAddressImplFromJson(
  Map<String, dynamic> json,
) => _$DeliveryAddressImpl(
  id: json['id'] as String,
  customerId: json['customer_id'] as String,
  label: json['label'] as String? ?? 'Casa',
  street: json['street'] as String,
  city: json['city'] as String,
  postalCode: json['postal_code'] as String,
  province: json['province'] as String?,
  country: json['country'] as String? ?? 'IT',
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  isDefault: json['is_default'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$DeliveryAddressImplToJson(
  _$DeliveryAddressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customer_id': instance.customerId,
  'label': instance.label,
  'street': instance.street,
  'city': instance.city,
  'postal_code': instance.postalCode,
  'province': instance.province,
  'country': instance.country,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'notes': instance.notes,
  'is_default': instance.isDefault,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
