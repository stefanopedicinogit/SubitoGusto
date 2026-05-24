import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/providers.dart';
import '../../data/providers/tenant_theme_provider.dart';
import '../../data/services/geocoding_service.dart';
import '../../core/widgets/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';
import 'discovery_settings_section.dart';
import 'edit_address_dialog.dart';

/// Settings page for mobile
class SettingsPageMobile extends ConsumerWidget {
  const SettingsPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final tenantAsync = ref.watch(tenantProvider);
    final colors = ref.watch(tenantColorsProvider);
    final primaryColor = colors.primary;

    return Scaffold(
      body: ListView(
        children: [
          // Tenant Info Section
          _SectionHeader(title: l.settingsRestaurant),
          tenantAsync.when(
            data: (tenant) => Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: tenant?.logoUrl != null
                          ? Image.network(
                              tenant!.logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  tenant.logoInitial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                tenant?.logoInitial ?? 'T',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    title: Text(tenant?.name ?? l.settingsRestaurant),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(l.settingsAddress),
                    subtitle: Text(tenant?.address ?? l.settingsNotConfigured),
                    trailing: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onTap: tenant == null
                        ? null
                        : () => showDialog(
                              context: context,
                              builder: (_) => EditAddressDialog(
                                tenantId: tenant.id,
                                currentAddress: tenant.address,
                              ),
                            ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(l.settingsPhone),
                    subtitle: Text(tenant?.phone ?? l.settingsNotConfigured),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(l.settingsEmail),
                    subtitle: Text(tenant?.email ?? l.settingsNotConfigured),
                  ),
                ],
              ),
            ),
            loading: () => const Card(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: ListTile(
                leading: const Icon(Icons.error, color: AppColors.error),
                title: Text(AppLocalizations.of(context).settingsLoadingError),
              ),
            ),
          ),

          // Notifications Section
          _SectionHeader(title: l.settingsNotifications),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: Text(l.settingsNotificationsOrders),
                  subtitle: Text(l.settingsNotificationsOrdersSub),
                  value: settings.orderNotifications,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setOrderNotifications(value);
                  },
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up),
                  title: Text(l.settingsSoundAlertsTitle),
                  subtitle: Text(l.settingsSoundAlertsSub),
                  value: settings.soundAlerts,
                  onChanged: settings.orderNotifications
                      ? (value) {
                          ref.read(settingsProvider.notifier).setSoundAlerts(value);
                        }
                      : null,
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: Text(l.settingsVibrationTitle),
                  subtitle: Text(l.settingsVibrationSubShort),
                  value: settings.vibration,
                  onChanged: settings.orderNotifications
                      ? (value) {
                          ref.read(settingsProvider.notifier).setVibration(value);
                        }
                      : null,
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(l.settingsNotificationSound),
                  trailing: DropdownButton<int>(
                    value: settings.notificationSoundIndex,
                    underline: const SizedBox(),
                    onChanged: settings.soundAlerts
                        ? (v) {
                            ref.read(settingsProvider.notifier).setNotificationSoundIndex(v!);
                          }
                        : null,
                    items: [
                      DropdownMenuItem(value: 0, child: Text(l.settingsSoundClassic)),
                      DropdownMenuItem(value: 1, child: Text(l.settingsSoundBell)),
                      DropdownMenuItem(value: 2, child: Text(l.settingsSoundChime)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders Section
          _SectionHeader(title: l.settingsOrdersManagement),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SwitchListTile(
              secondary: const Icon(Icons.check_circle),
              title: Text(l.settingsAutoConfirm),
              subtitle: Text(l.settingsAutoConfirmSub),
              value: settings.autoConfirmOrders,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setAutoConfirmOrders(value);
              },
              activeColor: primaryColor,
            ),
          ),

          // Delivery Section
          _SectionHeader(title: l.settingsDelivery),
          tenantAsync.when(
            data: (tenant) => _DeliverySettingsMobile(
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
            loading: () => const Card(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: ListTile(
                leading: const Icon(Icons.error, color: AppColors.error),
                title: Text(AppLocalizations.of(context).settingsLoadingError),
              ),
            ),
          ),

          // Discovery (cuisine + dietary tags)
          _SectionHeader(title: l.settingsCategoryAndTags),
          tenantAsync.when(
            data: (tenant) => tenant == null
                ? const SizedBox.shrink()
                : Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    child: DiscoverySettingsSection(tenant: tenant),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Promo codes — link to dedicated management page
          _SectionHeader(title: l.settingsPromoCodes),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: ListTile(
              leading: const Icon(Icons.local_offer_outlined),
              title: Text(l.settingsPromoCodesAction),
              subtitle: Text(l.settingsPromoCodesSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/promo-codes'),
            ),
          ),

          // Language
          _SectionHeader(title: 'Lingua / Language'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: const ListTile(
              leading: Icon(Icons.translate),
              title: Text('Lingua / Language'),
              trailing: LanguageSwitcher(),
            ),
          ),

          // Theme Section
          _SectionHeader(title: l.settingsAppearance),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                RadioListTile<String>(
                  secondary: const Icon(Icons.light_mode),
                  title: Text(l.settingsThemeLight),
                  value: 'light',
                  groupValue: settings.theme,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setTheme(value!);
                  },
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(l.settingsThemeDark),
                  value: 'dark',
                  groupValue: settings.theme,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setTheme(value!);
                  },
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  secondary: const Icon(Icons.settings_brightness),
                  title: Text(l.settingsThemeSystem),
                  value: 'system',
                  groupValue: settings.theme,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setTheme(value!);
                  },
                  activeColor: primaryColor,
                ),
              ],
            ),
          ),

          // Account Section
          _SectionHeader(title: l.settingsAccount),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(l.settingsEmail),
                  subtitle: Text(
                    Supabase.instance.client.auth.currentUser?.email ?? 'N/A',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(l.settingsChangePassword),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordSheet(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    l.settingsSignOut,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  onTap: () => _logout(context, ref),
                ),
              ],
            ),
          ),

          // App Info
          const SizedBox(height: AppSpacing.xl),
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
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const _ChangePasswordSheet(),
      ),
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.settingsChangePassword,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: l.settingsNewPassword,
                  prefixIcon: const Icon(Icons.lock),
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
                  prefixIcon: const Icon(Icons.lock_outline),
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
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isLoading ? null : _changePassword,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l.commonSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliverySettingsMobile extends ConsumerStatefulWidget {
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

  const _DeliverySettingsMobile({
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
  ConsumerState<_DeliverySettingsMobile> createState() =>
      _DeliverySettingsMobileState();
}

class _DeliverySettingsMobileState
    extends ConsumerState<_DeliverySettingsMobile> {
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
  void didUpdateWidget(covariant _DeliverySettingsMobile oldWidget) {
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
    final primaryColor = ref.watch(tenantColorsProvider).primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.delivery_dining),
            title: Text(l.settingsEnableDelivery),
            subtitle: Text(l.settingsEnableDeliverySubShort),
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
            activeColor: primaryColor,
          ),
          if (_enabled) ...[
            const Divider(height: 1),
            SwitchListTile(
              secondary: const Icon(Icons.beach_access_outlined),
              title: Text(l.settingsVacation),
              subtitle: Text(l.settingsVacationSubShort),
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
                child: _GeocodingWarningMobile(
                  tenantId: widget.tenantId!,
                  address: widget.address,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feeController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: l.settingsDeliveryCost,
                            suffixText: '\u20ac',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _minOrderController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: l.settingsDeliveryMinOrder,
                            suffixText: '\u20ac',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _radiusController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: l.settingsDeliveryRadiusLabel,
                            suffixText: 'km',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l.settingsDeliveryEtaLabel,
                            suffixText: 'min',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stripe status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
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
                      size: 18,
                      color: widget.stripeAccountId != null
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        widget.stripeAccountId != null
                            ? l.settingsStripeConnected
                            : l.settingsStripeNotConfigured,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.stripeAccountId != null
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
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
            child: SizedBox(
              width: double.infinity,
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
      ),
    );
  }
}

/// Warning shown when delivery is enabled but the tenant has no lat/lng.
class _GeocodingWarningMobile extends ConsumerStatefulWidget {
  final String tenantId;
  final String? address;

  const _GeocodingWarningMobile({required this.tenantId, this.address});

  @override
  ConsumerState<_GeocodingWarningMobile> createState() =>
      _GeocodingWarningMobileState();
}

class _GeocodingWarningMobileState
    extends ConsumerState<_GeocodingWarningMobile> {
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
        _resultMessage = l.settingsGeoFailShort;
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
      padding: const EdgeInsets.all(AppSpacing.sm),
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
                size: 18,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.settingsNotGeolocatedShort,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasAddress
                ? l.settingsGeoMissingHint
                : l.settingsGeoAddressFirst,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (_resultMessage != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _resultMessage!,
              style: TextStyle(
                fontSize: 12,
                color: _resultIsError ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: hasAddress
                  ? (_isRetrying ? null : _retry)
                  : _openAddressDialog,
              icon: _isRetrying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(hasAddress
                      ? Icons.refresh
                      : Icons.location_on_outlined),
              label: Text(
                hasAddress ? l.settingsRetryGeocoding : l.settingsSetAddress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
