// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_redemption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PromoRedemption _$PromoRedemptionFromJson(Map<String, dynamic> json) {
  return _PromoRedemption.fromJson(json);
}

/// @nodoc
mixin _$PromoRedemption {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'promo_code_id')
  String get promoCodeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_order_id')
  String get deliveryOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  double get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'redeemed_at')
  DateTime get redeemedAt => throw _privateConstructorUsedError;

  /// Serializes this PromoRedemption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromoRedemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromoRedemptionCopyWith<PromoRedemption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromoRedemptionCopyWith<$Res> {
  factory $PromoRedemptionCopyWith(
    PromoRedemption value,
    $Res Function(PromoRedemption) then,
  ) = _$PromoRedemptionCopyWithImpl<$Res, PromoRedemption>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'promo_code_id') String promoCodeId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'delivery_order_id') String deliveryOrderId,
    @JsonKey(name: 'discount_amount') double discountAmount,
    @JsonKey(name: 'redeemed_at') DateTime redeemedAt,
  });
}

/// @nodoc
class _$PromoRedemptionCopyWithImpl<$Res, $Val extends PromoRedemption>
    implements $PromoRedemptionCopyWith<$Res> {
  _$PromoRedemptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromoRedemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? promoCodeId = null,
    Object? customerId = null,
    Object? deliveryOrderId = null,
    Object? discountAmount = null,
    Object? redeemedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            promoCodeId: null == promoCodeId
                ? _value.promoCodeId
                : promoCodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryOrderId: null == deliveryOrderId
                ? _value.deliveryOrderId
                : deliveryOrderId // ignore: cast_nullable_to_non_nullable
                      as String,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            redeemedAt: null == redeemedAt
                ? _value.redeemedAt
                : redeemedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PromoRedemptionImplCopyWith<$Res>
    implements $PromoRedemptionCopyWith<$Res> {
  factory _$$PromoRedemptionImplCopyWith(
    _$PromoRedemptionImpl value,
    $Res Function(_$PromoRedemptionImpl) then,
  ) = __$$PromoRedemptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'promo_code_id') String promoCodeId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'delivery_order_id') String deliveryOrderId,
    @JsonKey(name: 'discount_amount') double discountAmount,
    @JsonKey(name: 'redeemed_at') DateTime redeemedAt,
  });
}

/// @nodoc
class __$$PromoRedemptionImplCopyWithImpl<$Res>
    extends _$PromoRedemptionCopyWithImpl<$Res, _$PromoRedemptionImpl>
    implements _$$PromoRedemptionImplCopyWith<$Res> {
  __$$PromoRedemptionImplCopyWithImpl(
    _$PromoRedemptionImpl _value,
    $Res Function(_$PromoRedemptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PromoRedemption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? promoCodeId = null,
    Object? customerId = null,
    Object? deliveryOrderId = null,
    Object? discountAmount = null,
    Object? redeemedAt = null,
  }) {
    return _then(
      _$PromoRedemptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        promoCodeId: null == promoCodeId
            ? _value.promoCodeId
            : promoCodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryOrderId: null == deliveryOrderId
            ? _value.deliveryOrderId
            : deliveryOrderId // ignore: cast_nullable_to_non_nullable
                  as String,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        redeemedAt: null == redeemedAt
            ? _value.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PromoRedemptionImpl implements _PromoRedemption {
  const _$PromoRedemptionImpl({
    required this.id,
    @JsonKey(name: 'promo_code_id') required this.promoCodeId,
    @JsonKey(name: 'customer_id') required this.customerId,
    @JsonKey(name: 'delivery_order_id') required this.deliveryOrderId,
    @JsonKey(name: 'discount_amount') required this.discountAmount,
    @JsonKey(name: 'redeemed_at') required this.redeemedAt,
  });

  factory _$PromoRedemptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromoRedemptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'promo_code_id')
  final String promoCodeId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'delivery_order_id')
  final String deliveryOrderId;
  @override
  @JsonKey(name: 'discount_amount')
  final double discountAmount;
  @override
  @JsonKey(name: 'redeemed_at')
  final DateTime redeemedAt;

  @override
  String toString() {
    return 'PromoRedemption(id: $id, promoCodeId: $promoCodeId, customerId: $customerId, deliveryOrderId: $deliveryOrderId, discountAmount: $discountAmount, redeemedAt: $redeemedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromoRedemptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.promoCodeId, promoCodeId) ||
                other.promoCodeId == promoCodeId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.deliveryOrderId, deliveryOrderId) ||
                other.deliveryOrderId == deliveryOrderId) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    promoCodeId,
    customerId,
    deliveryOrderId,
    discountAmount,
    redeemedAt,
  );

  /// Create a copy of PromoRedemption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromoRedemptionImplCopyWith<_$PromoRedemptionImpl> get copyWith =>
      __$$PromoRedemptionImplCopyWithImpl<_$PromoRedemptionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PromoRedemptionImplToJson(this);
  }
}

abstract class _PromoRedemption implements PromoRedemption {
  const factory _PromoRedemption({
    required final String id,
    @JsonKey(name: 'promo_code_id') required final String promoCodeId,
    @JsonKey(name: 'customer_id') required final String customerId,
    @JsonKey(name: 'delivery_order_id') required final String deliveryOrderId,
    @JsonKey(name: 'discount_amount') required final double discountAmount,
    @JsonKey(name: 'redeemed_at') required final DateTime redeemedAt,
  }) = _$PromoRedemptionImpl;

  factory _PromoRedemption.fromJson(Map<String, dynamic> json) =
      _$PromoRedemptionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'promo_code_id')
  String get promoCodeId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'delivery_order_id')
  String get deliveryOrderId;
  @override
  @JsonKey(name: 'discount_amount')
  double get discountAmount;
  @override
  @JsonKey(name: 'redeemed_at')
  DateTime get redeemedAt;

  /// Create a copy of PromoRedemption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromoRedemptionImplCopyWith<_$PromoRedemptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
