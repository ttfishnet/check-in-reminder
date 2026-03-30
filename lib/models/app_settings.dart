import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  @HiveType(typeId: 2)
  factory AppSettings({
    @HiveField(0) @Default([1, 2, 3, 4, 5]) List<int> workDays,
    @HiveField(1) @Default(true) bool holidayCalendarEnabled,
    @HiveField(2) @Default("22:00") String silentStart,
    @HiveField(3) @Default("06:00") String silentEnd,
    @HiveField(4) @Default(true) bool notifyOnEnter,
    @HiveField(5) @Default(true) bool notifyOnExit,
    @HiveField(6) @Default("dingtalk") String attendanceApp,
    @HiveField(7) @Default(120) int cooldownMinutes,
    @HiveField(8) @Default(180) int dwellDelaySeconds,
    @HiveField(9) @Default(5) int reRemindMinutes,
    @HiveField(10) @Default(2) int maxRemindCount,
    @HiveField(11) @Default(false) bool onboardingCompleted,
    @HiveField(12) @Default(["22:00-06:00"]) List<String> silentPeriods,
    @HiveField(13) @Default("system") String themeMode,
    @HiveField(14) @Default(true) bool hapticEnabled,
    @HiveField(15) @Default("default") String notificationSound,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
