import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:url_launcher/url_launcher.dart';

import 'package:check_in_reminder/services/storage_service.dart';
import 'package:check_in_reminder/services/notification_service.dart';
import 'package:check_in_reminder/services/geofence_service.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/geofence_service_provider.dart';
import 'package:check_in_reminder/providers/records_provider.dart';
import 'package:check_in_reminder/services/widget_service.dart';
import 'package:check_in_reminder/app.dart';

/// Headless task - system wakes the app after it's killed to handle geofence events
@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  final name = headlessEvent.name;
  if (name == 'geofence') {
    final geofenceEvent = headlessEvent.event as bg.GeofenceEvent;
    await GeofenceService.handleHeadlessGeofenceEvent(geofenceEvent);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize home widget
  await WidgetService.init();

  // Register headless task (failure won't block startup)
  try {
    bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  } catch (e) {
    developer.log('registerHeadlessTask failed: $e', name: 'main');
  }

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const App(),
    ),
  );
}

/// Set up notification tap callback: mark as punched + open attendance app
void setupNotificationHandler(ProviderContainer container) {
  NotificationService.onNotificationTapped = (String payload) async {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final recordId = data['recordId'] as String?;
      final app = data['app'] as String?;

      // Mark as clicked
      if (recordId != null) {
        container.read(recordsProvider.notifier).markAsClicked(recordId);
      }

      // Open attendance app
      if (app != null) {
        final storageService = container.read(storageServiceProvider);
        final apps = storageService.getAttendanceApps();
        final appObj = apps.where((a) => a.key == app).firstOrNull;
        final scheme = appObj?.scheme;
        developer.log('Opening attendance app: app=$app, scheme=$scheme', name: 'notification');
        if (scheme != null) {
          final uri = Uri.parse(scheme);
          final canLaunch = await canLaunchUrl(uri);
          developer.log('canLaunchUrl($uri) = $canLaunch', name: 'notification');
          if (canLaunch) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      developer.log('Notification tap handler failed: $e', name: 'notification');
    }
  };
}

/// Initialize geofence service after the app's first build
/// Called by [GeofenceInitializer] widget
Future<void> initGeofenceService(ProviderContainer container) async {
  // Set up notification tap callback
  setupNotificationHandler(container);

  try {
    final geofenceService = container.read(geofenceServiceProvider);
    developer.log('Initializing plugin...', name: 'GeofenceInit');
    await geofenceService.init();
    developer.log('Plugin initialized', name: 'GeofenceInit');

    final storageService = container.read(storageServiceProvider);
    final locations = storageService.getLocations();
    final hasActive = locations.any((l) => l.isActive);
    developer.log('Active locations: ${locations.where((l) => l.isActive).length}/${locations.length}', name: 'GeofenceInit');
    if (hasActive) {
      await geofenceService.syncGeofences();
      developer.log('syncGeofences done, isMonitoring=${geofenceService.isMonitoring}', name: 'GeofenceInit');
    } else {
      developer.log('No active locations, skipping syncGeofences', name: 'GeofenceInit');
    }
  } catch (e, st) {
    developer.log('Initialization failed: $e', name: 'GeofenceInit', error: e, stackTrace: st);
  }
}
