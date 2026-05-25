import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer registration page for desktop (two-column: branding + form).
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
        final error = response.data?['error'] ?? AppLocalizations.of(context).errorGeneric;
        throw Exception(error);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).consumerRegisterSuccess),
            backgroundColor: AppColors.success,
          ),
        );
        final returnTo = GoRouterState.of(
          context,
        ).uri.queryParameters['returnTo'];
        final path = returnTo == null || returnTo.isEmpty
            ? '/consumer/login'
            : '/consumer/login?returnTo=${Uri.encodeComponent(returnTo)}';
        context.go(path);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _translateError(e.toString(), AppLocalizations.of(context));
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _translateError(String error, AppLocalizations l) {
    if (error.contains('already registered') || error.contains('already exists')) {
      return l.consumerRegisterErrorAlreadyRegistered;
    }
    if (error.contains('password')) return l.errorAuthPasswordShort;
    if (error.contains('email')) return l.validationEmail;
    return l.consumerRegisterErrorGeneric;
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
        labelText: l.consumerRegisterConfirmPasswordLabel,
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
          return l.consumerRegisterPasswordMismatch;
        }
        return null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        actions: const [
          LanguageSwitcher(),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          // Left side - Branding
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    HSLColor.fromColor(primaryColor).withLightness(0.25).toColor(),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.delivery_dining,
                          size: 64,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l.consumerRegisterTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.consumerRegisterTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side - Registration form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.consumerRegisterTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.consumerRegisterSubtitle,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: AppColors.error),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style:
                                        const TextStyle(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        // Desktop layout: Name | Email / Phone / Password | Confirm
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: nameField),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: emailField),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        phoneField,
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: passwordField),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: confirmField),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SizedBox(
                          height: 56,
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
                        const SizedBox(height: AppSpacing.sm),
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: l.consumerRegisterOwnerPrompt,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextSpan(
                                    text: l.consumerRegisterOwnerLink,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
