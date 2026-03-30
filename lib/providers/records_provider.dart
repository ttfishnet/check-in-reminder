import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/check_record.dart';
import 'package:check_in_reminder/providers/location_provider.dart';

final recordsProvider =
    NotifierProvider<RecordsNotifier, List<CheckRecord>>(RecordsNotifier.new);

class RecordsNotifier extends Notifier<List<CheckRecord>> {
  @override
  List<CheckRecord> build() {
    return ref.read(storageServiceProvider).getRecords();
  }

  Future<void> addRecord(CheckRecord record) async {
    await ref.read(storageServiceProvider).saveRecord(record);
    state = ref.read(storageServiceProvider).getRecords();
  }

  List<CheckRecord> getRecordsByDate(DateTime date) {
    return state.where((r) {
      return r.timestamp.year == date.year &&
          r.timestamp.month == date.month &&
          r.timestamp.day == date.day;
    }).toList();
  }

  void refresh() {
    state = ref.read(storageServiceProvider).getRecords();
  }

  Future<void> markAsClicked(String recordId) async {
    final storage = ref.read(storageServiceProvider);
    final target = state.where((r) => r.id == recordId).firstOrNull;
    if (target != null && !target.notifyClicked) {
      await storage.updateRecord(target.copyWith(notifyClicked: true));
      refresh();
    }
  }
}

final todayRecordsProvider = Provider<List<CheckRecord>>((ref) {
  final records = ref.watch(recordsProvider);
  final now = DateTime.now();
  return records.where((r) {
    return r.timestamp.year == now.year &&
        r.timestamp.month == now.month &&
        r.timestamp.day == now.day;
  }).toList();
});
