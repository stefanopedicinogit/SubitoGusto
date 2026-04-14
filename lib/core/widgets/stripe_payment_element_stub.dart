import 'package:flutter/material.dart';

void registerStripeView(String viewId) {}

Widget buildStripeView(String viewId) {
  return const Center(
    child: Text('Pagamento non disponibile su questa piattaforma'),
  );
}

bool initStripePaymentElement(
    String publishableKey, String clientSecret, String elementId) {
  return false;
}

Future<String> confirmStripeElement(String returnUrl) async {
  return '{"error": "Not supported"}';
}

void destroyStripeElement() {}
