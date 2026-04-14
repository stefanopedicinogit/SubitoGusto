import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import 'welcome_page.dart';
import 'tenant_ferrara/welcome_page_ferrara.dart';

/// Page shown after customer scans QR code - loads table and shows welcome
class ScanPage extends ConsumerWidget {
  final String qrCode;

  const ScanPage({super.key, required this.qrCode});

  /// Routes to the correct tenant welcome page based on qrCode.
  /// Add new tenant entries here as they are created.
  static Widget _resolveWelcomePage(RestaurantTable table) {
    switch (table.qrCode) {
      case 'TBLFERRARA':
        return WelcomePageFerrara(table: table);
      default:
        return WelcomePage(table: table);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableAsync = ref.watch(tableByQrCodeProvider(qrCode));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: tableAsync.when(
        data: (table) {
          if (table == null) {
            return _ErrorView(
              message: 'Tavolo non trovato',
              onRetry: () => ref.invalidate(tableByQrCodeProvider(qrCode)),
            );
          }

          return _resolveWelcomePage(table);
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Caricamento...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        error: (e, _) => _ErrorView(
          message: 'Errore: $e',
          onRetry: () => ref.invalidate(tableByQrCodeProvider(qrCode)),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Builder(
                builder: (context) => FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Riprova'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
