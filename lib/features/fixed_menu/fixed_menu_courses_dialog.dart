import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/models/menu_item.dart';
import '../../data/providers/providers.dart';

/// Dialog for managing courses and choices of a fixed menu
class FixedMenuCoursesDialog extends ConsumerStatefulWidget {
  final FixedMenu menu;

  const FixedMenuCoursesDialog({super.key, required this.menu});

  @override
  ConsumerState<FixedMenuCoursesDialog> createState() => _FixedMenuCoursesDialogState();
}

class _FixedMenuCoursesDialogState extends ConsumerState<FixedMenuCoursesDialog> {
  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(fixedMenuCoursesProvider(widget.menu.id));

    return Dialog(
      child: Container(
        width: 700,
        height: 600,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.menu.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Gestisci portate e scelte',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _showAddCourseDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Aggiungi Portata'),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            // Courses list
            Expanded(
              child: coursesAsync.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ReorderableListView.builder(
                    itemCount: courses.length,
                    onReorder: (oldIndex, newIndex) {
                      _reorderCourses(courses, oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      return _CourseCard(
                        key: ValueKey(courses[index].id),
                        course: courses[index],
                        onEdit: () => _showEditCourseDialog(courses[index]),
                        onDelete: () => _deleteCourse(courses[index]),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Errore: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nessuna portata',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aggiungi portate come Primo, Secondo, Dolce...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) => _CourseEditDialog(
        fixedMenuId: widget.menu.id,
        onSaved: () => ref.invalidate(fixedMenuCoursesProvider(widget.menu.id)),
      ),
    );
  }

  void _showEditCourseDialog(FixedMenuCourse course) {
    showDialog(
      context: context,
      builder: (context) => _CourseEditDialog(
        fixedMenuId: widget.menu.id,
        course: course,
        onSaved: () => ref.invalidate(fixedMenuCoursesProvider(widget.menu.id)),
      ),
    );
  }

  Future<void> _deleteCourse(FixedMenuCourse course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Portata'),
        content: Text('Eliminare "${course.name}" e tutte le sue scelte?'),
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

    try {
      final repo = ref.read(fixedMenuCourseRepositoryProvider);
      await repo.delete(course.id);
      ref.invalidate(fixedMenuCoursesProvider(widget.menu.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _reorderCourses(List<FixedMenuCourse> courses, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final repo = ref.read(fixedMenuCourseRepositoryProvider);

    try {
      for (int i = 0; i < courses.length; i++) {
        int targetIndex = i;
        if (i == oldIndex) {
          targetIndex = newIndex;
        } else if (oldIndex < newIndex && i > oldIndex && i <= newIndex) {
          targetIndex = i - 1;
        } else if (oldIndex > newIndex && i < oldIndex && i >= newIndex) {
          targetIndex = i + 1;
        }

        if (courses[i].sortOrder != targetIndex) {
          await repo.update(
            courses[i].id,
            courses[i].copyWith(sortOrder: targetIndex),
          );
        }
      }
      ref.invalidate(fixedMenuCoursesProvider(widget.menu.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }
}

/// Card displaying a course with its choices
class _CourseCard extends ConsumerWidget {
  final FixedMenuCourse course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    super.key,
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choicesAsync = ref.watch(fixedMenuChoicesProvider(course.id));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ExpansionTile(
        leading: ReorderableDragStartListener(
          index: 0,
          child: const Icon(Icons.drag_handle),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                course.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (course.isRequired)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.burgundy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'Obbligatorio',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
          ],
        ),
        subtitle: choicesAsync.when(
          data: (choices) => Text(
            '${choices.length} scelte disponibili',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          loading: () => const Text('...'),
          error: (_, __) => const Text('Errore'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
              tooltip: 'Modifica',
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: AppColors.error),
              onPressed: onDelete,
              tooltip: 'Elimina',
            ),
          ],
        ),
        children: [
          choicesAsync.when(
            data: (choices) => _ChoicesList(
              courseId: course.id,
              choices: choices,
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text('Errore: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

/// List of choices within a course
class _ChoicesList extends ConsumerWidget {
  final String courseId;
  final List<FixedMenuChoice> choices;

  const _ChoicesList({
    required this.courseId,
    required this.choices,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add choice button
          OutlinedButton.icon(
            onPressed: () => _showAddChoiceDialog(context, ref),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Aggiungi Scelta'),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Choices
          if (choices.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Nessuna scelta. Aggiungi piatti dal menu.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...choices.map((choice) => _ChoiceTile(
                  choice: choice,
                  onDelete: () => _deleteChoice(context, ref, choice),
                )),
        ],
      ),
    );
  }

  void _showAddChoiceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AddChoiceDialog(
        courseId: courseId,
        existingChoiceIds: choices.map((c) => c.menuItemId).toList(),
        onSaved: () => ref.invalidate(fixedMenuChoicesProvider(courseId)),
      ),
    );
  }

  Future<void> _deleteChoice(BuildContext context, WidgetRef ref, FixedMenuChoice choice) async {
    try {
      final repo = ref.read(fixedMenuChoiceRepositoryProvider);
      await repo.delete(choice.id);
      ref.invalidate(fixedMenuChoicesProvider(courseId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }
}

/// Single choice tile
class _ChoiceTile extends StatelessWidget {
  final FixedMenuChoice choice;
  final VoidCallback onDelete;

  const _ChoiceTile({
    required this.choice,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      leading: Icon(
        choice.isDefault ? Icons.star : Icons.restaurant,
        size: 18,
        color: choice.isDefault ? AppColors.gold : AppColors.textSecondary,
      ),
      title: Text(choice.menuItemName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (choice.supplement > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '+€${choice.supplement.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: AppColors.error),
            onPressed: onDelete,
            tooltip: 'Rimuovi',
          ),
        ],
      ),
    );
  }
}

/// Dialog for editing a course
class _CourseEditDialog extends ConsumerStatefulWidget {
  final String fixedMenuId;
  final FixedMenuCourse? course;
  final VoidCallback onSaved;

  const _CourseEditDialog({
    required this.fixedMenuId,
    this.course,
    required this.onSaved,
  });

  @override
  ConsumerState<_CourseEditDialog> createState() => _CourseEditDialogState();
}

class _CourseEditDialogState extends ConsumerState<_CourseEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isRequired = true;
  bool _isLoading = false;

  bool get isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _descriptionController = TextEditingController(text: widget.course?.description ?? '');
    _isRequired = widget.course?.isRequired ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Modifica Portata' : 'Nuova Portata'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'es. Primo, Secondo, Dolce',
                ),
                validator: (v) => v?.isEmpty == true ? 'Obbligatorio' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrizione',
                  hintText: 'Descrizione opzionale',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                title: const Text('Selezione obbligatoria'),
                subtitle: const Text('Il cliente deve scegliere'),
                value: _isRequired,
                onChanged: (v) => setState(() => _isRequired = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Salva' : 'Crea'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fixedMenuCourseRepositoryProvider);

      final courseData = FixedMenuCourse(
        id: widget.course?.id ?? '',
        fixedMenuId: widget.fixedMenuId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isRequired: _isRequired,
        sortOrder: widget.course?.sortOrder ?? 999,
        createdAt: widget.course?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await repo.update(widget.course!.id, courseData);
      } else {
        await repo.insert(courseData);
      }

      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Dialog for adding a choice to a course
class _AddChoiceDialog extends ConsumerStatefulWidget {
  final String courseId;
  final List<String> existingChoiceIds;
  final VoidCallback onSaved;

  const _AddChoiceDialog({
    required this.courseId,
    required this.existingChoiceIds,
    required this.onSaved,
  });

  @override
  ConsumerState<_AddChoiceDialog> createState() => _AddChoiceDialogState();
}

class _AddChoiceDialogState extends ConsumerState<_AddChoiceDialog> {
  MenuItem? _selectedItem;
  final _supplementController = TextEditingController(text: '0');
  bool _isDefault = false;
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _supplementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuItemsAsync = ref.watch(menuItemsProvider);

    return AlertDialog(
      title: const Text('Aggiungi Scelta'),
      content: SizedBox(
        width: 500,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cerca piatto...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
            const SizedBox(height: AppSpacing.md),
            // Items list
            Expanded(
              child: menuItemsAsync.when(
                data: (items) {
                  final filtered = items.where((item) {
                    if (widget.existingChoiceIds.contains(item.id)) return false;
                    if (_searchQuery.isNotEmpty &&
                        !item.name.toLowerCase().contains(_searchQuery)) {
                      return false;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'Nessun piatto disponibile',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = _selectedItem?.id == item.id;

                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: AppColors.burgundy.withValues(alpha: 0.1),
                        leading: Icon(
                          isSelected ? Icons.check_circle : Icons.restaurant,
                          color: isSelected ? AppColors.burgundy : null,
                        ),
                        title: Text(item.name),
                        subtitle: Text('€${item.price.toStringAsFixed(2)}'),
                        onTap: () => setState(() => _selectedItem = item),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Errore: $e')),
              ),
            ),
            const Divider(),
            // Supplement and default
            if (_selectedItem != null) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _supplementController,
                      decoration: const InputDecoration(
                        labelText: 'Supplemento',
                        prefixText: '€ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Row(
                    children: [
                      Checkbox(
                        value: _isDefault,
                        onChanged: (v) => setState(() => _isDefault = v!),
                      ),
                      const Text('Predefinito'),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _selectedItem == null || _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Aggiungi'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (_selectedItem == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fixedMenuChoiceRepositoryProvider);
      final supplement = double.tryParse(
            _supplementController.text.replaceAll(',', '.'),
          ) ??
          0;

      final choice = FixedMenuChoice(
        id: '',
        courseId: widget.courseId,
        menuItemId: _selectedItem!.id,
        menuItemName: _selectedItem!.name,
        supplement: supplement,
        isDefault: _isDefault,
        createdAt: DateTime.now(),
      );

      await repo.insert(choice);
      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
