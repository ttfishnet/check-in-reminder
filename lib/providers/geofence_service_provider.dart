import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:check_in_reminder/services/geofence_service.dart';
import 'package:check_in_reminder/services/notification_service.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/geofence_state_provider.dart';
import 'package:check_in_reminder/providers/records_provider.dart';

/// NotificationService provider - overridden in main.dart
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// GeofenceService provider
final geofenceServiceProvider = Provider<GeofenceService>((ref) {
  final storageService = ref.read(storageServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);

  final service = GeofenceService(
    storageService: storageService,
    notificationService: notificationService,
  );

  // Set geofence event callback -> update Riverpod state
  service.onGeofenceEvent = (locationId, action, timestamp) {
    final geofenceNotifier = ref.read(geofenceStateProvider.notifier);
    if (action == 'ENTER' || action == 'DWELL') {
      geofenceNotifier.setEnterTime(timestamp, locationId: locationId);
    } else if (action == 'EXIT') {
      geofenceNotifier.setExitTime(timestamp);
    }
    // Refresh records list
    ref.read(recordsProvider.notifier).refresh();
  };

  // Set monitoring state change callback
  service.onMonitoringChanged = (isMonitoring) {
    ref.read(geofenceStateProvider.notifier).setMonitoring(isMonitoring);
  };

  return service;
});
