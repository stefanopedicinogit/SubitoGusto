import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/tenant.dart';
import '../../data/providers/repository_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../marketplace/marketplace_filters.dart' as filters;

/// Lets the staff user set their tenant's `cuisine_type` and `dietary_tags`
/// from a curated list. These power marketplace filters in Phase 10.
class DiscoverySettingsSection extends ConsumerStatefulWidget {
  final Tenant tenant;

  const DiscoverySettingsSection({super.key, required this.tenant});

  @override
  ConsumerState<DiscoverySettingsSection> createState() =>
      _DiscoverySettingsSectionState();
}

class _DiscoverySettingsSectionState
    extends ConsumerState<DiscoverySettingsSection> {
  String? _cuisine;
  late Set<String> _dietary;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _cuisine = widget.tenant.cuisineType;
    _dietary = widget.tenant.dietaryTags.toSet();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await Supabase.instance.client.from('tenants').update({
        'cuisine_type': _cuisine,
        'dietary_tags': _dietary.toList(),
      }).eq('id', widget.tenant.id);
      ref.invalidate(tenantProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).settingsSaved)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(humanizeError(e, context))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.settingsCuisineType,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: filters.kCuisineValues.map((v) {
              return ChoiceChip(
                label: Text(filters.labelForCuisine(context, v)),
                selected: _cuisine == v,
                onSelected: (sel) {
                  setState(() => _cuisine = sel ? v : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(
            l.settingsDietaryTags,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            l.settingsDietaryTagsHint,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: filters.kDietaryValues.map((v) {
              final selected = _dietary.contains(v);
              return FilterChip(
                label: Text(filters.labelForDietary(context, v)),
                selected: selected,
                onSelected: (sel) {
                  setState(() {
                    if (sel) {
                      _dietary.add(v);
                    } else {
                      _dietary.remove(v);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? l.settingsSaving : l.commonSave),
            ),
          ),
        ],
      ),
    );
  }
}
