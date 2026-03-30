package com.checkin.check_in_reminder

import android.location.Location
import android.location.LocationManager
import android.location.provider.ProviderProperties
import android.os.Build
import android.os.SystemClock
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.checkin.check_in_reminder/mock_location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setMockLocation" -> {
                    val lat = call.argument<Double>("latitude")!!
                    val lng = call.argument<Double>("longitude")!!
                    try {
                        setMockLocation(lat, lng)
                        result.success(true)
                    } catch (e: SecurityException) {
                        result.error("PERMISSION", "App is not set as mock location provider. Go to Developer Options → Select mock location app → select this app.", null)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "stopMockLocation" -> {
                    try {
                        stopMockLocation()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun setMockLocation(latitude: Double, longitude: Double) {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        // Set up test providers for both GPS and Network
        for (provider in listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)) {
            try {
                locationManager.removeTestProvider(provider)
            } catch (_: Exception) {}

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                locationManager.addTestProvider(
                    provider,
                    false, false, false, false, false, true, true,
                    ProviderProperties.POWER_USAGE_LOW,
                    ProviderProperties.ACCURACY_FINE
                )
            } else {
                @Suppress("DEPRECATION")
                locationManager.addTestProvider(
                    provider,
                    false, false, false, false, false, true, true,
                    android.location.Criteria.POWER_LOW,
                    android.location.Criteria.ACCURACY_FINE
                )
            }
            locationManager.setTestProviderEnabled(provider, true)

            val mockLocation = Location(provider).apply {
                this.latitude = latitude
                this.longitude = longitude
                this.altitude = 10.0
                this.accuracy = 5.0f
                this.time = System.currentTimeMillis()
                this.elapsedRealtimeNanos = SystemClock.elapsedRealtimeNanos()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    this.bearingAccuracyDegrees = 0.1f
                    this.verticalAccuracyMeters = 0.1f
                    this.speedAccuracyMetersPerSecond = 0.01f
                }
            }
            locationManager.setTestProviderLocation(provider, mockLocation)
        }
    }

    private fun stopMockLocation() {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        for (provider in listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)) {
            try {
                locationManager.removeTestProvider(provider)
            } catch (_: Exception) {}
        }
    }
}
