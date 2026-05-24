// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PromoCode _$PromoCodeFromJson(Map<String, dynamic> json) {
  return _PromoCode.fromJson(json);
}

/// @nodoc
mixin _$PromoCode {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  String? get tenantId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'percent' | 'fixed'
  double get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_order')
  double get minOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  DateTime get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_uses')
  int? get maxUses => throw _privateConstructorUsedError;
  @JsonKey(name: 'uses_count')
  int get usesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_customer_limit')
  int get perCustomerLimit => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PromoCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromoCodeCopyWith<PromoCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoCodeCopyWith<$Res> {
  factory $PromoCodeCopyWith(PromoCode value, $Res Function(PromoCode) then) =
      _$PromoCodeCopyWithImpl<$Res, PromoCode>;
  @useResult
  $Res call({
    String id,
    String code,
    @JsonKey(name: 'tenant_id') String? tenantId,
    String type,
    double value,
    @JsonKey(name: 'min_order') double minOrder,
    @JsonKey(name: 'valid_from') DateTime validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'uses_count') int usesCount,
    @JsonKey(name: 'per_customer_limit') int perCustomerLimit,
    bool active,
    String? description,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$PromoCodeCopyWithImpl<$Res, $Val extends PromoCode>
    implements $PromoCodeCopyWith<$Res> {
  _$PromoCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? tenantId = freezed,
    Object? type = null,
    Object? value = null,
    Object? minOrder = null,
    Object? validFrom = null,
    Object? validUntil = freezed,
    Object? maxUses = freezed,
    Object? usesCount = null,
    Object? perCustomerLimit = null,
    Object? active = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: freezed == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            minOrder: null == minOrder
                ? _value.minOrder
                : minOrder // ignore: cast_nullable_to_non_nullable
                      as double,
            validFrom: null == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            validUntil: freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            maxUses: freezed == maxUses
                ? _value.maxUses
                : maxUses // ignore: cast_nullable_to_non_nullable
                      as int?,
            usesCount: null == usesCount
                ? _value.usesCount
                : usesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            perCustomerLimit: null == perCustomerLimit
                ? _value.perCustomerLimit
                : perCustomerLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$PromoCodeImplCopyWith<$Res>
    implements $PromoCodeCopyWith<$Res> {
  factory _$$PromoCodeImplCopyWith(
    _$PromoCodeImpl value,
    $Res Function(_$PromoCodeImpl) then,
  ) = __$$PromoCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    @JsonKey(name: 'tenant_id') String? tenantId,
    String type,
    double value,
    @JsonKey(name: 'min_order') double minOrder,
    @JsonKey(name: 'valid_from') DateTime validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'uses_count') int usesCount,
    @JsonKey(name: 'per_customer_limit') int perCustomerLimit,
    bool active,
    String? description,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PromoCodeImplCopyWithImpl<$Res>
    extends _$PromoCodeCopyWithImpl<$Res, _$PromoCodeImpl>
    implements _$$PromoCodeImplCopyWith<$Res> {
  __$$PromoCodeImplCopyWithImpl(
    _$PromoCodeImpl _value,
    $Res Function(_$PromoCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? tenantId = freezed,
    Object? type = null,
    Object? value = null,
    Object? minOrder = null,
    Object? validFrom = null,
    Object? validUntil = freezed,
    Object? maxUses = freezed,
    Object? usesCount = null,
    Object? perCustomerLimit = null,
    Object? active = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PromoCodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        minOrder: null == minOrder
            ? _value.minOrder
            : minOrder // ignore: cast_nullable_to_non_nullable
                  as double,
        validFrom: null == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        validUntil: freezed == validUntil
            ? _value.validUntil
            : validUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        maxUses: freezed == maxUses
            ? _value.maxUses
            : maxUses // ignore: cast_nullable_to_non_nullable
                  as int?,
        usesCount: null == usesCount
            ? _value.usesCount
            : usesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        perCustomerLimit: null == perCustomerLimit
            ? _value.perCustomerLimit
            : perCustomerLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$PromoCodeImpl extends _PromoCode {
  const _$PromoCodeImpl({
    required this.id,
    required this.code,
    @JsonKey(name: 'tenant_id') this.tenantId,
    required this.type,
    required this.value,
    @JsonKey(name: 'min_order') this.minOrder = 0,
    @JsonKey(name: 'valid_from') required this.validFrom,
    @JsonKey(name: 'valid_until') this.validUntil,
    @JsonKey(name: 'max_uses') this.maxUses,
    @JsonKey(name: 'uses_count') this.usesCount = 0,
    @JsonKey(name: 'per_customer_limit') this.perCustomerLimit = 1,
    this.active = true,
    this.description,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$PromoCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoCodeImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  @JsonKey(name: 'tenant_id')
  final String? tenantId;
  @override
  final String type;
  // 'percent' | 'fixed'
  @override
  final double value;
  @override
  @JsonKey(name: 'min_order')
  final double minOrder;
  @override
  @JsonKey(name: 'valid_from')
  final DateTime validFrom;
  @override
  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;
  @override
  @JsonKey(name: 'max_uses')
  final int? maxUses;
  @override
  @JsonKey(name: 'uses_count')
  final int usesCount;
  @override
  @JsonKey(name: 'per_customer_limit')
  final int perCustomerLimit;
  @override
  @JsonKey()
  final bool active;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PromoCode(id: $id, code: $code, tenantId: $tenantId, type: $type, value: $value, minOrder: $minOrder, validFrom: $validFrom, validUntil: $validUntil, maxUses: $maxUses, usesCount: $usesCount, perCustomerLimit: $perCustomerLimit, active: $active, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.minOrder, minOrder) ||
                other.minOrder == minOrder) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses) &&
            (identical(other.usesCount, usesCount) ||
                other.usesCount == usesCount) &&
            (identical(other.perCustomerLimit, perCustomerLimit) ||
                other.perCustomerLimit == perCustomerLimit) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
    code,
    tenantId,
    type,
    value,
    minOrder,
    validFrom,
    validUntil,
    maxUses,
    usesCount,
    perCustomerLimit,
    active,
    description,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoCodeImplCopyWith<_$PromoCodeImpl> get copyWith =>
      __$$PromoCodeImplCopyWithImpl<_$PromoCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoCodeImplToJson(this);
  }
}

abstract class _PromoCode extends PromoCode {
  const factory _PromoCode({
    required final String id,
    required final String code,
    @JsonKey(name: 'tenant_id') final String? tenantId,
    required final String type,
    required final double value,
    @JsonKey(name: 'min_order') final double minOrder,
    @JsonKey(name: 'valid_from') required final DateTime validFrom,
    @JsonKey(name: 'valid_until') final DateTime? validUntil,
    @JsonKey(name: 'max_uses') final int? maxUses,
    @JsonKey(name: 'uses_count') final int usesCount,
    @JsonKey(name: 'per_customer_limit') final int perCustomerLimit,
    final bool active,
    final String? description,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$PromoCodeImpl;
  const _PromoCode._() : super._();

  factory _PromoCode.fromJson(Map<String, dynamic> json) =
      _$PromoCodeImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  @JsonKey(name: 'tenant_id')
  String? get tenantId;
  @override
  String get type; // 'percent' | 'fixed'
  @override
  double get value;
  @override
  @JsonKey(name: 'min_order')
  double get minOrder;
  @override
  @JsonKey(name: 'valid_from')
  DateTime get validFrom;
  @override
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil;
  @override
  @JsonKey(name: 'max_uses')
  int? get maxUses;
  @override
  @JsonKey(name: 'uses_count')
  int get usesCount;
  @override
  @JsonKey(name: 'per_customer_limit')
  int get perCustomerLimit;
  @override
  bool get active;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PromoCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromoCodeImplCopyWith<_$PromoCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
