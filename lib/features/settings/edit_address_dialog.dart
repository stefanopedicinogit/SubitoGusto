import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/web_geolocation.dart';
import '../../data/providers/providers.dart';
import '../../data/services/geocoding_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Edit tenant address with automatic geocoding on save.
/// Updates tenants.address + latitude + longitude.
/// On web, also offers a "Use my location" shortcut.
class EditAddressDialog extends ConsumerStatefulWidget {
  final String tenantId;
  final String? currentAddress;

  const EditAddressDialog({
    super.key,
    required this.tenantId,
    this.currentAddress,
  });

  @override
  ConsumerState<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends ConsumerState<EditAddressDialog> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  bool _isLocating = false;
  double? _lat;
  double? _lng;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentAddress ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
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

    final l = AppLocalizations.of(context);
    switch (result) {
      case GeolocationDenied():
        setState(() => _errorMessage = l.editAddressPermissionDenied);
      case GeolocationUnavailable(:final message):
        setState(() => _errorMessage = l.editAddressUnavailable(message));
      case GeolocationSuccess(:final lat, :final lng):
        final reverse = await GeocodingService().reverse(lat, lng);
        if (!mounted) return;
        if (reverse == null) {
          setState(() => _errorMessage = l.editAddressReverseFail);
          return;
        }
        setState(() {
          _lat = lat;
          _lng = lng;
          final parts = <String>[
            if (reverse.street.isNotEmpty) reverse.street,
            [reverse.postalCode, reverse.city]
                .where((s) => s.isNotEmpty)
                .join(' ')
                .trim(),
          ].where((s) => s.isNotEmpty).toList();
          _controller.text = parts.join(', ');
        });
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final address = _controller.text.trim();
    if (address.isEmpty) {
      setState(() => _errorMessage = l.editAddressRequired);
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      double? lat = _lat;
      double? lng = _lng;
      if (lat == null || lng == null) {
        final geo = await GeocodingService().geocode(address);
        lat = geo?.lat;
        lng = geo?.lng;
      }

      await Supabase.instance.client.from('tenants').update({
        'address': address,
        'latitude': lat,
        'longitude': lng,
      }).eq('id', widget.tenantId);

      ref.invalidate(tenantProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lat != null
                ? l.editAddressUpdatedGeo
                : l.editAddressSavedNoGeo),
            backgroundColor:
                lat != null ? AppColors.success : AppColors.warning,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = humanizeError(e, context));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.editAddressTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (kIsWeb) ...[
              SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed:
                      _isLocating || _isSaving ? null : _useMyLocation,
                  icon: _isLocating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location, size: 20),
                  label: Text(_isLocating
                      ? l.editAddressLocating
                      : l.editAddressUseMyLocation),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            TextField(
              controller: _controller,
              autofocus: !kIsWeb,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l.editAddressLabel,
                hintText: l.editAddressHint,
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
              onChanged: (_) {
                if (_lat != null) {
                  _lat = null;
                  _lng = null;
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.editAddressFormatHelp,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving || _isLocating
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving || _isLocating ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l.commonSave),
        ),
      ],
    );
  }
}
