import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Result of a geolocation request.
sealed class GeolocationResult {
  const GeolocationResult();
}

class GeolocationSuccess extends GeolocationResult {
  final double lat;
  final double lng;
  const GeolocationSuccess(this.lat, this.lng);
}

class GeolocationDenied extends GeolocationResult {
  const GeolocationDenied();
}

class GeolocationUnavailable extends GeolocationResult {
  final String message;
  const GeolocationUnavailable(this.message);
}

/// Ask the browser for the current position via the Geolocation API.
/// Web-only — call from places guarded by `kIsWeb`.
Future<GeolocationResult> getCurrentPosition({
  Duration timeout = const Duration(seconds: 15),
}) {
  final completer = Completer<GeolocationResult>();

  void success(web.GeolocationPosition position) {
    if (completer.isCompleted) return;
    completer.complete(GeolocationSuccess(
      position.coords.latitude,
      position.coords.longitude,
    ));
  }

  void failure(web.GeolocationPositionError error) {
    if (completer.isCompleted) return;
    // PERMISSION_DENIED == 1 per the spec
    if (error.code == 1) {
      completer.complete(const GeolocationDenied());
    } else {
      completer.complete(GeolocationUnavailable(error.message));
    }
  }

  try {
    web.window.navigator.geolocation.getCurrentPosition(
      success.toJS,
      failure.toJS,
      web.PositionOptions(
        enableHighAccuracy: false,
        timeout: timeout.inMilliseconds,
        maximumAge: 0,
      ),
    );
  } catch (e) {
    completer.complete(GeolocationUnavailable(e.toString()));
  }

  return completer.future.timeout(
    timeout + const Duration(seconds: 2),
    onTimeout: () => const GeolocationUnavailable('Timeout'),
  );
}
