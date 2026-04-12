import 'package:freezed_annotation/freezed_annotation.dart';

part 'table.freezed.dart';
part 'table.g.dart';

@freezed
class RestaurantTable with _$RestaurantTable {
  const RestaurantTable._();

  const factory RestaurantTable({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    required String name,
    @JsonKey(name: 'qr_code') required String qrCode,
    @Default(4) int capacity,
    String? zone,
    @Default('available') String status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(json);

  /// Check if table is available
  bool get isAvailable => status == 'available';

  /// Check if table is occupied
  bool get isOccupied => status == 'occupied';

  /// Check if table is reserved
  bool get isReserved => status == 'reserved';

  /// Generate QR code URL for this table
  String get qrCodeUrl => 'https://app.subitogusto.com/scan/$qrCode';
}
