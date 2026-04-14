import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Redirect the browser to the given URL
void redirectToUrl(String url) {
  web.window.location.href = url;
}
