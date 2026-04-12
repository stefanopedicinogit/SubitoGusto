// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FixedMenu _$FixedMenuFromJson(Map<String, dynamic> json) {
  return _FixedMenu.fromJson(json);
}

/// @nodoc
mixin _$FixedMenu {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  String get tenantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Available times: 'lunch', 'dinner', 'all'
  @JsonKey(name: 'available_for')
  String get availableFor => throw _privateConstructorUsedError;

  /// Available days: null = all days, or ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
  @JsonKey(name: 'available_days')
  List<String>? get availableDays => throw _privateConstructorUsedError;

  /// Start date for availability (null = always)
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom => throw _privateConstructorUsedError;

  /// End date for availability (null = no end)
  @JsonKey(name: 'valid_to')
  DateTime? get validTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FixedMenu to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedMenu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedMenuCopyWith<FixedMenu> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedMenuCopyWith<$Res> {
  factory $FixedMenuCopyWith(FixedMenu value, $Res Function(FixedMenu) then) =
      _$FixedMenuCopyWithImpl<$Res, FixedMenu>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    double price,
    @JsonKey(name: 'available_for') String availableFor,
    @JsonKey(name: 'available_days') List<String>? availableDays,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_to') DateTime? validTo,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$FixedMenuCopyWithImpl<$Res, $Val extends FixedMenu>
    implements $FixedMenuCopyWith<$Res> {
  _$FixedMenuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedMenu
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? availableFor = null,
    Object? availableDays = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            availableFor: null == availableFor
                ? _value.availableFor
                : availableFor // ignore: cast_nullable_to_non_nullable
                      as String,
            availableDays: freezed == availableDays
                ? _value.availableDays
                : availableDays // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            validFrom: freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            validTo: freezed == validTo
                ? _value.validTo
                : validTo // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$FixedMenuImplCopyWith<$Res>
    implements $FixedMenuCopyWith<$Res> {
  factory _$$FixedMenuImplCopyWith(
    _$FixedMenuImpl value,
    $Res Function(_$FixedMenuImpl) then,
  ) = __$$FixedMenuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    double price,
    @JsonKey(name: 'available_for') String availableFor,
    @JsonKey(name: 'available_days') List<String>? availableDays,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_to') DateTime? validTo,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FixedMenuImplCopyWithImpl<$Res>
    extends _$FixedMenuCopyWithImpl<$Res, _$FixedMenuImpl>
    implements _$$FixedMenuImplCopyWith<$Res> {
  __$$FixedMenuImplCopyWithImpl(
    _$FixedMenuImpl _value,
    $Res Function(_$FixedMenuImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixedMenu
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? availableFor = null,
    Object? availableDays = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FixedMenuImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        availableFor: null == availableFor
            ? _value.availableFor
            : availableFor // ignore: cast_nullable_to_non_nullable
                  as String,
        availableDays: freezed == availableDays
            ? _value._availableDays
            : availableDays // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        validFrom: freezed == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        validTo: freezed == validTo
            ? _value.validTo
            : validTo // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$FixedMenuImpl extends _FixedMenu {
  const _$FixedMenuImpl({
    required this.id,
    @JsonKey(name: 'tenant_id') required this.tenantId,
    required this.name,
    this.description,
    @JsonKey(name: 'image_url') this.imageUrl,
    required this.price,
    @JsonKey(name: 'available_for') this.availableFor = 'all',
    @JsonKey(name: 'available_days') final List<String>? availableDays,
    @JsonKey(name: 'valid_from') this.validFrom,
    @JsonKey(name: 'valid_to') this.validTo,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _availableDays = availableDays,
       super._();

  factory _$FixedMenuImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedMenuImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tenant_id')
  final String tenantId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final double price;

  /// Available times: 'lunch', 'dinner', 'all'
  @override
  @JsonKey(name: 'available_for')
  final String availableFor;

  /// Available days: null = all days, or ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
  final List<String>? _availableDays;

  /// Available days: null = all days, or ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
  @override
  @JsonKey(name: 'available_days')
  List<String>? get availableDays {
    final value = _availableDays;
    if (value == null) return null;
    if (_availableDays is EqualUnmodifiableListView) return _availableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Start date for availability (null = always)
  @override
  @JsonKey(name: 'valid_from')
  final DateTime? validFrom;

  /// End date for availability (null = no end)
  @override
  @JsonKey(name: 'valid_to')
  final DateTime? validTo;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FixedMenu(id: $id, tenantId: $tenantId, name: $name, description: $description, imageUrl: $imageUrl, price: $price, availableFor: $availableFor, availableDays: $availableDays, validFrom: $validFrom, validTo: $validTo, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedMenuImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.availableFor, availableFor) ||
                other.availableFor == availableFor) &&
            const DeepCollectionEquality().equals(
              other._availableDays,
              _availableDays,
            ) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    name,
    description,
    imageUrl,
    price,
    availableFor,
    const DeepCollectionEquality().hash(_availableDays),
    validFrom,
    validTo,
    sortOrder,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FixedMenu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedMenuImplCopyWith<_$FixedMenuImpl> get copyWith =>
      __$$FixedMenuImplCopyWithImpl<_$FixedMenuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedMenuImplToJson(this);
  }
}

abstract class _FixedMenu extends FixedMenu {
  const factory _FixedMenu({
    required final String id,
    @JsonKey(name: 'tenant_id') required final String tenantId,
    required final String name,
    final String? description,
    @JsonKey(name: 'image_url') final String? imageUrl,
    required final double price,
    @JsonKey(name: 'available_for') final String availableFor,
    @JsonKey(name: 'available_days') final List<String>? availableDays,
    @JsonKey(name: 'valid_from') final DateTime? validFrom,
    @JsonKey(name: 'valid_to') final DateTime? validTo,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$FixedMenuImpl;
  const _FixedMenu._() : super._();

  factory _FixedMenu.fromJson(Map<String, dynamic> json) =
      _$FixedMenuImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tenant_id')
  String get tenantId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  double get price;

  /// Available times: 'lunch', 'dinner', 'all'
  @override
  @JsonKey(name: 'available_for')
  String get availableFor;

  /// Available days: null = all days, or ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
  @override
  @JsonKey(name: 'available_days')
  List<String>? get availableDays;

  /// Start date for availability (null = always)
  @override
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom;

  /// End date for availability (null = no end)
  @override
  @JsonKey(name: 'valid_to')
  DateTime? get validTo;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of FixedMenu
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedMenuImplCopyWith<_$FixedMenuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixedMenuCourse _$FixedMenuCourseFromJson(Map<String, dynamic> json) {
  return _FixedMenuCourse.fromJson(json);
}

/// @nodoc
mixin _$FixedMenuCourse {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fixed_menu_id')
  String get fixedMenuId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Whether customer must select from this course
  @JsonKey(name: 'is_required')
  bool get isRequired => throw _privateConstructorUsedError;

  /// Maximum number of choices (usually 1)
  @JsonKey(name: 'max_choices')
  int get maxChoices => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FixedMenuCourse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedMenuCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedMenuCourseCopyWith<FixedMenuCourse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedMenuCourseCopyWith<$Res> {
  factory $FixedMenuCourseCopyWith(
    FixedMenuCourse value,
    $Res Function(FixedMenuCourse) then,
  ) = _$FixedMenuCourseCopyWithImpl<$Res, FixedMenuCourse>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'fixed_menu_id') String fixedMenuId,
    String name,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'max_choices') int maxChoices,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$FixedMenuCourseCopyWithImpl<$Res, $Val extends FixedMenuCourse>
    implements $FixedMenuCourseCopyWith<$Res> {
  _$FixedMenuCourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedMenuCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fixedMenuId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isRequired = null,
    Object? maxChoices = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fixedMenuId: null == fixedMenuId
                ? _value.fixedMenuId
                : fixedMenuId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            maxChoices: null == maxChoices
                ? _value.maxChoices
                : maxChoices // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FixedMenuCourseImplCopyWith<$Res>
    implements $FixedMenuCourseCopyWith<$Res> {
  factory _$$FixedMenuCourseImplCopyWith(
    _$FixedMenuCourseImpl value,
    $Res Function(_$FixedMenuCourseImpl) then,
  ) = __$$FixedMenuCourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'fixed_menu_id') String fixedMenuId,
    String name,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_required') bool isRequired,
    @JsonKey(name: 'max_choices') int maxChoices,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FixedMenuCourseImplCopyWithImpl<$Res>
    extends _$FixedMenuCourseCopyWithImpl<$Res, _$FixedMenuCourseImpl>
    implements _$$FixedMenuCourseImplCopyWith<$Res> {
  __$$FixedMenuCourseImplCopyWithImpl(
    _$FixedMenuCourseImpl _value,
    $Res Function(_$FixedMenuCourseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixedMenuCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fixedMenuId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sortOrder = null,
    Object? isRequired = null,
    Object? maxChoices = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FixedMenuCourseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fixedMenuId: null == fixedMenuId
            ? _value.fixedMenuId
            : fixedMenuId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxChoices: null == maxChoices
            ? _value.maxChoices
            : maxChoices // ignore: cast_nullable_to_non_nullable
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
class _$FixedMenuCourseImpl extends _FixedMenuCourse {
  const _$FixedMenuCourseImpl({
    required this.id,
    @JsonKey(name: 'fixed_menu_id') required this.fixedMenuId,
    required this.name,
    this.description,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_required') this.isRequired = true,
    @JsonKey(name: 'max_choices') this.maxChoices = 1,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$FixedMenuCourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedMenuCourseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'fixed_menu_id')
  final String fixedMenuId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  /// Whether customer must select from this course
  @override
  @JsonKey(name: 'is_required')
  final bool isRequired;

  /// Maximum number of choices (usually 1)
  @override
  @JsonKey(name: 'max_choices')
  final int maxChoices;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FixedMenuCourse(id: $id, fixedMenuId: $fixedMenuId, name: $name, description: $description, sortOrder: $sortOrder, isRequired: $isRequired, maxChoices: $maxChoices, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedMenuCourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fixedMenuId, fixedMenuId) ||
                other.fixedMenuId == fixedMenuId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.maxChoices, maxChoices) ||
                other.maxChoices == maxChoices) &&
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
    fixedMenuId,
    name,
    description,
    sortOrder,
    isRequired,
    maxChoices,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FixedMenuCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedMenuCourseImplCopyWith<_$FixedMenuCourseImpl> get copyWith =>
      __$$FixedMenuCourseImplCopyWithImpl<_$FixedMenuCourseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedMenuCourseImplToJson(this);
  }
}

abstract class _FixedMenuCourse extends FixedMenuCourse {
  const factory _FixedMenuCourse({
    required final String id,
    @JsonKey(name: 'fixed_menu_id') required final String fixedMenuId,
    required final String name,
    final String? description,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_required') final bool isRequired,
    @JsonKey(name: 'max_choices') final int maxChoices,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$FixedMenuCourseImpl;
  const _FixedMenuCourse._() : super._();

  factory _FixedMenuCourse.fromJson(Map<String, dynamic> json) =
      _$FixedMenuCourseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'fixed_menu_id')
  String get fixedMenuId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Whether customer must select from this course
  @override
  @JsonKey(name: 'is_required')
  bool get isRequired;

  /// Maximum number of choices (usually 1)
  @override
  @JsonKey(name: 'max_choices')
  int get maxChoices;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of FixedMenuCourse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedMenuCourseImplCopyWith<_$FixedMenuCourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixedMenuChoice _$FixedMenuChoiceFromJson(Map<String, dynamic> json) {
  return _FixedMenuChoice.fromJson(json);
}

/// @nodoc
mixin _$FixedMenuChoice {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'menu_item_id')
  String get menuItemId => throw _privateConstructorUsedError;

  /// Cached name from menu item
  @JsonKey(name: 'menu_item_name')
  String get menuItemName => throw _privateConstructorUsedError;

  /// Extra cost for this choice (e.g., +€5 for premium)
  double get supplement => throw _privateConstructorUsedError;

  /// Whether this is the default selection
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FixedMenuChoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedMenuChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedMenuChoiceCopyWith<FixedMenuChoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedMenuChoiceCopyWith<$Res> {
  factory $FixedMenuChoiceCopyWith(
    FixedMenuChoice value,
    $Res Function(FixedMenuChoice) then,
  ) = _$FixedMenuChoiceCopyWithImpl<$Res, FixedMenuChoice>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'menu_item_id') String menuItemId,
    @JsonKey(name: 'menu_item_name') String menuItemName,
    double supplement,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$FixedMenuChoiceCopyWithImpl<$Res, $Val extends FixedMenuChoice>
    implements $FixedMenuChoiceCopyWith<$Res> {
  _$FixedMenuChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedMenuChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? menuItemId = null,
    Object? menuItemName = null,
    Object? supplement = null,
    Object? isDefault = null,
    Object? sortOrder = null,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItemId: null == menuItemId
                ? _value.menuItemId
                : menuItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItemName: null == menuItemName
                ? _value.menuItemName
                : menuItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            supplement: null == supplement
                ? _value.supplement
                : supplement // ignore: cast_nullable_to_non_nullable
                      as double,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$FixedMenuChoiceImplCopyWith<$Res>
    implements $FixedMenuChoiceCopyWith<$Res> {
  factory _$$FixedMenuChoiceImplCopyWith(
    _$FixedMenuChoiceImpl value,
    $Res Function(_$FixedMenuChoiceImpl) then,
  ) = __$$FixedMenuChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'menu_item_id') String menuItemId,
    @JsonKey(name: 'menu_item_name') String menuItemName,
    double supplement,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'sort_order') int sortOrder,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FixedMenuChoiceImplCopyWithImpl<$Res>
    extends _$FixedMenuChoiceCopyWithImpl<$Res, _$FixedMenuChoiceImpl>
    implements _$$FixedMenuChoiceImplCopyWith<$Res> {
  __$$FixedMenuChoiceImplCopyWithImpl(
    _$FixedMenuChoiceImpl _value,
    $Res Function(_$FixedMenuChoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixedMenuChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? menuItemId = null,
    Object? menuItemName = null,
    Object? supplement = null,
    Object? isDefault = null,
    Object? sortOrder = null,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FixedMenuChoiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItemId: null == menuItemId
            ? _value.menuItemId
            : menuItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItemName: null == menuItemName
            ? _value.menuItemName
            : menuItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        supplement: null == supplement
            ? _value.supplement
            : supplement // ignore: cast_nullable_to_non_nullable
                  as double,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$FixedMenuChoiceImpl extends _FixedMenuChoice {
  const _$FixedMenuChoiceImpl({
    required this.id,
    @JsonKey(name: 'course_id') required this.courseId,
    @JsonKey(name: 'menu_item_id') required this.menuItemId,
    @JsonKey(name: 'menu_item_name') required this.menuItemName,
    this.supplement = 0,
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    @JsonKey(name: 'is_available') this.isAvailable = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$FixedMenuChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedMenuChoiceImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  @JsonKey(name: 'menu_item_id')
  final String menuItemId;

  /// Cached name from menu item
  @override
  @JsonKey(name: 'menu_item_name')
  final String menuItemName;

  /// Extra cost for this choice (e.g., +€5 for premium)
  @override
  @JsonKey()
  final double supplement;

  /// Whether this is the default selection
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FixedMenuChoice(id: $id, courseId: $courseId, menuItemId: $menuItemId, menuItemName: $menuItemName, supplement: $supplement, isDefault: $isDefault, sortOrder: $sortOrder, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedMenuChoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.menuItemName, menuItemName) ||
                other.menuItemName == menuItemName) &&
            (identical(other.supplement, supplement) ||
                other.supplement == supplement) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
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
    courseId,
    menuItemId,
    menuItemName,
    supplement,
    isDefault,
    sortOrder,
    isAvailable,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FixedMenuChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedMenuChoiceImplCopyWith<_$FixedMenuChoiceImpl> get copyWith =>
      __$$FixedMenuChoiceImplCopyWithImpl<_$FixedMenuChoiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedMenuChoiceImplToJson(this);
  }
}

abstract class _FixedMenuChoice extends FixedMenuChoice {
  const factory _FixedMenuChoice({
    required final String id,
    @JsonKey(name: 'course_id') required final String courseId,
    @JsonKey(name: 'menu_item_id') required final String menuItemId,
    @JsonKey(name: 'menu_item_name') required final String menuItemName,
    final double supplement,
    @JsonKey(name: 'is_default') final bool isDefault,
    @JsonKey(name: 'sort_order') final int sortOrder,
    @JsonKey(name: 'is_available') final bool isAvailable,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$FixedMenuChoiceImpl;
  const _FixedMenuChoice._() : super._();

  factory _FixedMenuChoice.fromJson(Map<String, dynamic> json) =
      _$FixedMenuChoiceImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  @JsonKey(name: 'menu_item_id')
  String get menuItemId;

  /// Cached name from menu item
  @override
  @JsonKey(name: 'menu_item_name')
  String get menuItemName;

  /// Extra cost for this choice (e.g., +€5 for premium)
  @override
  double get supplement;

  /// Whether this is the default selection
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of FixedMenuChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedMenuChoiceImplCopyWith<_$FixedMenuChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixedMenuSelection _$FixedMenuSelectionFromJson(Map<String, dynamic> json) {
  return _FixedMenuSelection.fromJson(json);
}

/// @nodoc
mixin _$FixedMenuSelection {
  String get fixedMenuId => throw _privateConstructorUsedError;
  String get fixedMenuName => throw _privateConstructorUsedError;
  double get basePrice => throw _privateConstructorUsedError;

  /// Map of courseId -> selected choiceId
  Map<String, SelectedChoice> get selections =>
      throw _privateConstructorUsedError;

  /// Serializes this FixedMenuSelection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedMenuSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedMenuSelectionCopyWith<FixedMenuSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedMenuSelectionCopyWith<$Res> {
  factory $FixedMenuSelectionCopyWith(
    FixedMenuSelection value,
    $Res Function(FixedMenuSelection) then,
  ) = _$FixedMenuSelectionCopyWithImpl<$Res, FixedMenuSelection>;
  @useResult
  $Res call({
    String fixedMenuId,
    String fixedMenuName,
    double basePrice,
    Map<String, SelectedChoice> selections,
  });
}

/// @nodoc
class _$FixedMenuSelectionCopyWithImpl<$Res, $Val extends FixedMenuSelection>
    implements $FixedMenuSelectionCopyWith<$Res> {
  _$FixedMenuSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedMenuSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixedMenuId = null,
    Object? fixedMenuName = null,
    Object? basePrice = null,
    Object? selections = null,
  }) {
    return _then(
      _value.copyWith(
            fixedMenuId: null == fixedMenuId
                ? _value.fixedMenuId
                : fixedMenuId // ignore: cast_nullable_to_non_nullable
                      as String,
            fixedMenuName: null == fixedMenuName
                ? _value.fixedMenuName
                : fixedMenuName // ignore: cast_nullable_to_non_nullable
                      as String,
            basePrice: null == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            selections: null == selections
                ? _value.selections
                : selections // ignore: cast_nullable_to_non_nullable
                      as Map<String, SelectedChoice>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FixedMenuSelectionImplCopyWith<$Res>
    implements $FixedMenuSelectionCopyWith<$Res> {
  factory _$$FixedMenuSelectionImplCopyWith(
    _$FixedMenuSelectionImpl value,
    $Res Function(_$FixedMenuSelectionImpl) then,
  ) = __$$FixedMenuSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fixedMenuId,
    String fixedMenuName,
    double basePrice,
    Map<String, SelectedChoice> selections,
  });
}

/// @nodoc
class __$$FixedMenuSelectionImplCopyWithImpl<$Res>
    extends _$FixedMenuSelectionCopyWithImpl<$Res, _$FixedMenuSelectionImpl>
    implements _$$FixedMenuSelectionImplCopyWith<$Res> {
  __$$FixedMenuSelectionImplCopyWithImpl(
    _$FixedMenuSelectionImpl _value,
    $Res Function(_$FixedMenuSelectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixedMenuSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixedMenuId = null,
    Object? fixedMenuName = null,
    Object? basePrice = null,
    Object? selections = null,
  }) {
    return _then(
      _$FixedMenuSelectionImpl(
        fixedMenuId: null == fixedMenuId
            ? _value.fixedMenuId
            : fixedMenuId // ignore: cast_nullable_to_non_nullable
                  as String,
        fixedMenuName: null == fixedMenuName
            ? _value.fixedMenuName
            : fixedMenuName // ignore: cast_nullable_to_non_nullable
                  as String,
        basePrice: null == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        selections: null == selections
            ? _value._selections
            : selections // ignore: cast_nullable_to_non_nullable
                  as Map<String, SelectedChoice>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedMenuSelectionImpl extends _FixedMenuSelection {
  const _$FixedMenuSelectionImpl({
    required this.fixedMenuId,
    required this.fixedMenuName,
    required this.basePrice,
    required final Map<String, SelectedChoice> selections,
  }) : _selections = selections,
       super._();

  factory _$FixedMenuSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedMenuSelectionImplFromJson(json);

  @override
  final String fixedMenuId;
  @override
  final String fixedMenuName;
  @override
  final double basePrice;

  /// Map of courseId -> selected choiceId
  final Map<String, SelectedChoice> _selections;

  /// Map of courseId -> selected choiceId
  @override
  Map<String, SelectedChoice> get selections {
    if (_selections is EqualUnmodifiableMapView) return _selections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selections);
  }

  @override
  String toString() {
    return 'FixedMenuSelection(fixedMenuId: $fixedMenuId, fixedMenuName: $fixedMenuName, basePrice: $basePrice, selections: $selections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedMenuSelectionImpl &&
            (identical(other.fixedMenuId, fixedMenuId) ||
                other.fixedMenuId == fixedMenuId) &&
            (identical(other.fixedMenuName, fixedMenuName) ||
                other.fixedMenuName == fixedMenuName) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            const DeepCollectionEquality().equals(
              other._selections,
              _selections,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fixedMenuId,
    fixedMenuName,
    basePrice,
    const DeepCollectionEquality().hash(_selections),
  );

  /// Create a copy of FixedMenuSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedMenuSelectionImplCopyWith<_$FixedMenuSelectionImpl> get copyWith =>
      __$$FixedMenuSelectionImplCopyWithImpl<_$FixedMenuSelectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedMenuSelectionImplToJson(this);
  }
}

abstract class _FixedMenuSelection extends FixedMenuSelection {
  const factory _FixedMenuSelection({
    required final String fixedMenuId,
    required final String fixedMenuName,
    required final double basePrice,
    required final Map<String, SelectedChoice> selections,
  }) = _$FixedMenuSelectionImpl;
  const _FixedMenuSelection._() : super._();

  factory _FixedMenuSelection.fromJson(Map<String, dynamic> json) =
      _$FixedMenuSelectionImpl.fromJson;

  @override
  String get fixedMenuId;
  @override
  String get fixedMenuName;
  @override
  double get basePrice;

  /// Map of courseId -> selected choiceId
  @override
  Map<String, SelectedChoice> get selections;

  /// Create a copy of FixedMenuSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedMenuSelectionImplCopyWith<_$FixedMenuSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelectedChoice _$SelectedChoiceFromJson(Map<String, dynamic> json) {
  return _SelectedChoice.fromJson(json);
}

/// @nodoc
mixin _$SelectedChoice {
  String get choiceId => throw _privateConstructorUsedError;
  String get choiceName => throw _privateConstructorUsedError;
  double get supplement => throw _privateConstructorUsedError;

  /// Serializes this SelectedChoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedChoiceCopyWith<SelectedChoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedChoiceCopyWith<$Res> {
  factory $SelectedChoiceCopyWith(
    SelectedChoice value,
    $Res Function(SelectedChoice) then,
  ) = _$SelectedChoiceCopyWithImpl<$Res, SelectedChoice>;
  @useResult
  $Res call({String choiceId, String choiceName, double supplement});
}

/// @nodoc
class _$SelectedChoiceCopyWithImpl<$Res, $Val extends SelectedChoice>
    implements $SelectedChoiceCopyWith<$Res> {
  _$SelectedChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceId = null,
    Object? choiceName = null,
    Object? supplement = null,
  }) {
    return _then(
      _value.copyWith(
            choiceId: null == choiceId
                ? _value.choiceId
                : choiceId // ignore: cast_nullable_to_non_nullable
                      as String,
            choiceName: null == choiceName
                ? _value.choiceName
                : choiceName // ignore: cast_nullable_to_non_nullable
                      as String,
            supplement: null == supplement
                ? _value.supplement
                : supplement // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectedChoiceImplCopyWith<$Res>
    implements $SelectedChoiceCopyWith<$Res> {
  factory _$$SelectedChoiceImplCopyWith(
    _$SelectedChoiceImpl value,
    $Res Function(_$SelectedChoiceImpl) then,
  ) = __$$SelectedChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String choiceId, String choiceName, double supplement});
}

/// @nodoc
class __$$SelectedChoiceImplCopyWithImpl<$Res>
    extends _$SelectedChoiceCopyWithImpl<$Res, _$SelectedChoiceImpl>
    implements _$$SelectedChoiceImplCopyWith<$Res> {
  __$$SelectedChoiceImplCopyWithImpl(
    _$SelectedChoiceImpl _value,
    $Res Function(_$SelectedChoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? choiceId = null,
    Object? choiceName = null,
    Object? supplement = null,
  }) {
    return _then(
      _$SelectedChoiceImpl(
        choiceId: null == choiceId
            ? _value.choiceId
            : choiceId // ignore: cast_nullable_to_non_nullable
                  as String,
        choiceName: null == choiceName
            ? _value.choiceName
            : choiceName // ignore: cast_nullable_to_non_nullable
                  as String,
        supplement: null == supplement
            ? _value.supplement
            : supplement // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedChoiceImpl implements _SelectedChoice {
  const _$SelectedChoiceImpl({
    required this.choiceId,
    required this.choiceName,
    required this.supplement,
  });

  factory _$SelectedChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedChoiceImplFromJson(json);

  @override
  final String choiceId;
  @override
  final String choiceName;
  @override
  final double supplement;

  @override
  String toString() {
    return 'SelectedChoice(choiceId: $choiceId, choiceName: $choiceName, supplement: $supplement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedChoiceImpl &&
            (identical(other.choiceId, choiceId) ||
                other.choiceId == choiceId) &&
            (identical(other.choiceName, choiceName) ||
                other.choiceName == choiceName) &&
            (identical(other.supplement, supplement) ||
                other.supplement == supplement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, choiceId, choiceName, supplement);

  /// Create a copy of SelectedChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedChoiceImplCopyWith<_$SelectedChoiceImpl> get copyWith =>
      __$$SelectedChoiceImplCopyWithImpl<_$SelectedChoiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedChoiceImplToJson(this);
  }
}

abstract class _SelectedChoice implements SelectedChoice {
  const factory _SelectedChoice({
    required final String choiceId,
    required final String choiceName,
    required final double supplement,
  }) = _$SelectedChoiceImpl;

  factory _SelectedChoice.fromJson(Map<String, dynamic> json) =
      _$SelectedChoiceImpl.fromJson;

  @override
  String get choiceId;
  @override
  String get choiceName;
  @override
  double get supplement;

  /// Create a copy of SelectedChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedChoiceImplCopyWith<_$SelectedChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
