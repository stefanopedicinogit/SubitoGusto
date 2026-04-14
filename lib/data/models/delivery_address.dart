import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_address.freezed.dart';
part 'delivery_address.g.dart';

@freezed
class DeliveryAddress with _$DeliveryAddress {
  const DeliveryAddress._();

  const factory DeliveryAddress({
    required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    @Default('Casa') String label,
    required String street,
    required String city,
    @JsonKey(name: 'postal_code') required String postalCode,
    String? province,
    @Default('IT') String country,
    double? latitude,
    double? longitude,
    String? notes,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  /// Full address display
  String get fullAddress => '$street, $postalCode $city';

  /// Short display with label
  String get shortDisplay => '$label - $street, $city';
}
