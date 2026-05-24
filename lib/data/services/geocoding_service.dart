import 'package:dio/dio.dart';

/// Geocoding via OpenStreetMap Nominatim.
///
/// Free, no API key. Subject to Nominatim usage policy: keep a meaningful
/// User-Agent and rate-limit to ~1 req/sec (we only call on user-initiated
/// address saves, so we're well under that).
class GeocodingService {
  GeocodingService([Dio? dio]) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _endpoint = 'https://nominatim.openstreetmap.org/search';
  static const _reverseEndpoint = 'https://nominatim.openstreetmap.org/reverse';
  static const _userAgent = 'SubitoGusto/1.0 (contact: support@subitogusto.app)';

  /// Returns (lat, lng) for the given address, or null on failure / no result.
  /// Restricted to Italy by default since the app ships there first.
  Future<({double lat, double lng})?> geocode(
    String address, {
    String countryCode = 'it',
  }) async {
    final query = address.trim();
    if (query.isEmpty) return null;

    try {
      final response = await _dio.get<List<dynamic>>(
        _endpoint,
        queryParameters: {
          'format': 'json',
          'q': query,
          'limit': 1,
          if (countryCode.isNotEmpty) 'countrycodes': countryCode,
        },
        options: Options(headers: {'User-Agent': _userAgent}),
      );

      final list = response.data;
      if (list == null || list.isEmpty) return null;

      final first = list.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat']?.toString() ?? '');
      final lng = double.tryParse(first['lon']?.toString() ?? '');
      if (lat == null || lng == null) return null;
      return (lat: lat, lng: lng);
    } catch (_) {
      return null;
    }
  }

  /// Reverse geocode lat/lng → structured address. Returns null on failure.
  Future<ReverseGeocodeResult?> reverse(double lat, double lng) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _reverseEndpoint,
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat,
          'lon': lng,
          'addressdetails': 1,
          'accept-language': 'it',
        },
        options: Options(headers: {'User-Agent': _userAgent}),
      );
      final data = response.data;
      if (data == null) return null;
      final address = (data['address'] as Map<String, dynamic>?) ?? const {};

      final road = (address['road'] ?? address['pedestrian'] ?? '') as String;
      final house = (address['house_number'] ?? '') as String;
      final street = [road, house].where((s) => s.isNotEmpty).join(' ').trim();

      return ReverseGeocodeResult(
        street: street,
        city: (address['city'] ??
                address['town'] ??
                address['village'] ??
                address['municipality'] ??
                '') as String,
        postalCode: (address['postcode'] ?? '') as String,
        province: (address['county'] ?? address['state'] ?? '') as String,
        displayName: (data['display_name'] ?? '') as String,
      );
    } catch (_) {
      return null;
    }
  }
}

class ReverseGeocodeResult {
  final String street;
  final String city;
  final String postalCode;
  final String province;
  final String displayName;

  const ReverseGeocodeResult({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.displayName,
  });
}

class StreetSuggestion {
  final String street;
  final String displayName;
  final double lat;
  final double lng;

  const StreetSuggestion({
    required this.street,
    required this.displayName,
    required this.lat,
    required this.lng,
  });
}

/// Rich free-text address suggestion. Includes parsed components when
/// available so the UI can show CAP / city as read-only confirmation.
class AddressSuggestion {
  final String street;
  final String city;
  final String postalCode;
  final String displayName;
  final double lat;
  final double lng;

  const AddressSuggestion({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.displayName,
    required this.lat,
    required this.lng,
  });
}

/// Extension methods for cascading address pickers and rich autocomplete.
extension GeocodingCascading on GeocodingService {
  /// Free-text address search returning structured suggestions with coords.
  Future<List<AddressSuggestion>> searchAddresses(
    String query, {
    String countryCode = 'it',
    int limit = 8,
  }) async {
    if (query.trim().length < 3) return const [];
    try {
      final response = await _dio.get<List<dynamic>>(
        GeocodingService._endpoint,
        queryParameters: {
          'format': 'json',
          'q': query.trim(),
          'countrycodes': countryCode,
          'addressdetails': 1,
          'limit': limit,
        },
        options: Options(headers: {'User-Agent': GeocodingService._userAgent}),
      );
      final list = response.data ?? const [];
      final out = <AddressSuggestion>[];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final lat = double.tryParse(m['lat']?.toString() ?? '');
        final lng = double.tryParse(m['lon']?.toString() ?? '');
        if (lat == null || lng == null) continue;
        final addr = (m['address'] as Map<String, dynamic>?) ?? const {};
        final road = (addr['road'] ?? addr['pedestrian'] ?? '') as String;
        final house = (addr['house_number'] ?? '') as String;
        final street = [road, house]
            .where((s) => s.isNotEmpty)
            .join(' ')
            .trim();
        out.add(AddressSuggestion(
          street: street,
          city: (addr['city'] ??
                  addr['town'] ??
                  addr['village'] ??
                  addr['municipality'] ??
                  '') as String,
          postalCode: (addr['postcode'] ?? '') as String,
          displayName: (m['display_name'] ?? '') as String,
          lat: lat,
          lng: lng,
        ));
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  /// Cities matching a postal code in a given country.
  Future<List<String>> citiesForPostalCode(
    String postalCode, {
    String countryCode = 'it',
  }) async {
    if (postalCode.trim().isEmpty) return const [];
    try {
      final response = await _dio.get<List<dynamic>>(
        GeocodingService._endpoint,
        queryParameters: {
          'format': 'json',
          'postalcode': postalCode,
          'countrycodes': countryCode,
          'addressdetails': 1,
          'limit': 20,
        },
        options: Options(headers: {'User-Agent': GeocodingService._userAgent}),
      );
      final list = response.data ?? const [];
      final cities = <String>{};
      for (final item in list) {
        final addr = (item as Map)['address'] as Map<String, dynamic>?;
        if (addr == null) continue;
        final city = (addr['city'] ??
            addr['town'] ??
            addr['village'] ??
            addr['municipality']) as String?;
        if (city != null && city.isNotEmpty) cities.add(city);
      }
      final sorted = cities.toList()..sort();
      return sorted;
    } catch (_) {
      return const [];
    }
  }

  /// Street suggestions within a postal code + city, filtered by a street prefix.
  Future<List<StreetSuggestion>> searchStreets({
    required String streetQuery,
    required String postalCode,
    required String city,
    String countryCode = 'it',
  }) async {
    if (streetQuery.trim().length < 2) return const [];
    try {
      final response = await _dio.get<List<dynamic>>(
        GeocodingService._endpoint,
        queryParameters: {
          'format': 'json',
          'street': streetQuery,
          'postalcode': postalCode,
          'city': city,
          'countrycodes': countryCode,
          'addressdetails': 1,
          'limit': 8,
        },
        options: Options(headers: {'User-Agent': GeocodingService._userAgent}),
      );
      final list = response.data ?? const [];
      final out = <StreetSuggestion>[];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final lat = double.tryParse(m['lat']?.toString() ?? '');
        final lng = double.tryParse(m['lon']?.toString() ?? '');
        if (lat == null || lng == null) continue;
        final addr = (m['address'] as Map<String, dynamic>?) ?? const {};
        final road = (addr['road'] ?? addr['pedestrian'] ?? '') as String;
        final house = (addr['house_number'] ?? '') as String;
        final street = [road, house]
            .where((s) => s.isNotEmpty)
            .join(' ')
            .trim();
        out.add(StreetSuggestion(
          street: street.isEmpty ? (m['display_name'] as String) : street,
          displayName: (m['display_name'] ?? '') as String,
          lat: lat,
          lng: lng,
        ));
      }
      return out;
    } catch (_) {
      return const [];
    }
  }
}
