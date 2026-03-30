import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/features/home/widgets/status_card.dart';
import 'package:check_in_reminder/features/home/widgets/map_view.dart';
import 'package:check_in_reminder/features/home/widgets/today_records.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusCard(),
            SizedBox(height: 16),
            MapView(),
            SizedBox(height: 16),
            TodayRecords(),
          ],
        ),
      ),
    );
  }
}
