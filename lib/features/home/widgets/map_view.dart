import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/geofence_state_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

/// Map view - displays location geofences
class MapView extends ConsumerWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locations = ref.watch(locationProvider);
    final geofenceState = ref.watch(geofenceStateProvider);
    final activeLocations = locations.where((l) => l.isActive).toList();

    if (activeLocations.isEmpty) {
      return Card(
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(l10n.addLocationHint,
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    final firstLoc = activeLocations.first;
    final center = LatLng(firstLoc.latitude, firstLoc.longitude);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 15.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.checkin.check_in_reminder',
            ),
            // Geofence radius circles
            CircleLayer(
              circles: activeLocations.map((loc) {
                final isInside =
                    geofenceState.status == GeofenceStatus.inside &&
                        geofenceState.currentLocationId == loc.id;
                return CircleMarker(
                  point: LatLng(loc.latitude, loc.longitude),
                  radius: loc.radiusMeters.toDouble(),
                  useRadiusInMeter: true,
                  color: (isInside ? Colors.green : Colors.blue)
                      .withValues(alpha: 0.15),
                  borderColor: isInside ? Colors.green : Colors.blue,
                  borderStrokeWidth: 2,
                );
              }).toList(),
            ),
            // Location markers
            MarkerLayer(
              markers: activeLocations.map((loc) {
                return Marker(
                  point: LatLng(loc.latitude, loc.longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_on,
                      color: Colors.red, size: 36),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
