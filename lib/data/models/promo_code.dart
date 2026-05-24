import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code.freezed.dart';
part 'promo_code.g.dart';

@freezed
class PromoCode with _$PromoCode {
  const PromoCode._();

  const factory PromoCode({
    required String id,
    required String code,
    @JsonKey(name: 'tenant_id') String? tenantId,
    required String type, // 'percent' | 'fixed'
    required double value,
    @JsonKey(name: 'min_order') @Default(0) double minOrder,
    @JsonKey(name: 'valid_from') required DateTime validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'uses_count') @Default(0) int usesCount,
    @JsonKey(name: 'per_customer_limit') @Default(1) int perCustomerLimit,
    @Default(true) bool active,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PromoCode;

  factory PromoCode.fromJson(Map<String, dynamic> json) =>
      _$PromoCodeFromJson(json);

  bool get isPercent => type == 'percent';
  bool get isFixed => type == 'fixed';

  /// Remaining uses, or `null` if unlimited.
  int? get usesLeft => maxUses == null ? null : (maxUses! - usesCount);

  bool get isExpired =>
      validUntil != null && DateTime.now().isAfter(validUntil!);

  bool get isExhausted => maxUses != null && usesCount >= maxUses!;

  /// Display-ready value, e.g. "10%" or "€ 5,00".
  String formatValue() {
    if (isPercent) return '${value.toStringAsFixed(0)}%';
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
