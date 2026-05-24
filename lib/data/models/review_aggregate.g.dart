// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_aggregate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewAggregateImpl _$$ReviewAggregateImplFromJson(
  Map<String, dynamic> json,
) => _$ReviewAggregateImpl(
  targetType: json['target_type'] as String,
  targetId: json['target_id'] as String,
  avgRating: (json['avg_rating'] as num).toDouble(),
  reviewCount: (json['review_count'] as num).toInt(),
);

Map<String, dynamic> _$$ReviewAggregateImplToJson(
  _$ReviewAggregateImpl instance,
) => <String, dynamic>{
  'target_type': instance.targetType,
  'target_id': instance.targetId,
  'avg_rating': instance.avgRating,
  'review_count': instance.reviewCount,
};
