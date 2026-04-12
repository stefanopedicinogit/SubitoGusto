import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixed_menu.freezed.dart';
part 'fixed_menu.g.dart';

/// Fixed Menu (Menu Fisso / Prix Fixe)
@freezed
class FixedMenu with _$FixedMenu {
  const FixedMenu._();

  const factory FixedMenu({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    required double price,
    /// Available times: 'lunch', 'dinner', 'all'
    @JsonKey(name: 'available_for') @Default('all') String availableFor,
    /// Available days: null = all days, or ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
    @JsonKey(name: 'available_days') List<String>? availableDays,
    /// Start date for availability (null = always)
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    /// End date for availability (null = no end)
    @JsonKey(name: 'valid_to') DateTime? validTo,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FixedMenu;

  factory FixedMenu.fromJson(Map<String, dynamic> json) =>
      _$FixedMenuFromJson(json);

  /// Check if menu is available for lunch
  bool get isLunchMenu => availableFor == 'lunch' || availableFor == 'all';

  /// Check if menu is available for dinner
  bool get isDinnerMenu => availableFor == 'dinner' || availableFor == 'all';

  /// Check if menu is currently valid based on dates
  bool get isCurrentlyValid {
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validTo != null && now.isAfter(validTo!)) return false;
    return true;
  }

  /// Check if menu is available today
  bool get isAvailableToday {
    if (!isActive || !isCurrentlyValid) return false;
    if (availableDays == null || availableDays!.isEmpty) return true;

    final dayNames = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final todayIndex = DateTime.now().weekday - 1; // 0-6
    return availableDays!.contains(dayNames[todayIndex]);
  }

  /// Check if available now based on time of day
  bool isAvailableNow() {
    if (!isAvailableToday) return false;

    // Menus available for 'all' are always shown when active and valid
    if (availableFor == 'all') return true;

    final hour = DateTime.now().hour;
    final isLunchTime = hour >= 11 && hour < 15;
    final isDinnerTime = hour >= 18 && hour < 23;

    if (availableFor == 'lunch') return isLunchTime;
    if (availableFor == 'dinner') return isDinnerTime;
    return true;
  }

  /// Format price with currency
  String formatPrice([String currency = '€']) =>
      '$currency ${price.toStringAsFixed(2)}';

  /// Get availability description in Italian
  String get availabilityDescription {
    final parts = <String>[];

    // Time of day
    if (availableFor == 'lunch') {
      parts.add('Solo pranzo');
    } else if (availableFor == 'dinner') {
      parts.add('Solo cena');
    }

    // Days
    if (availableDays != null && availableDays!.isNotEmpty) {
      final dayLabels = {
        'mon': 'Lun', 'tue': 'Mar', 'wed': 'Mer',
        'thu': 'Gio', 'fri': 'Ven', 'sat': 'Sab', 'sun': 'Dom'
      };
      final days = availableDays!.map((d) => dayLabels[d] ?? d).join(', ');
      parts.add(days);
    }

    return parts.isEmpty ? 'Sempre disponibile' : parts.join(' - ');
  }
}

/// Course within a fixed menu (e.g., Primo, Secondo, Dolce)
@freezed
class FixedMenuCourse with _$FixedMenuCourse {
  const FixedMenuCourse._();

  const factory FixedMenuCourse({
    required String id,
    @JsonKey(name: 'fixed_menu_id') required String fixedMenuId,
    required String name,
    String? description,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    /// Whether customer must select from this course
    @JsonKey(name: 'is_required') @Default(true) bool isRequired,
    /// Maximum number of choices (usually 1)
    @JsonKey(name: 'max_choices') @Default(1) int maxChoices,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FixedMenuCourse;

  factory FixedMenuCourse.fromJson(Map<String, dynamic> json) =>
      _$FixedMenuCourseFromJson(json);
}

/// Available choice within a course
@freezed
class FixedMenuChoice with _$FixedMenuChoice {
  const FixedMenuChoice._();

  const factory FixedMenuChoice({
    required String id,
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'menu_item_id') required String menuItemId,
    /// Cached name from menu item
    @JsonKey(name: 'menu_item_name') required String menuItemName,
    /// Extra cost for this choice (e.g., +€5 for premium)
    @Default(0) double supplement,
    /// Whether this is the default selection
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FixedMenuChoice;

  factory FixedMenuChoice.fromJson(Map<String, dynamic> json) =>
      _$FixedMenuChoiceFromJson(json);

  /// Format supplement price
  String get supplementDisplay =>
      supplement > 0 ? '+€${supplement.toStringAsFixed(2)}' : '';
}

/// Customer's selection from a fixed menu (for cart/order)
@freezed
class FixedMenuSelection with _$FixedMenuSelection {
  const FixedMenuSelection._();

  const factory FixedMenuSelection({
    required String fixedMenuId,
    required String fixedMenuName,
    required double basePrice,
    /// Map of courseId -> selected choiceId
    required Map<String, SelectedChoice> selections,
  }) = _FixedMenuSelection;

  factory FixedMenuSelection.fromJson(Map<String, dynamic> json) =>
      _$FixedMenuSelectionFromJson(json);

  /// Calculate total supplements
  double get totalSupplements =>
      selections.values.fold(0, (sum, s) => sum + s.supplement);

  /// Calculate final price
  double get totalPrice => basePrice + totalSupplements;

  /// Format total price
  String formatTotal([String currency = '€']) =>
      '$currency ${totalPrice.toStringAsFixed(2)}';
}

/// A single selected choice
@freezed
class SelectedChoice with _$SelectedChoice {
  const factory SelectedChoice({
    required String choiceId,
    required String choiceName,
    required double supplement,
  }) = _SelectedChoice;

  factory SelectedChoice.fromJson(Map<String, dynamic> json) =>
      _$SelectedChoiceFromJson(json);
}
