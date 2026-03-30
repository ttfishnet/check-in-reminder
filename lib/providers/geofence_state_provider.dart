import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GeofenceStatus {
  unknown,
  inside,
  outside,
}

class GeofenceState {
  final GeofenceStatus status;
  final DateTime? lastEnterTime;
  final DateTime? lastExitTime;
  final bool isMonitoring;
  final String? currentLocationId;

  const GeofenceState({
    this.status = GeofenceStatus.unknown,
    this.lastEnterTime,
    this.lastExitTime,
    this.isMonitoring = false,
    this.currentLocationId,
  });

  GeofenceState copyWith({
    GeofenceStatus? status,
    DateTime? lastEnterTime,
    DateTime? lastExitTime,
    bool? isMonitoring,
    String? currentLocationId,
    bool clearCurrentLocationId = false,
  }) {
    return GeofenceState(
      status: status ?? this.status,
      lastEnterTime: lastEnterTime ?? this.lastEnterTime,
      lastExitTime: lastExitTime ?? this.lastExitTime,
      isMonitoring: isMonitoring ?? this.isMonitoring,
      currentLocationId: clearCurrentLocationId
          ? null
          : (currentLocationId ?? this.currentLocationId),
    );
  }
}

final geofenceStateProvider =
    NotifierProvider<GeofenceStateNotifier, GeofenceState>(
        GeofenceStateNotifier.new);

class GeofenceStateNotifier extends Notifier<GeofenceState> {
  @override
  GeofenceState build() {
    return const GeofenceState();
  }

  void setStatus(GeofenceStatus status) {
    state = state.copyWith(status: status);
  }

  void setEnterTime(DateTime time, {String? locationId}) {
    state = state.copyWith(
      status: GeofenceStatus.inside,
      lastEnterTime: time,
      currentLocationId: locationId,
    );
  }

  void setExitTime(DateTime time) {
    state = state.copyWith(
      status: GeofenceStatus.outside,
      lastExitTime: time,
      clearCurrentLocationId: true,
    );
  }

  void setMonitoring(bool monitoring) {
    state = state.copyWith(isMonitoring: monitoring);
  }
}
