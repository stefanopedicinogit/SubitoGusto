import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'analytics_provider.dart';

/// Analytics Dashboard Page (mobile)
///
/// Vertical, single-column layout: horizontally scrollable date chips at the
/// top, a 2x2 KPI grid, then each chart stacked full-width below.
class AnalyticsPageMobile extends ConsumerWidget {
  const AnalyticsPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(analyticsDateRangeProvider);
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _DateRangeSelectorMobile(selectedRange: dateRange),
          Expanded(
            child: analyticsAsync.when(
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(analyticsDataProvider),
                child: _AnalyticsContentMobile(data: data),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text('Errore: $e', textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(analyticsDataProvider),
                        child: const Text('Riprova'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrollable chips + trailing refresh button. The desktop version
/// is a Row with a Spacer, which overflows on phones.
class _DateRangeSelectorMobile extends ConsumerWidget {
  final AnalyticsDateRange selectedRange;

  const _DateRangeSelectorMobile({required this.selectedRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AnalyticsDateRange.values.map((range) {
                  final isSelected = range == selectedRange;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(range.label(context)),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(analyticsDateRangeProvider.notifier).state =
                            range;
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            onPressed: () => ref.invalidate(analyticsDataProvider),
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context).analyticsRefresh,
          ),
        ],
      ),
    );
  }
}

/// Stacks every section vertically; each card sets its own height.
class _AnalyticsContentMobile extends StatelessWidget {
  final AnalyticsData data;

  const _AnalyticsContentMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KPIGridMobile(data: data),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 260, child: _RevenueChartMobile(data: data)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 320, child: _OrdersByStatusCardMobile(data: data)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 360, child: _TopSellingCardMobile(data: data)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 260, child: _PeakHoursCardMobile(data: data)),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
              height: 340, child: _CategoryPerformanceCardMobile(data: data)),
        ],
      ),
    );
  }
}

/// 2x2 grid replacing the desktop 4-card Row.
class _KPIGridMobile extends StatelessWidget {
  final AnalyticsData data;

  const _KPIGridMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');
    final l = AppLocalizations.of(context);

    final cards = <Widget>[
      _KPICardMobile(
        title: l.analyticsTotalRevenue,
        value: currencyFormat.format(data.totalRevenue),
        changePercent: data.revenueChangePercent,
        icon: Icons.euro,
        color: AppColors.success,
      ),
      _KPICardMobile(
        title: l.analyticsCompletedOrders,
        value: data.totalOrders.toString(),
        changePercent: data.ordersChangePercent,
        icon: Icons.receipt_long,
        color: Theme.of(context).colorScheme.primary,
      ),
      _KPICardMobile(
        title: l.analyticsAvgTicket,
        value: currencyFormat.format(data.averageOrderValue),
        icon: Icons.trending_up,
        color: AppColors.gold,
      ),
      _KPICardMobile(
        title: l.analyticsItemsSold,
        value: data.orderItems
            .fold<int>(0, (sum, i) => sum + i.quantity)
            .toString(),
        icon: Icons.restaurant,
        color: AppColors.statusPreparing,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.15,
      children: cards,
    );
  }
}

class _KPICardMobile extends StatelessWidget {
  final String title;
  final String value;
  final double? changePercent;
  final IconData icon;
  final Color color;

  const _KPICardMobile({
    required this.title,
    required this.value,
    this.changePercent,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = (changePercent ?? 0) >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                if (changePercent != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositive ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 10,
                          color:
                              isPositive ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${changePercent!.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Revenue chart for mobile. When many days are in range, allows horizontal
/// scroll so individual bars stay readable instead of getting squashed.
class _RevenueChartMobile extends StatelessWidget {
  final AnalyticsData data;

  const _RevenueChartMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    final sortedDays = data.revenueByDay.keys.toList()
      ..sort((a, b) {
        final partsA = a.split('/').map(int.parse).toList();
        final partsB = b.split('/').map(int.parse).toList();
        if (partsA[1] != partsB[1]) return partsA[1].compareTo(partsB[1]);
        return partsA[0].compareTo(partsB[0]);
      });

    final maxRevenue = data.revenueByDay.values.isEmpty
        ? 100.0
        : data.revenueByDay.values.reduce((a, b) => a > b ? a : b);

    // Each bar gets ~40px so the chart scrolls when the date range exceeds
    // what fits in screen width.
    final barSlotWidth = 40.0;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final chartWidth = (sortedDays.length * barSlotWidth)
        .clamp(screenWidth - AppSpacing.lg * 2, double.infinity);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).analyticsRevenueTrend,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text('Ricavi', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: sortedDays.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun dato disponibile',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: sortedDays.map((day) {
                            final revenue = data.revenueByDay[day] ?? 0;
                            final heightPercent =
                                maxRevenue > 0 ? revenue / maxRevenue : 0;

                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '€${revenue.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Flexible(
                                      child: FractionallySizedBox(
                                        heightFactor: heightPercent
                                            .clamp(0.05, 1.0)
                                            .toDouble(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                AppColors.success,
                                                AppColors.success
                                                    .withValues(alpha: 0.6),
                                              ],
                                            ),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      day,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersByStatusCardMobile extends StatelessWidget {
  final AnalyticsData data;

  const _OrdersByStatusCardMobile({required this.data});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'preparing':
        return AppColors.statusPreparing;
      case 'ready':
        return AppColors.statusReady;
      case 'served':
        return AppColors.statusServed;
      case 'paid':
        return AppColors.statusPaid;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'In attesa';
      case 'confirmed':
        return 'Confermati';
      case 'preparing':
        return 'In preparazione';
      case 'ready':
        return 'Pronti';
      case 'served':
        return 'Serviti';
      case 'paid':
        return 'Pagati';
      case 'cancelled':
        return 'Annullati';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = data.ordersByStatus.values.fold<int>(0, (sum, v) => sum + v);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).analyticsOrdersByStatus,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: data.ordersByStatus.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun ordine',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView(
                      children: data.ordersByStatus.entries.map((entry) {
                        final percent = total > 0 ? entry.value / total : 0.0;
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(entry.key),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      _getStatusLabel(entry.key),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percent,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation(
                                  _getStatusColor(entry.key),
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSellingCardMobile extends StatelessWidget {
  final AnalyticsData data;

  const _TopSellingCardMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).analyticsTopItems,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.emoji_events,
                    color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: data.topSellingItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun dato',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: data.topSellingItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = data.topSellingItems[index];
                        final isTop3 = index < 3;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: isTop3
                                ? [
                                    AppColors.gold,
                                    Colors.grey.shade400,
                                    Colors.brown.shade300,
                                  ][index]
                                : Colors.grey.shade200,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:
                                    isTop3 ? Colors.white : AppColors.charcoal,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${item.quantity} venduti',
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: Text(
                            currencyFormat.format(item.revenue),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeakHoursCardMobile extends StatelessWidget {
  final AnalyticsData data;

  const _PeakHoursCardMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(13, (i) => i + 11);
    final maxOrders = data.ordersByHour.values.isEmpty
        ? 1
        : data.ordersByHour.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).analyticsPeakHours,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(Icons.access_time,
                    color: Theme.of(context).colorScheme.primary, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: hours.map((hour) {
                  final orders = data.ordersByHour[hour] ?? 0;
                  final heightPercent =
                      maxOrders > 0 ? orders / maxOrders : 0;
                  final isHot = orders == maxOrders && orders > 0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (orders > 0)
                            Text(
                              '$orders',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isHot ? AppColors.error : null,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Flexible(
                            child: FractionallySizedBox(
                              heightFactor:
                                  heightPercent.clamp(0.05, 1.0).toDouble(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isHot
                                      ? AppColors.error
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.7),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$hour',
                            style: TextStyle(
                              fontSize: 9,
                              color: isHot
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                              fontWeight:
                                  isHot ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPerformanceCardMobile extends StatelessWidget {
  final AnalyticsData data;

  const _CategoryPerformanceCardMobile({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');
    final categories = data.categoryStats.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final totalRevenue =
        categories.fold<double>(0, (sum, c) => sum + c.revenue);

    final colors = [
      Theme.of(context).colorScheme.primary,
      AppColors.gold,
      AppColors.success,
      AppColors.statusConfirmed,
      AppColors.statusPreparing,
      AppColors.statusPending,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).analyticsByCategory,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.pie_chart, color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: categories.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun dato',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final percent =
                            totalRevenue > 0 ? cat.revenue / totalRevenue : 0.0;
                        final color = colors[index % colors.length];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    cat.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(cat.revenue),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation(color),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${(percent * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
