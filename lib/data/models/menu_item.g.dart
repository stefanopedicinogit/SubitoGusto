// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemImpl _$$MenuItemImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemImpl(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      allergens:
          (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isAvailable: json['is_available'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? true,
      preparationTime: (json['preparation_time'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MenuItemImplToJson(_$MenuItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'allergens': instance.allergens,
      'tags': instance.tags,
      'is_available': instance.isAvailable,
      'is_active': instance.isActive,
      'preparation_time': instance.preparationTime,
      'calories': instance.calories,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
