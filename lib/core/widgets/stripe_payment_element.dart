import 'dart:convert';
import 'package:flutter/material.dart';

import 'stripe_payment_element_stub.dart'
    if (dart.library.js_interop) 'stripe_payment_element_web.dart';

/// A widget that displays the Stripe Payment Element on web.
/// On non-web platforms, it shows a fallback message.
class StripePaymentElement extends StatefulWidget {
  final String clientSecret;
  final String publishableKey;
  final VoidCallback onPaymentSuccess;
  final ValueChanged<String> onPaymentError;
  final String returnUrl;

  const StripePaymentElement({
    super.key,
    required this.clientSecret,
    required this.publishableKey,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.returnUrl,
  });

  @override
  State<StripePaymentElement> createState() => _StripePaymentElementState();
}

class _StripePaymentElementState extends State<StripePaymentElement> {
  bool _initialized = false;
  bool _confirming = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'stripe-payment-${widget.clientSecret.hashCode}';
    _initElement();
  }

  void _initElement() {
    registerStripeView(_viewId);
    // Delay initialization to ensure the HTML element is mounted
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final result = initStripePaymentElement(
        widget.publishableKey,
        widget.clientSecret,
        'stripe-container-$_viewId',
      );
      if (mounted) {
        setState(() => _initialized = result);
      }
    });
  }

  @override
  void dispose() {
    destroyStripeElement();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    setState(() => _confirming = true);
    try {
      final resultJson = await confirmStripeElement(widget.returnUrl);
      final result = jsonDecode(resultJson) as Map<String, dynamic>;
      if (result['success'] == true) {
        widget.onPaymentSuccess();
      } else {
        widget.onPaymentError(result['error'] as String? ?? 'Pagamento fallito');
      }
    } catch (e) {
      widget.onPaymentError('Errore: $e');
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The Stripe Payment Element container
        SizedBox(
          height: 500,
          child: buildStripeView(_viewId),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: (_initialized && !_confirming) ? _confirmPayment : null,
          icon: _confirming
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.lock),
          label: Text(_confirming ? 'Elaborazione...' : 'Conferma pagamento'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}
