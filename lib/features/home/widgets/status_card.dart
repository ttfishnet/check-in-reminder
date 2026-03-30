import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/providers/geofence_state_provider.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final geofenceState = ref.watch(geofenceStateProvider);
    final locations = ref.watch(locationProvider);

    final GeofenceStatus status = geofenceState.status;

    final statusText = switch (status) {
      GeofenceStatus.inside => l10n.statusInside,
      GeofenceStatus.outside => l10n.statusOutside,
      GeofenceStatus.unknown => l10n.statusUnknown,
    };

    final statusColor = switch (status) {
      GeofenceStatus.inside => Colors.green,
      GeofenceStatus.outside => Colors.orange,
      GeofenceStatus.unknown => Colors.grey,
    };

    final statusIcon = switch (status) {
      GeofenceStatus.inside => Icons.location_on,
      GeofenceStatus.outside => Icons.location_off,
      GeofenceStatus.unknown => Icons.location_searching,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locations.isEmpty
                        ? l10n.noLocationSet
                        : l10n.monitoringCount(
                            locations.where((l) => l.isActive).length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            // Monitoring status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: geofenceState.isMonitoring
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                geofenceState.isMonitoring ? l10n.monitoring : l10n.notMonitoring,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      geofenceState.isMonitoring ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
