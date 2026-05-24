// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Tenant _$TenantFromJson(Map<String, dynamic> json) {
  return _Tenant.fromJson(json);
}

/// @nodoc
mixin _$Tenant {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_hours')
  Map<String, dynamic>? get openingHours => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings =>
      throw _privateConstructorUsedError; // Delivery settings
  @JsonKey(name: 'delivery_enabled')
  bool get deliveryEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee')
  double get deliveryFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_radius_km')
  double get deliveryRadiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_min_order')
  double get deliveryMinOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_estimated_time_min')
  int get deliveryEstimatedTimeMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'vacation_mode')
  bool get vacationMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'stripe_account_id')
  String? get stripeAccountId => throw _privateConstructorUsedError; // Discovery metadata (Phase 10)
  @JsonKey(name: 'cuisine_type')
  String? get cuisineType => throw _privateConstructorUsedError;
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Tenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantCopyWith<Tenant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantCopyWith<$Res> {
  factory $TenantCopyWith(Tenant value, $Res Function(Tenant) then) =
      _$TenantCopyWithImpl<$Res, Tenant>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    @JsonKey(name: 'opening_hours') Map<String, dynamic>? openingHours,
    Map<String, dynamic>? settings,
    @JsonKey(name: 'delivery_enabled') bool deliveryEnabled,
    @JsonKey(name: 'delivery_fee') double deliveryFee,
    @JsonKey(name: 'delivery_radius_km') double deliveryRadiusKm,
    @JsonKey(name: 'delivery_min_order') double deliveryMinOrder,
    @JsonKey(name: 'delivery_estimated_time_min') int deliveryEstimatedTimeMin,
    @JsonKey(name: 'vacation_mode') bool vacationMode,
    @JsonKey(name: 'stripe_account_id') String? stripeAccountId,
    @JsonKey(name: 'cuisine_type') String? cuisineType,
    @JsonKey(name: 'dietary_tags') List<String> dietaryTags,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$TenantCopyWithImpl<$Res, $Val extends Tenant>
    implements $TenantCopyWith<$Res> {
  _$TenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? openingHours = freezed,
    Object? settings = freezed,
    Object? deliveryEnabled = null,
    Object? deliveryFee = null,
    Object? deliveryRadiusKm = null,
    Object? deliveryMinOrder = null,
    Object? deliveryEstimatedTimeMin = null,
    Object? vacationMode = null,
    Object? stripeAccountId = freezed,
    Object? cuisineType = freezed,
    Object? dietaryTags = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverImageUrl: freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            openingHours: freezed == openingHours
                ? _value.openingHours
                : openingHours // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            deliveryEnabled: null == deliveryEnabled
                ? _value.deliveryEnabled
                : deliveryEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryRadiusKm: null == deliveryRadiusKm
                ? _value.deliveryRadiusKm
                : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryMinOrder: null == deliveryMinOrder
                ? _value.deliveryMinOrder
                : deliveryMinOrder // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryEstimatedTimeMin: null == deliveryEstimatedTimeMin
                ? _value.deliveryEstimatedTimeMin
                : deliveryEstimatedTimeMin // ignore: cast_nullable_to_non_nullable
                      as int,
            vacationMode: null == vacationMode
                ? _value.vacationMode
                : vacationMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            stripeAccountId: freezed == stripeAccountId
                ? _value.stripeAccountId
                : stripeAccountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cuisineType: freezed == cuisineType
                ? _value.cuisineType
                : cuisineType // ignore: cast_nullable_to_non_nullable
                      as String?,
            dietaryTags: null == dietaryTags
                ? _value.dietaryTags
                : dietaryTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantImplCopyWith<$Res> implements $TenantCopyWith<$Res> {
  factory _$$TenantImplCopyWith(
    _$TenantImpl value,
    $Res Function(_$TenantImpl) then,
  ) = __$$TenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    @JsonKey(name: 'opening_hours') Map<String, dynamic>? openingHours,
    Map<String, dynamic>? settings,
    @JsonKey(name: 'delivery_enabled') bool deliveryEnabled,
    @JsonKey(name: 'delivery_fee') double deliveryFee,
    @JsonKey(name: 'delivery_radius_km') double deliveryRadiusKm,
    @JsonKey(name: 'delivery_min_order') double deliveryMinOrder,
    @JsonKey(name: 'delivery_estimated_time_min') int deliveryEstimatedTimeMin,
    @JsonKey(name: 'vacation_mode') bool vacationMode,
    @JsonKey(name: 'stripe_account_id') String? stripeAccountId,
    @JsonKey(name: 'cuisine_type') String? cuisineType,
    @JsonKey(name: 'dietary_tags') List<String> dietaryTags,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TenantImplCopyWithImpl<$Res>
    extends _$TenantCopyWithImpl<$Res, _$TenantImpl>
    implements _$$TenantImplCopyWith<$Res> {
  __$$TenantImplCopyWithImpl(
    _$TenantImpl _value,
    $Res Function(_$TenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? openingHours = freezed,
    Object? settings = freezed,
    Object? deliveryEnabled = null,
    Object? deliveryFee = null,
    Object? deliveryRadiusKm = null,
    Object? deliveryMinOrder = null,
    Object? deliveryEstimatedTimeMin = null,
    Object? vacationMode = null,
    Object? stripeAccountId = freezed,
    Object? cuisineType = freezed,
    Object? dietaryTags = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$TenantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverImageUrl: freezed == coverImageUrl
            ? _value.coverImageUrl
            : coverImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        openingHours: freezed == openingHours
            ? _value._openingHours
            : openingHours // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        settings: freezed == settings
            ? _value._settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        deliveryEnabled: null == deliveryEnabled
            ? _value.deliveryEnabled
            : deliveryEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryRadiusKm: null == deliveryRadiusKm
            ? _value.deliveryRadiusKm
            : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryMinOrder: null == deliveryMinOrder
            ? _value.deliveryMinOrder
            : deliveryMinOrder // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryEstimatedTimeMin: null == deliveryEstimatedTimeMin
            ? _value.deliveryEstimatedTimeMin
            : deliveryEstimatedTimeMin // ignore: cast_nullable_to_non_nullable
                  as int,
        vacationMode: null == vacationMode
            ? _value.vacationMode
            : vacationMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        stripeAccountId: freezed == stripeAccountId
            ? _value.stripeAccountId
            : stripeAccountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cuisineType: freezed == cuisineType
            ? _value.cuisineType
            : cuisineType // ignore: cast_nullable_to_non_nullable
                  as String?,
        dietaryTags: null == dietaryTags
            ? _value._dietaryTags
            : dietaryTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantImpl extends _Tenant {
  const _$TenantImpl({
    required this.id,
    required this.name,
    this.description,
    @JsonKey(name: 'logo_url') this.logoUrl,
    @JsonKey(name: 'cover_image_url') this.coverImageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    @JsonKey(name: 'opening_hours') final Map<String, dynamic>? openingHours,
    final Map<String, dynamic>? settings,
    @JsonKey(name: 'delivery_enabled') this.deliveryEnabled = false,
    @JsonKey(name: 'delivery_fee') this.deliveryFee = 0,
    @JsonKey(name: 'delivery_radius_km') this.deliveryRadiusKm = 5.0,
    @JsonKey(name: 'delivery_min_order') this.deliveryMinOrder = 0,
    @JsonKey(name: 'delivery_estimated_time_min')
    this.deliveryEstimatedTimeMin = 45,
    @JsonKey(name: 'vacation_mode') this.vacationMode = false,
    @JsonKey(name: 'stripe_account_id') this.stripeAccountId,
    @JsonKey(name: 'cuisine_type') this.cuisineType,
    @JsonKey(name: 'dietary_tags')
    final List<String> dietaryTags = const <String>[],
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _openingHours = openingHours,
       _settings = settings,
       _dietaryTags = dietaryTags,
       super._();

  factory _$TenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? phone;
  @override
  final String? email;
  final Map<String, dynamic>? _openingHours;
  @override
  @JsonKey(name: 'opening_hours')
  Map<String, dynamic>? get openingHours {
    final value = _openingHours;
    if (value == null) return null;
    if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Delivery settings
  @override
  @JsonKey(name: 'delivery_enabled')
  final bool deliveryEnabled;
  @override
  @JsonKey(name: 'delivery_fee')
  final double deliveryFee;
  @override
  @JsonKey(name: 'delivery_radius_km')
  final double deliveryRadiusKm;
  @override
  @JsonKey(name: 'delivery_min_order')
  final double deliveryMinOrder;
  @override
  @JsonKey(name: 'delivery_estimated_time_min')
  final int deliveryEstimatedTimeMin;
  @override
  @JsonKey(name: 'vacation_mode')
  final bool vacationMode;
  @override
  @JsonKey(name: 'stripe_account_id')
  final String? stripeAccountId;
  // Discovery metadata (Phase 10)
  @override
  @JsonKey(name: 'cuisine_type')
  final String? cuisineType;
  final List<String> _dietaryTags;
  @override
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags {
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryTags);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Tenant(id: $id, name: $name, description: $description, logoUrl: $logoUrl, coverImageUrl: $coverImageUrl, address: $address, latitude: $latitude, longitude: $longitude, phone: $phone, email: $email, openingHours: $openingHours, settings: $settings, deliveryEnabled: $deliveryEnabled, deliveryFee: $deliveryFee, deliveryRadiusKm: $deliveryRadiusKm, deliveryMinOrder: $deliveryMinOrder, deliveryEstimatedTimeMin: $deliveryEstimatedTimeMin, vacationMode: $vacationMode, stripeAccountId: $stripeAccountId, cuisineType: $cuisineType, dietaryTags: $dietaryTags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._openingHours,
              _openingHours,
            ) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.deliveryEnabled, deliveryEnabled) ||
                other.deliveryEnabled == deliveryEnabled) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.deliveryRadiusKm, deliveryRadiusKm) ||
                other.deliveryRadiusKm == deliveryRadiusKm) &&
            (identical(other.deliveryMinOrder, deliveryMinOrder) ||
                other.deliveryMinOrder == deliveryMinOrder) &&
            (identical(
                  other.deliveryEstimatedTimeMin,
                  deliveryEstimatedTimeMin,
                ) ||
                other.deliveryEstimatedTimeMin == deliveryEstimatedTimeMin) &&
            (identical(other.vacationMode, vacationMode) ||
                other.vacationMode == vacationMode) &&
            (identical(other.stripeAccountId, stripeAccountId) ||
                other.stripeAccountId == stripeAccountId) &&
            (identical(other.cuisineType, cuisineType) ||
                other.cuisineType == cuisineType) &&
            const DeepCollectionEquality().equals(
              other._dietaryTags,
              _dietaryTags,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    logoUrl,
    coverImageUrl,
    address,
    latitude,
    longitude,
    phone,
    email,
    const DeepCollectionEquality().hash(_openingHours),
    const DeepCollectionEquality().hash(_settings),
    deliveryEnabled,
    deliveryFee,
    deliveryRadiusKm,
    deliveryMinOrder,
    deliveryEstimatedTimeMin,
    vacationMode,
    stripeAccountId,
    cuisineType,
    const DeepCollectionEquality().hash(_dietaryTags),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      __$$TenantImplCopyWithImpl<_$TenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantImplToJson(this);
  }
}

abstract class _Tenant extends Tenant {
  const factory _Tenant({
    required final String id,
    required final String name,
    final String? description,
    @JsonKey(name: 'logo_url') final String? logoUrl,
    @JsonKey(name: 'cover_image_url') final String? coverImageUrl,
    final String? address,
    final double? latitude,
    final double? longitude,
    final String? phone,
    final String? email,
    @JsonKey(name: 'opening_hours') final Map<String, dynamic>? openingHours,
    final Map<String, dynamic>? settings,
    @JsonKey(name: 'delivery_enabled') final bool deliveryEnabled,
    @JsonKey(name: 'delivery_fee') final double deliveryFee,
    @JsonKey(name: 'delivery_radius_km') final double deliveryRadiusKm,
    @JsonKey(name: 'delivery_min_order') final double deliveryMinOrder,
    @JsonKey(name: 'delivery_estimated_time_min')
    final int deliveryEstimatedTimeMin,
    @JsonKey(name: 'vacation_mode') final bool vacationMode,
    @JsonKey(name: 'stripe_account_id') final String? stripeAccountId,
    @JsonKey(name: 'cuisine_type') final String? cuisineType,
    @JsonKey(name: 'dietary_tags') final List<String> dietaryTags,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$TenantImpl;
  const _Tenant._() : super._();

  factory _Tenant.fromJson(Map<String, dynamic> json) = _$TenantImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  @JsonKey(name: 'opening_hours')
  Map<String, dynamic>? get openingHours;
  @override
  Map<String, dynamic>? get settings; // Delivery settings
  @override
  @JsonKey(name: 'delivery_enabled')
  bool get deliveryEnabled;
  @override
  @JsonKey(name: 'delivery_fee')
  double get deliveryFee;
  @override
  @JsonKey(name: 'delivery_radius_km')
  double get deliveryRadiusKm;
  @override
  @JsonKey(name: 'delivery_min_order')
  double get deliveryMinOrder;
  @override
  @JsonKey(name: 'delivery_estimated_time_min')
  int get deliveryEstimatedTimeMin;
  @override
  @JsonKey(name: 'vacation_mode')
  bool get vacationMode;
  @override
  @JsonKey(name: 'stripe_account_id')
  String? get stripeAccountId; // Discovery metadata (Phase 10)
  @override
  @JsonKey(name: 'cuisine_type')
  String? get cuisineType;
  @override
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
