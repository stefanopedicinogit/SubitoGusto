import 'dart:js_interop';

@JS('initStripePayment')
external bool _initStripePayment(
    JSString publishableKey, JSString clientSecret, JSString elementId);

@JS('confirmStripePayment')
external JSPromise<JSString> _confirmStripePayment(JSString returnUrl);

@JS('destroyStripePayment')
external void _destroyStripePayment();

/// Initialize Stripe Payment Element in the given DOM container
bool initStripePayment(
    String publishableKey, String clientSecret, String elementId) {
  return _initStripePayment(
      publishableKey.toJS, clientSecret.toJS, elementId.toJS);
}

/// Confirm the payment. Returns {'success': true} or {'error': 'message'}
Future<String> confirmStripePayment(String returnUrl) async {
  final result = await _confirmStripePayment(returnUrl.toJS).toDart;
  return result.toDart;
}

/// Clean up Stripe elements
void destroyStripePayment() {
  _destroyStripePayment();
}
