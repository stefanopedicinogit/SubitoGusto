import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Auth state class
class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? tenantId;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.tenantId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? tenantId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}

/// Provider for authentication state
final supabaseAuthProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return client.auth.onAuthStateChange.asyncMap((event) async {
    final session = event.session;
    if (session == null) {
      return const AuthState(isAuthenticated: false);
    }

    // Try to get tenant_id from user metadata or users table
    String? tenantId;
    try {
      final userData = await client
          .from('users')
          .select('tenant_id')
          .eq('id', session.user.id)
          .maybeSingle();

      tenantId = userData?['tenant_id'] as String?;
    } catch (_) {
      // User table might not exist yet or other error
    }

    return AuthState(
      isAuthenticated: true,
      user: session.user,
      tenantId: tenantId,
    );
  });
});

/// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.user?.id;
});

/// Provider for current tenant ID
final currentTenantIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.tenantId;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.isAuthenticated ?? false;
});
