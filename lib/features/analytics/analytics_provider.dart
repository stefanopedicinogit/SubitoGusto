import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order.dart';
import '../../data/models/order_item.dart';
import '../../data/providers/providers.dart';

/// Date range for analytics
enum AnalyticsDateRange {
  today,
  week,
  month,
  year,
}

extension AnalyticsDateRangeExtension on AnalyticsDateRange {
  String get label {
    switch (this) {
      case AnalyticsDateRange.today:
        return 'Oggi';
      case AnalyticsDateRange.week:
        return 'Settimana';
      case AnalyticsDateRange.month:
        return 'Mese';
      case AnalyticsDateRange.year:
        return 'Anno';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsDateRange.today:
        return DateTime(now.year, now.month, now.day);
      case AnalyticsDateRange.week:
        return DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
      case AnalyticsDateRange.month:
        return DateTime(now.year, now.month - 1, now.day);
      case AnalyticsDateRange.year:
        return DateTime(now.year - 1, now.month, now.day);
    }
  }
}

/// Selected date range provider
final analyticsDateRangeProvider = StateProvider<AnalyticsDateRange>((ref) {
  return AnalyticsDateRange.week;
});

/// Analytics data model
class AnalyticsData {
  final double totalRevenue;
  final double previousPeriodRevenue;
  final int totalOrders;
  final int previousPeriodOrders;
  final double averageOrderValue;
  final List<Order> orders;
  final List<OrderItem> orderItems;
  final Map<String, int> ordersByStatus;
  final Map<String, double> revenueByDay;
  final Map<int, int> ordersByHour;
  final List<TopSellingItem> topSellingItems;
  final Map<String, CategoryStats> categoryStats;

  const AnalyticsData({
    required this.totalRevenue,
    required this.previousPeriodRevenue,
    required this.totalOrders,
    required this.previousPeriodOrders,
    required this.averageOrderValue,
    required this.orders,
    required this.orderItems,
    required this.ordersByStatus,
    required this.revenueByDay,
    required this.ordersByHour,
    required this.topSellingItems,
    required this.categoryStats,
  });

  double get revenueChangePercent {
    if (previousPeriodRevenue == 0) return totalRevenue > 0 ? 100 : 0;
    return ((totalRevenue - previousPeriodRevenue) / previousPeriodRevenue) * 100;
  }

  double get ordersChangePercent {
    if (previousPeriodOrders == 0) return totalOrders > 0 ? 100 : 0;
    return ((totalOrders - previousPeriodOrders) / previousPeriodOrders) * 100;
  }
}

/// Top selling item model
class TopSellingItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double revenue;

  const TopSellingItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.revenue,
  });
}

/// Category statistics
class CategoryStats {
  final String categoryId;
  final String name;
  final int orderCount;
  final double revenue;

  const CategoryStats({
    required this.categoryId,
    required this.name,
    required this.orderCount,
    required this.revenue,
  });
}

/// Main analytics data provider
final analyticsDataProvider = FutureProvider<AnalyticsData>((ref) async {
  final dateRange = ref.watch(analyticsDateRangeProvider);
  final ordersAsync = await ref.watch(ordersProvider.future);
  final menuItemsAsync = await ref.watch(menuItemsProvider.future);
  final categoriesAsync = await ref.watch(categoriesProvider.future);

  final startDate = dateRange.startDate;
  final now = DateTime.now();

  // Filter orders for current period (only completed orders: served or paid)
  final completedStatuses = ['served', 'paid'];
  final periodOrders = ordersAsync.where((o) {
    return o.createdAt.isAfter(startDate) &&
        o.createdAt.isBefore(now) &&
        completedStatuses.contains(o.status);
  }).toList();

  // Calculate previous period for comparison
  final periodDuration = now.difference(startDate);
  final previousStart = startDate.subtract(periodDuration);
  final previousOrders = ordersAsync.where((o) {
    return o.createdAt.isAfter(previousStart) &&
        o.createdAt.isBefore(startDate) &&
        completedStatuses.contains(o.status);
  }).toList();

  // Calculate totals
  final totalRevenue = periodOrders.fold<double>(0, (sum, o) => sum + o.total);
  final previousRevenue = previousOrders.fold<double>(0, (sum, o) => sum + o.total);
  final averageOrderValue = periodOrders.isEmpty ? 0.0 : totalRevenue / periodOrders.length;

  // Orders by status (all orders, not just completed)
  final allPeriodOrders = ordersAsync.where((o) {
    return o.createdAt.isAfter(startDate) && o.createdAt.isBefore(now);
  }).toList();

  final ordersByStatus = <String, int>{};
  for (final order in allPeriodOrders) {
    ordersByStatus[order.status] = (ordersByStatus[order.status] ?? 0) + 1;
  }

  // Revenue by day
  final revenueByDay = <String, double>{};
  for (final order in periodOrders) {
    final dayKey = '${order.createdAt.day}/${order.createdAt.month}';
    revenueByDay[dayKey] = (revenueByDay[dayKey] ?? 0) + order.total;
  }

  // Orders by hour
  final ordersByHour = <int, int>{};
  for (final order in periodOrders) {
    final hour = order.createdAt.hour;
    ordersByHour[hour] = (ordersByHour[hour] ?? 0) + 1;
  }

  // Get all order items for the period
  final orderItemRepo = ref.read(orderItemRepositoryProvider);
  final allOrderItems = <OrderItem>[];
  for (final order in periodOrders) {
    final items = await orderItemRepo.query(equals: {'order_id': order.id});
    allOrderItems.addAll(items);
  }

  // Top selling items
  final itemSales = <String, TopSellingItem>{};
  for (final item in allOrderItems) {
    final existing = itemSales[item.menuItemId];
    if (existing != null) {
      itemSales[item.menuItemId] = TopSellingItem(
        menuItemId: item.menuItemId,
        name: item.menuItemName,
        quantity: existing.quantity + item.quantity,
        revenue: existing.revenue + (item.unitPrice * item.quantity),
      );
    } else {
      itemSales[item.menuItemId] = TopSellingItem(
        menuItemId: item.menuItemId,
        name: item.menuItemName,
        quantity: item.quantity,
        revenue: item.unitPrice * item.quantity,
      );
    }
  }
  final topSelling = itemSales.values.toList()
    ..sort((a, b) => b.quantity.compareTo(a.quantity));

  // Category stats
  final categoryStatsMap = <String, CategoryStats>{};
  final menuItemsMap = {for (final m in menuItemsAsync) m.id: m};
  final categoriesMap = {for (final c in categoriesAsync) c.id: c};

  for (final item in allOrderItems) {
    final menuItem = menuItemsMap[item.menuItemId];
    if (menuItem == null) continue;

    final category = categoriesMap[menuItem.categoryId];
    if (category == null) continue;

    final existing = categoryStatsMap[category.id];
    if (existing != null) {
      categoryStatsMap[category.id] = CategoryStats(
        categoryId: category.id,
        name: category.name,
        orderCount: existing.orderCount + item.quantity,
        revenue: existing.revenue + (item.unitPrice * item.quantity),
      );
    } else {
      categoryStatsMap[category.id] = CategoryStats(
        categoryId: category.id,
        name: category.name,
        orderCount: item.quantity,
        revenue: item.unitPrice * item.quantity,
      );
    }
  }

  return AnalyticsData(
    totalRevenue: totalRevenue,
    previousPeriodRevenue: previousRevenue,
    totalOrders: periodOrders.length,
    previousPeriodOrders: previousOrders.length,
    averageOrderValue: averageOrderValue,
    orders: periodOrders,
    orderItems: allOrderItems,
    ordersByStatus: ordersByStatus,
    revenueByDay: revenueByDay,
    ordersByHour: ordersByHour,
    topSellingItems: topSelling.take(10).toList(),
    categoryStats: categoryStatsMap,
  );
});
