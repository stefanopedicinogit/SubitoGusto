import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
class MenuItem with _$MenuItem {
  const MenuItem._();

  const factory MenuItem({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default([]) List<String> allergens,
    @Default([]) List<String> tags,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'preparation_time') int? preparationTime,
    int? calories,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  /// Check if item is vegetarian
  bool get isVegetarian => tags.contains('vegetariano');

  /// Check if item is vegan
  bool get isVegan => tags.contains('vegano');

  /// Check if item is gluten free
  bool get isGlutenFree =>
      tags.contains('gluten_free') || !allergens.contains('glutine');

  /// Check if item is spicy
  bool get isSpicy => tags.contains('piccante');

  /// Check if item is chef's choice
  bool get isChefsChoice => tags.contains('chefs_choice');

  /// Format price with currency symbol
  String formatPrice([String currency = '€']) => '$currency ${price.toStringAsFixed(2)}';
}
