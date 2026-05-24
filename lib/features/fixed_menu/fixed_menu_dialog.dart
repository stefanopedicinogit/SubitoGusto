import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/providers/providers.dart';
import '../../l10n/generated/app_localizations.dart';

/// Dialog for creating/editing a fixed menu
class FixedMenuDialog extends ConsumerStatefulWidget {
  final FixedMenu? menu;

  const FixedMenuDialog({super.key, this.menu});

  @override
  ConsumerState<FixedMenuDialog> createState() => _FixedMenuDialogState();
}

class _FixedMenuDialogState extends ConsumerState<FixedMenuDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  String _availableFor = 'all';
  List<String> _availableDays = [];
  bool _isActive = true;
  bool _isLoading = false;

  bool get isEditing => widget.menu != null;

  static const _dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  String _dayLabel(BuildContext context, String key) {
    final l = AppLocalizations.of(context);
    switch (key) {
      case 'mon': return l.dayMon;
      case 'tue': return l.dayTue;
      case 'wed': return l.dayWed;
      case 'thu': return l.dayThu;
      case 'fri': return l.dayFri;
      case 'sat': return l.daySat;
      case 'sun': return l.daySun;
      default: return key;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menu?.name ?? '');
    _descriptionController = TextEditingController(text: widget.menu?.description ?? '');
    _priceController = TextEditingController(
      text: widget.menu?.price.toStringAsFixed(2) ?? '',
    );
    _imageUrlController = TextEditingController(text: widget.menu?.imageUrl ?? '');
    _availableFor = widget.menu?.availableFor ?? 'all';
    _availableDays = widget.menu?.availableDays ?? [];
    _isActive = widget.menu?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? AppLocalizations.of(context).fixedMenuDialogEdit : AppLocalizations.of(context).fixedMenuDialogNew),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).fixedMenuDialogName,
                    hintText: 'es. Menu Degustazione',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context).fixedMenuDialogNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).fixedMenuDialogDescription,
                    hintText: AppLocalizations.of(context).fixedMenuDialogDescriptionHint,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).fixedMenuDialogPrice,
                    prefixText: '€ ',
                    hintText: '0.00',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context).fixedMenuDialogPriceRequired;
                    }
                    final price = double.tryParse(value.replaceAll(',', '.'));
                    if (price == null || price < 0) {
                      return AppLocalizations.of(context).fixedMenuDialogPriceInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Image URL
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).fixedMenuDialogImageUrl,
                    hintText: 'https://...',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Availability section
                Text(
                  AppLocalizations.of(context).fixedMenuDialogAvailability,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Time of day
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(AppLocalizations.of(context).fixedMenuDialogAlways),
                        value: 'all',
                        groupValue: _availableFor,
                        onChanged: (v) => setState(() => _availableFor = v!),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(AppLocalizations.of(context).fixedMenuDialogLunch),
                        value: 'lunch',
                        groupValue: _availableFor,
                        onChanged: (v) => setState(() => _availableFor = v!),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(AppLocalizations.of(context).fixedMenuDialogDinner),
                        value: 'dinner',
                        groupValue: _availableFor,
                        onChanged: (v) => setState(() => _availableFor = v!),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Days
                Text(
                  AppLocalizations.of(context).fixedMenuDialogDays,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _dayKeys.map((day) {
                    final isSelected = _availableDays.contains(day);
                    return FilterChip(
                      label: Text(_dayLabel(context, day)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _availableDays = [..._availableDays, day];
                          } else {
                            _availableDays = _availableDays.where((d) => d != day).toList();
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Active toggle
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).fixedMenuDialogActive),
                  subtitle: Text(AppLocalizations.of(context).fixedMenuDialogActiveSub),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (isEditing)
          TextButton(
            onPressed: _isLoading ? null : _deleteMenu,
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
        FilledButton(
          onPressed: _isLoading ? null : _saveMenu,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? AppLocalizations.of(context).commonSave : AppLocalizations.of(context).tableDialogCreate),
        ),
      ],
    );
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fixedMenuRepositoryProvider);
      final price = double.parse(_priceController.text.replaceAll(',', '.'));

      final menuData = FixedMenu(
        id: widget.menu?.id ?? '',
        tenantId: widget.menu?.tenantId ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        price: price,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        availableFor: _availableFor,
        availableDays: _availableDays.isEmpty ? null : _availableDays,
        isActive: _isActive,
        createdAt: widget.menu?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await repo.update(widget.menu!.id, menuData);
      } else {
        await repo.insert(menuData);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? AppLocalizations.of(context).fixedMenuDialogUpdated : AppLocalizations.of(context).fixedMenuDialogCreated),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMenu() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(AppLocalizations.of(dialogCtx).fixedMenuDialogDeleteTitle),
        content: Text(
          '${AppLocalizations.of(dialogCtx).fixedMenuDialogDeleteConfirm(widget.menu!.name)}\n\n'
          '${AppLocalizations.of(dialogCtx).fixedMenuDialogDeleteWarn}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(AppLocalizations.of(dialogCtx).commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(dialogCtx).commonDelete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fixedMenuRepositoryProvider);
      await repo.delete(widget.menu!.id);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).fixedMenuDialogDeleted),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
