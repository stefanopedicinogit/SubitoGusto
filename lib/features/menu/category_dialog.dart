import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/category.dart';
import '../../data/providers/providers.dart';

/// Dialog for creating or editing a category
class CategoryDialog extends ConsumerStatefulWidget {
  final Category? category; // null for new category

  const CategoryDialog({super.key, this.category});

  @override
  ConsumerState<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _sortOrderController;
  late bool _isActive;
  bool _isLoading = false;

  bool get isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.description ?? '');
    _imageUrlController =
        TextEditingController(text: widget.category?.imageUrl ?? '');
    _sortOrderController = TextEditingController(
        text: (widget.category?.sortOrder ?? 0).toString());
    _isActive = widget.category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tenantId = ref.read(currentTenantIdProvider);

      if (tenantId == null && !isEditing) {
        throw Exception('Tenant ID non configurato');
      }

      final data = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'image_url': _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        'sort_order': int.tryParse(_sortOrderController.text) ?? 0,
        'is_active': _isActive,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (isEditing) {
        await Supabase.instance.client
            .from('categories')
            .update(data)
            .eq('id', widget.category!.id);
      } else {
        data['tenant_id'] = tenantId;
        data['created_at'] = DateTime.now().toIso8601String();
        await Supabase.instance.client.from('categories').insert(data);
      }

      // Refresh categories
      ref.invalidate(categoriesProvider);
      ref.invalidate(categoriesStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Categoria aggiornata' : 'Categoria creata',
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
        title: const Text('Elimina Categoria'),
        content: Text(
          'Sei sicuro di voler eliminare "${widget.category!.name}"?\n\n'
          'Attenzione: tutti i piatti in questa categoria dovranno essere riassegnati.',
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
          .from('categories')
          .delete()
          .eq('id', widget.category!.id);

      ref.invalidate(categoriesProvider);
      ref.invalidate(categoriesStreamProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoria eliminata'),
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
    return AlertDialog(
      title: Text(isEditing ? 'Modifica Categoria' : 'Nuova Categoria'),
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
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    hintText: 'Es: Antipasti, Primi Piatti...',
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
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    hintText: 'Descrizione opzionale...',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Immagine',
                    hintText: 'https://...',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _sortOrderController,
                  decoration: const InputDecoration(
                    labelText: 'Ordine',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: const Text('Attiva'),
                  subtitle: const Text('Visibile nel menu'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
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
            onPressed: _isLoading ? null : _delete,
            child: const Text(
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
    );
  }
}
