import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
class Tenant with _$Tenant {
  const Tenant._();

  const factory Tenant({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    String? address,
    String? phone,
    String? email,
    @JsonKey(name: 'opening_hours') Map<String, dynamic>? openingHours,
    Map<String, dynamic>? settings,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) =>
      _$TenantFromJson(json);

  /// Get currency from settings or default to EUR
  String get currency => settings?['currency'] as String? ?? 'EUR';

  /// Get default language from settings
  String get defaultLanguage => settings?['language'] as String? ?? 'it';

  // Theme settings
  /// Primary color (hex string like '#722F37')
  String? get primaryColor => settings?['primary_color'] as String?;

  /// Secondary/accent color (hex string)
  String? get secondaryColor => settings?['secondary_color'] as String?;

  /// Background color (hex string)
  String? get backgroundColor => settings?['background_color'] as String?;

  /// Logo initial letter for display
  String get logoInitial => name.isNotEmpty ? name[0].toUpperCase() : 'T';
}
