import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/customer.dart';
import '../../data/providers/consumer_providers.dart';
import '../../data/providers/locale_provider.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer profile page
class ConsumerProfilePage extends ConsumerStatefulWidget {
  const ConsumerProfilePage({super.key});

  @override
  ConsumerState<ConsumerProfilePage> createState() =>
      _ConsumerProfilePageState();
}

class _ConsumerProfilePageState extends ConsumerState<ConsumerProfilePage> {
  bool _isEditing = false;
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(customerProfileProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l.profileTitle),
          ],
        ),
        centerTitle: false,
      ),
      body: profileAsync.when(
        data: (customer) {
          if (customer == null) {
            return Center(child: Text(l.profileNotFound));
          }

          if (!_isEditing) {
            _displayNameController.text = customer.displayName ?? '';
            _phoneController.text = customer.phone ?? '';
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  backgroundImage: customer.avatarUrl != null
                      ? NetworkImage(customer.avatarUrl!)
                      : null,
                  child: customer.avatarUrl == null
                      ? Text(
                          customer.avatarInitial,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (!_isEditing) ...[
                Center(
                  child: Text(
                    customer.displayLabel,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Center(
                  child: Text(
                    customer.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                if (customer.phone != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Center(
                    child: Text(
                      customer.phone!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ] else ...[
                // Edit form
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: l.profileDisplayNameLabel,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: l.profilePhoneLabel,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _isEditing = false),
                        child: Text(l.commonCancel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text(l.commonSave),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),

              // Menu items
              if (!_isEditing) ...[
                _ProfileMenuItem(
                  icon: Icons.edit_outlined,
                  title: l.profileEdit,
                  onTap: () => setState(() => _isEditing = true),
                ),
                _ProfileMenuItem(
                  icon: Icons.location_on_outlined,
                  title: l.profileAddresses,
                  onTap: () => context.push('/consumer/addresses'),
                ),
                _ProfileMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: l.profileOrders,
                  onTap: () => context.go('/consumer/orders'),
                ),
                _PushNotificationToggle(customer: customer),
                const _LanguageSelectorTile(),
                const SizedBox(height: AppSpacing.xl),
                // Logout
                OutlinedButton.icon(
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      context.go('/consumer/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    l.profileSignOut,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      await client.from('customers').update({
        'display_name': _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      }).eq('id', userId);

      ref.invalidate(customerProfileProvider);
      if (mounted) setState(() => _isEditing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(humanizeError(e, context))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

/// Notification opt-in switch. Reads the current value directly from
/// the `customers` table (column is not on the freezed model) and toggles it.
class _PushNotificationToggle extends StatefulWidget {
  final Customer customer;

  const _PushNotificationToggle({required this.customer});

  @override
  State<_PushNotificationToggle> createState() =>
      _PushNotificationToggleState();
}

class _PushNotificationToggleState extends State<_PushNotificationToggle> {
  bool? _enabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await Supabase.instance.client
          .from('customers')
          .select('push_notifications_enabled')
          .eq('id', widget.customer.id)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _enabled = (row?['push_notifications_enabled'] as bool?) ?? true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _enabled = true);
    }
  }

  Future<void> _toggle(bool value) async {
    setState(() => _saving = true);
    final previous = _enabled;
    setState(() => _enabled = value); // optimistic
    try {
      await Supabase.instance.client
          .from('customers')
          .update({'push_notifications_enabled': value})
          .eq('id', widget.customer.id);
    } catch (e) {
      if (!mounted) return;
      setState(() => _enabled = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(humanizeError(e, context))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _enabled;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SwitchListTile(
        secondary: const Icon(Icons.notifications_outlined),
        title: Text(AppLocalizations.of(context).profilePushNotifications),
        subtitle: Text(AppLocalizations.of(context).profilePushNotificationsSubtitle),
        value: enabled ?? true,
        onChanged: (enabled == null || _saving) ? null : _toggle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

/// Language selector — drop-down between supported app locales. Persists via
/// [localeProvider] (SharedPreferences-backed).
class _LanguageSelectorTile extends ConsumerWidget {
  const _LanguageSelectorTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: const Icon(Icons.language_outlined),
        title: const Text('Lingua / Language'),
        trailing: DropdownButton<String>(
          value: current?.languageCode ?? 'it',
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: 'it', child: Text('Italiano')),
            DropdownMenuItem(value: 'en', child: Text('English')),
          ],
          onChanged: (code) {
            if (code != null) {
              ref.read(localeProvider.notifier).set(Locale(code));
            }
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
