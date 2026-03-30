import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/location_type.dart';
import 'package:check_in_reminder/providers/location_provider.dart';

final locationTypeProvider =
    NotifierProvider<LocationTypeNotifier, List<LocationType>>(
        LocationTypeNotifier.new);

class LocationTypeNotifier extends Notifier<List<LocationType>> {
  @override
  List<LocationType> build() {
    return ref.read(storageServiceProvider).getLocationTypes();
  }

  Future<void> addLocationType(LocationType type) async {
    await ref.read(storageServiceProvider).saveLocationType(type);
    state = ref.read(storageServiceProvider).getLocationTypes();
  }

  Future<void> updateLocationType(LocationType type) async {
    await ref.read(storageServiceProvider).saveLocationType(type);
    state = ref.read(storageServiceProvider).getLocationTypes();
  }

  Future<void> removeLocationType(String key) async {
    await ref.read(storageServiceProvider).deleteLocationType(key);
    state = ref.read(storageServiceProvider).getLocationTypes();
  }
}
