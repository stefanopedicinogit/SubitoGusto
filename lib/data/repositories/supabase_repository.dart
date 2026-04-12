import 'package:supabase_flutter/supabase_flutter.dart';

/// Generic repository for Supabase CRUD operations
class SupabaseRepository<T> {
  final SupabaseClient _client;
  final String tableName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final String? Function()? getCurrentTenantId;

  SupabaseRepository({
    required SupabaseClient client,
    required this.tableName,
    required this.fromJson,
    required this.toJson,
    this.getCurrentTenantId,
  }) : _client = client;

  /// Get all records with optional ordering and limit
  Future<List<T>> getAll({
    String? orderBy,
    bool ascending = true,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    var query = _client.from(tableName).select();

    // Apply tenant filter if available
    final tenantId = getCurrentTenantId?.call();
    if (tenantId != null) {
      query = query.eq('tenant_id', tenantId);
    }

    // Apply additional filters
    if (filters != null) {
      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }

    // Build final query with transforms
    final response = await _applyTransforms(
      query,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
    );

    return (response as List).map((json) => fromJson(json)).toList();
  }

  /// Apply ordering and limit transforms
  Future<dynamic> _applyTransforms(
    dynamic query, {
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    dynamic result = query;

    if (orderBy != null) {
      result = result.order(orderBy, ascending: ascending);
    }

    if (limit != null && offset != null) {
      result = result.range(offset, offset + limit - 1);
    } else if (limit != null) {
      result = result.limit(limit);
    }

    return await result;
  }

  /// Get a single record by ID
  Future<T?> getById(String id) async {
    final response =
        await _client.from(tableName).select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return fromJson(response);
  }

  /// Insert a new record
  Future<T> insert(T item) async {
    final data = toJson(item);

    // Remove id if it's null or empty for auto-generation
    if (data['id'] == null || data['id'] == '') {
      data.remove('id');
    }

    // Add tenant ID if available (also handles empty string)
    final tenantId = getCurrentTenantId?.call();
    final currentTenantId = data['tenant_id'];
    if (tenantId != null && (currentTenantId == null || currentTenantId == '')) {
      data['tenant_id'] = tenantId;
    }

    final response =
        await _client.from(tableName).insert(data).select().single();

    return fromJson(response);
  }

  /// Update an existing record
  Future<T> update(String id, T item) async {
    final data = toJson(item);
    data['updated_at'] = DateTime.now().toIso8601String();

    final response = await _client
        .from(tableName)
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return fromJson(response);
  }

  /// Delete a record by ID
  Future<void> delete(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }

  /// Upsert a record (insert or update)
  Future<T> upsert(T item, {String? onConflict}) async {
    final data = toJson(item);

    final tenantId = getCurrentTenantId?.call();
    if (tenantId != null && !data.containsKey('tenant_id')) {
      data['tenant_id'] = tenantId;
    }

    final response = await _client
        .from(tableName)
        .upsert(data, onConflict: onConflict)
        .select()
        .single();

    return fromJson(response);
  }

  /// Query records with custom filters
  Future<List<T>> query({
    Map<String, dynamic>? equals,
    Map<String, dynamic>? notEquals,
    Map<String, List<dynamic>>? inList,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from(tableName).select();

    // Apply tenant filter
    final tenantId = getCurrentTenantId?.call();
    if (tenantId != null) {
      query = query.eq('tenant_id', tenantId);
    }

    // Apply equals filters
    if (equals != null) {
      for (final entry in equals.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }

    // Apply not equals filters
    if (notEquals != null) {
      for (final entry in notEquals.entries) {
        query = query.neq(entry.key, entry.value);
      }
    }

    // Apply in list filters
    if (inList != null) {
      for (final entry in inList.entries) {
        query = query.inFilter(entry.key, entry.value);
      }
    }

    // Build final query with transforms
    final response = await _applyTransforms(
      query,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
      offset: offset,
    );

    return (response as List).map((json) => fromJson(json)).toList();
  }

  /// Search records by text in a specific column
  Future<List<T>> search({
    required String column,
    required String searchTerm,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    var query = _client.from(tableName).select().ilike(column, '%$searchTerm%');

    // Apply tenant filter
    final tenantId = getCurrentTenantId?.call();
    if (tenantId != null) {
      query = query.eq('tenant_id', tenantId);
    }

    final response = await _applyTransforms(
      query,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
    );

    return (response as List).map((json) => fromJson(json)).toList();
  }

  /// Count records with optional filters
  Future<int> count({Map<String, dynamic>? filters}) async {
    var query = _client.from(tableName).select();

    // Apply tenant filter
    final tenantId = getCurrentTenantId?.call();
    if (tenantId != null) {
      query = query.eq('tenant_id', tenantId);
    }

    if (filters != null) {
      for (final entry in filters.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }

    final response = await query.count(CountOption.exact);
    return response.count;
  }

  /// Watch all records in realtime
  Stream<List<T>> watchAll({String? orderBy, bool ascending = true}) {
    return _client
        .from(tableName)
        .stream(primaryKey: ['id'])
        .order(orderBy ?? 'created_at', ascending: ascending)
        .map((data) => data.map((json) => fromJson(json)).toList());
  }

  /// Watch a single record by ID
  Stream<T?> watchById(String id) {
    return _client
        .from(tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => data.isEmpty ? null : fromJson(data.first));
  }

  /// Insert multiple records
  Future<List<T>> insertMany(List<T> items) async {
    final tenantId = getCurrentTenantId?.call();

    final dataList = items.map((item) {
      final data = toJson(item);
      if (tenantId != null && !data.containsKey('tenant_id')) {
        data['tenant_id'] = tenantId;
      }
      if (data['id'] == null || data['id'] == '') {
        data.remove('id');
      }
      return data;
    }).toList();

    final response =
        await _client.from(tableName).insert(dataList).select();

    return (response as List).map((json) => fromJson(json)).toList();
  }

  /// Delete multiple records by IDs
  Future<void> deleteMany(List<String> ids) async {
    await _client.from(tableName).delete().inFilter('id', ids);
  }
}
