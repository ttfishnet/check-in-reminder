import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:uuid/uuid.dart';

import 'package:check_in_reminder/models/check_record.dart';
import 'package:check_in_reminder/models/app_settings.dart';
import 'package:check_in_reminder/services/storage_service.dart';
import 'package:check_in_reminder/services/notification_service.dart';
import 'package:check_in_reminder/services/widget_service.dart';

/// Geofence event callback type
typedef GeofenceEventCallback = void Function(
    String locationId, String action, DateTime timestamp);

/// Monitoring state change callback type
typedef MonitoringChangedCallback = void Function(bool isMonitoring);

/// Geofence service - uses flutter_background_geolocation to register
/// circular geofences and listen for ENTER / EXIT / DWELL events.
class GeofenceService {
  final StorageService _storageService;
  final NotificationService _notificationService;

  /// Set by provider layer to update Riverpod state
  GeofenceEventCallback? onGeofenceEvent;
  MonitoringChangedCallback? onMonitoringChanged;

  /// Re-remind timers (locationId -> Timer)
  final Map<String, Timer> _reRemindTimers = {};

  /// Re-remind counts (locationId -> count)
  final Map<String, int> _reRemindCounts = {};

  bool _isMonitoring = false;

  GeofenceService({
    required StorageService storageService,
    required NotificationService notificationService,
  })  : _storageService = storageService,
        _notificationService = notificationService;

  /// Initialize the plugin
  Future<void> init() async {
    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      stopOnTerminate: false,
      startOnBoot: true,
      geofenceModeHighAccuracy: true,
      enableHeadless: true,
      locationAuthorizationRequest: 'Always',
      notification: bg.Notification(
        channelName: 'Background Location Service',
        title: 'Monitoring active',
        text: 'Geofence monitoring is running',
        priority: bg.NotificationPriority.min,
        sticky: true,
      ),
    ));

    bg.BackgroundGeolocation.onGeofence(_onGeofenceEvent);
  }

  /// Core geofence event handler
  void _onGeofenceEvent(bg.GeofenceEvent event) async {
    final identifier = event.identifier;
    final action = event.action;
    final now = DateTime.now();

    developer.log('Received: action=$action, id=$identifier, time=$now', name: 'GeofenceEvent');

    final settings = _storageService.getSettings();

    // 1) Check if notification is enabled for this event type
    if (action == 'ENTER' || action == 'DWELL') {
      if (!settings.notifyOnEnter) {
        developer.log('Filtered: notifyOnEnter=false', name: 'GeofenceEvent');
        return;
      }
    } else if (action == 'EXIT') {
      if (!settings.notifyOnExit) {
        developer.log('Filtered: notifyOnExit=false', name: 'GeofenceEvent');
        return;
      }
    }

    // 2) Check if today is a workday
    if (!settings.workDays.contains(now.weekday)) {
      developer.log('Filtered: today is not a workday', name: 'GeofenceEvent');
      return;
    }

    // 3) Check if in silent hours
    if (_isSilentHours(now, settings)) {
      developer.log('Filtered: currently in silent period', name: 'GeofenceEvent');
      return;
    }

    // 4) Check if in cooldown period
    if (_isInCooldown(identifier, action, now, settings)) {
      developer.log('Filtered: in cooldown period', name: 'GeofenceEvent');
      return;
    }

    // All checks passed -> save record + send notification
    developer.log('All checks passed, sending notification...', name: 'GeofenceEvent');
    await _saveRecordAndNotify(identifier, action, now, settings);
  }

  /// Check if current time falls within any silent period
  bool _isSilentHours(DateTime now, AppSettings settings) {
    final nowMinutes = now.hour * 60 + now.minute;

    for (final period in settings.silentPeriods) {
      final parts = period.split('-');
      if (parts.length != 2) continue;

      final start = _parseTime(parts[0]);
      final end = _parseTime(parts[1]);

      if (start <= end) {
        // Same day, e.g. 11:30 ~ 13:30
        if (nowMinutes >= start && nowMinutes < end) return true;
      } else {
        // Overnight, e.g. 22:00 ~ 06:00
        if (nowMinutes >= start || nowMinutes < end) return true;
      }
    }
    return false;
  }

  /// Parse "HH:mm" to minutes since midnight
  int _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// Check if in cooldown period (same location, same event type)
  bool _isInCooldown(
      String locationId, String action, DateTime now, AppSettings settings) {
    final records = _storageService.getRecordsByDate(now);
    final type = (action == 'EXIT') ? 'exit' : 'enter';
    final cooldownDuration = Duration(minutes: settings.cooldownMinutes);

    for (final record in records.reversed) {
      if (record.locationId == locationId && record.type == type) {
        if (now.difference(record.timestamp) < cooldownDuration) {
          return true;
        }
        break; // Only need to check the most recent same-type record
      }
    }
    return false;
  }

  /// Save check-in record and send notification
  Future<void> _saveRecordAndNotify(
    String locationId,
    String action,
    DateTime now,
    AppSettings settings,
  ) async {
    final type = (action == 'EXIT') ? 'exit' : 'enter';

    // Look up location name and type
    final locations = _storageService.getLocations();
    final location = locations.where((l) => l.id == locationId).firstOrNull;
    final locationName = location?.name ?? locationId;
    final locType = location?.locationType ?? 'work';
    final locationTypes = _storageService.getLocationTypes();
    final typeConfig = locationTypes.where((t) => t.key == locType).firstOrNull;
    final enterTextStr = typeConfig?.enterText ?? 'Arrived at destination';
    final exitTextStr = typeConfig?.exitText ?? 'Left destination';

    // Save record
    final record = CheckRecord(
      id: const Uuid().v4(),
      locationId: locationId,
      type: type,
      timestamp: now,
    );
    await _storageService.saveRecord(record);

    // Build notification payload (for opening attendance app + marking as punched on tap)
    final payload = jsonEncode({
      'recordId': record.id,
      'app': settings.attendanceApp,
    });

    // Send notification
    final title = type == 'enter' ? 'Arrived at $locationName' : 'Left $locationName';
    final body = type == 'enter' ? enterTextStr : exitTextStr;
    await _notificationService.showCheckInReminder(
      title: title,
      body: body,
      id: locationId.hashCode,
      payload: payload,
      soundSetting: settings.notificationSound,
    );

    // Haptic feedback
    if (settings.hapticEnabled) {
      HapticFeedback.heavyImpact();
    }

    // Update home widget
    await WidgetService.onGeofenceEvent(
      action: action,
      locationName: locationName,
      timestamp: now,
      attendanceApp: settings.attendanceApp,
    );

    // Notify provider layer to update state
    onGeofenceEvent?.call(locationId, action, now);

    // Cancel previous re-remind for this location
    _cancelReRemind(locationId);

    // Start re-remind
    if (settings.maxRemindCount > 0 && settings.reRemindMinutes > 0) {
      _startReRemind(locationId, locationName, type, settings, record.id);
    }
  }

  /// Start re-remind timer
  void _startReRemind(
    String locationId,
    String locationName,
    String type,
    AppSettings settings,
    String recordId,
  ) {
    _reRemindCounts[locationId] = 0;
    _reRemindTimers[locationId] = Timer.periodic(
      Duration(minutes: settings.reRemindMinutes),
      (timer) async {
        final count = (_reRemindCounts[locationId] ?? 0) + 1;
        _reRemindCounts[locationId] = count;

        if (count >= settings.maxRemindCount) {
          timer.cancel();
          _reRemindTimers.remove(locationId);
          _reRemindCounts.remove(locationId);
          return;
        }

        final title =
            type == 'enter' ? 'Arrived at $locationName' : 'Left $locationName';
        final body = type == 'enter'
            ? 'Reminder: please check in (#${count + 1})'
            : 'Reminder: please check out (#${count + 1})';

        final payload = jsonEncode({
          'recordId': recordId,
          'app': settings.attendanceApp,
        });

        await _notificationService.showCheckInReminder(
          title: title,
          body: body,
          id: locationId.hashCode + count,
          payload: payload,
          soundSetting: settings.notificationSound,
        );
      },
    );
  }

  /// Cancel re-remind for a specific location
  void _cancelReRemind(String locationId) {
    _reRemindTimers[locationId]?.cancel();
    _reRemindTimers.remove(locationId);
    _reRemindCounts.remove(locationId);
  }

  /// Sync all geofences: remove all then re-register all active locations
  Future<void> syncGeofences() async {
    await bg.BackgroundGeolocation.removeGeofences();

    final locations = _storageService.getLocations();
    final activeLocations = locations.where((l) => l.isActive).toList();

    if (activeLocations.isEmpty) {
      await stop();
      return;
    }

    for (final location in activeLocations) {
      await addGeofence(
        identifier: location.id,
        latitude: location.latitude,
        longitude: location.longitude,
        radiusMeters: location.radiusMeters,
        dwellDelaySeconds: location.dwellDelaySeconds,
      );
    }

    await start();
  }

  /// Register a single geofence
  Future<void> addGeofence({
    required String identifier,
    required double latitude,
    required double longitude,
    required int radiusMeters,
    int dwellDelaySeconds = 180,
  }) async {
    await bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: identifier,
      latitude: latitude,
      longitude: longitude,
      radius: radiusMeters.toDouble(),
      notifyOnEntry: true,
      notifyOnExit: true,
      notifyOnDwell: true,
      loiteringDelay: dwellDelaySeconds * 1000,
    ));
  }

  /// Remove a single geofence
  Future<void> removeGeofence(String identifier) async {
    await bg.BackgroundGeolocation.removeGeofence(identifier);
  }

  /// Start geofence-only monitoring (low power)
  Future<void> start() async {
    // Check if plugin is already running to avoid duplicate start causing PlatformException
    final state = await bg.BackgroundGeolocation.state;
    if (!state.enabled) {
      await bg.BackgroundGeolocation.startGeofences();
    }
    _isMonitoring = true;
    onMonitoringChanged?.call(true);
  }

  /// Stop monitoring + cancel all re-remind timers
  Future<void> stop() async {
    await bg.BackgroundGeolocation.stop();
    _isMonitoring = false;
    onMonitoringChanged?.call(false);

    // Cancel all re-remind timers
    for (final timer in _reRemindTimers.values) {
      timer.cancel();
    }
    _reRemindTimers.clear();
    _reRemindCounts.clear();
  }

  bool get isMonitoring => _isMonitoring;

  /// Force get current location and check geofence status (for accelerating detection after mock GPS)
  Future<void> forceLocationCheck() async {
    try {
      // Switch to moving state to trigger active location acquisition
      await bg.BackgroundGeolocation.changePace(true);
      // Get one location to trigger geofence evaluation
      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        extras: {},
        samples: 1,
        persist: false,
        timeout: 10,
      );
      developer.log(
          'forceLocationCheck got location: '
          'lat=${location.coords.latitude}, lng=${location.coords.longitude}, '
          'accuracy=${location.coords.accuracy}m, '
          'mock=${location.mock}',
          name: 'GeofenceService');
    } catch (e) {
      developer.log('forceLocationCheck error: $e', name: 'GeofenceService', error: e);
    }
  }

  /// Simulate geofence event (for debugging), skips all business checks
  /// (workday, silent hours, cooldown) and directly saves record + sends notification.
  Future<void> simulateEvent(String locationId, String action) async {
    final now = DateTime.now();
    final settings = _storageService.getSettings();

    developer.log('action=$action, locationId=$locationId', name: 'GeofenceSimulate');
    await _saveRecordAndNotify(locationId, action, now, settings);
    developer.log('done', name: 'GeofenceSimulate');
  }

  /// Handle geofence event in headless mode (system wakes app after it's killed)
  static Future<void> handleHeadlessGeofenceEvent(
      bg.GeofenceEvent event) async {
    final storageService = StorageService();
    await storageService.init();

    final notificationService = NotificationService();
    await notificationService.init();

    final service = GeofenceService(
      storageService: storageService,
      notificationService: notificationService,
    );

    service._onGeofenceEvent(event);
  }
}
