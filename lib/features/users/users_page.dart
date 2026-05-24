import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/user.dart';
import '../../data/providers/providers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'user_dialog.dart';

/// Users management page for admins
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);
    final l = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    final addButton = FilledButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const UserDialog(),
        );
      },
      icon: const Icon(Icons.person_add),
      label: Text(l.usersAdd),
    );

    return Padding(
      padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: on mobile, drop the "Utenti" subtitle and stretch the
          // add-user button to full width.
          if (isMobile)
            SizedBox(width: double.infinity, child: addButton)
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.usersTitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                addButton,
              ],
            ),
          SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.lg),
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
                          l.usersEmpty,
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
                          label: Text(l.usersAdd),
                        ),
                      ],
                    ),
                  );
                }

                if (isMobile) {
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    itemCount: users.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        _UserCard(user: users[index]),
                  );
                }

                return Card(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text(l.usersHeader)),
                        DataColumn(label: Text(l.usersEmail)),
                        DataColumn(label: Text(l.usersRole)),
                        DataColumn(label: Text(l.usersStatus)),
                        DataColumn(label: Text(l.usersLastLogin)),
                        DataColumn(label: Text(l.usersActions)),
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
    final l = AppLocalizations.of(context);
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
              : l.usersNever,
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
                tooltip: l.commonEdit,
              ),
              IconButton(
                icon: Icon(
                  user.isActive ? Icons.block : Icons.check_circle,
                  size: 20,
                  color: user.isActive ? AppColors.error : AppColors.success,
                ),
                onPressed: () => _toggleUserStatus(context, ref, user),
                tooltip: user.isActive ? l.usersDeactivate : l.usersActivate,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                onPressed: () => _deleteUser(context, ref, user),
                tooltip: l.commonDelete,
              ),
            ],
          ),
        ),
      ],
    );
  }

}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

Future<void> _deleteUser(BuildContext context, WidgetRef ref, AppUser user) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: Text(AppLocalizations.of(dialogCtx).usersDeleteConfirm(user.fullName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: Text(AppLocalizations.of(dialogCtx).commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: Text(AppLocalizations.of(dialogCtx).commonDelete),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  try {
    final client = Supabase.instance.client;
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
        SnackBar(
          content: Text(AppLocalizations.of(context).usersDeletedToast),
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
    builder: (dialogCtx) {
      final l = AppLocalizations.of(dialogCtx);
      return AlertDialog(
        title: Text(user.isActive ? l.usersDeactivate : l.usersActivate),
        content: Text(user.fullName),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: user.isActive ? AppColors.error : AppColors.success,
            ),
            child: Text(user.isActive ? l.usersDeactivate : l.usersActivate),
          ),
        ],
      );
    },
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

class _UserCard extends ConsumerWidget {
  final AppUser user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: primary.withValues(alpha: 0.1),
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? Text(
                          user.initials,
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                _RoleChip(role: user.role),
                _StatusChip(isActive: user.isActive),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '${l.usersLastLogin}: '
                    '${user.lastLoginAt != null ? _formatDate(user.lastLoginAt!) : l.usersNever}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => UserDialog(user: user),
                    );
                  },
                  tooltip: l.commonEdit,
                ),
                IconButton(
                  icon: Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    size: 20,
                    color: user.isActive ? AppColors.error : AppColors.success,
                  ),
                  onPressed: () => _toggleUserStatus(context, ref, user),
                  tooltip: user.isActive ? l.usersDeactivate : l.usersActivate,
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      size: 20, color: AppColors.error),
                  onPressed: () => _deleteUser(context, ref, user),
                  tooltip: l.commonDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
