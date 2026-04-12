import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/menu_item.dart';
import 'cart_provider.dart';

/// Bottom sheet showing menu item details
class MenuItemDetailSheet extends ConsumerStatefulWidget {
  final MenuItem item;

  const MenuItemDetailSheet({super.key, required this.item});

  @override
  ConsumerState<MenuItemDetailSheet> createState() =>
      _MenuItemDetailSheetState();
}

class _MenuItemDetailSheetState extends ConsumerState<MenuItemDetailSheet> {
  int _quantity = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    ref.read(cartProvider.notifier).addItem(
          widget.item,
          quantity: _quantity,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.item.name} aggiunto al carrello'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final totalPrice = item.price * _quantity;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: item.imageUrl != null
                            ? Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Name and price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Text(
                          item.formatPrice(),
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    // Description
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                    // Tags
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: item.tags.map((tag) {
                          return _TagChip(tag: tag);
                        }).toList(),
                      ),
                    ],
                    // Allergens
                    if (item.allergens.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Allergeni',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: item.allergens.map((allergen) {
                          return Chip(
                            label: Text(_formatAllergen(allergen)),
                            backgroundColor: AppColors.warningLight,
                            labelStyle: const TextStyle(fontSize: 12),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                    // Info row
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        if (item.preparationTime != null) ...[
                          Icon(Icons.schedule,
                              size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${item.preparationTime} min',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                        ],
                        if (item.calories != null) ...[
                          Icon(Icons.local_fire_department,
                              size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${item.calories} kcal',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                    // Notes
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Note (opzionale)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Es: senza cipolla, ben cotto...',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              // Bottom bar with quantity and add button
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Quantity selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              visualDensity: VisualDensity.compact,
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Add to cart button
                      Expanded(
                        child: FilledButton(
                          onPressed: _addToCart,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                          child: Text(
                            'Aggiungi - € ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cream,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: AppColors.textSecondary,
        ),
      ),
    );
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

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getEmoji(), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _getLabel(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _getTextColor(),
                ),
          ),
        ],
      ),
    );
  }

  String _getEmoji() {
    switch (tag) {
      case 'vegetariano':
        return '🥬';
      case 'vegano':
        return '🌱';
      case 'gluten_free':
        return '🌾';
      case 'piccante':
        return '🌶️';
      case 'chefs_choice':
        return '⭐';
      default:
        return '🏷️';
    }
  }

  String _getLabel() {
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

  Color _getBackgroundColor() {
    switch (tag) {
      case 'vegetariano':
      case 'vegano':
        return const Color(0xFFE8F5E9);
      case 'gluten_free':
        return const Color(0xFFFFF3E0);
      case 'piccante':
        return const Color(0xFFFFEBEE);
      case 'chefs_choice':
        return const Color(0xFFFFF8E1);
      default:
        return AppColors.creamLight;
    }
  }

  Color _getTextColor() {
    switch (tag) {
      case 'vegetariano':
      case 'vegano':
        return const Color(0xFF2E7D32);
      case 'gluten_free':
        return const Color(0xFFE65100);
      case 'piccante':
        return const Color(0xFFC62828);
      case 'chefs_choice':
        return const Color(0xFFF57F17);
      default:
        return AppColors.charcoal;
    }
  }
}
