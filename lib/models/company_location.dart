import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'company_location.freezed.dart';
part 'company_location.g.dart';

@freezed
abstract class CompanyLocation with _$CompanyLocation {
  @HiveType(typeId: 0)
  factory CompanyLocation({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double latitude,
    @HiveField(3) required double longitude,
    @HiveField(4) @Default(200) int radiusMeters,
    @HiveField(5) @Default(180) int dwellDelaySeconds,
    @HiveField(6) @Default(true) bool isActive,
    @HiveField(7) @Default([]) List<String> wifiSSIDs,
    @HiveField(8) @Default('work') String locationType,
  }) = _CompanyLocation;

  factory CompanyLocation.fromJson(Map<String, dynamic> json) =>
      _$CompanyLocationFromJson(json);
}
