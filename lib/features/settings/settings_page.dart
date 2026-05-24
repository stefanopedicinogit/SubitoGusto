import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/providers.dart';
import '../../data/services/geocoding_service.dart';
import '../../core/widgets/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';
import 'discovery_settings_section.dart';
import 'edit_address_dialog.dart';

/// Settings page for desktop
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final tenantAsync = ref.watch(tenantProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tenant Info Section
                _SectionCard(
                  title: l.settingsRestaurantInfo,
                  icon: Icons.restaurant,
                  child: tenantAsync.when(
                    data: (tenant) => Column(
                      children: [
                        _InfoRow(
                          label: l.settingsRestaurantName,
                          value: tenant?.name ?? l.settingsRestaurant,
                        ),
                        const Divider(height: 1),
                        InkWell(
                          onTap: tenant == null
                              ? null
                              : () => showDialog(
                                    context: context,
                                    builder: (_) => EditAddressDialog(
                                      tenantId: tenant.id,
                                      currentAddress: tenant.address,
                                    ),
                                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    l.settingsAddress,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tenant?.address ?? l.settingsNotConfigured,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        _InfoRow(
                          label: l.settingsPhone,
                          value: tenant?.phone ?? l.settingsNotConfigured,
                        ),
                        const Divider(height: 1),
                        _InfoRow(
                          label: l.settingsEmail,
                          value: tenant?.email ?? l.settingsNotConfigured,
                        ),
                      ],
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(l.settingsLoadingError),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Notifications Section
                _SectionCard(
                  title: l.settingsNotifications,
                  icon: Icons.notifications,
                  child: Column(
                    children: [
                      _SettingsSwitch(
                        title: l.settingsNotificationsOrders,
                        subtitle: l.settingsNotificationsOrdersSub,
                        value: settings.orderNotifications,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).setOrderNotifications(value);
                        },
                      ),
                      const Divider(height: 1),
                      _SettingsSwitch(
                        title: l.settingsSoundAlertsTitle,
                        subtitle: l.settingsSoundAlertsSub,
                        value: settings.soundAlerts,
                        onChanged: settings.orderNotifications
                            ? (value) {
                                ref.read(settingsProvider.notifier).setSoundAlerts(value);
                              }
                            : null,
                      ),
                      const Divider(height: 1),
                      _SettingsSwitch(
                        title: l.settingsVibrationTitle,
                        subtitle: l.settingsVibrationSub,
                        value: settings.vibration,
                        onChanged: settings.orderNotifications
                            ? (value) {
                                ref.read(settingsProvider.notifier).setVibration(value);
                              }
                            : null,
                      ),
                      const Divider(height: 1),
                      _SoundSelector(
                        currentIndex: settings.notificationSoundIndex,
                        onChanged: settings.soundAlerts
                            ? (index) {
                                ref.read(settingsProvider.notifier).setNotificationSoundIndex(index);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Orders Section
                _SectionCard(
                  title: l.settingsOrdersManagement,
                  icon: Icons.receipt_long,
                  child: Column(
                    children: [
                      _SettingsSwitch(
                        title: l.settingsAutoConfirm,
                        subtitle: l.settingsAutoConfirmSub,
                        value: settings.autoConfirmOrders,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).setAutoConfirmOrders(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Delivery Section
                _SectionCard(
                  title: l.settingsDelivery,
                  icon: Icons.delivery_dining,
                  child: tenantAsync.when(
                    data: (tenant) => _DeliverySettingsEditor(
                      deliveryEnabled: tenant?.deliveryEnabled ?? false,
                      deliveryFee: tenant?.deliveryFee ?? 0,
                      deliveryRadiusKm: tenant?.deliveryRadiusKm ?? 5,
                      deliveryMinOrder: tenant?.deliveryMinOrder ?? 0,
                      deliveryEstimatedTimeMin: tenant?.deliveryEstimatedTimeMin ?? 30,
                      stripeAccountId: tenant?.stripeAccountId,
                      tenantId: tenant?.id,
                      hasCoordinates: tenant?.hasCoordinates ?? false,
                      address: tenant?.address,
                      vacationMode: tenant?.vacationMode ?? false,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(l.settingsLoadingError),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Discovery (cuisine + dietary tags) — powers marketplace filters
                _SectionCard(
                  title: l.settingsCategoryAndTags,
                  icon: Icons.local_dining,
                  child: tenantAsync.when(
                    data: (tenant) => tenant == null
                        ? const SizedBox.shrink()
                        : DiscoverySettingsSection(tenant: tenant),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(l.settingsLoadingError),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Promo codes — link to the dedicated management page.
                _SectionCard(
                  title: l.settingsPromoCodes,
                  icon: Icons.local_offer,
                  child: ListTile(
                    leading: const Icon(Icons.local_offer_outlined),
                    title: Text(l.settingsPromoCodesAction),
                    subtitle: Text(l.settingsPromoCodesSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/promo-codes'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Language
                _SectionCard(
                  title: 'Lingua / Language',
                  icon: Icons.language,
                  child: const ListTile(
                    leading: Icon(Icons.translate),
                    title: Text('Lingua / Language'),
                    trailing: LanguageSwitcher(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Theme Section
                _SectionCard(
                  title: l.settingsAppearance,
                  icon: Icons.palette,
                  child: Column(
                    children: [
                      _ThemeSelector(
                        currentTheme: settings.theme,
                        onChanged: (theme) {
                          ref.read(settingsProvider.notifier).setTheme(theme);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Brand Colors Section
                _SectionCard(
                  title: l.settingsBrandColors,
                  icon: Icons.color_lens,
                  child: tenantAsync.when(
                    data: (tenant) => _BrandColorsEditor(
                      primaryColor: tenant?.primaryColor,
                      secondaryColor: tenant?.secondaryColor,
                      backgroundColor: tenant?.backgroundColor,
                      tenantId: tenant?.id,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(l.settingsLoadingError),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Account Section
                _SectionCard(
                  title: l.settingsAccount,
                  icon: Icons.person,
                  child: Column(
                    children: [
                      _InfoRow(
                        label: l.settingsEmail,
                        value: Supabase.instance.client.auth.currentUser?.email ?? 'N/A',
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showChangePasswordDialog(context),
                                icon: const Icon(Icons.lock),
                                label: Text(l.settingsChangePassword),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _logout(context, ref),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                icon: const Icon(Icons.logout),
                                label: Text(l.settingsSignOut),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // App Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        'SubitoGusto',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l.settingsVersion('1.0.0'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _ChangePasswordDialog(),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(AppLocalizations.of(dialogCtx).settingsSignOutTitle),
        content: Text(AppLocalizations.of(dialogCtx).settingsSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(AppLocalizations.of(dialogCtx).commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(dialogCtx).settingsSignOut),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final String currentTheme;
  final ValueChanged<String> onChanged;

  const _ThemeSelector({
    required this.currentTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(l.settingsTheme),
          const Spacer(),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'light',
                icon: const Icon(Icons.light_mode),
                label: Text(l.settingsThemeLightShort),
              ),
              ButtonSegment(
                value: 'dark',
                icon: const Icon(Icons.dark_mode),
                label: Text(l.settingsThemeDarkShort),
              ),
              ButtonSegment(
                value: 'system',
                icon: const Icon(Icons.settings_brightness),
                label: Text(l.settingsThemeSystemShort),
              ),
            ],
            selected: {currentTheme},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

class _SoundSelector extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onChanged;

  const _SoundSelector({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sounds = [l.settingsSoundClassic, l.settingsSoundBell, l.settingsSoundChime];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text(l.settingsNotificationSound),
          const Spacer(),
          DropdownButton<int>(
            value: currentIndex,
            onChanged: onChanged != null ? (v) => onChanged!(v!) : null,
            items: sounds.asMap().entries.map((e) {
              return DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _newPasswordController.text),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsPasswordUpdated),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.settingsChangePassword),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: l.settingsNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return l.settingsPasswordMinChars;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: l.settingsConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return l.settingsPasswordMismatch;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.commonSave),
        ),
      ],
    );
  }
}

class _BrandColorsEditor extends ConsumerStatefulWidget {
  final String? primaryColor;
  final String? secondaryColor;
  final String? backgroundColor;
  final String? tenantId;

  const _BrandColorsEditor({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.tenantId,
  });

  @override
  ConsumerState<_BrandColorsEditor> createState() => _BrandColorsEditorState();
}

class _BrandColorsEditorState extends ConsumerState<_BrandColorsEditor> {
  late TextEditingController _primaryController;
  late TextEditingController _secondaryController;
  late TextEditingController _backgroundController;
  bool _isSaving = false;

  // Predefined color options
  static const List<String> _primaryOptions = [
    '#722F37', // Burgundy (default)
    '#1E3A5F', // Navy Blue
    '#2E7D32', // Forest Green
    '#6D4C41', // Brown
    '#5D4037', // Dark Brown
    '#37474F', // Blue Grey
    '#4A148C', // Deep Purple
    '#B71C1C', // Dark Red
  ];

  static const List<String> _secondaryOptions = [
    '#D4AF37', // Gold (default)
    '#FFB74D', // Orange
    '#81C784', // Light Green
    '#64B5F6', // Light Blue
    '#BA68C8', // Purple
    '#F06292', // Pink
    '#4DB6AC', // Teal
    '#A1887F', // Tan
  ];

  static const List<String> _backgroundOptions = [
    '#FDF5E6', // Cream (default)
    '#FFFFFF', // White
    '#F5F5F5', // Light Grey
    '#FFF8E1', // Warm White
    '#E8F5E9', // Mint
    '#E3F2FD', // Ice Blue
    '#FBE9E7', // Peach
    '#F3E5F5', // Lavender
  ];

  @override
  void initState() {
    super.initState();
    _primaryController = TextEditingController(text: widget.primaryColor ?? '#722F37');
    _secondaryController = TextEditingController(text: widget.secondaryColor ?? '#D4AF37');
    _backgroundController = TextEditingController(text: widget.backgroundColor ?? '#FDF5E6');
  }

  @override
  void didUpdateWidget(covariant _BrandColorsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primaryColor != widget.primaryColor) {
      _primaryController.text = widget.primaryColor ?? '#722F37';
    }
    if (oldWidget.secondaryColor != widget.secondaryColor) {
      _secondaryController.text = widget.secondaryColor ?? '#D4AF37';
    }
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _backgroundController.text = widget.backgroundColor ?? '#FDF5E6';
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Color? _parseColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      if (hexCode.length == 6) {
        return Color(int.parse('FF$hexCode', radix: 16));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _saveColors() async {
    if (widget.tenantId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsNoTenantError),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get current settings
      final currentSettings = await Supabase.instance.client
          .from('tenants')
          .select('settings')
          .eq('id', widget.tenantId!)
          .single();

      final settings = Map<String, dynamic>.from(
        currentSettings['settings'] as Map<String, dynamic>? ?? {},
      );

      // Update theme colors
      settings['primary_color'] = _primaryController.text;
      settings['secondary_color'] = _secondaryController.text;
      settings['background_color'] = _backgroundController.text;

      // Use .select().single() to verify the update actually succeeded
      await Supabase.instance.client
          .from('tenants')
          .update({'settings': settings})
          .eq('id', widget.tenantId!)
          .select()
          .single();

      // Invalidate tenant provider to refresh theme
      ref.invalidate(tenantProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsColorsSaved),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorPickerRow(
          label: l.settingsPrimaryColor,
          hint: l.settingsPrimaryColorHint,
          controller: _primaryController,
          options: _primaryOptions,
          onColorSelected: (color) => setState(() => _primaryController.text = color),
        ),
        const Divider(height: 1),
        _ColorPickerRow(
          label: l.settingsSecondaryColor,
          hint: l.settingsSecondaryColorHint,
          controller: _secondaryController,
          options: _secondaryOptions,
          onColorSelected: (color) => setState(() => _secondaryController.text = color),
        ),
        const Divider(height: 1),
        _ColorPickerRow(
          label: l.settingsBackgroundColor,
          hint: l.settingsBackgroundColorHint,
          controller: _backgroundController,
          options: _backgroundOptions,
          onColorSelected: (color) => setState(() => _backgroundController.text = color),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Preview
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: _parseColor(_backgroundController.text) ?? AppColors.cream,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _parseColor(_primaryController.text) ?? AppColors.burgundy,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: _parseColor(_secondaryController.text) ?? AppColors.gold,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          l.settingsAccent,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveColors,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(l.settingsSaveColors),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorPickerRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<String> options;
  final ValueChanged<String> onColorSelected;

  const _ColorPickerRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.options,
    required this.onColorSelected,
  });

  Color? _parseColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      if (hexCode.length == 6) {
        return Color(int.parse('FF$hexCode', radix: 16));
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _parseColor(controller.text);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      hint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              // Current color preview
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: currentColor ?? Colors.grey,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Hex input
              SizedBox(
                width: 100,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'monospace'),
                  onChanged: (_) => onColorSelected(controller.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Color options
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: options.map((hex) {
              final color = _parseColor(hex);
              final isSelected = controller.text.toLowerCase() == hex.toLowerCase();
              return GestureDetector(
                onTap: () => onColorSelected(hex),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade400,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _isLightColor(color) ? Colors.black : Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isLightColor(Color? color) {
    if (color == null) return true;
    return color.computeLuminance() > 0.5;
  }
}

class _DeliverySettingsEditor extends ConsumerStatefulWidget {
  final bool deliveryEnabled;
  final double deliveryFee;
  final double deliveryRadiusKm;
  final double deliveryMinOrder;
  final int deliveryEstimatedTimeMin;
  final String? stripeAccountId;
  final String? tenantId;
  final bool hasCoordinates;
  final String? address;
  final bool vacationMode;

  const _DeliverySettingsEditor({
    required this.deliveryEnabled,
    required this.deliveryFee,
    required this.deliveryRadiusKm,
    required this.deliveryMinOrder,
    required this.deliveryEstimatedTimeMin,
    this.stripeAccountId,
    this.tenantId,
    required this.hasCoordinates,
    this.address,
    required this.vacationMode,
  });

  @override
  ConsumerState<_DeliverySettingsEditor> createState() =>
      _DeliverySettingsEditorState();
}

class _DeliverySettingsEditorState
    extends ConsumerState<_DeliverySettingsEditor> {
  late bool _enabled;
  late bool _vacation;
  late TextEditingController _feeController;
  late TextEditingController _radiusController;
  late TextEditingController _minOrderController;
  late TextEditingController _timeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _enabled = widget.deliveryEnabled;
    _vacation = widget.vacationMode;
    _feeController =
        TextEditingController(text: widget.deliveryFee.toStringAsFixed(2));
    _radiusController =
        TextEditingController(text: widget.deliveryRadiusKm.toStringAsFixed(1));
    _minOrderController =
        TextEditingController(text: widget.deliveryMinOrder.toStringAsFixed(2));
    _timeController =
        TextEditingController(text: widget.deliveryEstimatedTimeMin.toString());
  }

  @override
  void didUpdateWidget(covariant _DeliverySettingsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveryEnabled != widget.deliveryEnabled) {
      _enabled = widget.deliveryEnabled;
    }
    if (oldWidget.vacationMode != widget.vacationMode) {
      _vacation = widget.vacationMode;
    }
    if (oldWidget.deliveryFee != widget.deliveryFee) {
      _feeController.text = widget.deliveryFee.toStringAsFixed(2);
    }
    if (oldWidget.deliveryRadiusKm != widget.deliveryRadiusKm) {
      _radiusController.text = widget.deliveryRadiusKm.toStringAsFixed(1);
    }
    if (oldWidget.deliveryMinOrder != widget.deliveryMinOrder) {
      _minOrderController.text = widget.deliveryMinOrder.toStringAsFixed(2);
    }
    if (oldWidget.deliveryEstimatedTimeMin != widget.deliveryEstimatedTimeMin) {
      _timeController.text = widget.deliveryEstimatedTimeMin.toString();
    }
  }

  @override
  void dispose() {
    _feeController.dispose();
    _radiusController.dispose();
    _minOrderController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _startStripeOnboarding() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'stripe-connect-onboard',
        body: {
          'returnUrl': Uri.base.toString(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      final url = data['url'] as String;
      // Open Stripe onboarding in a new tab/window
      // ignore: avoid_print
      print('Stripe onboarding URL: $url');
      // Use url_launcher or just show the URL
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(ctx).settingsStripeOnboardingTitle),
            content: SelectableText(
              AppLocalizations.of(ctx).settingsStripeOnboardingBody(url),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (widget.tenantId == null) return;

    setState(() => _isSaving = true);

    try {
      await Supabase.instance.client
          .from('tenants')
          .update({
            'delivery_enabled': _enabled,
            'vacation_mode': _vacation,
            'delivery_fee': double.tryParse(_feeController.text) ?? 0,
            'delivery_radius_km':
                double.tryParse(_radiusController.text) ?? 5,
            'delivery_min_order':
                double.tryParse(_minOrderController.text) ?? 0,
            'delivery_estimated_time_min':
                int.tryParse(_timeController.text) ?? 30,
          })
          .eq('id', widget.tenantId!)
          .select()
          .single();

      ref.invalidate(tenantProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsDeliverySaved),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        SwitchListTile(
          title: Text(l.settingsEnableDelivery),
          subtitle: Text(l.settingsEnableDeliverySub),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        if (_enabled) ...[
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.beach_access_outlined),
            title: Text(l.settingsVacation),
            subtitle: Text(l.settingsVacationSub),
            value: _vacation,
            onChanged: (value) => setState(() => _vacation = value),
            activeColor: AppColors.warning,
          ),
          const Divider(height: 1),
          if (!widget.hasCoordinates && widget.tenantId != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: _GeocodingWarning(
                tenantId: widget.tenantId!,
                address: widget.address,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _DeliveryField(
                    label: l.settingsDeliveryCost,
                    suffix: '\u20ac',
                    controller: _feeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _DeliveryField(
                    label: l.settingsDeliveryMinOrder,
                    suffix: '\u20ac',
                    controller: _minOrderController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _DeliveryField(
                    label: l.settingsDeliveryRadiusLabel,
                    suffix: 'km',
                    controller: _radiusController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _DeliveryField(
                    label: l.settingsDeliveryEtaLabel,
                    suffix: 'min',
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Stripe status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: widget.stripeAccountId != null
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: widget.stripeAccountId != null
                      ? AppColors.success.withValues(alpha: 0.4)
                      : AppColors.warning.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.stripeAccountId != null
                        ? Icons.check_circle
                        : Icons.info_outline,
                    size: 20,
                    color: widget.stripeAccountId != null
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: widget.stripeAccountId != null
                        ? Text(
                            l.settingsStripeConnected,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          )
                        : Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.warning,
                              ),
                              children: [
                                TextSpan(
                                  text: l.settingsStripeNotConnected,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: l.settingsStripeNotConnectedSub,
                                ),
                              ],
                            ),
                          ),
                  ),
                  if (widget.stripeAccountId == null)
                    FilledButton.tonal(
                      onPressed: _startStripeOnboarding,
                      child: Text(l.settingsStripeConfigure),
                    ),
                ],
              ),
            ),
          ),
        ],
        const Divider(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(l.commonSave),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeliveryField extends StatelessWidget {
  final String label;
  final String suffix;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _DeliveryField({
    required this.label,
    required this.suffix,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// Warning shown when delivery is enabled but the tenant has no lat/lng.
/// Offers a retry button that re-geocodes the existing address, or — if no
/// address is set — prompts the user to add one.
class _GeocodingWarning extends ConsumerStatefulWidget {
  final String tenantId;
  final String? address;

  const _GeocodingWarning({required this.tenantId, this.address});

  @override
  ConsumerState<_GeocodingWarning> createState() => _GeocodingWarningState();
}

class _GeocodingWarningState extends ConsumerState<_GeocodingWarning> {
  bool _isRetrying = false;
  String? _resultMessage;
  bool _resultIsError = false;

  Future<void> _retry() async {
    final address = widget.address?.trim();
    if (address == null || address.isEmpty) return;

    setState(() {
      _isRetrying = true;
      _resultMessage = null;
    });

    final geo = await GeocodingService().geocode(address);

    if (!mounted) return;

    final l = AppLocalizations.of(context);
    if (geo == null) {
      setState(() {
        _isRetrying = false;
        _resultIsError = true;
        _resultMessage = l.settingsGeoFail;
      });
      return;
    }

    try {
      await Supabase.instance.client.from('tenants').update({
        'latitude': geo.lat,
        'longitude': geo.lng,
      }).eq('id', widget.tenantId);

      ref.invalidate(tenantProvider);

      if (!mounted) return;
      setState(() {
        _isRetrying = false;
        _resultIsError = false;
        _resultMessage = l.settingsGeoSuccess;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isRetrying = false;
        _resultIsError = true;
        _resultMessage = humanizeError(e, context);
      });
    }
  }

  Future<void> _openAddressDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (_) => EditAddressDialog(
        tenantId: widget.tenantId,
        currentAddress: widget.address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasAddress =
        widget.address != null && widget.address!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.settingsNotGeolocated,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                    fontSize: 14,
                  ),
                ),
              ),
              if (hasAddress)
                FilledButton.tonal(
                  onPressed: _isRetrying ? null : _retry,
                  child: _isRetrying
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.commonRetry),
                )
              else
                FilledButton.tonal(
                  onPressed: _openAddressDialog,
                  child: Text(l.settingsSetAddress),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasAddress
                ? l.settingsGeoMissingHint
                : l.settingsGeoAddressFirst,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (_resultMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _resultMessage!,
              style: TextStyle(
                fontSize: 13,
                color: _resultIsError ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
