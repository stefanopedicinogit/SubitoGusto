import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/providers.dart';

/// Dialog for creating or editing a menu item
class MenuItemDialog extends ConsumerStatefulWidget {
  final MenuItem? menuItem;
  final String? initialCategoryId;

  const MenuItemDialog({
    super.key,
    this.menuItem,
    this.initialCategoryId,
  });

  @override
  ConsumerState<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends ConsumerState<MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _sortOrderController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _caloriesController;
  late String? _categoryId;
  late bool _isAvailable;
  late bool _isActive;
  late List<String> _selectedTags;
  late List<String> _selectedAllergens;
  bool _isLoading = false;

  bool get isEditing => widget.menuItem != null;

  static const _availableTags = [
    'vegetariano',
    'vegano',
    'gluten_free',
    'piccante',
    'chefs_choice',
  ];

  static const _availableAllergens = [
    'glutine',
    'lattosio',
    'uova',
    'pesce',
    'crostacei',
    'arachidi',
    'frutta_secca',
    'soia',
    'sedano',
    'senape',
    'sesamo',
    'solfiti',
    'lupini',
    'molluschi',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menuItem?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.menuItem?.description ?? '');
    _priceController = TextEditingController(
        text: widget.menuItem?.price.toStringAsFixed(2) ?? '');
    _imageUrlController =
        TextEditingController(text: widget.menuItem?.imageUrl ?? '');
    _sortOrderController = TextEditingController(
        text: (widget.menuItem?.sortOrder ?? 0).toString());
    _prepTimeController = TextEditingController(
        text: widget.menuItem?.preparationTime?.toString() ?? '');
    _caloriesController = TextEditingController(
        text: widget.menuItem?.calories?.toString() ?? '');
    _categoryId = widget.menuItem?.categoryId ?? widget.initialCategoryId;
    _isAvailable = widget.menuItem?.isAvailable ?? true;
    _isActive = widget.menuItem?.isActive ?? true;
    _selectedTags = List.from(widget.menuItem?.tags ?? []);
    _selectedAllergens = List.from(widget.menuItem?.allergens ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _sortOrderController.dispose();
    _prepTimeController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona una categoria'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tenantId = ref.read(currentTenantIdProvider);

      if (tenantId == null && !isEditing) {
        throw Exception('Tenant ID non configurato');
      }

      final data = {
        'category_id': _categoryId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0,
        'image_url': _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        'allergens': _selectedAllergens,
        'tags': _selectedTags,
        'is_available': _isAvailable,
        'is_active': _isActive,
        'preparation_time': int.tryParse(_prepTimeController.text),
        'calories': int.tryParse(_caloriesController.text),
        'sort_order': int.tryParse(_sortOrderController.text) ?? 0,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (isEditing) {
        await Supabase.instance.client
            .from('menu_items')
            .update(data)
            .eq('id', widget.menuItem!.id);
      } else {
        data['tenant_id'] = tenantId;
        data['created_at'] = DateTime.now().toIso8601String();
        await Supabase.instance.client.from('menu_items').insert(data);
      }

      ref.invalidate(menuItemsProvider);
      ref.invalidate(menuItemsStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Piatto aggiornato' : 'Piatto creato',
            ),
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _delete() async {
    if (!isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Piatto'),
        content: Text(
          'Sei sicuro di voler eliminare "${widget.menuItem!.name}"?',
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

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client
          .from('menu_items')
          .delete()
          .eq('id', widget.menuItem!.id);

      ref.invalidate(menuItemsProvider);
      ref.invalidate(menuItemsStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Piatto eliminato'),
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Text(
                    isEditing ? 'Modifica Piatto' : 'Nuovo Piatto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Category row
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nome *',
                                hintText: 'Es: Spaghetti Carbonara',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Il nome e obbligatorio';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: categoriesAsync.when(
                              data: (categories) => DropdownButtonFormField<String>(
                                value: _categoryId,
                                decoration: const InputDecoration(
                                  labelText: 'Categoria *',
                                ),
                                items: categories.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat.id,
                                    child: Text(cat.name),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => _categoryId = value),
                              ),
                              loading: () => const LinearProgressIndicator(),
                              error: (_, __) =>
                                  const Text('Errore caricamento categorie'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrizione',
                          hintText: 'Descrizione del piatto...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Price, Prep time, Calories row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Prezzo *',
                                prefixText: '€ ',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il prezzo';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Prezzo non valido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _prepTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Tempo prep. (min)',
                                hintText: '15',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _caloriesController,
                              decoration: const InputDecoration(
                                labelText: 'Calorie',
                                hintText: '450',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Image URL and Sort Order
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _imageUrlController,
                              decoration: const InputDecoration(
                                labelText: 'URL Immagine',
                                hintText: 'https://...',
                              ),
                              keyboardType: TextInputType.url,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _sortOrderController,
                              decoration: const InputDecoration(
                                labelText: 'Ordine',
                                hintText: '0',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Tags
                      Text(
                        'Tag',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _availableTags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(_formatTag(tag)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                            selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            checkmarkColor: Theme.of(context).colorScheme.primary,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Allergens
                      Text(
                        'Allergeni',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _availableAllergens.map((allergen) {
                          final isSelected = _selectedAllergens.contains(allergen);
                          return FilterChip(
                            label: Text(_formatAllergen(allergen)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAllergens.add(allergen);
                                } else {
                                  _selectedAllergens.remove(allergen);
                                }
                              });
                            },
                            selectedColor: AppColors.warning.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.warning,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Switches
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Disponibile'),
                              value: _isAvailable,
                              onChanged: (value) =>
                                  setState(() => _isAvailable = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Attivo'),
                              value: _isActive,
                              onChanged: (value) =>
                                  setState(() => _isActive = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            // Actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  if (isEditing)
                    TextButton(
                      onPressed: _isLoading ? null : _delete,
                      child: Text(
                        'Elimina',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Annulla'),
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
                        : Text(isEditing ? 'Salva' : 'Crea'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTag(String tag) {
    switch (tag) {
      case 'vegetariano':
        return 'Vegetariano';
      case 'vegano':
        return 'Vegano';
      case 'gluten_free':
        return 'Senza Glutine';
      case 'piccante':
        return 'Piccante';
      case 'chefs_choice':
        return 'Scelta dello Chef';
      default:
        return tag;
    }
  }

  String _formatAllergen(String allergen) {
    switch (allergen) {
      case 'glutine':
        return 'Glutine';
      case 'lattosio':
        return 'Lattosio';
      case 'uova':
        return 'Uova';
      case 'pesce':
        return 'Pesce';
      case 'crostacei':
        return 'Crostacei';
      case 'arachidi':
        return 'Arachidi';
      case 'frutta_secca':
        return 'Frutta a guscio';
      case 'soia':
        return 'Soia';
      case 'sedano':
        return 'Sedano';
      case 'senape':
        return 'Senape';
      case 'sesamo':
        return 'Sesamo';
      case 'solfiti':
        return 'Solfiti';
      case 'lupini':
        return 'Lupini';
      case 'molluschi':
        return 'Molluschi';
      default:
        return allergen;
    }
  }
}
