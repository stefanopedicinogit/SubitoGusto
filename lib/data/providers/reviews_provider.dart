import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review.dart';
import '../models/review_aggregate.dart';
import 'supabase_provider.dart';

// ============================================================================
// Aggregate (avg + count) for a single target
// ============================================================================

class ReviewTargetKey {
  final String targetType; // 'restaurant' | 'item'
  final String targetId;

  const ReviewTargetKey(this.targetType, this.targetId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewTargetKey &&
          other.targetType == targetType &&
          other.targetId == targetId);

  @override
  int get hashCode => Object.hash(targetType, targetId);
}

/// Avg rating + count for a single target (restaurant or item).
final reviewAggregateProvider =
    FutureProvider.family<ReviewAggregate?, ReviewTargetKey>(
        (ref, key) async {
  final client = ref.watch(supabaseClientProvider);
  final row = await client
      .from('review_aggregates')
      .select()
      .eq('target_type', key.targetType)
      .eq('target_id', key.targetId)
      .maybeSingle();
  if (row == null) return null;
  return ReviewAggregate.fromJson(row);
});

/// All restaurant aggregates in one fetch. Used by the marketplace card list
/// to avoid N+1 queries. Cheap at our scale (hundreds of tenants max).
final allRestaurantAggregatesProvider =
    FutureProvider<Map<String, ReviewAggregate>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final rows = await client
      .from('review_aggregates')
      .select()
      .eq('target_type', 'restaurant');
  final list =
      (rows as List).map((j) => ReviewAggregate.fromJson(j)).toList();
  return {for (final a in list) a.targetId: a};
});

/// All item aggregates for a given restaurant in one fetch.
final itemAggregatesForRestaurantProvider =
    FutureProvider.family<Map<String, ReviewAggregate>, String>(
        (ref, restaurantId) async {
  final client = ref.watch(supabaseClientProvider);
  // Pull menu_item ids for this restaurant first, then fetch aggregates.
  final menuItems = await client
      .from('menu_items')
      .select('id')
      .eq('tenant_id', restaurantId);
  final ids = (menuItems as List).map((j) => j['id'] as String).toList();
  if (ids.isEmpty) return {};
  final rows = await client
      .from('review_aggregates')
      .select()
      .eq('target_type', 'item')
      .inFilter('target_id', ids);
  final list =
      (rows as List).map((j) => ReviewAggregate.fromJson(j)).toList();
  return {for (final a in list) a.targetId: a};
});

// ============================================================================
// Reviews list for a target
// ============================================================================

final reviewsByTargetProvider =
    FutureProvider.family<List<Review>, ReviewTargetKey>((ref, key) async {
  final client = ref.watch(supabaseClientProvider);
  final rows = await client
      .from('reviews')
      .select()
      .eq('target_type', key.targetType)
      .eq('target_id', key.targetId)
      .order('created_at', ascending: false);
  return (rows as List).map((j) => Review.fromJson(j)).toList();
});

// ============================================================================
// Current customer's existing review for a target (used to prefill the form)
// ============================================================================

final myReviewForTargetProvider =
    FutureProvider.family<Review?, ReviewTargetKey>((ref, key) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  final client = ref.watch(supabaseClientProvider);
  final row = await client
      .from('reviews')
      .select()
      .eq('customer_id', userId)
      .eq('target_type', key.targetType)
      .eq('target_id', key.targetId)
      .maybeSingle();
  if (row == null) return null;
  return Review.fromJson(row);
});

// ============================================================================
// Submit (upsert) a review. Throws if RLS denies (no delivered order found).
// ============================================================================

class SubmitReviewArgs {
  final String targetType;
  final String targetId;
  final int rating;
  final String? comment;

  const SubmitReviewArgs({
    required this.targetType,
    required this.targetId,
    required this.rating,
    this.comment,
  });
}

/// Convenience helper — call `ref.read(submitReviewProvider).submit(args)`.
class SubmitReviewService {
  final Ref _ref;
  SubmitReviewService(this._ref);

  Future<void> submit(SubmitReviewArgs args) async {
    final client = _ref.read(supabaseClientProvider);
    final userId = _ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Devi essere autenticato');

    await client.from('reviews').upsert(
      {
        'customer_id': userId,
        'target_type': args.targetType,
        'target_id': args.targetId,
        'rating': args.rating,
        'comment': args.comment?.trim().isEmpty == true ? null : args.comment,
      },
      onConflict: 'customer_id,target_type,target_id',
    );

    // Invalidate the relevant caches so UIs refresh.
    final key = ReviewTargetKey(args.targetType, args.targetId);
    _ref.invalidate(reviewAggregateProvider(key));
    _ref.invalidate(reviewsByTargetProvider(key));
    _ref.invalidate(myReviewForTargetProvider(key));
    // Bulk providers used by marketplace / restaurant detail — refetch so
    // cards and headers reflect the new rating immediately.
    _ref.invalidate(allRestaurantAggregatesProvider);
    _ref.invalidate(itemAggregatesForRestaurantProvider);
  }
}

final submitReviewProvider = Provider<SubmitReviewService>((ref) {
  return SubmitReviewService(ref);
});
