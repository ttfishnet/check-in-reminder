import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:check_in_reminder/providers/statistics_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  bool _isWeekView = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = _isWeekView
        ? ref.watch(weekStatisticsProvider)
        : ref.watch(monthStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        actions: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l10n.weekView)),
              ButtonSegment(value: false, label: Text(l10n.monthView)),
            ],
            selected: {_isWeekView},
            onSelectionChanged: (v) => setState(() => _isWeekView = v.first),
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arrival time bar chart
            _ArrivalChart(stats: stats, isWeek: _isWeekView),
            const SizedBox(height: 16),

            // Stats cards
            _StatCards(stats: stats),
            const SizedBox(height: 16),

            // Detail list
            _DetailList(stats: stats),
          ],
        ),
      ),
    );
  }
}

/// Arrival time bar chart
class _ArrivalChart extends StatelessWidget {
  final PeriodStatistics stats;
  final bool isWeek;

  const _ArrivalChart({required this.stats, required this.isWeek});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final workDays =
        stats.days.where((d) => d.firstEnter != null || d.forgotPunch).toList();

    if (workDays.isEmpty) {
      return Card(
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Center(
            child: Text(l10n.noData,
                style: TextStyle(color: theme.colorScheme.outline)),
          ),
        ),
      );
    }

    // Show recent days (week max 7, month max 15)
    final displayDays = isWeek
        ? stats.days
        : stats.days.reversed.take(15).toList().reversed.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isWeek ? l10n.weekArrival : l10n.monthArrival,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: displayDays.map((day) {
                  return Expanded(child: _BarItem(day: day));
                }).toList(),
              ),
            ),
            // Late threshold marker
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.lateThresholdHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final DayStatistics day;

  const _BarItem({required this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dayLabel = DateFormat('E', locale == 'zh' ? 'zh_CN' : 'en').format(day.date);
    final enter = day.firstEnter;

    // Bar height: based on arrival time (7:00=full height, 10:00=low)
    double heightFraction = 0;
    Color barColor = theme.colorScheme.outline.withValues(alpha: 0.3);

    if (enter != null) {
      final minutes = enter.hour * 60 + enter.minute;
      // 7:00(420) → 1.0,  10:00(600) → 0.1
      heightFraction = ((600 - minutes) / 180).clamp(0.1, 1.0);
      barColor = day.isLate ? Colors.orange : Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (enter != null)
            Text(
              DateFormat('HH:mm').format(enter),
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
          if (day.forgotPunch && enter == null)
            Icon(Icons.help_outline, size: 12, color: Colors.red),
          const SizedBox(height: 2),
          Container(
            height: 80 * heightFraction,
            width: double.infinity,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(dayLabel, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// Stats cards (2x2 grid)
class _StatCards extends StatelessWidget {
  final PeriodStatistics stats;

  const _StatCards({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avgTimeStr = stats.avgArrivalTime != null
        ? '${stats.avgArrivalTime!.inHours.toString().padLeft(2, '0')}:${(stats.avgArrivalTime!.inMinutes % 60).toString().padLeft(2, '0')}'
        : '--:--';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            label: l10n.attendanceDays,
            value: '${stats.attendedDays}/${stats.totalWorkDays}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.access_time,
            label: l10n.avgArrival,
            value: avgTimeStr,
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.warning_amber,
            label: l10n.lateDays,
            value: '${stats.lateDays}',
            color: stats.lateDays > 0 ? Colors.orange : Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.error_outline,
            label: l10n.forgotPunch,
            value: '${stats.forgotPunchDays}',
            color: stats.forgotPunchDays > 0 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Detail list
class _DetailList extends StatelessWidget {
  final PeriodStatistics stats;

  const _DetailList({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    // Only show workdays or days with records, sorted by date descending
    final relevantDays = stats.days
        .where((d) => d.firstEnter != null || d.forgotPunch)
        .toList()
        .reversed
        .toList();

    if (relevantDays.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              l10n.detail,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relevantDays.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final day = relevantDays[index];
              final dateStr = DateFormat('MM/dd E', locale == 'zh' ? 'zh_CN' : 'en')
                  .format(day.date);
              final enterStr = day.firstEnter != null
                  ? DateFormat('HH:mm').format(day.firstEnter!)
                  : '--:--';
              final exitStr = day.lastExit != null
                  ? DateFormat('HH:mm').format(day.lastExit!)
                  : '--:--';

              return ListTile(
                dense: true,
                leading: Icon(
                  day.isLate
                      ? Icons.warning_amber
                      : day.forgotPunch && day.firstEnter == null
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                  color: day.isLate
                      ? Colors.orange
                      : day.forgotPunch && day.firstEnter == null
                          ? Colors.red
                          : Colors.green,
                  size: 20,
                ),
                title: Text(dateStr),
                trailing: Text(
                  '$enterStr  ~  $exitStr',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
