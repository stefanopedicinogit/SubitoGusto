import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

enum ReviewTargetType { restaurant, item }

@freezed
class Review with _$Review {
  const Review._();

  const factory Review({
    required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'target_type') required String targetType,
    @JsonKey(name: 'target_id') required String targetId,
    required int rating,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  ReviewTargetType get targetTypeEnum => targetType == 'item'
      ? ReviewTargetType.item
      : ReviewTargetType.restaurant;
}
