import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/providers/providers.dart';

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

  final _dayOptions = [
    ('mon', 'Lun'),
    ('tue', 'Mar'),
    ('wed', 'Mer'),
    ('thu', 'Gio'),
    ('fri', 'Ven'),
    ('sat', 'Sab'),
    ('sun', 'Dom'),
  ];

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
      title: Text(isEditing ? 'Modifica Menu' : 'Nuovo Menu Fisso'),
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
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    hintText: 'es. Menu Degustazione',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    hintText: 'Descrizione opzionale del menu',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Prezzo *',
                    prefixText: '€ ',
                    hintText: '0.00',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il prezzo';
                    }
                    final price = double.tryParse(value.replaceAll(',', '.'));
                    if (price == null || price < 0) {
                      return 'Prezzo non valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Image URL
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Immagine',
                    hintText: 'https://...',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Availability section
                Text(
                  'Disponibilita',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Time of day
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Sempre'),
                        value: 'all',
                        groupValue: _availableFor,
                        onChanged: (v) => setState(() => _availableFor = v!),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Pranzo'),
                        value: 'lunch',
                        groupValue: _availableFor,
                        onChanged: (v) => setState(() => _availableFor = v!),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Cena'),
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
                  'Giorni (lascia vuoto per tutti)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _dayOptions.map((day) {
                    final isSelected = _availableDays.contains(day.$1);
                    return FilterChip(
                      label: Text(day.$2),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _availableDays = [..._availableDays, day.$1];
                          } else {
                            _availableDays = _availableDays.where((d) => d != day.$1).toList();
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Active toggle
                SwitchListTile(
                  title: const Text('Menu Attivo'),
                  subtitle: const Text('Visibile ai clienti'),
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
              'Elimina',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        const Spacer(),
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveMenu,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Salva' : 'Crea'),
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
            content: Text(isEditing ? 'Menu aggiornato' : 'Menu creato'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
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
      builder: (context) => AlertDialog(
        title: const Text('Elimina Menu'),
        content: Text('Sei sicuro di voler eliminare "${widget.menu!.name}"?\n\n'
            'Questa azione eliminerà anche tutte le portate e scelte associate.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Elimina'),
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
          const SnackBar(
            content: Text('Menu eliminato'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
