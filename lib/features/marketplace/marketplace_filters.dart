import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/generated/app_localizations.dart';

// ============================================================================
// Curated option lists. UI shows these; new options can be added without
// migrations since the DB columns are free-form text.
// ============================================================================

/// Cuisine type values stored in DB. Labels are resolved via [labelForCuisine].
const List<String> kCuisineValues = [
  'pizza',
  'pasta',
  'sushi',
  'burger',
  'kebab',
  'chinese',
  'indian',
  'mexican',
  'asian',
  'mediterranean',
  'american',
  'dessert',
  'breakfast',
  'other',
];

/// Dietary tag values stored in DB. Labels via [labelForDietary].
const List<String> kDietaryValues = [
  'vegan',
  'vegetarian',
  'gluten_free',
  'halal',
  'kosher',
  'lactose_free',
];

String labelForCuisine(BuildContext context, String value) {
  final l = AppLocalizations.of(context);
  return switch (value) {
    'pizza' => l.cuisinePizza,
    'pasta' => l.cuisinePasta,
    'sushi' => l.cuisineSushi,
    'burger' => l.cuisineBurger,
    'kebab' => l.cuisineKebab,
    'chinese' => l.cuisineChinese,
    'indian' => l.cuisineIndian,
    'mexican' => l.cuisineMexican,
    'asian' => l.cuisineAsian,
    'mediterranean' => l.cuisineMediterranean,
    'american' => l.cuisineAmerican,
    'dessert' => l.cuisineDessert,
    'breakfast' => l.cuisineBreakfast,
    'other' => l.cuisineOther,
    _ => value,
  };
}

String labelForDietary(BuildContext context, String value) {
  final l = AppLocalizations.of(context);
  return switch (value) {
    'vegan' => l.dietaryVegan,
    'vegetarian' => l.dietaryVegetarian,
    'gluten_free' => l.dietaryGlutenFree,
    'halal' => l.dietaryHalal,
    'kosher' => l.dietaryKosher,
    'lactose_free' => l.dietaryLactoseFree,
    _ => value,
  };
}

// ============================================================================
// Sort
// ============================================================================

enum MarketplaceSort {
  distance,
  deliveryTime,
  rating,
  price,
}

extension MarketplaceSortX on MarketplaceSort {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (this) {
      MarketplaceSort.distance => l.sortDistance,
      MarketplaceSort.deliveryTime => l.sortDeliveryTime,
      MarketplaceSort.rating => l.sortRating,
      MarketplaceSort.price => l.sortPrice,
    };
  }
}

// ============================================================================
// Filter state
// ============================================================================

class MarketplaceFilters {
  final String? cuisineType;
  final Set<String> dietaryTags;
  final int? maxDeliveryTimeMin;
  final bool freeDeliveryOnly;
  final MarketplaceSort sort;

  const MarketplaceFilters({
    this.cuisineType,
    this.dietaryTags = const {},
    this.maxDeliveryTimeMin,
    this.freeDeliveryOnly = false,
    this.sort = MarketplaceSort.distance,
  });

  /// True when any filter is set (used to show a "reset" affordance).
  bool get hasAnyFilter =>
      cuisineType != null ||
      dietaryTags.isNotEmpty ||
      maxDeliveryTimeMin != null ||
      freeDeliveryOnly;

  /// Count of active filters (used for the badge on the "Filtri" button).
  int get activeCount =>
      (cuisineType != null ? 1 : 0) +
      dietaryTags.length +
      (maxDeliveryTimeMin != null ? 1 : 0) +
      (freeDeliveryOnly ? 1 : 0);

  MarketplaceFilters copyWith({
    Object? cuisineType = _sentinel,
    Set<String>? dietaryTags,
    Object? maxDeliveryTimeMin = _sentinel,
    bool? freeDeliveryOnly,
    MarketplaceSort? sort,
  }) {
    return MarketplaceFilters(
      cuisineType: identical(cuisineType, _sentinel)
          ? this.cuisineType
          : cuisineType as String?,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      maxDeliveryTimeMin: identical(maxDeliveryTimeMin, _sentinel)
          ? this.maxDeliveryTimeMin
          : maxDeliveryTimeMin as int?,
      freeDeliveryOnly: freeDeliveryOnly ?? this.freeDeliveryOnly,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() => {
        'cuisineType': cuisineType,
        'dietaryTags': dietaryTags.toList(),
        'maxDeliveryTimeMin': maxDeliveryTimeMin,
        'freeDeliveryOnly': freeDeliveryOnly,
        'sort': sort.name,
      };

  factory MarketplaceFilters.fromJson(Map<String, dynamic> json) {
    return MarketplaceFilters(
      cuisineType: json['cuisineType'] as String?,
      dietaryTags:
          (json['dietaryTags'] as List?)?.cast<String>().toSet() ?? const {},
      maxDeliveryTimeMin: json['maxDeliveryTimeMin'] as int?,
      freeDeliveryOnly: json['freeDeliveryOnly'] as bool? ?? false,
      sort: MarketplaceSort.values.firstWhere(
        (s) => s.name == json['sort'],
        orElse: () => MarketplaceSort.distance,
      ),
    );
  }
}

const _sentinel = Object();

// ============================================================================
// Notifier — loads from SharedPreferences on construction, saves on each change
// ============================================================================

const _kPrefsKey = 'marketplace_filters_v1';

class MarketplaceFiltersNotifier extends StateNotifier<MarketplaceFilters> {
  MarketplaceFiltersNotifier() : super(const MarketplaceFilters()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kPrefsKey);
      if (raw == null) return;
      state =
          MarketplaceFilters.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupted prefs — fall back to default state.
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPrefsKey, jsonEncode(state.toJson()));
    } catch (_) {
      // Silent — UI keeps working even if persistence fails.
    }
  }

  void update(MarketplaceFilters next) {
    state = next;
    _save();
  }

  void reset() {
    state = const MarketplaceFilters();
    _save();
  }
}

final marketplaceFiltersProvider =
    StateNotifierProvider<MarketplaceFiltersNotifier, MarketplaceFilters>(
        (ref) => MarketplaceFiltersNotifier());
