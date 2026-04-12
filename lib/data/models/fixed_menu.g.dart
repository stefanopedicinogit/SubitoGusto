// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FixedMenuImpl _$$FixedMenuImplFromJson(Map<String, dynamic> json) =>
    _$FixedMenuImpl(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      price: (json['price'] as num).toDouble(),
      availableFor: json['available_for'] as String? ?? 'all',
      availableDays: (json['available_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      validFrom: json['valid_from'] == null
          ? null
          : DateTime.parse(json['valid_from'] as String),
      validTo: json['valid_to'] == null
          ? null
          : DateTime.parse(json['valid_to'] as String),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FixedMenuImplToJson(_$FixedMenuImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'available_for': instance.availableFor,
      'available_days': instance.availableDays,
      'valid_from': instance.validFrom?.toIso8601String(),
      'valid_to': instance.validTo?.toIso8601String(),
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$FixedMenuCourseImpl _$$FixedMenuCourseImplFromJson(
  Map<String, dynamic> json,
) => _$FixedMenuCourseImpl(
  id: json['id'] as String,
  fixedMenuId: json['fixed_menu_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isRequired: json['is_required'] as bool? ?? true,
  maxChoices: (json['max_choices'] as num?)?.toInt() ?? 1,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$FixedMenuCourseImplToJson(
  _$FixedMenuCourseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fixed_menu_id': instance.fixedMenuId,
  'name': instance.name,
  'description': instance.description,
  'sort_order': instance.sortOrder,
  'is_required': instance.isRequired,
  'max_choices': instance.maxChoices,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_$FixedMenuChoiceImpl _$$FixedMenuChoiceImplFromJson(
  Map<String, dynamic> json,
) => _$FixedMenuChoiceImpl(
  id: json['id'] as String,
  courseId: json['course_id'] as String,
  menuItemId: json['menu_item_id'] as String,
  menuItemName: json['menu_item_name'] as String,
  supplement: (json['supplement'] as num?)?.toDouble() ?? 0,
  isDefault: json['is_default'] as bool? ?? false,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isAvailable: json['is_available'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$FixedMenuChoiceImplToJson(
  _$FixedMenuChoiceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'course_id': instance.courseId,
  'menu_item_id': instance.menuItemId,
  'menu_item_name': instance.menuItemName,
  'supplement': instance.supplement,
  'is_default': instance.isDefault,
  'sort_order': instance.sortOrder,
  'is_available': instance.isAvailable,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_$FixedMenuSelectionImpl _$$FixedMenuSelectionImplFromJson(
  Map<String, dynamic> json,
) => _$FixedMenuSelectionImpl(
  fixedMenuId: json['fixedMenuId'] as String,
  fixedMenuName: json['fixedMenuName'] as String,
  basePrice: (json['basePrice'] as num).toDouble(),
  selections: (json['selections'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, SelectedChoice.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$$FixedMenuSelectionImplToJson(
  _$FixedMenuSelectionImpl instance,
) => <String, dynamic>{
  'fixedMenuId': instance.fixedMenuId,
  'fixedMenuName': instance.fixedMenuName,
  'basePrice': instance.basePrice,
  'selections': instance.selections,
};

_$SelectedChoiceImpl _$$SelectedChoiceImplFromJson(Map<String, dynamic> json) =>
    _$SelectedChoiceImpl(
      choiceId: json['choiceId'] as String,
      choiceName: json['choiceName'] as String,
      supplement: (json['supplement'] as num).toDouble(),
    );

Map<String, dynamic> _$$SelectedChoiceImplToJson(
  _$SelectedChoiceImpl instance,
) => <String, dynamic>{
  'choiceId': instance.choiceId,
  'choiceName': instance.choiceName,
  'supplement': instance.supplement,
};
