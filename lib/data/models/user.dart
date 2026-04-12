import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    required String email,
    @Default('waiter') String role,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  /// Get full name
  String get fullName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.isEmpty ? email : parts.join(' ');
  }

  /// Get initials for avatar
  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '${firstName![0]}${lastName![0]}'.toUpperCase();
      }
      return firstName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  // Role checks
  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager';
  bool get isWaiter => role == 'waiter';
  bool get isKitchen => role == 'kitchen';

  /// Check if user can manage menu
  bool get canManageMenu => isAdmin || isManager;

  /// Check if user can manage tables
  bool get canManageTables => isAdmin || isManager;

  /// Check if user can manage orders
  bool get canManageOrders => isAdmin || isManager || isWaiter;

  /// Check if user can view reports
  bool get canViewReports => isAdmin || isManager;

  /// Check if user can manage users
  bool get canManageUsers => isAdmin;

  /// Get display role in Italian
  String get roleDisplayName {
    switch (role) {
      case 'admin':
        return 'Amministratore';
      case 'manager':
        return 'Manager';
      case 'waiter':
        return 'Cameriere';
      case 'kitchen':
        return 'Cucina';
      default:
        return role;
    }
  }
}
