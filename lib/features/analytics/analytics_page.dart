import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import 'analytics_provider.dart';

/// Analytics Dashboard Page
class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(analyticsDateRangeProvider);
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Date range selector
          _DateRangeSelector(selectedRange: dateRange),
          // Content
          Expanded(
            child: analyticsAsync.when(
              data: (data) => _AnalyticsContent(data: data),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text('Errore: $e'),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(analyticsDataProvider),
                      child: const Text('Riprova'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date range selector
class _DateRangeSelector extends ConsumerWidget {
  final AnalyticsDateRange selectedRange;

  const _DateRangeSelector({required this.selectedRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Periodo:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: AppSpacing.md),
          ...AnalyticsDateRange.values.map((range) {
            final isSelected = range == selectedRange;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(range.label),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(analyticsDateRangeProvider.notifier).state = range;
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }),
          const Spacer(),
          IconButton(
            onPressed: () => ref.invalidate(analyticsDataProvider),
            icon: const Icon(Icons.refresh),
            tooltip: 'Aggiorna dati',
          ),
        ],
      ),
    );
  }
}

/// Main analytics content
class _AnalyticsContent extends StatelessWidget {
  final AnalyticsData data;

  const _AnalyticsContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards Row
          _KPICardsRow(data: data),
          const SizedBox(height: AppSpacing.lg),
          // Charts Row
          SizedBox(
            height: 320,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Revenue Chart
                Expanded(
                  flex: 2,
                  child: _RevenueChart(data: data),
                ),
                const SizedBox(width: AppSpacing.md),
                // Orders by Status
                Expanded(
                  child: _OrdersByStatusCard(data: data),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Bottom Row
          SizedBox(
            height: 380,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Selling Items
                Expanded(
                  child: _TopSellingCard(data: data),
                ),
                const SizedBox(width: AppSpacing.md),
                // Peak Hours
                Expanded(
                  child: _PeakHoursCard(data: data),
                ),
                const SizedBox(width: AppSpacing.md),
                // Category Performance
                Expanded(
                  child: _CategoryPerformanceCard(data: data),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// KPI Cards Row
class _KPICardsRow extends StatelessWidget {
  final AnalyticsData data;

  const _KPICardsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return Row(
      children: [
        Expanded(
          child: _KPICard(
            title: 'Ricavi Totali',
            value: currencyFormat.format(data.totalRevenue),
            changePercent: data.revenueChangePercent,
            icon: Icons.euro,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _KPICard(
            title: 'Ordini Completati',
            value: data.totalOrders.toString(),
            changePercent: data.ordersChangePercent,
            icon: Icons.receipt_long,
            color: AppColors.burgundy,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _KPICard(
            title: 'Scontrino Medio',
            value: currencyFormat.format(data.averageOrderValue),
            icon: Icons.trending_up,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _KPICard(
            title: 'Piatti Venduti',
            value: data.orderItems.fold<int>(0, (sum, i) => sum + i.quantity).toString(),
            icon: Icons.restaurant,
            color: AppColors.statusPreparing,
          ),
        ),
      ],
    );
  }
}

/// Single KPI Card
class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final double? changePercent;
  final IconData icon;
  final Color color;

  const _KPICard({
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                if (changePercent != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
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
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: isPositive ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${changePercent!.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isPositive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Revenue Chart Card
class _RevenueChart extends StatelessWidget {
  final AnalyticsData data;

  const _RevenueChart({required this.data});

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Andamento Ricavi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
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
                      const Text(
                        'Ricavi',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: sortedDays.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessun dato disponibile',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: sortedDays.map((day) {
                        final revenue = data.revenueByDay[day] ?? 0;
                        final heightPercent = maxRevenue > 0 ? revenue / maxRevenue : 0;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '€${revenue.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Flexible(
                                  child: FractionallySizedBox(
                                    heightFactor: heightPercent.clamp(0.05, 1.0).toDouble(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppColors.success,
                                            AppColors.success.withValues(alpha: 0.6),
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.vertical(
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
                                    fontSize: 10,
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
          ],
        ),
      ),
    );
  }
}

/// Orders by Status Card
class _OrdersByStatusCard extends StatelessWidget {
  final AnalyticsData data;

  const _OrdersByStatusCard({required this.data});

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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordini per Stato',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
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
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
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

/// Top Selling Items Card
class _TopSellingCard extends StatelessWidget {
  final AnalyticsData data;

  const _TopSellingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Piatti Più Venduti',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.emoji_events, color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
                          leading: CircleAvatar(
                            radius: 16,
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isTop3 ? Colors.white : AppColors.charcoal,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${item.quantity} venduti',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            currencyFormat.format(item.revenue),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
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

/// Peak Hours Card
class _PeakHoursCard extends StatelessWidget {
  final AnalyticsData data;

  const _PeakHoursCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // Restaurant hours typically 11-23
    final hours = List.generate(13, (i) => i + 11);
    final maxOrders = data.ordersByHour.values.isEmpty
        ? 1
        : data.ordersByHour.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Ore di Punta',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.access_time, color: AppColors.burgundy, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: hours.map((hour) {
                  final orders = data.ordersByHour[hour] ?? 0;
                  final heightPercent = maxOrders > 0 ? orders / maxOrders : 0;
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
                              heightFactor: heightPercent.clamp(0.05, 1.0).toDouble(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isHot
                                      ? AppColors.error
                                      : AppColors.burgundy.withValues(alpha: 0.7),
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
                              color: isHot ? AppColors.error : AppColors.textSecondary,
                              fontWeight: isHot ? FontWeight.bold : FontWeight.normal,
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

/// Category Performance Card
class _CategoryPerformanceCard extends StatelessWidget {
  final AnalyticsData data;

  const _CategoryPerformanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');
    final categories = data.categoryStats.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final totalRevenue = categories.fold<double>(0, (sum, c) => sum + c.revenue);

    // Colors for pie chart segments
    final colors = [
      AppColors.burgundy,
      AppColors.gold,
      AppColors.success,
      AppColors.statusConfirmed,
      AppColors.statusPreparing,
      AppColors.statusPending,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Per Categoria',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.pie_chart, color: AppColors.gold, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
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
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final percent = totalRevenue > 0 ? cat.revenue / totalRevenue : 0.0;
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
