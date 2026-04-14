/// Stubs for non-web platforms

bool initStripePayment(
    String publishableKey, String clientSecret, String elementId) {
  return false;
}

Future<String> confirmStripePayment(String returnUrl) async {
  return '{"error": "Not supported on this platform"}';
}

void destroyStripePayment() {}
