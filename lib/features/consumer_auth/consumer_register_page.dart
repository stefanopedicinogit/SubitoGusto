import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer registration page
class ConsumerRegisterPage extends ConsumerStatefulWidget {
  const ConsumerRegisterPage({super.key});

  @override
  ConsumerState<ConsumerRegisterPage> createState() =>
      _ConsumerRegisterPageState();
}

class _ConsumerRegisterPageState extends ConsumerState<ConsumerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = Supabase.instance.client;

      // Call Edge Function to register consumer
      final response = await client.functions.invoke(
        'register-consumer',
        body: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'displayName': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (response.status != 200) {
        final error = response.data?['error'] ?? 'Errore sconosciuto';
        throw Exception(error);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).consumerRegisterSuccess),
            backgroundColor: AppColors.success,
          ),
        );
        // Preserve returnTo so post-login the user still lands on their
        // original QR scan page.
        final returnTo = GoRouterState.of(
          context,
        ).uri.queryParameters['returnTo'];
        final path = returnTo == null || returnTo.isEmpty
            ? '/consumer/login'
            : '/consumer/login?returnTo=${Uri.encodeComponent(returnTo)}';
        context.go(path);
      }
    } catch (e) {
      setState(() {
        _errorMessage = _translateError(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _translateError(String error) {
    if (error.contains('already registered') ||
        error.contains('already exists')) {
      return 'Questa email è già registrata. Prova ad accedere.';
    }
    if (error.contains('password')) {
      return 'La password deve avere almeno 6 caratteri.';
    }
    if (error.contains('email')) {
      return 'Inserisci un\'email valida.';
    }
    return 'Errore durante la registrazione. Riprova.';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final l = AppLocalizations.of(context);

    final nameField = TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: l.consumerRegisterNameLabel,
        prefixIcon: const Icon(Icons.person_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l.validationRequired;
        }
        return null;
      },
    );
    final emailField = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l.consumerRegisterEmailLabel,
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l.validationRequired;
        }
        if (!value.contains('@')) {
          return l.validationEmail;
        }
        return null;
      },
    );
    final phoneField = TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: l.profilePhoneLabel,
        prefixIcon: const Icon(Icons.phone_outlined),
      ),
    );
    final passwordField = TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: l.consumerRegisterPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l.validationRequired;
        }
        if (value.length < 6) {
          return l.validationPasswordMin;
        }
        return null;
      },
    );
    final confirmField = TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirm,
      decoration: InputDecoration(
        labelText: 'Conferma password',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirm
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Le password non corrispondono';
        }
        return null;
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 600;
                  final maxFormWidth = isDesktop
                      ? constraints.maxWidth * 0.7
                      : constraints.maxWidth;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxFormWidth),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),
                            // Logo
                            Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_add_outlined,
                                  color: primaryColor,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Center(
                              child: Text(
                                'SubitoGusto',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Center(
                              child: Text(
                                'Ordina a domicilio dai migliori ristoranti',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            // Error message
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.errorLight,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            // Form fields: desktop = 3 rows (Name|Email /
                            // Phone / Password|Confirm); mobile = 5 stacked.
                            if (isDesktop) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: nameField),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(child: emailField),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              phoneField,
                              const SizedBox(height: AppSpacing.lg),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: passwordField),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(child: confirmField),
                                ],
                              ),
                            ] else ...[
                              nameField,
                              const SizedBox(height: AppSpacing.lg),
                              emailField,
                              const SizedBox(height: AppSpacing.lg),
                              phoneField,
                              const SizedBox(height: AppSpacing.lg),
                              passwordField,
                              const SizedBox(height: AppSpacing.lg),
                              confirmField,
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            // Register button
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(l.consumerRegisterSubmit),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // Login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l.consumerRegisterHaveAccount),
                                TextButton(
                                  onPressed: () {
                                    final returnTo = GoRouterState.of(
                                      context,
                                    ).uri.queryParameters['returnTo'];
                                    final path =
                                        returnTo == null || returnTo.isEmpty
                                        ? '/consumer/login'
                                        : '/consumer/login?returnTo=${Uri.encodeComponent(returnTo)}';
                                    context.go(path);
                                  },
                                  child: Text(l.consumerRegisterSignIn),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Staff login link
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/login'),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Sei un ristoratore? ',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Accedi qui',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: LanguageSwitcher(),
            ),
          ],
        ),
      ),
    );
  }
}
