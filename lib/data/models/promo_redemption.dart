import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_redemption.freezed.dart';
part 'promo_redemption.g.dart';

@freezed
class PromoRedemption with _$PromoRedemption {
  const factory PromoRedemption({
    required String id,
    @JsonKey(name: 'promo_code_id') required String promoCodeId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'delivery_order_id') required String deliveryOrderId,
    @JsonKey(name: 'discount_amount') required double discountAmount,
    @JsonKey(name: 'redeemed_at') required DateTime redeemedAt,
  }) = _PromoRedemption;

  factory PromoRedemption.fromJson(Map<String, dynamic> json) =>
      _$PromoRedemptionFromJson(json);
}
