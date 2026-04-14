import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/providers.dart';
import '../../data/providers/tenant_theme_provider.dart';

/// Settings page for mobile
class SettingsPageMobile extends ConsumerWidget {
  const SettingsPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final tenantAsync = ref.watch(tenantProvider);
    final colors = ref.watch(tenantColorsProvider);
    final primaryColor = colors.primary;

    return Scaffold(
      body: ListView(
        children: [
          // Tenant Info Section
          _SectionHeader(title: 'Ristorante'),
          tenantAsync.when(
            data: (tenant) => Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
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
                                    fontSize: 24,
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    title: Text(tenant?.name ?? 'Ristorante'),
                    subtitle: Text(tenant?.address ?? 'Indirizzo non configurato'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Telefono'),
                    subtitle: Text(tenant?.phone ?? 'Non configurato'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(tenant?.email ?? 'Non configurato'),
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
            error: (_, __) => const Card(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: ListTile(
                leading: Icon(Icons.error, color: AppColors.error),
                title: Text('Errore nel caricamento'),
              ),
            ),
          ),

          // Notifications Section
          _SectionHeader(title: 'Notifiche'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Notifiche ordini'),
                  subtitle: const Text('Ricevi notifiche per nuovi ordini'),
                  value: settings.orderNotifications,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).setOrderNotifications(value);
                  },
                  activeColor: primaryColor,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up),
                  title: const Text('Suoni di avviso'),
                  subtitle: const Text('Riproduci un suono per le notifiche'),
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
                  title: const Text('Vibrazione'),
                  subtitle: const Text('Vibra per le notifiche'),
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
                  title: const Text('Suono notifica'),
                  trailing: DropdownButton<int>(
                    value: settings.notificationSoundIndex,
                    underline: const SizedBox(),
                    onChanged: settings.soundAlerts
                        ? (v) {
                            ref.read(settingsProvider.notifier).setNotificationSoundIndex(v!);
                          }
                        : null,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Classico')),
                      DropdownMenuItem(value: 1, child: Text('Campanello')),
                      DropdownMenuItem(value: 2, child: Text('Chime')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders Section
          _SectionHeader(title: 'Gestione Ordini'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SwitchListTile(
              secondary: const Icon(Icons.check_circle),
              title: const Text('Conferma automatica'),
              subtitle: const Text('Conferma automaticamente i nuovi ordini'),
              value: settings.autoConfirmOrders,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setAutoConfirmOrders(value);
              },
              activeColor: primaryColor,
            ),
          ),

          // Delivery Section
          _SectionHeader(title: 'Consegne'),
          tenantAsync.when(
            data: (tenant) => _DeliverySettingsMobile(
              deliveryEnabled: tenant?.deliveryEnabled ?? false,
              deliveryFee: tenant?.deliveryFee ?? 0,
              deliveryRadiusKm: tenant?.deliveryRadiusKm ?? 5,
              deliveryMinOrder: tenant?.deliveryMinOrder ?? 0,
              deliveryEstimatedTimeMin: tenant?.deliveryEstimatedTimeMin ?? 30,
              stripeAccountId: tenant?.stripeAccountId,
              tenantId: tenant?.id,
            ),
            loading: () => const Card(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => const Card(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: ListTile(
                leading: Icon(Icons.error, color: AppColors.error),
                title: Text('Errore nel caricamento'),
              ),
            ),
          ),

          // Theme Section
          _SectionHeader(title: 'Aspetto'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                RadioListTile<String>(
                  secondary: const Icon(Icons.light_mode),
                  title: const Text('Tema chiaro'),
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
                  title: const Text('Tema scuro'),
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
                  title: const Text('Segui sistema'),
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
          _SectionHeader(title: 'Account'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(
                    Supabase.instance.client.auth.currentUser?.email ?? 'N/A',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Cambia password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordSheet(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text(
                    'Esci',
                    style: TextStyle(color: AppColors.error),
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
                  'Versione 1.0.0',
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
      builder: (context) => AlertDialog(
        title: const Text('Conferma Logout'),
        content: const Text('Sei sicuro di voler uscire?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Esci'),
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
          const SnackBar(
            content: Text('Password aggiornata con successo'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
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
                'Cambia password',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'Nuova password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Minimo 6 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Conferma password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Le password non coincidono';
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
                    : const Text('Salva'),
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

  const _DeliverySettingsMobile({
    required this.deliveryEnabled,
    required this.deliveryFee,
    required this.deliveryRadiusKm,
    required this.deliveryMinOrder,
    required this.deliveryEstimatedTimeMin,
    this.stripeAccountId,
    this.tenantId,
  });

  @override
  ConsumerState<_DeliverySettingsMobile> createState() =>
      _DeliverySettingsMobileState();
}

class _DeliverySettingsMobileState
    extends ConsumerState<_DeliverySettingsMobile> {
  late bool _enabled;
  late TextEditingController _feeController;
  late TextEditingController _radiusController;
  late TextEditingController _minOrderController;
  late TextEditingController _timeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _enabled = widget.deliveryEnabled;
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
          const SnackBar(
            content: Text('Impostazioni consegna salvate'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel salvataggio: $e'),
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
    final primaryColor = ref.watch(tenantColorsProvider).primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.delivery_dining),
            title: const Text('Abilita consegne'),
            subtitle: const Text('Appari nel marketplace'),
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
            activeColor: primaryColor,
          ),
          if (_enabled) ...[
            const Divider(height: 1),
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
                          decoration: const InputDecoration(
                            labelText: 'Costo consegna',
                            suffixText: '\u20ac',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _minOrderController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Ordine minimo',
                            suffixText: '\u20ac',
                            isDense: true,
                            border: OutlineInputBorder(),
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
                          decoration: const InputDecoration(
                            labelText: 'Raggio',
                            suffixText: 'km',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Tempo stimato',
                            suffixText: 'min',
                            isDense: true,
                            border: OutlineInputBorder(),
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
                            ? 'Stripe Connect configurato'
                            : 'Stripe non configurato',
                        style: TextStyle(
                          fontSize: 13,
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
                label: const Text('Salva'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
