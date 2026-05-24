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
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    @JsonKey(name: 'opening_hours') Map<String, dynamic>? openingHours,
    Map<String, dynamic>? settings,
    // Delivery settings
    @JsonKey(name: 'delivery_enabled') @Default(false) bool deliveryEnabled,
    @JsonKey(name: 'delivery_fee') @Default(0) double deliveryFee,
    @JsonKey(name: 'delivery_radius_km') @Default(5.0) double deliveryRadiusKm,
    @JsonKey(name: 'delivery_min_order') @Default(0) double deliveryMinOrder,
    @JsonKey(name: 'delivery_estimated_time_min') @Default(45) int deliveryEstimatedTimeMin,
    @JsonKey(name: 'vacation_mode') @Default(false) bool vacationMode,
    @JsonKey(name: 'stripe_account_id') String? stripeAccountId,
    // Discovery metadata (Phase 10)
    @JsonKey(name: 'cuisine_type') String? cuisineType,
    @JsonKey(name: 'dietary_tags') @Default(<String>[]) List<String> dietaryTags,
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

  /// Whether Stripe Connect is set up for this tenant
  bool get hasStripeAccount => stripeAccountId != null && stripeAccountId!.isNotEmpty;

  /// Format delivery fee with currency
  String formatDeliveryFee([String currency = '€']) =>
      deliveryFee > 0 ? '$currency ${deliveryFee.toStringAsFixed(2)}' : 'Gratis';

  /// Format minimum order with currency
  String formatMinOrder([String currency = '€']) =>
      '$currency ${deliveryMinOrder.toStringAsFixed(2)}';

  /// Format estimated delivery time (prep only, no travel — used when distance unknown).
  String get estimatedTimeDisplay => '$deliveryEstimatedTimeMin min';

  /// Average delivery vehicle speed in km/h. Tuned for urban scooter/bike
  /// food delivery; conservative on purpose.
  static const double _averageDeliverySpeedKmh = 25.0;

  /// Minimum travel time floor (handoff overhead: locating address, hand-off).
  /// Applied to any non-zero distance so very short distances don't round to 0.
  static const int _minTravelMinutes = 3;

  /// Total estimated time = restaurant prep time + travel time computed from
  /// the haversine distance at [_averageDeliverySpeedKmh], with a
  /// [_minTravelMinutes] floor for realism. Falls back to just the prep time
  /// when [distanceKm] is null (e.g. one side not geolocated).
  int estimatedTotalMinutes(double? distanceKm) {
    if (distanceKm == null) return deliveryEstimatedTimeMin;
    final raw = (distanceKm / _averageDeliverySpeedKmh * 60).round();
    final travelMinutes = raw < _minTravelMinutes ? _minTravelMinutes : raw;
    return deliveryEstimatedTimeMin + travelMinutes;
  }

  /// Format total estimated time as e.g. "42 min".
  String formatEstimatedTotal(double? distanceKm) =>
      '${estimatedTotalMinutes(distanceKm)} min';

  /// Whether this tenant has been geocoded
  bool get hasCoordinates => latitude != null && longitude != null;
}
