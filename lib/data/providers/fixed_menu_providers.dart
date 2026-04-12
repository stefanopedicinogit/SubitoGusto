import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fixed_menu.dart';
import '../repositories/supabase_repository.dart';
import 'supabase_provider.dart';

// ============================================================================
// Repository Providers
// ============================================================================

/// Fixed Menu repository provider
final fixedMenuRepositoryProvider = Provider<SupabaseRepository<FixedMenu>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  return SupabaseRepository<FixedMenu>(
    client: client,
    tableName: 'fixed_menus',
    fromJson: FixedMenu.fromJson,
    toJson: (fm) => fm.toJson(),
    getCurrentTenantId: () => tenantId,
  );
});

/// Fixed Menu Course repository provider
final fixedMenuCourseRepositoryProvider = Provider<SupabaseRepository<FixedMenuCourse>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseRepository<FixedMenuCourse>(
    client: client,
    tableName: 'fixed_menu_courses',
    fromJson: FixedMenuCourse.fromJson,
    toJson: (c) => c.toJson(),
  );
});

/// Fixed Menu Choice repository provider
final fixedMenuChoiceRepositoryProvider = Provider<SupabaseRepository<FixedMenuChoice>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseRepository<FixedMenuChoice>(
    client: client,
    tableName: 'fixed_menu_choices',
    fromJson: FixedMenuChoice.fromJson,
    toJson: (c) => c.toJson(),
  );
});

// ============================================================================
// Data Providers
// ============================================================================

/// All fixed menus provider
final fixedMenusProvider = FutureProvider<List<FixedMenu>>((ref) async {
  ref.watch(supabaseAuthProvider);
  final repo = ref.watch(fixedMenuRepositoryProvider);
  return repo.getAll(orderBy: 'sort_order');
});

/// Active fixed menus provider
final activeFixedMenusProvider = FutureProvider<List<FixedMenu>>((ref) async {
  final menus = await ref.watch(fixedMenusProvider.future);
  return menus.where((m) => m.isActive && m.isCurrentlyValid).toList();
});

/// Currently available fixed menus (for customers)
final availableFixedMenusProvider = FutureProvider<List<FixedMenu>>((ref) async {
  final menus = await ref.watch(activeFixedMenusProvider.future);
  return menus.where((m) => m.isAvailableNow()).toList();
});

/// Single fixed menu provider
final fixedMenuProvider = FutureProvider.family<FixedMenu?, String>((ref, id) async {
  final repo = ref.watch(fixedMenuRepositoryProvider);
  return repo.getById(id);
});

/// Courses for a fixed menu
final fixedMenuCoursesProvider = FutureProvider.family<List<FixedMenuCourse>, String>((ref, fixedMenuId) async {
  final repo = ref.watch(fixedMenuCourseRepositoryProvider);
  final courses = await repo.query(
    equals: {'fixed_menu_id': fixedMenuId},
    orderBy: 'sort_order',
  );
  return courses;
});

/// Choices for a course
final fixedMenuChoicesProvider = FutureProvider.family<List<FixedMenuChoice>, String>((ref, courseId) async {
  final repo = ref.watch(fixedMenuChoiceRepositoryProvider);
  final choices = await repo.query(
    equals: {'course_id': courseId},
    orderBy: 'sort_order',
  );
  return choices;
});

/// Full fixed menu with all courses and choices
final fullFixedMenuProvider = FutureProvider.family<FullFixedMenu?, String>((ref, fixedMenuId) async {
  final menu = await ref.watch(fixedMenuProvider(fixedMenuId).future);
  if (menu == null) return null;

  final courseRepo = ref.watch(fixedMenuCourseRepositoryProvider);
  final choiceRepo = ref.watch(fixedMenuChoiceRepositoryProvider);

  final courses = await courseRepo.query(
    equals: {'fixed_menu_id': fixedMenuId},
    orderBy: 'sort_order',
  );

  final coursesWithChoices = <FixedMenuCourseWithChoices>[];
  for (final course in courses) {
    final choices = await choiceRepo.query(
      equals: {'course_id': course.id},
      orderBy: 'sort_order',
    );
    coursesWithChoices.add(FixedMenuCourseWithChoices(
      course: course,
      choices: choices,
    ));
  }

  return FullFixedMenu(menu: menu, courses: coursesWithChoices);
});

// ============================================================================
// Stream Providers (Realtime)
// ============================================================================

/// Realtime fixed menus stream
final fixedMenusStreamProvider = StreamProvider<List<FixedMenu>>((ref) {
  ref.watch(supabaseAuthProvider);
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('fixed_menus')
      .stream(primaryKey: ['id'])
      .order('sort_order')
      .map((data) => data.map((json) => FixedMenu.fromJson(json)).toList());
});

// ============================================================================
// Helper Classes
// ============================================================================

/// Course with its choices loaded
class FixedMenuCourseWithChoices {
  final FixedMenuCourse course;
  final List<FixedMenuChoice> choices;

  const FixedMenuCourseWithChoices({
    required this.course,
    required this.choices,
  });

  /// Get the default choice if any
  FixedMenuChoice? get defaultChoice =>
      choices.where((c) => c.isDefault).firstOrNull;

  /// Get available choices only
  List<FixedMenuChoice> get availableChoices =>
      choices.where((c) => c.isAvailable).toList();
}

/// Full fixed menu with all data loaded
class FullFixedMenu {
  final FixedMenu menu;
  final List<FixedMenuCourseWithChoices> courses;

  const FullFixedMenu({
    required this.menu,
    required this.courses,
  });

  /// Get only required courses
  List<FixedMenuCourseWithChoices> get requiredCourses =>
      courses.where((c) => c.course.isRequired).toList();

  /// Get optional courses
  List<FixedMenuCourseWithChoices> get optionalCourses =>
      courses.where((c) => !c.course.isRequired).toList();

  /// Calculate min price (base + no supplements)
  double get minPrice => menu.price;

  /// Calculate max price (base + all max supplements)
  double get maxPrice {
    double maxSupp = 0;
    for (final course in courses) {
      if (course.choices.isNotEmpty) {
        final maxChoiceSupp = course.choices
            .map((c) => c.supplement)
            .reduce((a, b) => a > b ? a : b);
        maxSupp += maxChoiceSupp;
      }
    }
    return menu.price + maxSupp;
  }
}
