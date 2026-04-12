import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';

/// Registration page for new tenants (restaurants)
class RegisterTenantPage extends ConsumerStatefulWidget {
  const RegisterTenantPage({super.key});

  @override
  ConsumerState<RegisterTenantPage> createState() => _RegisterTenantPageState();
}

class _RegisterTenantPageState extends ConsumerState<RegisterTenantPage> {
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

      // Call Edge Function to register tenant (bypasses RLS)
      final response = await client.functions.invoke(
        'register-tenant',
        body: {
          'tenantName': _tenantNameController.text.trim(),
          'tenantPhone': _tenantPhoneController.text.trim(),
          'tenantAddress': _tenantAddressController.text.trim(),
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
        // Show success and redirect to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrazione completata! Effettua il login.'),
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

    return Scaffold(
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
                          Icons.business,
                          size: 64,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      'Registra la tua\nAzienda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Inizia a gestire la tua attività\nin pochi minuti',
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
                          'Crea il tuo account',
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
                        // Stepper
                        Stepper(
                          currentStep: _currentStep,
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
                                  FilledButton(
                                    onPressed: _isLoading ? null : details.onStepContinue,
                                    child: _isLoading && _currentStep == 1
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(_currentStep == 1 ? 'Registrati' : 'Continua'),
                                  ),
                                  if (_currentStep > 0) ...[
                                    const SizedBox(width: AppSpacing.sm),
                                    TextButton(
                                      onPressed: _isLoading ? null : details.onStepCancel,
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
                              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                              content: Column(
                                children: [
                                  TextFormField(
                                    controller: _tenantNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome Azienda *',
                                      prefixIcon: Icon(Icons.business),
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
                                    decoration: const InputDecoration(
                                      labelText: 'Telefono',
                                      prefixIcon: Icon(Icons.phone),
                                      hintText: 'Es: +39 02 1234567',
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  TextFormField(
                                    controller: _tenantAddressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Indirizzo',
                                      prefixIcon: Icon(Icons.location_on),
                                      hintText: 'Es: Via Roma 1, Milano',
                                    ),
                                    textCapitalization: TextCapitalization.words,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  TextFormField(
                                    controller: _tenantEmailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email Azienda',
                                      prefixIcon: Icon(Icons.email_outlined),
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
                              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                              content: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _adminFirstNameController,
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
                                          controller: _adminLastNameController,
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
                                  TextFormField(
                                    controller: _adminEmailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email di accesso *',
                                      prefixIcon: Icon(Icons.email),
                                      hintText: 'La userai per accedere',
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
                                  TextFormField(
                                    controller: _adminPasswordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Password *',
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
                        const SizedBox(height: AppSpacing.xl),
                        // Back to login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Hai già un account?'),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Accedi'),
                            ),
                          ],
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
