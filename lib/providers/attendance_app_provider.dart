import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/attendance_app.dart';
import 'package:check_in_reminder/providers/location_provider.dart';

final attendanceAppProvider =
    NotifierProvider<AttendanceAppNotifier, List<AttendanceApp>>(
        AttendanceAppNotifier.new);

class AttendanceAppNotifier extends Notifier<List<AttendanceApp>> {
  @override
  List<AttendanceApp> build() {
    return ref.read(storageServiceProvider).getAttendanceApps();
  }

  Future<void> addAttendanceApp(AttendanceApp app) async {
    await ref.read(storageServiceProvider).saveAttendanceApp(app);
    state = ref.read(storageServiceProvider).getAttendanceApps();
  }

  Future<void> updateAttendanceApp(AttendanceApp app) async {
    await ref.read(storageServiceProvider).saveAttendanceApp(app);
    state = ref.read(storageServiceProvider).getAttendanceApps();
  }

  Future<void> removeAttendanceApp(String key) async {
    await ref.read(storageServiceProvider).deleteAttendanceApp(key);
    state = ref.read(storageServiceProvider).getAttendanceApps();
  }
}
