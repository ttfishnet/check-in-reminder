import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:check_in_reminder/models/company_location.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/location_type_provider.dart';
import 'package:check_in_reminder/services/wifi_monitor_service.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class AddLocationPage extends ConsumerStatefulWidget {
  final CompanyLocation? editingLocation;

  const AddLocationPage({super.key, this.editingLocation});

  @override
  ConsumerState<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends ConsumerState<AddLocationPage> {
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double _radiusMeters = 200;
  bool _isGettingLocation = false;
  bool _showManualInput = false;
  bool _hasCoordinates = false;
  List<String> _wifiSSIDs = [];
  String _locationType = 'work';

  bool get _isEditing => widget.editingLocation != null;

  @override
  void initState() {
    super.initState();
    final loc = widget.editingLocation;
    if (loc != null) {
      _nameController.text = loc.name;
      _latController.text = loc.latitude.toStringAsFixed(6);
      _lngController.text = loc.longitude.toStringAsFixed(6);
      _radiusMeters = loc.radiusMeters.toDouble();
      _wifiSSIDs = List.from(loc.wifiSSIDs);
      _locationType = loc.locationType;
      _showManualInput = true;
      _hasCoordinates = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        if (mounted) _showPermissionDeniedDialog();
        return;
      }
    }

    setState(() => _isGettingLocation = true);

    try {
      await bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_OFF,
      ));

      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        extras: {},
        samples: 3,
        persist: false,
      );

      if (mounted) {
        setState(() {
          _latController.text = location.coords.latitude.toStringAsFixed(6);
          _lngController.text = location.coords.longitude.toStringAsFixed(6);
          _hasCoordinates = true;
          _showManualInput = true;
          _isGettingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGettingLocation = false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.getLocationFailed(e.toString()))),
        );
      }
    }
  }

  void _showPermissionDeniedDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.locationPermRequired),
        content: Text(l10n.locationPermDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _showManualInput = true);
            },
            child: Text(l10n.manualInput),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(l10n.goToSettingsShort),
          ),
        ],
      ),
    );
  }

  Future<void> _bindCurrentWifi() async {
    final l10n = AppLocalizations.of(context)!;
    final wifiService = WifiMonitorService(
      storageService: ref.read(storageServiceProvider),
    );
    final ssid = await wifiService.getCurrentSSID();
    if (ssid == null || ssid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noWifiDetected)),
        );
      }
      return;
    }
    if (_wifiSSIDs.contains(ssid)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.wifiAlreadyBound(ssid))),
        );
      }
      return;
    }
    setState(() => _wifiSSIDs.add(ssid));
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidCoordinates)),
      );
      return;
    }

    final location = CompanyLocation(
      id: widget.editingLocation?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      latitude: lat,
      longitude: lng,
      radiusMeters: _radiusMeters.round(),
      isActive: widget.editingLocation?.isActive ?? true,
      wifiSSIDs: _wifiSSIDs,
      locationType: _locationType,
    );

    final notifier = ref.read(locationProvider.notifier);
    if (_isEditing) {
      await notifier.updateLocation(location);
    } else {
      await notifier.addLocation(location);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(_isEditing ? l10n.locationUpdated : l10n.locationSaved)),
      );
      context.pop();
    }
  }

  String _getHintForType(String typeKey, AppLocalizations l10n) {
    return switch (typeKey) {
      'work' => l10n.locationNameHintWork,
      'school' => l10n.locationNameHintSchool,
      'gym' => l10n.locationNameHintGym,
      _ => l10n.locationNameHintCustom,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationTypes = ref.watch(locationTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editLocation : l10n.addLocation),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Location type
            Text(l10n.locationType,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: locationTypes.map((type) {
                return ChoiceChip(
                  label: Text(type.label),
                  selected: _locationType == type.key,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _locationType = type.key);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.locationName,
                hintText: _getHintForType(_locationType, l10n),
                prefixIcon: const Icon(Icons.business),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterName;
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              icon: _isGettingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.my_location),
              label: Text(_isGettingLocation
                  ? l10n.gettingLocation
                  : l10n.useCurrentLocation),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () async {
                final initialLatLng = _hasCoordinates
                    ? LatLng(
                        double.tryParse(_latController.text) ?? 0,
                        double.tryParse(_lngController.text) ?? 0,
                      )
                    : null;
                final result = await context.push<LatLng>(
                  '/map-picker',
                  extra: initialLatLng,
                );
                if (result != null && mounted) {
                  setState(() {
                    _latController.text =
                        result.latitude.toStringAsFixed(6);
                    _lngController.text =
                        result.longitude.toStringAsFixed(6);
                    _hasCoordinates = true;
                    _showManualInput = true;
                  });
                }
              },
              icon: const Icon(Icons.map),
              label: Text(l10n.mapPicker),
            ),

            const SizedBox(height: 12),

            if (!_showManualInput)
              OutlinedButton.icon(
                onPressed: () => setState(() => _showManualInput = true),
                icon: const Icon(Icons.edit_location_alt),
                label: Text(l10n.manualInput),
              ),

            if (_showManualInput) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _latController,
                decoration: InputDecoration(
                  labelText: l10n.latitude,
                  hintText: '31.230416',
                  prefixIcon: const Icon(Icons.north),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))
                ],
                onChanged: (_) => _updateCoordinateState(),
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.enterLatitude;
                  final v = double.tryParse(value);
                  if (v == null || v < -90 || v > 90) {
                    return l10n.latitudeRange;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lngController,
                decoration: InputDecoration(
                  labelText: l10n.longitude,
                  hintText: '121.473701',
                  prefixIcon: const Icon(Icons.east),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))
                ],
                onChanged: (_) => _updateCoordinateState(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterLongitude;
                  }
                  final v = double.tryParse(value);
                  if (v == null || v < -180 || v > 180) {
                    return l10n.longitudeRange;
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 24),

            // Radius slider
            Text(l10n.fenceRadiusValue(_radiusMeters.round()),
                style: Theme.of(context).textTheme.titleSmall),
            Slider(
              value: _radiusMeters,
              min: 50,
              max: 1000,
              divisions: 19,
              label: '${_radiusMeters.round()}m',
              onChanged: (value) => setState(() => _radiusMeters = value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('50m', style: Theme.of(context).textTheme.bodySmall),
                  Text('1000m', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Wi-Fi binding
            Text(l10n.wifiAssist,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _bindCurrentWifi,
              icon: const Icon(Icons.wifi),
              label: Text(l10n.bindCurrentWifi),
            ),
            if (_wifiSSIDs.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _wifiSSIDs
                    .map((ssid) => Chip(
                          label: Text(ssid),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () =>
                              setState(() => _wifiSSIDs.remove(ssid)),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _hasCoordinates ? _saveLocation : null,
              icon: const Icon(Icons.save),
              label: Text(l10n.saveLocation),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCoordinateState() {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);
    final has = lat != null && lng != null;
    if (has != _hasCoordinates) {
      setState(() => _hasCoordinates = has);
    }
  }
}
