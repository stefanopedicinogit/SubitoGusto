// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_redemption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromoRedemptionImpl _$$PromoRedemptionImplFromJson(
  Map<String, dynamic> json,
) => _$PromoRedemptionImpl(
  id: json['id'] as String,
  promoCodeId: json['promo_code_id'] as String,
  customerId: json['customer_id'] as String,
  deliveryOrderId: json['delivery_order_id'] as String,
  discountAmount: (json['discount_amount'] as num).toDouble(),
  redeemedAt: DateTime.parse(json['redeemed_at'] as String),
);

Map<String, dynamic> _$$PromoRedemptionImplToJson(
  _$PromoRedemptionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'promo_code_id': instance.promoCodeId,
  'customer_id': instance.customerId,
  'delivery_order_id': instance.deliveryOrderId,
  'discount_amount': instance.discountAmount,
  'redeemed_at': instance.redeemedAt.toIso8601String(),
};
