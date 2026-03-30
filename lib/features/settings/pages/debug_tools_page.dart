import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:check_in_reminder/providers/settings_provider.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/attendance_app_provider.dart';
import 'package:check_in_reminder/providers/geofence_service_provider.dart';
import 'package:check_in_reminder/providers/geofence_state_provider.dart';
import 'package:check_in_reminder/services/mock_location_service.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class DebugToolsPage extends ConsumerStatefulWidget {
  const DebugToolsPage({super.key});

  @override
  ConsumerState<DebugToolsPage> createState() => _DebugToolsPageState();
}

class _DebugToolsPageState extends ConsumerState<DebugToolsPage> {
  bool _isMocking = false;
  String? _mockingLocationName;
  Timer? _mockTimer;

  @override
  void dispose() {
    _stopMock();
    super.dispose();
  }

  Future<void> _startMockEnter(
      double lat, double lng, String name, String locationId, BuildContext ctx) async {
    try {
      await MockLocationService.setMockLocation(lat, lng);
      // Keep sending mock location every 1s to maintain position
      _mockTimer?.cancel();
      _mockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        MockLocationService.setMockLocation(lat, lng);
      });
      setState(() {
        _isMocking = true;
        _mockingLocationName = name;
      });
      // Directly trigger simulated enter event (plugin may not respond to mock locations)
      await ref.read(geofenceServiceProvider).simulateEvent(locationId, 'ENTER');
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('GPS mocked to "$name", enter notification triggered')),
        );
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Mock failed: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _startMockExit(String locationId, String name, BuildContext ctx) async {
    // Move to 0, 0 (middle of ocean)
    try {
      await MockLocationService.setMockLocation(0, 0);
      _mockTimer?.cancel();
      _mockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        MockLocationService.setMockLocation(0, 0);
      });
      setState(() {
        _isMocking = true;
        _mockingLocationName = 'Away from geofence (0, 0)';
      });
      // Directly trigger simulated exit event
      await ref.read(geofenceServiceProvider).simulateEvent(locationId, 'EXIT');
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('GPS mocked to remote, exit notification for "$name" triggered')),
        );
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Mock failed: $e'), duration: const Duration(seconds: 5)),
        );
      }
    }
  }

  Future<void> _stopMock() async {
    _mockTimer?.cancel();
    _mockTimer = null;
    try {
      await MockLocationService.stopMockLocation();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isMocking = false;
        _mockingLocationName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final locations = ref.watch(locationProvider);
    final geofenceState = ref.watch(geofenceStateProvider);
    final attendanceApps = ref.watch(attendanceAppProvider);

    final statusText = switch (geofenceState.status) {
      GeofenceStatus.unknown => l10n.statusUnknown,
      GeofenceStatus.inside => l10n.statusInside,
      GeofenceStatus.outside => l10n.statusOutside,
    };
    final enterTime = geofenceState.lastEnterTime;
    final exitTime = geofenceState.lastExitTime;
    final activeLocations = locations.where((l) => l.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debugTools),
      ),
      body: ListView(
        children: [
          // Geofence status
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.geofenceStatus),
            subtitle: Text(statusText),
          ),
          ListTile(
            leading: const Icon(Icons.sensors),
            title: Text(l10n.monitorStatus),
            subtitle: Text(
                geofenceState.isMonitoring
                    ? l10n.monitoring
                    : l10n.notMonitored),
          ),
          if (enterTime != null)
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(l10n.lastEnter),
              subtitle: Text(
                  '${enterTime.hour.toString().padLeft(2, '0')}:${enterTime.minute.toString().padLeft(2, '0')}:${enterTime.second.toString().padLeft(2, '0')}'),
            ),
          if (exitTime != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.lastExit),
              subtitle: Text(
                  '${exitTime.hour.toString().padLeft(2, '0')}:${exitTime.minute.toString().padLeft(2, '0')}:${exitTime.second.toString().padLeft(2, '0')}'),
            ),

          const Divider(),

          // GPS mock (end-to-end test)
          _SectionHeader(title: 'GPS Mock Test'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Mock GPS coordinates and directly trigger geofence event notifications.\n'
              'Also changes system GPS (requires selecting this app as mock location app in Developer Options).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          if (_isMocking)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.gps_fixed),
                title: const Text('GPS Mocking Active'),
                subtitle: Text(_mockingLocationName ?? ''),
                trailing: FilledButton.tonal(
                  onPressed: () async {
                    await _stopMock();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('GPS mock stopped, real location restored')),
                      );
                    }
                  },
                  child: const Text('Stop'),
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (activeLocations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('No active locations. Add a location in settings first.'),
            )
          else
            ...activeLocations.map((loc) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.name,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          '${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}  (R=${loc.radiusMeters}m)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                icon: const Icon(Icons.login, size: 18),
                                label: const Text('Mock Enter'),
                                onPressed: () => _startMockEnter(
                                    loc.latitude, loc.longitude, loc.name, loc.id, context),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.logout, size: 18),
                                label: const Text('Mock Exit'),
                                onPressed: () => _startMockExit(loc.id, loc.name, context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),

          const Divider(),

          // Other tools
          _SectionHeader(title: 'Other Tools'),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: Text(l10n.resetOnboarding),
            onTap: () async {
              await ref.read(settingsProvider.notifier).resetOnboarding();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.resetOnboardingDone)),
                );
                context.go('/onboarding');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_settings_alt),
            title: Text(l10n.manageAttendanceApps),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/attendance-apps'),
          ),

          const Divider(),

          // Current settings snapshot
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings Snapshot',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                _infoRow('attendanceApp', settings.attendanceApp),
                _infoRow('onboardingCompleted',
                    settings.onboardingCompleted.toString()),
                _infoRow('workDays', settings.workDays.toString()),
                _infoRow('cooldownMinutes',
                    settings.cooldownMinutes.toString()),
                _infoRow('silentPeriods',
                    settings.silentPeriods.toString()),
                _infoRow('locations', '${locations.length}'),
                _infoRow('attendanceApps', '${attendanceApps.length}'),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'monospace', fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
