// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_aggregate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewAggregate _$ReviewAggregateFromJson(Map<String, dynamic> json) {
  return _ReviewAggregate.fromJson(json);
}

/// @nodoc
mixin _$ReviewAggregate {
  @JsonKey(name: 'target_type')
  String get targetType => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_id')
  String get targetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rating')
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;

  /// Serializes this ReviewAggregate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewAggregateCopyWith<ReviewAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewAggregateCopyWith<$Res> {
  factory $ReviewAggregateCopyWith(
    ReviewAggregate value,
    $Res Function(ReviewAggregate) then,
  ) = _$ReviewAggregateCopyWithImpl<$Res, ReviewAggregate>;
  @useResult
  $Res call({
    @JsonKey(name: 'target_type') String targetType,
    @JsonKey(name: 'target_id') String targetId,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'review_count') int reviewCount,
  });
}

/// @nodoc
class _$ReviewAggregateCopyWithImpl<$Res, $Val extends ReviewAggregate>
    implements $ReviewAggregateCopyWith<$Res> {
  _$ReviewAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetType = null,
    Object? targetId = null,
    Object? avgRating = null,
    Object? reviewCount = null,
  }) {
    return _then(
      _value.copyWith(
            targetType: null == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: null == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewAggregateImplCopyWith<$Res>
    implements $ReviewAggregateCopyWith<$Res> {
  factory _$$ReviewAggregateImplCopyWith(
    _$ReviewAggregateImpl value,
    $Res Function(_$ReviewAggregateImpl) then,
  ) = __$$ReviewAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'target_type') String targetType,
    @JsonKey(name: 'target_id') String targetId,
    @JsonKey(name: 'avg_rating') double avgRating,
    @JsonKey(name: 'review_count') int reviewCount,
  });
}

/// @nodoc
class __$$ReviewAggregateImplCopyWithImpl<$Res>
    extends _$ReviewAggregateCopyWithImpl<$Res, _$ReviewAggregateImpl>
    implements _$$ReviewAggregateImplCopyWith<$Res> {
  __$$ReviewAggregateImplCopyWithImpl(
    _$ReviewAggregateImpl _value,
    $Res Function(_$ReviewAggregateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetType = null,
    Object? targetId = null,
    Object? avgRating = null,
    Object? reviewCount = null,
  }) {
    return _then(
      _$ReviewAggregateImpl(
        targetType: null == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewAggregateImpl extends _ReviewAggregate {
  const _$ReviewAggregateImpl({
    @JsonKey(name: 'target_type') required this.targetType,
    @JsonKey(name: 'target_id') required this.targetId,
    @JsonKey(name: 'avg_rating') required this.avgRating,
    @JsonKey(name: 'review_count') required this.reviewCount,
  }) : super._();

  factory _$ReviewAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewAggregateImplFromJson(json);

  @override
  @JsonKey(name: 'target_type')
  final String targetType;
  @override
  @JsonKey(name: 'target_id')
  final String targetId;
  @override
  @JsonKey(name: 'avg_rating')
  final double avgRating;
  @override
  @JsonKey(name: 'review_count')
  final int reviewCount;

  @override
  String toString() {
    return 'ReviewAggregate(targetType: $targetType, targetId: $targetId, avgRating: $avgRating, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewAggregateImpl &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetType, targetId, avgRating, reviewCount);

  /// Create a copy of ReviewAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewAggregateImplCopyWith<_$ReviewAggregateImpl> get copyWith =>
      __$$ReviewAggregateImplCopyWithImpl<_$ReviewAggregateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewAggregateImplToJson(this);
  }
}

abstract class _ReviewAggregate extends ReviewAggregate {
  const factory _ReviewAggregate({
    @JsonKey(name: 'target_type') required final String targetType,
    @JsonKey(name: 'target_id') required final String targetId,
    @JsonKey(name: 'avg_rating') required final double avgRating,
    @JsonKey(name: 'review_count') required final int reviewCount,
  }) = _$ReviewAggregateImpl;
  const _ReviewAggregate._() : super._();

  factory _ReviewAggregate.fromJson(Map<String, dynamic> json) =
      _$ReviewAggregateImpl.fromJson;

  @override
  @JsonKey(name: 'target_type')
  String get targetType;
  @override
  @JsonKey(name: 'target_id')
  String get targetId;
  @override
  @JsonKey(name: 'avg_rating')
  double get avgRating;
  @override
  @JsonKey(name: 'review_count')
  int get reviewCount;

  /// Create a copy of ReviewAggregate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewAggregateImplCopyWith<_$ReviewAggregateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
