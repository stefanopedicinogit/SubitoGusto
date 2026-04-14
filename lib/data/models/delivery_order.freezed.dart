// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeliveryOrder _$DeliveryOrderFromJson(Map<String, dynamic> json) {
  return _DeliveryOrder.fromJson(json);
}

/// @nodoc
mixin _$DeliveryOrder {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  String get tenantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee')
  double get deliveryFee => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Delivery address snapshot
  @JsonKey(name: 'delivery_street')
  String get deliveryStreet => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_city')
  String get deliveryCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_postal_code')
  String get deliveryPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_province')
  String? get deliveryProvince => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_latitude')
  double? get deliveryLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_longitude')
  double? get deliveryLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_notes')
  String? get deliveryNotes => throw _privateConstructorUsedError; // Payment
  @JsonKey(name: 'stripe_payment_intent_id')
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_delivery_at')
  DateTime? get estimatedDeliveryAt => throw _privateConstructorUsedError;

  /// Serializes this DeliveryOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryOrderCopyWith<DeliveryOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryOrderCopyWith<$Res> {
  factory $DeliveryOrderCopyWith(
    DeliveryOrder value,
    $Res Function(DeliveryOrder) then,
  ) = _$DeliveryOrderCopyWithImpl<$Res, DeliveryOrder>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'order_number') String orderNumber,
    String status,
    double subtotal,
    @JsonKey(name: 'delivery_fee') double deliveryFee,
    double discount,
    double total,
    String? notes,
    @JsonKey(name: 'delivery_street') String deliveryStreet,
    @JsonKey(name: 'delivery_city') String deliveryCity,
    @JsonKey(name: 'delivery_postal_code') String deliveryPostalCode,
    @JsonKey(name: 'delivery_province') String? deliveryProvince,
    @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,
    @JsonKey(name: 'delivery_notes') String? deliveryNotes,
    @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'estimated_delivery_at') DateTime? estimatedDeliveryAt,
  });
}

/// @nodoc
class _$DeliveryOrderCopyWithImpl<$Res, $Val extends DeliveryOrder>
    implements $DeliveryOrderCopyWith<$Res> {
  _$DeliveryOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? customerId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? notes = freezed,
    Object? deliveryStreet = null,
    Object? deliveryCity = null,
    Object? deliveryPostalCode = null,
    Object? deliveryProvince = freezed,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? deliveryNotes = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? paymentStatus = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? confirmedAt = freezed,
    Object? deliveredAt = freezed,
    Object? estimatedDeliveryAt = freezed,
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
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryStreet: null == deliveryStreet
                ? _value.deliveryStreet
                : deliveryStreet // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryCity: null == deliveryCity
                ? _value.deliveryCity
                : deliveryCity // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryPostalCode: null == deliveryPostalCode
                ? _value.deliveryPostalCode
                : deliveryPostalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryProvince: freezed == deliveryProvince
                ? _value.deliveryProvince
                : deliveryProvince // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryLatitude: freezed == deliveryLatitude
                ? _value.deliveryLatitude
                : deliveryLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryLongitude: freezed == deliveryLongitude
                ? _value.deliveryLongitude
                : deliveryLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            deliveryNotes: freezed == deliveryNotes
                ? _value.deliveryNotes
                : deliveryNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripePaymentIntentId: freezed == stripePaymentIntentId
                ? _value.stripePaymentIntentId
                : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveredAt: freezed == deliveredAt
                ? _value.deliveredAt
                : deliveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estimatedDeliveryAt: freezed == estimatedDeliveryAt
                ? _value.estimatedDeliveryAt
                : estimatedDeliveryAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryOrderImplCopyWith<$Res>
    implements $DeliveryOrderCopyWith<$Res> {
  factory _$$DeliveryOrderImplCopyWith(
    _$DeliveryOrderImpl value,
    $Res Function(_$DeliveryOrderImpl) then,
  ) = __$$DeliveryOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'tenant_id') String tenantId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'order_number') String orderNumber,
    String status,
    double subtotal,
    @JsonKey(name: 'delivery_fee') double deliveryFee,
    double discount,
    double total,
    String? notes,
    @JsonKey(name: 'delivery_street') String deliveryStreet,
    @JsonKey(name: 'delivery_city') String deliveryCity,
    @JsonKey(name: 'delivery_postal_code') String deliveryPostalCode,
    @JsonKey(name: 'delivery_province') String? deliveryProvince,
    @JsonKey(name: 'delivery_latitude') double? deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') double? deliveryLongitude,
    @JsonKey(name: 'delivery_notes') String? deliveryNotes,
    @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
    @JsonKey(name: 'estimated_delivery_at') DateTime? estimatedDeliveryAt,
  });
}

/// @nodoc
class __$$DeliveryOrderImplCopyWithImpl<$Res>
    extends _$DeliveryOrderCopyWithImpl<$Res, _$DeliveryOrderImpl>
    implements _$$DeliveryOrderImplCopyWith<$Res> {
  __$$DeliveryOrderImplCopyWithImpl(
    _$DeliveryOrderImpl _value,
    $Res Function(_$DeliveryOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? customerId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? discount = null,
    Object? total = null,
    Object? notes = freezed,
    Object? deliveryStreet = null,
    Object? deliveryCity = null,
    Object? deliveryPostalCode = null,
    Object? deliveryProvince = freezed,
    Object? deliveryLatitude = freezed,
    Object? deliveryLongitude = freezed,
    Object? deliveryNotes = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? paymentStatus = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? confirmedAt = freezed,
    Object? deliveredAt = freezed,
    Object? estimatedDeliveryAt = freezed,
  }) {
    return _then(
      _$DeliveryOrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryStreet: null == deliveryStreet
            ? _value.deliveryStreet
            : deliveryStreet // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryCity: null == deliveryCity
            ? _value.deliveryCity
            : deliveryCity // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryPostalCode: null == deliveryPostalCode
            ? _value.deliveryPostalCode
            : deliveryPostalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryProvince: freezed == deliveryProvince
            ? _value.deliveryProvince
            : deliveryProvince // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryLatitude: freezed == deliveryLatitude
            ? _value.deliveryLatitude
            : deliveryLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryLongitude: freezed == deliveryLongitude
            ? _value.deliveryLongitude
            : deliveryLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        deliveryNotes: freezed == deliveryNotes
            ? _value.deliveryNotes
            : deliveryNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripePaymentIntentId: freezed == stripePaymentIntentId
            ? _value.stripePaymentIntentId
            : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveredAt: freezed == deliveredAt
            ? _value.deliveredAt
            : deliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estimatedDeliveryAt: freezed == estimatedDeliveryAt
            ? _value.estimatedDeliveryAt
            : estimatedDeliveryAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryOrderImpl extends _DeliveryOrder {
  const _$DeliveryOrderImpl({
    required this.id,
    @JsonKey(name: 'tenant_id') required this.tenantId,
    @JsonKey(name: 'customer_id') required this.customerId,
    @JsonKey(name: 'order_number') required this.orderNumber,
    this.status = 'pending',
    this.subtotal = 0,
    @JsonKey(name: 'delivery_fee') this.deliveryFee = 0,
    this.discount = 0,
    this.total = 0,
    this.notes,
    @JsonKey(name: 'delivery_street') required this.deliveryStreet,
    @JsonKey(name: 'delivery_city') required this.deliveryCity,
    @JsonKey(name: 'delivery_postal_code') required this.deliveryPostalCode,
    @JsonKey(name: 'delivery_province') this.deliveryProvince,
    @JsonKey(name: 'delivery_latitude') this.deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') this.deliveryLongitude,
    @JsonKey(name: 'delivery_notes') this.deliveryNotes,
    @JsonKey(name: 'stripe_payment_intent_id') this.stripePaymentIntentId,
    @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'confirmed_at') this.confirmedAt,
    @JsonKey(name: 'delivered_at') this.deliveredAt,
    @JsonKey(name: 'estimated_delivery_at') this.estimatedDeliveryAt,
  }) : super._();

  factory _$DeliveryOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryOrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'tenant_id')
  final String tenantId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey(name: 'delivery_fee')
  final double deliveryFee;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double total;
  @override
  final String? notes;
  // Delivery address snapshot
  @override
  @JsonKey(name: 'delivery_street')
  final String deliveryStreet;
  @override
  @JsonKey(name: 'delivery_city')
  final String deliveryCity;
  @override
  @JsonKey(name: 'delivery_postal_code')
  final String deliveryPostalCode;
  @override
  @JsonKey(name: 'delivery_province')
  final String? deliveryProvince;
  @override
  @JsonKey(name: 'delivery_latitude')
  final double? deliveryLatitude;
  @override
  @JsonKey(name: 'delivery_longitude')
  final double? deliveryLongitude;
  @override
  @JsonKey(name: 'delivery_notes')
  final String? deliveryNotes;
  // Payment
  @override
  @JsonKey(name: 'stripe_payment_intent_id')
  final String? stripePaymentIntentId;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  // Timestamps
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'delivered_at')
  final DateTime? deliveredAt;
  @override
  @JsonKey(name: 'estimated_delivery_at')
  final DateTime? estimatedDeliveryAt;

  @override
  String toString() {
    return 'DeliveryOrder(id: $id, tenantId: $tenantId, customerId: $customerId, orderNumber: $orderNumber, status: $status, subtotal: $subtotal, deliveryFee: $deliveryFee, discount: $discount, total: $total, notes: $notes, deliveryStreet: $deliveryStreet, deliveryCity: $deliveryCity, deliveryPostalCode: $deliveryPostalCode, deliveryProvince: $deliveryProvince, deliveryLatitude: $deliveryLatitude, deliveryLongitude: $deliveryLongitude, deliveryNotes: $deliveryNotes, stripePaymentIntentId: $stripePaymentIntentId, paymentStatus: $paymentStatus, createdAt: $createdAt, updatedAt: $updatedAt, confirmedAt: $confirmedAt, deliveredAt: $deliveredAt, estimatedDeliveryAt: $estimatedDeliveryAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.deliveryStreet, deliveryStreet) ||
                other.deliveryStreet == deliveryStreet) &&
            (identical(other.deliveryCity, deliveryCity) ||
                other.deliveryCity == deliveryCity) &&
            (identical(other.deliveryPostalCode, deliveryPostalCode) ||
                other.deliveryPostalCode == deliveryPostalCode) &&
            (identical(other.deliveryProvince, deliveryProvince) ||
                other.deliveryProvince == deliveryProvince) &&
            (identical(other.deliveryLatitude, deliveryLatitude) ||
                other.deliveryLatitude == deliveryLatitude) &&
            (identical(other.deliveryLongitude, deliveryLongitude) ||
                other.deliveryLongitude == deliveryLongitude) &&
            (identical(other.deliveryNotes, deliveryNotes) ||
                other.deliveryNotes == deliveryNotes) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.estimatedDeliveryAt, estimatedDeliveryAt) ||
                other.estimatedDeliveryAt == estimatedDeliveryAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    tenantId,
    customerId,
    orderNumber,
    status,
    subtotal,
    deliveryFee,
    discount,
    total,
    notes,
    deliveryStreet,
    deliveryCity,
    deliveryPostalCode,
    deliveryProvince,
    deliveryLatitude,
    deliveryLongitude,
    deliveryNotes,
    stripePaymentIntentId,
    paymentStatus,
    createdAt,
    updatedAt,
    confirmedAt,
    deliveredAt,
    estimatedDeliveryAt,
  ]);

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryOrderImplCopyWith<_$DeliveryOrderImpl> get copyWith =>
      __$$DeliveryOrderImplCopyWithImpl<_$DeliveryOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryOrderImplToJson(this);
  }
}

abstract class _DeliveryOrder extends DeliveryOrder {
  const factory _DeliveryOrder({
    required final String id,
    @JsonKey(name: 'tenant_id') required final String tenantId,
    @JsonKey(name: 'customer_id') required final String customerId,
    @JsonKey(name: 'order_number') required final String orderNumber,
    final String status,
    final double subtotal,
    @JsonKey(name: 'delivery_fee') final double deliveryFee,
    final double discount,
    final double total,
    final String? notes,
    @JsonKey(name: 'delivery_street') required final String deliveryStreet,
    @JsonKey(name: 'delivery_city') required final String deliveryCity,
    @JsonKey(name: 'delivery_postal_code')
    required final String deliveryPostalCode,
    @JsonKey(name: 'delivery_province') final String? deliveryProvince,
    @JsonKey(name: 'delivery_latitude') final double? deliveryLatitude,
    @JsonKey(name: 'delivery_longitude') final double? deliveryLongitude,
    @JsonKey(name: 'delivery_notes') final String? deliveryNotes,
    @JsonKey(name: 'stripe_payment_intent_id')
    final String? stripePaymentIntentId,
    @JsonKey(name: 'payment_status') final String paymentStatus,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
    @JsonKey(name: 'delivered_at') final DateTime? deliveredAt,
    @JsonKey(name: 'estimated_delivery_at') final DateTime? estimatedDeliveryAt,
  }) = _$DeliveryOrderImpl;
  const _DeliveryOrder._() : super._();

  factory _DeliveryOrder.fromJson(Map<String, dynamic> json) =
      _$DeliveryOrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'tenant_id')
  String get tenantId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  String get status;
  @override
  double get subtotal;
  @override
  @JsonKey(name: 'delivery_fee')
  double get deliveryFee;
  @override
  double get discount;
  @override
  double get total;
  @override
  String? get notes; // Delivery address snapshot
  @override
  @JsonKey(name: 'delivery_street')
  String get deliveryStreet;
  @override
  @JsonKey(name: 'delivery_city')
  String get deliveryCity;
  @override
  @JsonKey(name: 'delivery_postal_code')
  String get deliveryPostalCode;
  @override
  @JsonKey(name: 'delivery_province')
  String? get deliveryProvince;
  @override
  @JsonKey(name: 'delivery_latitude')
  double? get deliveryLatitude;
  @override
  @JsonKey(name: 'delivery_longitude')
  double? get deliveryLongitude;
  @override
  @JsonKey(name: 'delivery_notes')
  String? get deliveryNotes; // Payment
  @override
  @JsonKey(name: 'stripe_payment_intent_id')
  String? get stripePaymentIntentId;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus; // Timestamps
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'delivered_at')
  DateTime? get deliveredAt;
  @override
  @JsonKey(name: 'estimated_delivery_at')
  DateTime? get estimatedDeliveryAt;

  /// Create a copy of DeliveryOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryOrderImplCopyWith<_$DeliveryOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
