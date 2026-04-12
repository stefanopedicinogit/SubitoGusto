import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../../data/providers/providers.dart';
import 'user_dialog.dart';

/// Users management page for admins
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gestisci gli utenti del ristorante',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const UserDialog(),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Nuovo Utente'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Users list
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Nessun utente',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const UserDialog(),
                            );
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Aggiungi il primo utente'),
                        ),
                      ],
                    ),
                  );
                }

                return Card(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Utente')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Ruolo')),
                        DataColumn(label: Text('Stato')),
                        DataColumn(label: Text('Ultimo accesso')),
                        DataColumn(label: Text('Azioni')),
                      ],
                      rows: users.map((user) => _buildUserRow(context, ref, user)).toList(),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Errore: $e')),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildUserRow(BuildContext context, WidgetRef ref, AppUser user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.initials,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(user.fullName),
            ],
          ),
        ),
        DataCell(Text(user.email)),
        DataCell(_RoleChip(role: user.role)),
        DataCell(_StatusChip(isActive: user.isActive)),
        DataCell(Text(
          user.lastLoginAt != null
              ? _formatDate(user.lastLoginAt!)
              : 'Mai',
          style: TextStyle(color: AppColors.textSecondary),
        )),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => UserDialog(user: user),
                  );
                },
                tooltip: 'Modifica',
              ),
              IconButton(
                icon: Icon(
                  user.isActive ? Icons.block : Icons.check_circle,
                  size: 20,
                  color: user.isActive ? AppColors.error : AppColors.success,
                ),
                onPressed: () => _toggleUserStatus(context, ref, user),
                tooltip: user.isActive ? 'Disattiva' : 'Attiva',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                onPressed: () => _deleteUser(context, ref, user),
                tooltip: 'Elimina',
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _deleteUser(BuildContext context, WidgetRef ref, AppUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Utente'),
        content: Text(
          'Sei sicuro di voler eliminare "${user.fullName}"?\n\nQuesta azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Call Edge Function to delete user completely (auth + profile)
      final client = Supabase.instance.client;

      // Supabase Flutter SDK automatically passes the JWT when user is authenticated
      final response = await client.functions.invoke(
        'delete-user',
        body: {'userId': user.id},
      );

      if (response.status != 200) {
        final error = response.data?['error'] ?? 'Errore sconosciuto';
        throw Exception(error);
      }

      ref.invalidate(usersListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Utente eliminato'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleUserStatus(BuildContext context, WidgetRef ref, AppUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.isActive ? 'Disattiva Utente' : 'Attiva Utente'),
        content: Text(
          user.isActive
              ? 'Sei sicuro di voler disattivare "${user.fullName}"?\n\nL\'utente non potrà più accedere.'
              : 'Sei sicuro di voler riattivare "${user.fullName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: user.isActive ? AppColors.error : AppColors.success,
            ),
            child: Text(user.isActive ? 'Disattiva' : 'Attiva'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.update(user.id, user.copyWith(isActive: !user.isActive));
      ref.invalidate(usersListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(user.isActive ? 'Utente disattivato' : 'Utente attivato'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _RoleChip extends StatelessWidget {
  final String role;

  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: _getColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'manager':
        return Colors.blue;
      case 'waiter':
        return Colors.green;
      case 'kitchen':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getLabel() {
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

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            isActive ? 'Attivo' : 'Inattivo',
            style: TextStyle(
              color: isActive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
