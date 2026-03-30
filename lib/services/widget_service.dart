import 'package:home_widget/home_widget.dart';
import 'package:check_in_reminder/services/storage_service.dart';
import 'package:intl/intl.dart';

/// Home widget data sync service
///
/// Updates widget content when geofence events are triggered.
class WidgetService {
  static const _androidName = 'CheckInWidgetProvider';
  static const _iOSName = 'CheckInWidget';

  /// Initialize widget communication
  static Future<void> init() async {
    await HomeWidget.setAppGroupId('group.com.checkin.checkInReminder');
  }

  /// Update widget data
  static Future<void> updateWidget({
    required String status,
    String? lastTime,
    String? locationName,
    String? attendanceApp,
  }) async {
    await HomeWidget.saveWidgetData<String>('status', status);
    await HomeWidget.saveWidgetData<String>(
        'lastTime', lastTime ?? '--:--');
    await HomeWidget.saveWidgetData<String>(
        'locationName', locationName ?? '');
    await HomeWidget.saveWidgetData<String>(
        'attendanceApp', attendanceApp ?? '');
    await HomeWidget.updateWidget(
      androidName: _androidName,
      iOSName: _iOSName,
    );
  }

  /// Update widget based on geofence event
  static Future<void> onGeofenceEvent({
    required String action,
    required String locationName,
    required DateTime timestamp,
    required String attendanceApp,
  }) async {
    final timeStr = DateFormat('HH:mm').format(timestamp);
    final status = (action == 'EXIT') ? 'outside' : 'inside';

    await updateWidget(
      status: status,
      lastTime: timeStr,
      locationName: locationName,
      attendanceApp: attendanceApp,
    );
  }

  /// Refresh widget from storage (called on app startup)
  static Future<void> refreshFromStorage(StorageService storage) async {
    final records = storage.getRecordsByDate(DateTime.now());
    if (records.isEmpty) {
      await updateWidget(status: 'unknown');
      return;
    }

    final lastRecord = records.last;
    final timeStr = DateFormat('HH:mm').format(lastRecord.timestamp);
    final status = lastRecord.type == 'enter' ? 'inside' : 'outside';
    final settings = storage.getSettings();

    await updateWidget(
      status: status,
      lastTime: timeStr,
      attendanceApp: settings.attendanceApp,
    );
  }
}
