import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/check_record.dart';
import 'package:check_in_reminder/providers/records_provider.dart';
import 'package:check_in_reminder/providers/settings_provider.dart';

class DayStatistics {
  final DateTime date;
  final DateTime? firstEnter;
  final DateTime? lastExit;
  final bool isLate;
  final bool forgotPunch; // Workday with entry but no exit, or no records at all

  DayStatistics({
    required this.date,
    this.firstEnter,
    this.lastExit,
    this.isLate = false,
    this.forgotPunch = false,
  });
}

class PeriodStatistics {
  final int totalWorkDays;
  final int attendedDays;
  final int lateDays;
  final int forgotPunchDays;
  final Duration? avgArrivalTime; // Duration since midnight
  final List<DayStatistics> days;

  PeriodStatistics({
    required this.totalWorkDays,
    required this.attendedDays,
    required this.lateDays,
    required this.forgotPunchDays,
    this.avgArrivalTime,
    required this.days,
  });
}

/// Late threshold: 9:30
const _lateThresholdMinutes = 9 * 60 + 30;

PeriodStatistics _calculateStats(
  List<CheckRecord> allRecords,
  List<int> workDays,
  DateTime startDate,
  DateTime endDate,
) {
  final today = DateTime.now();
  final days = <DayStatistics>[];
  int totalWorkDays = 0;
  int attendedDays = 0;
  int lateDays = 0;
  int forgotPunchDays = 0;
  int totalArrivalMinutes = 0;
  int arrivalCount = 0;

  for (var d = startDate;
      !d.isAfter(endDate) && !d.isAfter(today);
      d = d.add(const Duration(days: 1))) {
    final isWorkDay = workDays.contains(d.weekday);
    if (!isWorkDay) {
      days.add(DayStatistics(date: d));
      continue;
    }

    totalWorkDays++;

    // Filter records for this day
    final dayRecords = allRecords.where((r) =>
        r.timestamp.year == d.year &&
        r.timestamp.month == d.month &&
        r.timestamp.day == d.day);

    final enters = dayRecords.where((r) => r.type == 'enter').toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final exits = dayRecords.where((r) => r.type == 'exit').toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final firstEnter = enters.isNotEmpty ? enters.first.timestamp : null;
    final lastExit = exits.isNotEmpty ? exits.last.timestamp : null;

    bool isLate = false;
    bool forgotPunch = false;

    if (firstEnter != null) {
      attendedDays++;
      final arrivalMinutes = firstEnter.hour * 60 + firstEnter.minute;
      totalArrivalMinutes += arrivalMinutes;
      arrivalCount++;

      if (arrivalMinutes > _lateThresholdMinutes) {
        isLate = true;
        lateDays++;
      }

      // Has entry but no exit record (and not today)
      if (lastExit == null && d.day != today.day) {
        forgotPunch = true;
        forgotPunchDays++;
      }
    } else if (d.day != today.day) {
      // Workday with no records at all (excluding today which may not have checked in yet)
      forgotPunch = true;
      forgotPunchDays++;
    }

    days.add(DayStatistics(
      date: d,
      firstEnter: firstEnter,
      lastExit: lastExit,
      isLate: isLate,
      forgotPunch: forgotPunch,
    ));
  }

  return PeriodStatistics(
    totalWorkDays: totalWorkDays,
    attendedDays: attendedDays,
    lateDays: lateDays,
    forgotPunchDays: forgotPunchDays,
    avgArrivalTime: arrivalCount > 0
        ? Duration(minutes: totalArrivalMinutes ~/ arrivalCount)
        : null,
    days: days,
  );
}

final weekStatisticsProvider = Provider<PeriodStatistics>((ref) {
  final records = ref.watch(recordsProvider);
  final settings = ref.watch(settingsProvider);
  final now = DateTime.now();
  // This Monday
  final monday = now.subtract(Duration(days: now.weekday - 1));
  final startDate = DateTime(monday.year, monday.month, monday.day);
  final endDate = startDate.add(const Duration(days: 6));
  return _calculateStats(records, settings.workDays, startDate, endDate);
});

final monthStatisticsProvider = Provider<PeriodStatistics>((ref) {
  final records = ref.watch(recordsProvider);
  final settings = ref.watch(settingsProvider);
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, 1);
  final endDate = DateTime(now.year, now.month + 1, 0); // Last day of month
  return _calculateStats(records, settings.workDays, startDate, endDate);
});
