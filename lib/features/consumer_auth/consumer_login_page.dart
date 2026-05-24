import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';

/// Consumer login page with email/password and social login
class ConsumerLoginPage extends ConsumerStatefulWidget {
  const ConsumerLoginPage({super.key});

  @override
  ConsumerState<ConsumerLoginPage> createState() => _ConsumerLoginPageState();
}

class _ConsumerLoginPageState extends ConsumerState<ConsumerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        // If we were sent here from a QR-flow page (returnTo query param),
        // go back there. Otherwise default to the marketplace.
        final returnTo = GoRouterState.of(
          context,
        ).uri.queryParameters['returnTo'];
        context.go(
          (returnTo != null && returnTo.isNotEmpty) ? returnTo : '/marketplace',
        );
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Si è verificato un errore. Riprova.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final l = AppLocalizations.of(context);

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
                            const SizedBox(height: AppSpacing.xl),
                            // Logo
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xl,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.delivery_dining,
                                    color: Colors.white,
                                    size: 40,
                                  ),
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
                                l.consumerLoginSubtitle,
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
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: l.consumerLoginEmailLabel,
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
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: l.consumerLoginPasswordLabel,
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l.validationRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // Login button
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(l.consumerLoginSubmit),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // Register link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l.consumerLoginNoAccount),
                                TextButton(
                                  onPressed: () {
                                    // Preserve returnTo across login ↔ register.
                                    final returnTo = GoRouterState.of(
                                      context,
                                    ).uri.queryParameters['returnTo'];
                                    final path =
                                        returnTo == null || returnTo.isEmpty
                                        ? '/consumer/register'
                                        : '/consumer/register?returnTo=${Uri.encodeComponent(returnTo)}';
                                    context.go(path);
                                  },
                                  child: Text(l.consumerLoginSignUp),
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
