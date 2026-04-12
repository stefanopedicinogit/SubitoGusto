import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/fixed_menu.dart';
import '../../data/providers/providers.dart';
import '../cart/cart_provider.dart';

/// Bottom sheet for selecting choices from a fixed menu
class FixedMenuSelectionSheet extends ConsumerStatefulWidget {
  final FixedMenu menu;

  const FixedMenuSelectionSheet({super.key, required this.menu});

  @override
  ConsumerState<FixedMenuSelectionSheet> createState() =>
      _FixedMenuSelectionSheetState();
}

class _FixedMenuSelectionSheetState
    extends ConsumerState<FixedMenuSelectionSheet> {
  // Map of courseId -> selected choiceId
  final Map<String, FixedMenuChoice?> _selections = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final fullMenuAsync = ref.watch(fullFixedMenuProvider(widget.menu.id));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: fullMenuAsync.when(
        data: (fullMenu) {
          if (fullMenu == null) {
            return const Center(child: Text('Menu non trovato'));
          }
          return _buildContent(context, fullMenu);
        },
        loading: () => const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => SizedBox(
          height: 300,
          child: Center(child: Text('Errore: $e')),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FullFixedMenu fullMenu) {
    // Calculate total with supplements
    double totalSupplements = 0;
    for (final selection in _selections.values) {
      if (selection != null) {
        totalSupplements += selection.supplement;
      }
    }
    final totalPrice = widget.menu.price + totalSupplements;

    // Check if all required courses (that have available choices) have selections
    final selectableRequiredCourses = fullMenu.requiredCourses
        .where((c) => c.availableChoices.isNotEmpty)
        .toList();
    final allRequiredSelected = selectableRequiredCourses.every((course) {
      return _selections[course.course.id] != null;
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.menu.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (widget.menu.description != null)
                      Text(
                        widget.menu.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  children: [
                    if (totalSupplements > 0)
                      Text(
                        widget.menu.formatPrice(),
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.charcoal,
                        ),
                      ),
                    Text(
                      '€ ${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Courses list
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              children: fullMenu.courses.map((courseWithChoices) {
                return _CourseSelectionSection(
                  courseWithChoices: courseWithChoices,
                  selectedChoice: _selections[courseWithChoices.course.id],
                  onChoiceSelected: (choice) {
                    setState(() {
                      _selections[courseWithChoices.course.id] = choice;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        // Add to cart button
        Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (!allRequiredSelected)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Seleziona tutte le portate obbligatorie',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: allRequiredSelected && !_isLoading
                      ? () => _addToCart(fullMenu, totalPrice)
                      : null,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_shopping_cart),
                  label: Text(
                    'Aggiungi al carrello - €${totalPrice.toStringAsFixed(2)}',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addToCart(FullFixedMenu fullMenu, double totalPrice) {
    setState(() => _isLoading = true);

    // Build the selection summary
    final selectionDetails = <String>[];
    for (final course in fullMenu.courses) {
      final selection = _selections[course.course.id];
      if (selection != null) {
        String detail = '${course.course.name}: ${selection.menuItemName}';
        if (selection.supplement > 0) {
          detail += ' (+€${selection.supplement.toStringAsFixed(2)})';
        }
        selectionDetails.add(detail);
      }
    }

    // Create selections map for the model
    final selectionsMap = <String, SelectedChoice>{};
    for (final entry in _selections.entries) {
      if (entry.value != null) {
        selectionsMap[entry.key] = SelectedChoice(
          choiceId: entry.value!.id,
          choiceName: entry.value!.menuItemName,
          supplement: entry.value!.supplement,
        );
      }
    }

    final selection = FixedMenuSelection(
      fixedMenuId: widget.menu.id,
      fixedMenuName: widget.menu.name,
      basePrice: widget.menu.price,
      selections: selectionsMap,
    );

    // Add to cart
    ref.read(cartProvider.notifier).addFixedMenu(
          selection,
          selectionDetails.join('\n'),
        );

    // Capture scaffold messenger before popping (context may deactivate after pop)
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${widget.menu.name} aggiunto al carrello'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Section for selecting from a course
class _CourseSelectionSection extends StatelessWidget {
  final FixedMenuCourseWithChoices courseWithChoices;
  final FixedMenuChoice? selectedChoice;
  final ValueChanged<FixedMenuChoice?> onChoiceSelected;

  const _CourseSelectionSection({
    required this.courseWithChoices,
    required this.selectedChoice,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final course = courseWithChoices.course;
    final choices = courseWithChoices.availableChoices;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          Row(
            children: [
              Expanded(
                child: Text(
                  course.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                      fontSize: 10,
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Opzionale',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          if (course.description != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                course.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          // Choices
          if (choices.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Nessuna scelta disponibile per questa portata',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),
          ...choices.map((choice) {
            final isSelected = selectedChoice?.id == choice.id;

            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  if (isSelected && !course.isRequired) {
                    onChoiceSelected(null);
                  } else {
                    onChoiceSelected(choice);
                  }
                },
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      // Radio indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Choice info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              choice.menuItemName,
                              style: TextStyle(
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            if (choice.isDefault)
                              Text(
                                'Scelta consigliata',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Supplement
                      if (choice.supplement > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '+€${choice.supplement.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
