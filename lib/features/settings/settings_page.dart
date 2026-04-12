import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/providers.dart';

/// Settings page for desktop
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final tenantAsync = ref.watch(tenantProvider);

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
                  title: 'Informazioni Ristorante',
                  icon: Icons.restaurant,
                  child: tenantAsync.when(
                    data: (tenant) => Column(
                      children: [
                        _InfoRow(
                          label: 'Nome',
                          value: tenant?.name ?? 'Ristorante',
                        ),
                        const Divider(height: 1),
                        _InfoRow(
                          label: 'Indirizzo',
                          value: tenant?.address ?? 'Non configurato',
                        ),
                        const Divider(height: 1),
                        _InfoRow(
                          label: 'Telefono',
                          value: tenant?.phone ?? 'Non configurato',
                        ),
                        const Divider(height: 1),
                        _InfoRow(
                          label: 'Email',
                          value: tenant?.email ?? 'Non configurato',
                        ),
                      ],
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text('Errore nel caricamento'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Notifications Section
                _SectionCard(
                  title: 'Notifiche',
                  icon: Icons.notifications,
                  child: Column(
                    children: [
                      _SettingsSwitch(
                        title: 'Notifiche ordini',
                        subtitle: 'Ricevi notifiche per nuovi ordini',
                        value: settings.orderNotifications,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).setOrderNotifications(value);
                        },
                      ),
                      const Divider(height: 1),
                      _SettingsSwitch(
                        title: 'Suoni di avviso',
                        subtitle: 'Riproduci un suono per le notifiche',
                        value: settings.soundAlerts,
                        onChanged: settings.orderNotifications
                            ? (value) {
                                ref.read(settingsProvider.notifier).setSoundAlerts(value);
                              }
                            : null,
                      ),
                      const Divider(height: 1),
                      _SettingsSwitch(
                        title: 'Vibrazione',
                        subtitle: 'Vibra per le notifiche (mobile)',
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
                  title: 'Gestione Ordini',
                  icon: Icons.receipt_long,
                  child: Column(
                    children: [
                      _SettingsSwitch(
                        title: 'Conferma automatica',
                        subtitle: 'Conferma automaticamente i nuovi ordini',
                        value: settings.autoConfirmOrders,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).setAutoConfirmOrders(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Theme Section
                _SectionCard(
                  title: 'Aspetto',
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
                  title: 'Colori Brand',
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
                    error: (_, __) => const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text('Errore nel caricamento'),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Account Section
                _SectionCard(
                  title: 'Account',
                  icon: Icons.person,
                  child: Column(
                    children: [
                      _InfoRow(
                        label: 'Email',
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
                                label: const Text('Cambia Password'),
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
                                label: const Text('Esci'),
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
                        'Versione 1.0.0',
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Text('Tema'),
          const Spacer(),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'light',
                icon: Icon(Icons.light_mode),
                label: Text('Chiaro'),
              ),
              ButtonSegment(
                value: 'dark',
                icon: Icon(Icons.dark_mode),
                label: Text('Scuro'),
              ),
              ButtonSegment(
                value: 'system',
                icon: Icon(Icons.settings_brightness),
                label: Text('Sistema'),
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
    final sounds = ['Classico', 'Campanello', 'Chime'];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          const Text('Suono notifica'),
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
    return AlertDialog(
      title: const Text('Cambia Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Nuova password',
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salva'),
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
    if (widget.tenantId == null) return;

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

      await Supabase.instance.client
          .from('tenants')
          .update({'settings': settings})
          .eq('id', widget.tenantId!);

      // Invalidate tenant provider to refresh theme
      ref.invalidate(tenantProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Colori salvati con successo'),
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
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorPickerRow(
          label: 'Colore Primario',
          hint: 'Il colore principale del brand',
          controller: _primaryController,
          options: _primaryOptions,
          onColorSelected: (color) => setState(() => _primaryController.text = color),
        ),
        const Divider(height: 1),
        _ColorPickerRow(
          label: 'Colore Secondario',
          hint: 'Colore per accenti e dettagli',
          controller: _secondaryController,
          options: _secondaryOptions,
          onColorSelected: (color) => setState(() => _secondaryController.text = color),
        ),
        const Divider(height: 1),
        _ColorPickerRow(
          label: 'Colore Sfondo',
          hint: 'Sfondo delle pagine (tema chiaro)',
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
                        child: const Text(
                          'Accento',
                          style: TextStyle(
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
                label: const Text('Salva Colori'),
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
