import 'dart:math' as math;

/// Great-circle distance in kilometers between two lat/lng points.
/// Assumes spherical Earth (good enough for delivery-range UI).
double haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const earthRadiusKm = 6371.0;
  final dLat = _toRad(lat2 - lat1);
  final dLng = _toRad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRad(lat1)) *
          math.cos(_toRad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusKm * c;
}

double _toRad(double deg) => deg * math.pi / 180;

/// Format a km value for marketplace cards: "1.2 km", "12 km", "<1 km".
String formatKm(double km) {
  if (km < 1) return '<1 km';
  if (km < 10) return '${km.toStringAsFixed(1)} km';
  return '${km.round()} km';
}
