import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/web_geolocation.dart';
import '../../data/models/delivery_address.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/services/geocoding_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// First-time location capture for consumers.
/// Two paths: browser geolocation (web) or manual address entry.
/// Result is saved as the default delivery address.
class LocationPromptPage extends ConsumerStatefulWidget {
  const LocationPromptPage({super.key});

  @override
  ConsumerState<LocationPromptPage> createState() => _LocationPromptPageState();
}

class _LocationPromptPageState extends ConsumerState<LocationPromptPage> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController(text: 'Casa');
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  bool _isLocating = false;
  bool _isSaving = false;
  bool _usedGeolocation = false;
  double? _lat;
  double? _lng;
  String? _errorMessage;

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _isLocating = true;
      _errorMessage = null;
    });

    final result = await getCurrentPosition();

    if (!mounted) return;
    setState(() => _isLocating = false);

    switch (result) {
      case GeolocationDenied():
        setState(() => _errorMessage =
            'Permesso negato. Inserisci manualmente il tuo indirizzo.');
      case GeolocationUnavailable(:final message):
        setState(() => _errorMessage = 'Posizione non disponibile: $message');
      case GeolocationSuccess(:final lat, :final lng):
        final reverse = await GeocodingService().reverse(lat, lng);
        if (!mounted) return;
        if (reverse == null) {
          setState(() => _errorMessage =
              'Impossibile leggere l\'indirizzo. Riprova o inserisci manualmente.');
          return;
        }
        setState(() {
          _lat = lat;
          _lng = lng;
          _usedGeolocation = true;
          _labelController.text = 'Posizione Corrente';
          _streetController.text = reverse.street;
          _cityController.text = reverse.city;
          _postalController.text = reverse.postalCode;
        });
    }
  }

  Future<void> _useSavedAddress(DeliveryAddress addr) async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _errorMessage = 'Sessione scaduta. Accedi di nuovo.');
        return;
      }

      await client
          .from('delivery_addresses')
          .update({'is_default': false})
          .eq('customer_id', userId);
      await client
          .from('delivery_addresses')
          .update({'is_default': true})
          .eq('id', addr.id);

      ref.invalidate(deliveryAddressesProvider);

      if (mounted) context.go('/marketplace');
    } catch (e) {
      if (mounted) setState(() => _errorMessage = humanizeError(e, context));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _errorMessage = 'Sessione scaduta. Accedi di nuovo.');
        return;
      }

      final street = _streetController.text.trim();
      final city = _cityController.text.trim();
      final postal = _postalController.text.trim();

      var lat = _lat;
      var lng = _lng;
      if (lat == null || lng == null) {
        final geo =
            await GeocodingService().geocode('$street, $postal $city, Italia');
        lat = geo?.lat;
        lng = geo?.lng;
      }

      // Clear any existing default flags.
      await client
          .from('delivery_addresses')
          .update({'is_default': false})
          .eq('customer_id', userId);

      // If saving via geolocation, overwrite any existing "Posizione Corrente"
      // row instead of stacking duplicates.
      if (_usedGeolocation) {
        final existing = await client
            .from('delivery_addresses')
            .select('id')
            .eq('customer_id', userId)
            .eq('label', 'Posizione Corrente')
            .limit(1);

        if ((existing as List).isNotEmpty) {
          await client.from('delivery_addresses').update({
            'street': street,
            'city': city,
            'postal_code': postal,
            'latitude': ?lat,
            'longitude': ?lng,
            'is_default': true,
          }).eq('id', existing.first['id']);
        } else {
          await client.from('delivery_addresses').insert({
            'customer_id': userId,
            'label': 'Posizione Corrente',
            'street': street,
            'city': city,
            'postal_code': postal,
            'latitude': ?lat,
            'longitude': ?lng,
            'is_default': true,
          });
        }
      } else {
        final label = _labelController.text.trim().isEmpty
            ? 'Casa'
            : _labelController.text.trim();
        await client.from('delivery_addresses').insert({
          'customer_id': userId,
          'label': label,
          'street': street,
          'city': city,
          'postal_code': postal,
          'latitude': ?lat,
          'longitude': ?lng,
          'is_default': true,
        });
      }

      ref.invalidate(deliveryAddressesProvider);

      if (mounted) {
        context.go('/marketplace');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Errore nel salvataggio: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final addressesAsync = ref.watch(deliveryAddressesProvider);
    final savedAddresses = addressesAsync.valueOrNull ?? const [];
    final isLoadingAddresses = addressesAsync.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: primaryColor,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text(
                    AppLocalizations.of(context).locationPromptTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Center(
                  child: Text(
                    'Ci serve per mostrarti i ristoranti che consegnano a te',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (isLoadingAddresses) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (savedAddresses.isNotEmpty) ...[
                  Text(
                    'I tuoi indirizzi salvati',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...savedAddresses.map((addr) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: InkWell(
                            onTap: _isSaving || _isLocating
                                ? null
                                : () => _useSavedAddress(addr),
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: [
                                  Icon(
                                    addr.isDefault
                                        ? Icons.star
                                        : Icons.location_on_outlined,
                                    color: addr.isDefault
                                        ? AppColors.gold
                                        : primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addr.label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          addr.fullAddress,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        child: Text(
                          'oppure aggiungi nuovo',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (kIsWeb) ...[
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isLocating || _isSaving ? null : _useMyLocation,
                      icon: _isLocating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(_isLocating
                          ? 'Localizzazione in corso...'
                          : 'Usa la mia posizione'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        child: Text(
                          'oppure inserisci',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                TextFormField(
                  controller: _labelController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Etichetta (es. Casa, Ufficio)',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Via e numero civico',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Inserisci la via' : null,
                  onChanged: (_) {
                    if (_lat != null || _usedGeolocation) {
                      _lat = null;
                      _lng = null;
                      _usedGeolocation = false;
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'Città',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Inserisci la città'
                            : null,
                        onChanged: (_) {
                          if (_lat != null || _usedGeolocation) {
                            _lat = null;
                            _lng = null;
                            _usedGeolocation = false;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _postalController,
                        decoration: const InputDecoration(
                          labelText: 'CAP',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'CAP'
                            : null,
                        onChanged: (_) {
                          if (_lat != null || _usedGeolocation) {
                            _lat = null;
                            _lng = null;
                            _usedGeolocation = false;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _isSaving || _isLocating ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Continua'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
