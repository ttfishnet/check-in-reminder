import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:check_in_reminder/services/storage_service.dart';

/// Wi-Fi event callback type
typedef WifiEventCallback = void Function(String locationId, String action);

/// Wi-Fi assisted location service
/// Periodically checks the current Wi-Fi SSID against SSIDs bound to locations,
/// serving as a supplementary check alongside GPS geofencing.
class WifiMonitorService {
  final StorageService _storageService;
  final NetworkInfo _networkInfo = NetworkInfo();

  Timer? _pollTimer;
  String? _lastSSID;

  /// Set by provider layer
  WifiEventCallback? onWifiEvent;

  WifiMonitorService({required StorageService storageService})
      : _storageService = storageService;

  /// Start monitoring (checks every 30 seconds)
  void startMonitoring() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkWifi(),
    );
    // Check immediately
    _checkWifi();
  }

  void stopMonitoring() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  bool get isMonitoring => _pollTimer != null;

  /// Get current Wi-Fi SSID
  Future<String?> getCurrentSSID() async {
    try {
      final name = await _networkInfo.getWifiName();
      // iOS/Android may return SSID with quotes, strip them
      return name?.replaceAll('"', '');
    } catch (_) {
      return null;
    }
  }

  Future<void> _checkWifi() async {
    final currentSSID = await getCurrentSSID();
    if (currentSSID == _lastSSID) return;

    final locations = _storageService.getLocations();
    for (final loc
        in locations.where((l) => l.isActive && l.wifiSSIDs.isNotEmpty)) {
      final wasConnected =
          _lastSSID != null && loc.wifiSSIDs.contains(_lastSSID);
      final isConnected =
          currentSSID != null && loc.wifiSSIDs.contains(currentSSID);

      if (!wasConnected && isConnected) {
        onWifiEvent?.call(loc.id, 'ENTER');
      } else if (wasConnected && !isConnected) {
        onWifiEvent?.call(loc.id, 'EXIT');
      }
    }

    _lastSSID = currentSSID;
  }
}
