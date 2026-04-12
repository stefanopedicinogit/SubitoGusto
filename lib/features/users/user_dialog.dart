import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../../data/providers/providers.dart';

/// Dialog for creating or editing a user
class UserDialog extends ConsumerStatefulWidget {
  final AppUser? user;

  const UserDialog({super.key, this.user});

  @override
  ConsumerState<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends ConsumerState<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late String _role;
  late bool _isActive;
  bool _isLoading = false;
  bool _obscurePassword = true;

  bool get isEditing => widget.user != null;

  static const _roles = [
    ('admin', 'Amministratore', Icons.admin_panel_settings),
    ('manager', 'Manager', Icons.manage_accounts),
    ('waiter', 'Cameriere', Icons.person),
    ('kitchen', 'Cucina', Icons.restaurant),
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user?.lastName ?? '');
    _role = widget.user?.role ?? 'waiter';
    _isActive = widget.user?.isActive ?? true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final client = Supabase.instance.client;
      final tenantId = ref.read(currentTenantIdProvider);

      if (isEditing) {
        // Update existing user
        final repo = ref.read(userRepositoryProvider);
        await repo.update(
          widget.user!.id,
          widget.user!.copyWith(
            firstName: _firstNameController.text.trim().isEmpty
                ? null
                : _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim().isEmpty
                ? null
                : _lastNameController.text.trim(),
            role: _role,
            isActive: _isActive,
          ),
        );
      } else {
        // Save tenantId BEFORE signup (provider may not work after session change)
        final savedTenantId = tenantId;
        if (savedTenantId == null) {
          throw Exception('Tenant ID non trovato. Effettua nuovamente il login.');
        }

        // Save current admin session before creating new user
        final currentSession = client.auth.currentSession;
        if (currentSession == null) {
          throw Exception('Sessione non valida. Effettua nuovamente il login.');
        }

        // Create new auth user
        final authResponse = await client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (authResponse.user == null) {
          throw Exception('Errore nella creazione dell\'utente');
        }

        final newUserId = authResponse.user!.id;

        // Restore admin session immediately
        await client.auth.setSession(currentSession.refreshToken!);

        // Refresh auth state to prevent navigation issues
        ref.invalidate(supabaseAuthProvider);

        // Wait for session to be fully restored
        await Future.delayed(const Duration(milliseconds: 300));

        // Check if trigger already created the user record
        final existingUser = await client
            .from('users')
            .select('id')
            .eq('id', newUserId)
            .maybeSingle();

        if (existingUser != null) {
          // Update the record created by trigger
          await client.from('users').update({
            'tenant_id': savedTenantId,
            'role': _role,
            'first_name': _firstNameController.text.trim().isEmpty
                ? null
                : _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim().isEmpty
                ? null
                : _lastNameController.text.trim(),
            'is_active': _isActive,
          }).eq('id', newUserId);
        } else {
          // Insert new record if trigger didn't create it
          await client.from('users').insert({
            'id': newUserId,
            'tenant_id': savedTenantId,
            'email': _emailController.text.trim(),
            'role': _role,
            'first_name': _firstNameController.text.trim().isEmpty
                ? null
                : _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim().isEmpty
                ? null
                : _lastNameController.text.trim(),
            'is_active': _isActive,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      }

      ref.invalidate(usersListProvider);

      if (mounted) {
        // Show success message first
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Utente aggiornato' : 'Utente creato con successo',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        // Then close the dialog
        Navigator.of(context).pop(true);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_translateAuthError(e.message)),
            backgroundColor: AppColors.error,
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

  String _translateAuthError(String message) {
    if (message.contains('already registered')) {
      return 'Questa email è già registrata';
    }
    if (message.contains('invalid email')) {
      return 'Email non valida';
    }
    if (message.contains('weak password') || message.contains('at least')) {
      return 'La password deve essere di almeno 6 caratteri';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Modifica Utente' : 'Nuovo Utente'),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Cognome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Email
                TextFormField(
                  controller: _emailController,
                  enabled: !isEditing, // Can't change email after creation
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: const Icon(Icons.email_outlined),
                    helperText: isEditing ? 'L\'email non può essere modificata' : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'L\'email è obbligatoria';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Inserisci un\'email valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Password (only for new users)
                if (!isEditing) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      helperText: 'Minimo 6 caratteri',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La password è obbligatoria';
                      }
                      if (value.length < 6) {
                        return 'La password deve essere di almeno 6 caratteri';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                // Role selector
                Text(
                  'Ruolo *',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _roles.map((role) {
                    final isSelected = _role == role.$1;
                    return ChoiceChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _role = role.$1);
                        }
                      },
                      avatar: Icon(
                        role.$3,
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(role.$2),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Role description
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _getRoleDescription(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Active toggle
                SwitchListTile(
                  title: const Text('Utente attivo'),
                  subtitle: Text(
                    _isActive
                        ? 'L\'utente può accedere al sistema'
                        : 'L\'utente non può accedere',
                  ),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _save,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check),
          label: Text(isEditing ? 'Salva' : 'Crea Utente'),
        ),
      ],
    );
  }

  String _getRoleDescription() {
    switch (_role) {
      case 'admin':
        return 'Accesso completo: gestione menu, tavoli, ordini, utenti e impostazioni.';
      case 'manager':
        return 'Gestione menu, tavoli e ordini. Non può gestire utenti e impostazioni.';
      case 'waiter':
        return 'Può visualizzare e gestire solo gli ordini. Ideale per camerieri.';
      case 'kitchen':
        return 'Visualizza solo gli ordini da preparare. Ideale per il personale di cucina.';
      default:
        return '';
    }
  }
}
