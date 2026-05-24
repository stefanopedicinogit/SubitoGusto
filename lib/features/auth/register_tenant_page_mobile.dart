import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/language_switcher.dart';
import '../../data/services/geocoding_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Registration page for new tenants (restaurants) — mobile layout
class RegisterTenantPageMobile extends ConsumerStatefulWidget {
  const RegisterTenantPageMobile({super.key});

  @override
  ConsumerState<RegisterTenantPageMobile> createState() =>
      _RegisterTenantPageMobileState();
}

class _RegisterTenantPageMobileState
    extends ConsumerState<RegisterTenantPageMobile> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Tenant fields
  final _tenantNameController = TextEditingController();
  final _tenantPhoneController = TextEditingController();
  final _tenantAddressController = TextEditingController();
  final _tenantEmailController = TextEditingController();

  // Admin user fields
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _adminFirstNameController = TextEditingController();
  final _adminLastNameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _tenantNameController.dispose();
    _tenantPhoneController.dispose();
    _tenantAddressController.dispose();
    _tenantEmailController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _adminFirstNameController.dispose();
    _adminLastNameController.dispose();
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

      final tenantAddress = _tenantAddressController.text.trim();
      final geo = tenantAddress.isEmpty
          ? null
          : await GeocodingService().geocode(tenantAddress);

      final response = await client.functions.invoke(
        'register-tenant',
        body: {
          'tenantName': _tenantNameController.text.trim(),
          'tenantPhone': _tenantPhoneController.text.trim(),
          'tenantAddress': tenantAddress,
          if (geo != null) 'tenantLatitude': geo.lat,
          if (geo != null) 'tenantLongitude': geo.lng,
          'tenantEmail': _tenantEmailController.text.trim(),
          'adminEmail': _adminEmailController.text.trim(),
          'adminPassword': _adminPasswordController.text,
          'adminFirstName': _adminFirstNameController.text.trim(),
          'adminLastName': _adminLastNameController.text.trim(),
        },
      );

      if (response.status != 200) {
        final error = response.data?['error'] ?? 'Errore sconosciuto';
        throw Exception(error);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).registerTenantSuccess),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      setState(() {
        _errorMessage = _translateAuthError(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: LanguageSwitcher(),
                ),
                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    'SubitoGusto',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  l.registerTenantTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Compila i dati per registrare la tua azienda',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                // Stepper (vertical, full-width on mobile)
                Stepper(
                  physics: const NeverScrollableScrollPhysics(),
                  currentStep: _currentStep,
                  margin: EdgeInsets.zero,
                  onStepContinue: () {
                    if (_currentStep < 1) {
                      setState(() => _currentStep++);
                    } else {
                      _handleRegister();
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed:
                                    _isLoading ? null : details.onStepContinue,
                                child: _isLoading && _currentStep == 1
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(_currentStep == 1
                                        ? l.registerTenantSubmit
                                        : l.registerTenantContinue),
                              ),
                            ),
                          ),
                          if (_currentStep > 0) ...[
                            const SizedBox(width: AppSpacing.sm),
                            TextButton(
                              onPressed:
                                  _isLoading ? null : details.onStepCancel,
                              child: const Text('Indietro'),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  steps: [
                    // Step 1: Tenant info
                    Step(
                      title: const Text('Dati Azienda'),
                      subtitle: const Text('Informazioni della tua attività'),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          TextFormField(
                            controller: _tenantNameController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantBusinessName,
                              prefixIcon: const Icon(Icons.business),
                              hintText: 'Es: La Mia Azienda Srl',
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Il nome è obbligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _tenantPhoneController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantPhone,
                              prefixIcon: const Icon(Icons.phone),
                              hintText: 'Es: +39 02 1234567',
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _tenantAddressController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantAddress,
                              prefixIcon: const Icon(Icons.location_on),
                              hintText: 'Es: Via Roma 1, Milano',
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _tenantEmailController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantBusinessEmail,
                              prefixIcon: const Icon(Icons.email_outlined),
                              hintText: 'Es: info@azienda.it',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                    // Step 2: Admin user info
                    Step(
                      title: const Text('Account Amministratore'),
                      subtitle: const Text('Le tue credenziali di accesso'),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          TextFormField(
                            controller: _adminFirstNameController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantFirstName,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _adminLastNameController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantLastName,
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _adminEmailController,
                            decoration: InputDecoration(
                              labelText: l.registerTenantAccountEmail,
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'La userai per accedere',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'L\'email è obbligatoria';
                              }
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Inserisci un\'email valida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _adminPasswordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: l.registerTenantPassword,
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Minimo 6 caratteri',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Back to login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.registerTenantHaveAccount),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l.registerTenantSignIn),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Consumer login link
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/consumer/login'),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sei un cliente? ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'Accedi qui',
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
    );
  }
}
