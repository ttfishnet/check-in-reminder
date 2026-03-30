import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/company_location.dart';
import 'package:check_in_reminder/services/storage_service.dart';
import 'package:check_in_reminder/providers/geofence_service_provider.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final locationProvider =
    NotifierProvider<LocationNotifier, List<CompanyLocation>>(
        LocationNotifier.new);

class LocationNotifier extends Notifier<List<CompanyLocation>> {
  @override
  List<CompanyLocation> build() {
    return ref.read(storageServiceProvider).getLocations();
  }

  Future<void> addLocation(CompanyLocation location) async {
    await ref.read(storageServiceProvider).saveLocation(location);
    state = ref.read(storageServiceProvider).getLocations();
    ref.read(geofenceServiceProvider).syncGeofences();
  }

  Future<void> updateLocation(CompanyLocation location) async {
    await ref.read(storageServiceProvider).saveLocation(location);
    state = ref.read(storageServiceProvider).getLocations();
    ref.read(geofenceServiceProvider).syncGeofences();
  }

  Future<void> removeLocation(String id) async {
    await ref.read(storageServiceProvider).deleteLocation(id);
    state = ref.read(storageServiceProvider).getLocations();
    ref.read(geofenceServiceProvider).syncGeofences();
  }

  void refresh() {
    state = ref.read(storageServiceProvider).getLocations();
  }
}
