import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:check_in_reminder/core/constants.dart';
import 'package:check_in_reminder/models/company_location.dart';
import 'package:check_in_reminder/models/check_record.dart';
import 'package:check_in_reminder/models/app_settings.dart';
import 'package:check_in_reminder/models/location_type.dart';
import 'package:check_in_reminder/models/attendance_app.dart';
import 'package:check_in_reminder/hive_registrar.g.dart';

class StorageService {
  late Box<CompanyLocation> _locationBox;
  late Box<CheckRecord> _recordBox;
  late Box<AppSettings> _settingsBox;
  late Box<LocationType> _locationTypeBox;
  late Box<AttendanceApp> _attendanceAppBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    _locationBox = await Hive.openBox<CompanyLocation>(kBoxLocations);
    _recordBox = await Hive.openBox<CheckRecord>(kBoxRecords);
    _settingsBox = await Hive.openBox<AppSettings>(kBoxSettings);
    _locationTypeBox = await Hive.openBox<LocationType>(kBoxLocationTypes);
    _attendanceAppBox = await Hive.openBox<AttendanceApp>(kBoxAttendanceApps);

    // Seed default location types if empty
    if (_locationTypeBox.isEmpty) {
      for (final entry in kDefaultLocationTypes.entries) {
        await _locationTypeBox.put(
          entry.key,
          LocationType(
            key: entry.key,
            label: entry.value['label'] as String,
            enterText: entry.value['enterText'] as String,
            exitText: entry.value['exitText'] as String,
            isBuiltin: true,
          ),
        );
      }
    }

    // Seed default attendance apps if empty
    if (_attendanceAppBox.isEmpty) {
      for (final entry in kDefaultAttendanceApps.entries) {
        await _attendanceAppBox.put(
          entry.key,
          AttendanceApp(
            key: entry.key,
            name: entry.value['name']!,
            scheme: entry.value['scheme']!,
            isBuiltin: true,
          ),
        );
      }
    }
  }

  // === Locations ===

  List<CompanyLocation> getLocations() => _locationBox.values.toList();

  Future<void> saveLocation(CompanyLocation location) async {
    await _locationBox.put(location.id, location);
  }

  Future<void> deleteLocation(String id) async {
    await _locationBox.delete(id);
  }

  // === Records ===

  List<CheckRecord> getRecords() => _recordBox.values.toList();

  List<CheckRecord> getRecordsByDate(DateTime date) {
    return _recordBox.values.where((r) {
      return r.timestamp.year == date.year &&
          r.timestamp.month == date.month &&
          r.timestamp.day == date.day;
    }).toList();
  }

  Future<void> saveRecord(CheckRecord record) async {
    await _recordBox.put(record.id, record);
  }

  Future<void> updateRecord(CheckRecord record) async {
    await _recordBox.put(record.id, record);
  }

  // === Settings ===

  AppSettings getSettings() {
    return _settingsBox.get('settings') ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('settings', settings);
  }

  // === Location Types ===

  List<LocationType> getLocationTypes() => _locationTypeBox.values.toList();

  Future<void> saveLocationType(LocationType type) async {
    await _locationTypeBox.put(type.key, type);
  }

  Future<void> deleteLocationType(String key) async {
    await _locationTypeBox.delete(key);
  }

  // === Attendance Apps ===

  List<AttendanceApp> getAttendanceApps() => _attendanceAppBox.values.toList();

  Future<void> saveAttendanceApp(AttendanceApp app) async {
    await _attendanceAppBox.put(app.key, app);
  }

  Future<void> deleteAttendanceApp(String key) async {
    await _attendanceAppBox.delete(key);
  }
}
