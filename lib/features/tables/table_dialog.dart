import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/table.dart';
import '../../data/providers/providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Dialog for creating or editing a table
class TableDialog extends ConsumerStatefulWidget {
  final RestaurantTable? table;

  const TableDialog({super.key, this.table});

  @override
  ConsumerState<TableDialog> createState() => _TableDialogState();
}

class _TableDialogState extends ConsumerState<TableDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _capacityController;
  late final TextEditingController _zoneController;
  late String _status;
  late bool _isActive;
  bool _isLoading = false;

  bool get isEditing => widget.table != null;

  static const _statusKeys = ['available', 'occupied', 'reserved'];

  String _statusLabel(BuildContext context, String key) {
    final l = AppLocalizations.of(context);
    switch (key) {
      case 'available': return l.tablesStatusFree;
      case 'occupied': return l.tablesStatusOccupied;
      case 'reserved': return l.tablesStatusReserved;
      default: return key;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.table?.name ?? '');
    _capacityController = TextEditingController(
        text: (widget.table?.capacity ?? 4).toString());
    _zoneController = TextEditingController(text: widget.table?.zone ?? '');
    _status = widget.table?.status ?? 'available';
    _isActive = widget.table?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(tableRepositoryProvider);

      // Generate QR code if new
      final qrCode = widget.table?.qrCode ?? const Uuid().v4().substring(0, 8);

      final table = RestaurantTable(
        id: widget.table?.id ?? '',
        tenantId: widget.table?.tenantId ?? '',
        name: _nameController.text.trim(),
        qrCode: qrCode,
        capacity: int.tryParse(_capacityController.text) ?? 4,
        zone: _zoneController.text.trim().isEmpty
            ? null
            : _zoneController.text.trim(),
        status: _status,
        isActive: _isActive,
        createdAt: widget.table?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await repo.update(widget.table!.id, table);
      } else {
        await repo.insert(table);
      }

      ref.invalidate(tablesProvider);
      ref.invalidate(tablesStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? AppLocalizations.of(context).tableDialogUpdated : AppLocalizations.of(context).tableDialogCreated,
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _delete() async {
    if (!isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(AppLocalizations.of(dialogCtx).tablesDeleteConfirm),
        content: Text('"${widget.table!.name}"'),
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

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(tableRepositoryProvider);
      await repo.delete(widget.table!.id);

      ref.invalidate(tablesProvider);
      ref.invalidate(tablesStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).tableDialogDeleted),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(humanizeError(e, context)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? AppLocalizations.of(context).tableDialogEdit : AppLocalizations.of(context).tableDialogNew),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tableDialogName,
                    hintText: 'Es: Tavolo 1, Tavolo Terrazza...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Il nome e obbligatorio';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _capacityController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).tableDialogSeats,
                          hintText: '4',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).tableDialogSeatsRequired;
                          }
                          final capacity = int.tryParse(value);
                          if (capacity == null || capacity < 1) {
                            return AppLocalizations.of(context).tableDialogInvalidNumber;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _zoneController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).tableDialogZone,
                          hintText: 'Es: Terrazza, Interno...',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tableDialogState,
                  ),
                  items: _statusKeys.map((key) {
                    return DropdownMenuItem(
                      value: key,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(_statusLabel(context, key)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _status = value);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).tableDialogActive),
                  subtitle: Text(AppLocalizations.of(context).tableDialogActiveSub),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (isEditing) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code, color: AppColors.textSecondary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).tableDialogQrCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                widget.table!.qrCode,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            if (isEditing)
              TextButton(
                onPressed: _isLoading ? null : _delete,
                child: Text(
                  AppLocalizations.of(context).commonDelete,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            const Spacer(),
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).commonCancel),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEditing ? AppLocalizations.of(context).commonSave : AppLocalizations.of(context).tableDialogCreate),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return AppColors.success;
      case 'occupied':
        return AppColors.error;
      case 'reserved':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}
