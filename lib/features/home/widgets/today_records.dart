import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:check_in_reminder/providers/records_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class TodayRecords extends ConsumerWidget {
  const TodayRecords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final records = ref.watch(todayRecordsProvider);
    final timeFormat = DateFormat('HH:mm:ss');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.todayRecords,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (records.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noRecordsToday,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final record = records[index];
                final isEnter = record.type == 'enter';
                return ListTile(
                  leading: Icon(
                    isEnter ? Icons.login : Icons.logout,
                    color: isEnter ? Colors.green : Colors.orange,
                  ),
                  title: Text(isEnter
                      ? l10n.enterRangeRecord
                      : l10n.exitRangeRecord),
                  subtitle: Text(timeFormat.format(record.timestamp)),
                  trailing: record.notifyClicked
                      ? const Icon(Icons.check_circle,
                          color: Colors.green, size: 20)
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }
}
