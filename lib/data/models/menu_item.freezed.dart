// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) {
  return _MenuItem.fromJson(json);
}

/// @nodoc
mixin _$MenuItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  String get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparation_time')
  int? get preparationTime => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MenuItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuItemCopyWith<MenuItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuItemCopyWith<$Res> {
  factory $MenuItemCopyWith(MenuItem value, $Res Function(MenuItem) then) =
      _$MenuItemCopyWithImpl<$Res, MenuItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    @JsonKey(name: 'category_id') String categoryId,
    String name,
    String? description,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String> allergens,
    List<String> tags,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'preparation_time') int? preparationTime,
    int? calories,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$MenuItemCopyWithImpl<$Res, $Val extends MenuItem>
    implements $MenuItemCopyWith<$Res> {
  _$MenuItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? categoryId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? allergens = null,
    Object? tags = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? preparationTime = freezed,
    Object? calories = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            allergens: null == allergens
                ? _value.allergens
                : allergens // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            preparationTime: freezed == preparationTime
                ? _value.preparationTime
                : preparationTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MenuItemImplCopyWith<$Res>
    implements $MenuItemCopyWith<$Res> {
  factory _$$MenuItemImplCopyWith(
    _$MenuItemImpl value,
    $Res Function(_$MenuItemImpl) then,
  ) = __$$MenuItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    @JsonKey(name: 'category_id') String categoryId,
    String name,
    String? description,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    List<String> allergens,
    List<String> tags,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'preparation_time') int? preparationTime,
    int? calories,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$MenuItemImplCopyWithImpl<$Res>
    extends _$MenuItemCopyWithImpl<$Res, _$MenuItemImpl>
    implements _$$MenuItemImplCopyWith<$Res> {
  __$$MenuItemImplCopyWithImpl(
    _$MenuItemImpl _value,
    $Res Function(_$MenuItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? categoryId = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? allergens = null,
    Object? tags = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? preparationTime = freezed,
    Object? calories = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MenuItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        allergens: null == allergens
            ? _value._allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        preparationTime: freezed == preparationTime
            ? _value.preparationTime
            : preparationTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuItemImpl extends _MenuItem {
  const _$MenuItemImpl({
    required this.id,
    @JsonKey(name: 'tenant_id') required this.tenantId,
    @JsonKey(name: 'category_id') required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    @JsonKey(name: 'image_url') this.imageUrl,
    final List<String> allergens = const [],
    final List<String> tags = const [],
    @JsonKey(name: 'is_available') this.isAvailable = true,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'preparation_time') this.preparationTime,
    this.calories,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _allergens = allergens,
       _tags = tags,
       super._();

  factory _$MenuItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tenant_id')
  final String tenantId;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'preparation_time')
  final int? preparationTime;
  @override
  final int? calories;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MenuItem(id: $id, tenantId: $tenantId, categoryId: $categoryId, name: $name, description: $description, price: $price, imageUrl: $imageUrl, allergens: $allergens, tags: $tags, isAvailable: $isAvailable, isActive: $isActive, preparationTime: $preparationTime, calories: $calories, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(
              other._allergens,
              _allergens,
            ) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tenantId,
    categoryId,
    name,
    description,
    price,
    imageUrl,
    const DeepCollectionEquality().hash(_allergens),
    const DeepCollectionEquality().hash(_tags),
    isAvailable,
    isActive,
    preparationTime,
    calories,
    sortOrder,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuItemImplCopyWith<_$MenuItemImpl> get copyWith =>
      __$$MenuItemImplCopyWithImpl<_$MenuItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuItemImplToJson(this);
  }
}

abstract class _MenuItem extends MenuItem {
  const factory _MenuItem({
    required final String id,
    @JsonKey(name: 'tenant_id') required final String tenantId,
    @JsonKey(name: 'category_id') required final String categoryId,
    required final String name,
    final String? description,
    required final double price,
    @JsonKey(name: 'image_url') final String? imageUrl,
    final List<String> allergens,
    final List<String> tags,
    @JsonKey(name: 'is_available') final bool isAvailable,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'preparation_time') final int? preparationTime,
    final int? calories,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$MenuItemImpl;
  const _MenuItem._() : super._();

  factory _MenuItem.fromJson(Map<String, dynamic> json) =
      _$MenuItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tenant_id')
  String get tenantId;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  List<String> get allergens;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'preparation_time')
  int? get preparationTime;
  @override
  int? get calories;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of MenuItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuItemImplCopyWith<_$MenuItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
