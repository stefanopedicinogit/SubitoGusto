// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'waiter',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'email': instance.email,
      'role': instance.role,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
    };
