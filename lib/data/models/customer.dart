import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const Customer._();

  const factory Customer({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  /// Display name or email fallback
  String get displayLabel => displayName ?? email;

  /// First letter for avatar
  String get avatarInitial =>
      (displayName ?? email).isNotEmpty ? (displayName ?? email)[0].toUpperCase() : 'C';
}
