import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'attendance_app.freezed.dart';
part 'attendance_app.g.dart';

@freezed
abstract class AttendanceApp with _$AttendanceApp {
  @HiveType(typeId: 4)
  factory AttendanceApp({
    @HiveField(0) required String key,
    @HiveField(1) required String name,
    @HiveField(2) required String scheme,
    @HiveField(3) @Default(false) bool isBuiltin,
  }) = _AttendanceApp;

  factory AttendanceApp.fromJson(Map<String, dynamic> json) =>
      _$AttendanceAppFromJson(json);
}
