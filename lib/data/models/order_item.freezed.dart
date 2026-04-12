// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'menu_item_id')
  String? get menuItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'menu_item_name')
  String get menuItemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'fixed_menu_id')
  String? get fixedMenuId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fixed_menu_selections')
  Map<String, dynamic>? get fixedMenuSelections =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'menu_item_id') String? menuItemId,
    @JsonKey(name: 'menu_item_name') String menuItemName,
    @JsonKey(name: 'unit_price') double unitPrice,
    int quantity,
    String? notes,
    String status,
    @JsonKey(name: 'fixed_menu_id') String? fixedMenuId,
    @JsonKey(name: 'fixed_menu_selections')
    Map<String, dynamic>? fixedMenuSelections,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? menuItemId = freezed,
    Object? menuItemName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? notes = freezed,
    Object? status = null,
    Object? fixedMenuId = freezed,
    Object? fixedMenuSelections = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItemId: freezed == menuItemId
                ? _value.menuItemId
                : menuItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            menuItemName: null == menuItemName
                ? _value.menuItemName
                : menuItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            fixedMenuId: freezed == fixedMenuId
                ? _value.fixedMenuId
                : fixedMenuId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fixedMenuSelections: freezed == fixedMenuSelections
                ? _value.fixedMenuSelections
                : fixedMenuSelections // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
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
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'menu_item_id') String? menuItemId,
    @JsonKey(name: 'menu_item_name') String menuItemName,
    @JsonKey(name: 'unit_price') double unitPrice,
    int quantity,
    String? notes,
    String status,
    @JsonKey(name: 'fixed_menu_id') String? fixedMenuId,
    @JsonKey(name: 'fixed_menu_selections')
    Map<String, dynamic>? fixedMenuSelections,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? menuItemId = freezed,
    Object? menuItemName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? notes = freezed,
    Object? status = null,
    Object? fixedMenuId = freezed,
    Object? fixedMenuSelections = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItemId: freezed == menuItemId
            ? _value.menuItemId
            : menuItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        menuItemName: null == menuItemName
            ? _value.menuItemName
            : menuItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        fixedMenuId: freezed == fixedMenuId
            ? _value.fixedMenuId
            : fixedMenuId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fixedMenuSelections: freezed == fixedMenuSelections
            ? _value._fixedMenuSelections
            : fixedMenuSelections // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
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
class _$OrderItemImpl extends _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'menu_item_id') this.menuItemId,
    @JsonKey(name: 'menu_item_name') required this.menuItemName,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    this.quantity = 1,
    this.notes,
    this.status = 'pending',
    @JsonKey(name: 'fixed_menu_id') this.fixedMenuId,
    @JsonKey(name: 'fixed_menu_selections')
    final Map<String, dynamic>? fixedMenuSelections,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _fixedMenuSelections = fixedMenuSelections,
       super._();

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'menu_item_id')
  final String? menuItemId;
  @override
  @JsonKey(name: 'menu_item_name')
  final String menuItemName;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey()
  final int quantity;
  @override
  final String? notes;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'fixed_menu_id')
  final String? fixedMenuId;
  final Map<String, dynamic>? _fixedMenuSelections;
  @override
  @JsonKey(name: 'fixed_menu_selections')
  Map<String, dynamic>? get fixedMenuSelections {
    final value = _fixedMenuSelections;
    if (value == null) return null;
    if (_fixedMenuSelections is EqualUnmodifiableMapView)
      return _fixedMenuSelections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, menuItemId: $menuItemId, menuItemName: $menuItemName, unitPrice: $unitPrice, quantity: $quantity, notes: $notes, status: $status, fixedMenuId: $fixedMenuId, fixedMenuSelections: $fixedMenuSelections, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.menuItemName, menuItemName) ||
                other.menuItemName == menuItemName) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fixedMenuId, fixedMenuId) ||
                other.fixedMenuId == fixedMenuId) &&
            const DeepCollectionEquality().equals(
              other._fixedMenuSelections,
              _fixedMenuSelections,
            ) &&
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
    orderId,
    menuItemId,
    menuItemName,
    unitPrice,
    quantity,
    notes,
    status,
    fixedMenuId,
    const DeepCollectionEquality().hash(_fixedMenuSelections),
    createdAt,
    updatedAt,
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem extends OrderItem {
  const factory _OrderItem({
    required final String id,
    @JsonKey(name: 'order_id') required final String orderId,
    @JsonKey(name: 'menu_item_id') final String? menuItemId,
    @JsonKey(name: 'menu_item_name') required final String menuItemName,
    @JsonKey(name: 'unit_price') required final double unitPrice,
    final int quantity,
    final String? notes,
    final String status,
    @JsonKey(name: 'fixed_menu_id') final String? fixedMenuId,
    @JsonKey(name: 'fixed_menu_selections')
    final Map<String, dynamic>? fixedMenuSelections,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$OrderItemImpl;
  const _OrderItem._() : super._();

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'menu_item_id')
  String? get menuItemId;
  @override
  @JsonKey(name: 'menu_item_name')
  String get menuItemName;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  int get quantity;
  @override
  String? get notes;
  @override
  String get status;
  @override
  @JsonKey(name: 'fixed_menu_id')
  String? get fixedMenuId;
  @override
  @JsonKey(name: 'fixed_menu_selections')
  Map<String, dynamic>? get fixedMenuSelections;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
