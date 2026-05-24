import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/widgets/stripe_payment_element.dart';
import '../../data/providers/consumer_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../marketplace/delivery_cart_provider.dart';

/// Checkout page: order summary, address selection, payment
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _isProcessing = false;
  String? _errorMessage;

  // Web payment element state
  String? _clientSecret;
  String? _orderId;
  bool _showPaymentElement = false;

  final _orderNotesController = TextEditingController();

  // Promo code state
  final _promoController = TextEditingController();
  bool _validatingPromo = false;
  String? _promoError;
  String? _appliedPromoCode;
  double _promoDiscount = 0;

  @override
  void dispose() {
    _orderNotesController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    final cart = ref.read(deliveryCartProvider);
    if (cart.restaurantId == null) return;

    setState(() {
      _validatingPromo = true;
      _promoError = null;
    });

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'validate-promo-code',
        body: {
          'code': code,
          'restaurantId': cart.restaurantId,
          'subtotal': cart.subtotal,
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data['valid'] == true) {
        setState(() {
          _appliedPromoCode = data['code'] as String;
          _promoDiscount = (data['discountAmount'] as num).toDouble();
          _promoController.text = data['code'] as String;
        });
      } else {
        setState(() {
          _promoError = (data['error'] as String?) ?? 'Codice non valido';
          _appliedPromoCode = null;
          _promoDiscount = 0;
        });
      }
    } on FunctionException catch (e) {
      // Edge function returned non-2xx. Try to extract the `error` field from
      // the response body before falling back to a generic message.
      setState(() {
        _promoError = _extractFunctionErrorMessage(e) ?? humanizeError(e, context);
        _appliedPromoCode = null;
        _promoDiscount = 0;
      });
    } catch (e) {
      setState(() {
        _promoError = humanizeError(e, context);
        _appliedPromoCode = null;
        _promoDiscount = 0;
      });
    } finally {
      if (mounted) setState(() => _validatingPromo = false);
    }
  }

  /// Best-effort extraction of an `error` field from a [FunctionException]'s
  /// response body, regardless of whether it was decoded to a Map or left as
  /// a JSON string.
  String? _extractFunctionErrorMessage(FunctionException e) {
    final d = e.details;
    if (d is Map) {
      final err = d['error'];
      if (err is String && err.isNotEmpty) return err;
    }
    if (d is String && d.isNotEmpty) {
      try {
        final decoded = const JsonDecoder().convert(d);
        if (decoded is Map && decoded['error'] is String) {
          return decoded['error'] as String;
        }
      } catch (_) {}
    }
    return null;
  }

  void _removePromoCode() {
    setState(() {
      _appliedPromoCode = null;
      _promoDiscount = 0;
      _promoError = null;
      _promoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(deliveryCartProvider);
    final defaultAddress = ref.watch(defaultDeliveryAddressProvider);
    final l = AppLocalizations.of(context);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.checkoutTitle)),
        body: Center(child: Text(l.checkoutCartEmpty)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.checkoutTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/consumer');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name
                Text(
                  cart.restaurantName ?? 'Ordine',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Order items summary
                _SectionTitle(title: l.checkoutSummary),
                Card(
                  child: Column(
                    children: [
                      ...cart.items.map((item) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              child: Text(
                                '${item.quantity}x',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            title: Text(item.menuItem.name),
                            subtitle: item.notes != null
                                ? Text(
                                    item.notes!,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            trailing: Text(
                              '\u20ac ${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Delivery address — read-only display.
                // Selection happens in the profile's addresses page; if none
                // exist, prompt the user to add one before checking out.
                _SectionTitle(title: l.checkoutDeliveryAddress),
                if (defaultAddress != null)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(defaultAddress.label),
                      subtitle: Text(defaultAddress.fullAddress),
                    ),
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.checkoutNoAddress,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l.checkoutNoAddressHint,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          OutlinedButton.icon(
                            onPressed: () =>
                                context.push('/consumer/addresses'),
                            icon: const Icon(Icons.add_location_alt_outlined),
                            label: Text(l.checkoutAddAddress),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Order notes
                _SectionTitle(title: l.checkoutOrderNotes),
                TextField(
                  controller: _orderNotesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: l.checkoutOrderNotesHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Promo code
                _SectionTitle(title: l.checkoutPromoCodeTitle),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_appliedPromoCode != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: AppColors.success, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  l.checkoutPromoApplied(_appliedPromoCode!),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              TextButton(
                                onPressed: _removePromoCode,
                                child: Text(l.checkoutPromoRemove),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _promoController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: l.checkoutPromoHint,
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onSubmitted: (_) => _applyPromoCode(),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              FilledButton(
                                onPressed:
                                    _validatingPromo ? null : _applyPromoCode,
                                child: _validatingPromo
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : Text(l.checkoutPromoApply),
                              ),
                            ],
                          ),
                          if (_promoError != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _promoError!,
                              style: const TextStyle(
                                  color: AppColors.error, fontSize: 13),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Totals
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        _TotalRow(
                            label: l.checkoutSubtotal,
                            value: cart.formatSubtotal()),
                        const SizedBox(height: AppSpacing.xs),
                        _TotalRow(
                            label: l.checkoutDelivery,
                            value: cart.formatDeliveryFee()),
                        if (_promoDiscount > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _TotalRow(
                            label: '${l.checkoutDiscount} ($_appliedPromoCode)',
                            value: '-€ ${_promoDiscount.toStringAsFixed(2)}',
                            valueColor: AppColors.success,
                          ),
                        ],
                        const Divider(height: AppSpacing.lg),
                        _TotalRow(
                          label: l.checkoutTotal,
                          value:
                              '€ ${(cart.total - _promoDiscount).toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Payment section
                if (kIsWeb && _showPaymentElement && _clientSecret != null) ...[
                  _SectionTitle(title: l.checkoutTotal),
                  StripePaymentElement(
                    publishableKey: dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '',
                    clientSecret: _clientSecret!,
                    returnUrl: '${Uri.base.origin}/order-confirmation/$_orderId',
                    onPaymentSuccess: () {
                      ref.read(deliveryCartProvider.notifier).clear();
                      if (mounted) {
                        context.go('/order-confirmation/$_orderId');
                      }
                    },
                    onPaymentError: (error) {
                      setState(() => _errorMessage = error);
                    },
                  ),
                ] else ...[
                  // Pay button (creates PaymentIntent, then shows element on web or PaymentSheet on mobile)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: (_isProcessing || defaultAddress == null)
                          ? null
                          : _processPayment,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.payment),
                      label: Text(
                        _isProcessing
                            ? l.checkoutProcessing
                            : l.checkoutPay(
                                '€ ${(cart.total - _promoDiscount).toStringAsFixed(2)}'),
                      ),
                      style: FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    final defaultAddress = ref.read(defaultDeliveryAddressProvider);
    if (defaultAddress == null) {
      setState(() => _errorMessage =
          AppLocalizations.of(context).checkoutAddressRequired);
      return;
    }

    final cart = ref.read(deliveryCartProvider);
    if (cart.isEmpty || cart.restaurantId == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final client = Supabase.instance.client;

      final requestBody = {
        'restaurantId': cart.restaurantId,
        'items': cart.items
            .map((item) => {
                  'menuItemId': item.menuItem.id,
                  'name': item.menuItem.name,
                  'quantity': item.quantity,
                  'unitPrice': item.menuItem.price,
                  'totalPrice': item.totalPrice,
                  'notes': item.notes,
                })
            .toList(),
        'deliveryFee': cart.deliveryFee,
        'subtotal': cart.subtotal,
        'total': cart.total,
        'deliveryAddressId': defaultAddress.id,
        'addressSnapshot': {
          'street': defaultAddress.street,
          'city': defaultAddress.city,
          'postalCode': defaultAddress.postalCode,
          'notes': defaultAddress.notes,
          'latitude': defaultAddress.latitude,
          'longitude': defaultAddress.longitude,
        },
        'notes': _orderNotesController.text.trim().isEmpty
            ? null
            : _orderNotesController.text.trim(),
        if (_appliedPromoCode != null) 'promoCode': _appliedPromoCode,
      };

      final response = await client.functions.invoke(
        'create-payment-intent',
        body: requestBody,
      );

      final data = response.data as Map<String, dynamic>;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      final clientSecret = data['clientSecret'] as String;
      final orderId = data['orderId'] as String;

      if (kIsWeb) {
        // Web: show inline Stripe Payment Element
        setState(() {
          _clientSecret = clientSecret;
          _orderId = orderId;
          _showPaymentElement = true;
          _isProcessing = false;
        });
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) {
        // Mobile: use Stripe PaymentSheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'SubitoGusto',
            style: ThemeMode.system,
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        ref.read(deliveryCartProvider.notifier).clear();

        if (mounted) {
          context.go('/order-confirmation/$orderId');
        }
      } else {
        // Desktop fallback: mark as paid for development
        await client.from('delivery_orders').update({
          'payment_status': 'paid',
          'status': 'confirmed',
        }).eq('id', orderId);

        ref.read(deliveryCartProvider.notifier).clear();

        if (mounted) {
          context.go('/order-confirmation/$orderId');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = humanizeError(e, context);
        _isProcessing = false;
      });
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
