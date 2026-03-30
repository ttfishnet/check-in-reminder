import 'package:flutter/services.dart';

class MockLocationService {
  static const _channel =
      MethodChannel('com.checkin.check_in_reminder/mock_location');

  /// Set mock GPS location. Requires app to be selected as
  /// mock location provider in Developer Options.
  static Future<void> setMockLocation(double latitude, double longitude) async {
    await _channel.invokeMethod('setMockLocation', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Stop mock location and restore real GPS.
  static Future<void> stopMockLocation() async {
    await _channel.invokeMethod('stopMockLocation');
  }
}
