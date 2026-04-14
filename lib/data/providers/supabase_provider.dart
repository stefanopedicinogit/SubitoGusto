import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// User type: staff (restaurant employee) or consumer (delivery customer)
enum UserType { staff, consumer }

/// Auth state class
class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? tenantId;
  final UserType? userType;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.tenantId,
    this.userType,
  });

  bool get isStaff => userType == UserType.staff;
  bool get isConsumer => userType == UserType.consumer;

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? tenantId,
    UserType? userType,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      tenantId: tenantId ?? this.tenantId,
      userType: userType ?? this.userType,
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

    // Detect user type: staff (in users table) or consumer (in customers table)
    String? tenantId;
    UserType? userType;
    try {
      // Check if staff user
      final userData = await client
          .from('users')
          .select('tenant_id')
          .eq('id', session.user.id)
          .maybeSingle();

      if (userData != null) {
        tenantId = userData['tenant_id'] as String?;
        userType = UserType.staff;
      } else {
        // Check if consumer
        final customerData = await client
            .from('customers')
            .select('id')
            .eq('id', session.user.id)
            .maybeSingle();
        if (customerData != null) {
          userType = UserType.consumer;
        }
      }
    } catch (_) {
      // Table might not exist yet or other error
    }

    return AuthState(
      isAuthenticated: true,
      user: session.user,
      tenantId: tenantId,
      userType: userType,
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

/// Check if current user is staff
final isStaffProvider = Provider<bool>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.isStaff ?? false;
});

/// Check if current user is consumer
final isConsumerProvider = Provider<bool>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.isConsumer ?? false;
});

/// Current user type
final userTypeProvider = Provider<UserType?>((ref) {
  final authState = ref.watch(supabaseAuthProvider).valueOrNull;
  return authState?.userType;
});
