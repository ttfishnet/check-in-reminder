import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'check_record.freezed.dart';
part 'check_record.g.dart';

@freezed
abstract class CheckRecord with _$CheckRecord {
  @HiveType(typeId: 1)
  factory CheckRecord({
    @HiveField(0) required String id,
    @HiveField(1) required String locationId,
    @HiveField(2) required String type, // "enter" | "exit"
    @HiveField(3) required DateTime timestamp,
    @HiveField(4) @Default(false) bool notifyClicked,
  }) = _CheckRecord;

  factory CheckRecord.fromJson(Map<String, dynamic> json) =>
      _$CheckRecordFromJson(json);
}
