import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:check_in_reminder/providers/records_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class RecordsPage extends ConsumerStatefulWidget {
  const RecordsPage({super.key});

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allRecords = ref.watch(recordsProvider);
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    // Filter by selected date
    final dayRecords = allRecords.where((r) {
      return r.timestamp.year == _selectedDate.year &&
          r.timestamp.month == _selectedDate.month &&
          r.timestamp.day == _selectedDate.day;
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recordsTitle),
      ),
      body: Column(
        children: [
          // Date picker
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate =
                            _selectedDate.subtract(const Duration(days: 1));
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: Text(
                      dateFormat.format(_selectedDate),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: _selectedDate.isBefore(DateTime.now())
                        ? () {
                            setState(() {
                              _selectedDate =
                                  _selectedDate.add(const Duration(days: 1));
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          // Records list
          Expanded(
            child: dayRecords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noRecordsOnDate,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dayRecords.length,
                    itemBuilder: (context, index) {
                      final record = dayRecords[index];
                      final isEnter = record.type == 'enter';
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isEnter
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            child: Icon(
                              isEnter ? Icons.login : Icons.logout,
                              color: isEnter ? Colors.green : Colors.orange,
                            ),
                          ),
                          title: Text(isEnter
                              ? l10n.enterRangeRecord
                              : l10n.exitRangeRecord),
                          subtitle:
                              Text(timeFormat.format(record.timestamp)),
                          trailing: record.notifyClicked
                              ? Chip(label: Text(l10n.punched))
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
