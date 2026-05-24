import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_aggregate.freezed.dart';
part 'review_aggregate.g.dart';

/// Aggregated rating summary from the `review_aggregates` view.
/// Postgres `numeric` comes over PostgREST as a JSON number, so plain double
/// decoding works without a custom converter.
@freezed
class ReviewAggregate with _$ReviewAggregate {
  const ReviewAggregate._();

  const factory ReviewAggregate({
    @JsonKey(name: 'target_type') required String targetType,
    @JsonKey(name: 'target_id') required String targetId,
    @JsonKey(name: 'avg_rating') required double avgRating,
    @JsonKey(name: 'review_count') required int reviewCount,
  }) = _ReviewAggregate;

  factory ReviewAggregate.fromJson(Map<String, dynamic> json) =>
      _$ReviewAggregateFromJson(json);

  /// Display string like "4.5" or "—" if no reviews.
  String get displayRating =>
      reviewCount == 0 ? '—' : avgRating.toStringAsFixed(1);
}
