import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/stripe_payment_element.dart';
import '../../data/models/delivery_address.dart';
import '../../data/providers/consumer_providers.dart';
import '../marketplace/delivery_cart_provider.dart';

/// Checkout page: order summary, address selection, payment
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  DeliveryAddress? _selectedAddress;
  bool _isProcessing = false;
  String? _errorMessage;

  // Web payment element state
  String? _clientSecret;
  String? _orderId;
  bool _showPaymentElement = false;

  // New address fields (if no saved addresses)
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();
  final _orderNotesController = TextEditingController();
  bool _showNewAddressForm = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    _orderNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(deliveryCartProvider);
    final addressesAsync = ref.watch(deliveryAddressesProvider);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Il carrello è vuoto')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
                _SectionTitle(title: 'Riepilogo ordine'),
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

                // Delivery address
                _SectionTitle(title: 'Indirizzo di consegna'),
                addressesAsync.when(
                  data: (addresses) {
                    // Auto-select default address
                    if (_selectedAddress == null && !_showNewAddressForm) {
                      final defaultAddr = addresses.where((a) => a.isDefault).firstOrNull;
                      if (defaultAddr != null) {
                        _selectedAddress = defaultAddr;
                      } else if (addresses.isNotEmpty) {
                        _selectedAddress = addresses.first;
                      }
                    }

                    return Card(
                      child: Column(
                        children: [
                          if (addresses.isNotEmpty && !_showNewAddressForm) ...[
                            ...addresses.map((addr) => RadioListTile<String>(
                                  title: Text(addr.label),
                                  subtitle: Text(addr.fullAddress),
                                  value: addr.id,
                                  groupValue: _selectedAddress?.id,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedAddress = addresses
                                          .firstWhere((a) => a.id == val);
                                    });
                                  },
                                )),
                            const Divider(height: 1),
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _showNewAddressForm = true),
                              icon: const Icon(Icons.add),
                              label: const Text('Nuovo indirizzo'),
                            ),
                          ] else ...[
                            _buildNewAddressForm(),
                            if (addresses.isNotEmpty)
                              TextButton(
                                onPressed: () =>
                                    setState(() => _showNewAddressForm = false),
                                child: const Text('Usa indirizzo salvato'),
                              ),
                          ],
                        ],
                      ),
                    );
                  },
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (_, __) => Card(
                    child: _buildNewAddressForm(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Order notes
                _SectionTitle(title: 'Note per il ristorante'),
                TextField(
                  controller: _orderNotesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Es. Suonare al citofono, allergie...',
                    border: OutlineInputBorder(),
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
                            label: 'Subtotale', value: cart.formatSubtotal()),
                        const SizedBox(height: AppSpacing.xs),
                        _TotalRow(
                            label: 'Consegna',
                            value: cart.formatDeliveryFee()),
                        const Divider(height: AppSpacing.lg),
                        _TotalRow(
                          label: 'Totale',
                          value: cart.formatTotal(),
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
                  _SectionTitle(title: 'Pagamento'),
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
                      onPressed: _isProcessing ? null : _processPayment,
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
                            ? 'Elaborazione...'
                            : 'Paga ${cart.formatTotal()}',
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

  Widget _buildNewAddressForm() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _streetController,
            decoration: const InputDecoration(
              labelText: 'Via e numero civico',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Città',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'CAP',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Note indirizzo (opzionale)',
              hintText: 'Piano, scala, interno...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasValidAddress() {
    if (_selectedAddress != null && !_showNewAddressForm) return true;
    return _streetController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _postalCodeController.text.trim().isNotEmpty;
  }

  Map<String, String?> _getAddressSnapshot() {
    if (_selectedAddress != null && !_showNewAddressForm) {
      return {
        'street': _selectedAddress!.street,
        'city': _selectedAddress!.city,
        'postalCode': _selectedAddress!.postalCode,
        'notes': _selectedAddress!.notes,
      };
    }
    return {
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'postalCode': _postalCodeController.text.trim(),
      'notes': _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    };
  }

  Future<void> _processPayment() async {
    if (!_hasValidAddress()) {
      setState(() => _errorMessage = 'Inserisci un indirizzo di consegna');
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

      // Save new address if entered manually
      String? addressId;
      if (_showNewAddressForm || _selectedAddress == null) {
        final userId = client.auth.currentUser?.id;
        if (userId != null) {
          final result = await client.from('delivery_addresses').insert({
            'customer_id': userId,
            'label': 'Consegna',
            'street': _streetController.text.trim(),
            'city': _cityController.text.trim(),
            'postal_code': _postalCodeController.text.trim(),
            'notes': _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          }).select().single();
          addressId = result['id'] as String;
          ref.invalidate(deliveryAddressesProvider);
        }
      } else {
        addressId = _selectedAddress!.id;
      }

      // Build the request body — always use PaymentIntent (not Checkout Session)
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
        'deliveryAddressId': addressId,
        'addressSnapshot': _getAddressSnapshot(),
        'notes': _orderNotesController.text.trim().isEmpty
            ? null
            : _orderNotesController.text.trim(),
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
        _errorMessage = 'Errore: $e';
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

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
