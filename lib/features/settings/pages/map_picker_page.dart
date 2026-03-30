import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:check_in_reminder/l10n/app_localizations.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _selectedLocation;
  late LatLng _center;
  bool _loadingGps = false;

  // Default fallback (GPS will override if available)
  static const _defaultCenter = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _center = widget.initialLocation!;
      _selectedLocation = widget.initialLocation;
    } else {
      _center = _defaultCenter;
      _tryGetCurrentLocation();
    }
  }

  Future<void> _tryGetCurrentLocation() async {
    setState(() => _loadingGps = true);
    try {
      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        extras: {},
        samples: 1,
        persist: false,
        timeout: 10,
      );
      if (mounted) {
        setState(() {
          _center = LatLng(
            location.coords.latitude,
            location.coords.longitude,
          );
          _loadingGps = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingGps = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapPickerTitle),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() => _selectedLocation = point);
              },
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.checkin.check_in_reminder',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (_loadingGps)
            const Center(child: CircularProgressIndicator()),
          if (_selectedLocation == null)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(l10n.tapToSelectLocation),
                ),
              ),
            ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: FilledButton.icon(
                onPressed: () => context.pop(_selectedLocation),
                icon: const Icon(Icons.check),
                label: Text(l10n.confirmLocation),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
