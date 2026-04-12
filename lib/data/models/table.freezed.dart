// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RestaurantTable _$RestaurantTableFromJson(Map<String, dynamic> json) {
  return _RestaurantTable.fromJson(json);
}

/// @nodoc
mixin _$RestaurantTable {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  String get tenantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_code')
  String get qrCode => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String? get zone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RestaurantTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantTableCopyWith<RestaurantTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantTableCopyWith<$Res> {
  factory $RestaurantTableCopyWith(
    RestaurantTable value,
    $Res Function(RestaurantTable) then,
  ) = _$RestaurantTableCopyWithImpl<$Res, RestaurantTable>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    String name,
    @JsonKey(name: 'qr_code') String qrCode,
    int capacity,
    String? zone,
    String status,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$RestaurantTableCopyWithImpl<$Res, $Val extends RestaurantTable>
    implements $RestaurantTableCopyWith<$Res> {
  _$RestaurantTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? qrCode = null,
    Object? capacity = null,
    Object? zone = freezed,
    Object? status = null,
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
            qrCode: null == qrCode
                ? _value.qrCode
                : qrCode // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            zone: freezed == zone
                ? _value.zone
                : zone // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$RestaurantTableImplCopyWith<$Res>
    implements $RestaurantTableCopyWith<$Res> {
  factory _$$RestaurantTableImplCopyWith(
    _$RestaurantTableImpl value,
    $Res Function(_$RestaurantTableImpl) then,
  ) = __$$RestaurantTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    String name,
    @JsonKey(name: 'qr_code') String qrCode,
    int capacity,
    String? zone,
    String status,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RestaurantTableImplCopyWithImpl<$Res>
    extends _$RestaurantTableCopyWithImpl<$Res, _$RestaurantTableImpl>
    implements _$$RestaurantTableImplCopyWith<$Res> {
  __$$RestaurantTableImplCopyWithImpl(
    _$RestaurantTableImpl _value,
    $Res Function(_$RestaurantTableImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? qrCode = null,
    Object? capacity = null,
    Object? zone = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RestaurantTableImpl(
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
        qrCode: null == qrCode
            ? _value.qrCode
            : qrCode // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        zone: freezed == zone
            ? _value.zone
            : zone // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$RestaurantTableImpl extends _RestaurantTable {
  const _$RestaurantTableImpl({
    required this.id,
    @JsonKey(name: 'tenant_id') required this.tenantId,
    required this.name,
    @JsonKey(name: 'qr_code') required this.qrCode,
    this.capacity = 4,
    this.zone,
    this.status = 'available',
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$RestaurantTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantTableImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tenant_id')
  final String tenantId;
  @override
  final String name;
  @override
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @override
  @JsonKey()
  final int capacity;
  @override
  final String? zone;
  @override
  @JsonKey()
  final String status;
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
    return 'RestaurantTable(id: $id, tenantId: $tenantId, name: $name, qrCode: $qrCode, capacity: $capacity, zone: $zone, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.status, status) || other.status == status) &&
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
    qrCode,
    capacity,
    zone,
    status,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      __$$RestaurantTableImplCopyWithImpl<_$RestaurantTableImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantTableImplToJson(this);
  }
}

abstract class _RestaurantTable extends RestaurantTable {
  const factory _RestaurantTable({
    required final String id,
    @JsonKey(name: 'tenant_id') required final String tenantId,
    required final String name,
    @JsonKey(name: 'qr_code') required final String qrCode,
    final int capacity,
    final String? zone,
    final String status,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$RestaurantTableImpl;
  const _RestaurantTable._() : super._();

  factory _RestaurantTable.fromJson(Map<String, dynamic> json) =
      _$RestaurantTableImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tenant_id')
  String get tenantId;
  @override
  String get name;
  @override
  @JsonKey(name: 'qr_code')
  String get qrCode;
  @override
  int get capacity;
  @override
  String? get zone;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
