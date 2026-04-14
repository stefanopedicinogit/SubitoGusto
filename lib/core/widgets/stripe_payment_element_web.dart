import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../utils/stripe_web.dart';

/// Register an HTML view for the Stripe Payment Element
void registerStripeView(String viewId) {
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
    final div = web.document.createElement('div') as web.HTMLDivElement;
    div.id = 'stripe-container-$viewId';
    div.style.width = '100%';
    div.style.height = '100%';
    return div;
  });
}

/// Build the platform view widget
Widget buildStripeView(String viewId) {
  return HtmlElementView(viewType: viewId);
}

/// Initialize the Stripe Payment Element
bool initStripePaymentElement(
    String publishableKey, String clientSecret, String elementId) {
  return initStripePayment(publishableKey, clientSecret, elementId);
}

/// Confirm the payment
Future<String> confirmStripeElement(String returnUrl) {
  return confirmStripePayment(returnUrl);
}

/// Clean up
void destroyStripeElement() {
  destroyStripePayment();
}
