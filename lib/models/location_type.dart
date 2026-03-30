import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'location_type.freezed.dart';
part 'location_type.g.dart';

@freezed
abstract class LocationType with _$LocationType {
  @HiveType(typeId: 3)
  factory LocationType({
    @HiveField(0) required String key,
    @HiveField(1) required String label,
    @HiveField(2) required String enterText,
    @HiveField(3) required String exitText,
    @HiveField(4) @Default(false) bool isBuiltin,
  }) = _LocationType;

  factory LocationType.fromJson(Map<String, dynamic> json) =>
      _$LocationTypeFromJson(json);
}
