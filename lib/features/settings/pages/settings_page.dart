import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:check_in_reminder/providers/settings_provider.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/providers/location_type_provider.dart';
import 'package:check_in_reminder/providers/attendance_app_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final locations = ref.watch(locationProvider);
    final locationTypes = ref.watch(locationTypeProvider);
    final attendanceApps = ref.watch(attendanceAppProvider);

    // Group locations by type
    final groupedLocations = <String, List<dynamic>>{};
    for (final loc in locations) {
      groupedLocations.putIfAbsent(loc.locationType, () => []).add(loc);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          // Locations (grouped by type)
          ...groupedLocations.entries.map((entry) {
            final typeKey = entry.key;
            final locs = entry.value;
            final typeObj = locationTypes.where((t) => t.key == typeKey).firstOrNull;
            final typeLabel = typeObj?.label ?? typeKey;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: typeLabel),
                ...locs.map((loc) => ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(loc.name),
                      subtitle: Text(l10n.radiusLabel(loc.radiusMeters)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: loc.isActive,
                            onChanged: (value) {
                              ref.read(locationProvider.notifier).updateLocation(
                                    loc.copyWith(isActive: value),
                                  );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDeleteLocation(
                                context, ref, loc.id, loc.name, l10n),
                          ),
                        ],
                      ),
                      onTap: () => context.push('/add-location', extra: loc),
                    )),
              ],
            );
          }),
          if (groupedLocations.isEmpty)
            _SectionHeader(title: l10n.companyLocation),
          ListTile(
            leading: const Icon(Icons.add_location_alt),
            title: Text(l10n.addLocation),
            subtitle: Text(l10n.addLocationSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/add-location'),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(l10n.manageLocationTypes),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/location-types'),
          ),

          const Divider(),

          // Notification settings
          _SectionHeader(title: l10n.notificationSettings),
          SwitchListTile(
            title: Text(l10n.notifyOnEnter),
            subtitle: Text(l10n.notifyOnEnterSub),
            value: settings.notifyOnEnter,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(notifyOnEnter: value),
                  );
            },
          ),
          SwitchListTile(
            title: Text(l10n.notifyOnExit),
            subtitle: Text(l10n.notifyOnExitSub),
            value: settings.notifyOnExit,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(notifyOnExit: value),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: Text(l10n.cooldownTime),
            subtitle: Text(l10n.cooldownTimeSub),
            trailing: DropdownButton<int>(
              value: settings.cooldownMinutes,
              underline: const SizedBox.shrink(),
              items: [30, 60, 90, 120, 180, 240]
                  .map((v) => DropdownMenuItem(
                      value: v, child: Text(l10n.minutes(v))))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(cooldownMinutes: v),
                      );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: Text(l10n.reRemindInterval),
            subtitle: Text(l10n.reRemindIntervalSub),
            trailing: DropdownButton<int>(
              value: settings.reRemindMinutes,
              underline: const SizedBox.shrink(),
              items: [1, 2, 3, 5, 10, 15]
                  .map((v) => DropdownMenuItem(
                      value: v, child: Text(l10n.minutes(v))))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(reRemindMinutes: v),
                      );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.looks_one),
            title: Text(l10n.maxRemindCount),
            subtitle: Text(l10n.maxRemindCountSub),
            trailing: DropdownButton<int>(
              value: settings.maxRemindCount,
              underline: const SizedBox.shrink(),
              items: [1, 2, 3, 4, 5]
                  .map((v) => DropdownMenuItem(
                      value: v, child: Text(l10n.times(v))))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(maxRemindCount: v),
                      );
                }
              },
            ),
          ),

          const Divider(),

          // Attendance app
          _SectionHeader(title: l10n.attendanceApp),
          RadioGroup<String>(
            groupValue: settings.attendanceApp,
            onChanged: (v) {
              if (v != null) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(attendanceApp: v),
                    );
              }
            },
            child: Column(
              children: attendanceApps.map((app) => RadioListTile<String>(
                    title: Text(app.name),
                    value: app.key,
                  )).toList(),
            ),
          ),

          const Divider(),
          _SectionHeader(title: l10n.workDays),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final dayNames = [
                  l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu,
                  l10n.dayFri, l10n.daySat, l10n.daySun,
                ];
                final day = i + 1;
                final isSelected = settings.workDays.contains(day);
                return FilterChip(
                  label: Text(dayNames[i]),
                  selected: isSelected,
                  onSelected: (selected) {
                    final newDays = List<int>.from(settings.workDays);
                    selected ? newDays.add(day) : newDays.remove(day);
                    newDays.sort();
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(workDays: newDays),
                        );
                  },
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.business, size: 18),
                  label: Text(l10n.monToFri),
                  onPressed: () {
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(workDays: [1, 2, 3, 4, 5]),
                        );
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.work_history, size: 18),
                  label: Text(l10n.monToSat),
                  onPressed: () {
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(workDays: [1, 2, 3, 4, 5, 6]),
                        );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // Silent period
          _SectionHeader(title: l10n.silentPeriod),
          ...settings.silentPeriods.asMap().entries.map((entry) {
            final index = entry.key;
            final period = entry.value;
            final parts = period.split('-');
            final start = parts.isNotEmpty ? parts[0] : '';
            final end = parts.length > 1 ? parts[1] : '';
            return ListTile(
              leading: const Icon(Icons.do_not_disturb),
              title: Text('$start ~ $end'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: settings.silentPeriods.length <= 1
                    ? null
                    : () {
                        final updated =
                            List<String>.from(settings.silentPeriods)
                              ..removeAt(index);
                        ref.read(settingsProvider.notifier).updateSettings(
                              settings.copyWith(silentPeriods: updated),
                            );
                      },
              ),
              onTap: () async {
                final result = await _pickSilentPeriod(context, period, l10n);
                if (result != null) {
                  final updated =
                      List<String>.from(settings.silentPeriods)
                        ..[index] = result;
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(silentPeriods: updated),
                      );
                }
              },
            );
          }),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l10n.addSilentPeriod),
            onTap: () async {
              final result = await _pickSilentPeriod(context, null, l10n);
              if (result != null) {
                final updated =
                    List<String>.from(settings.silentPeriods)..add(result);
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(silentPeriods: updated),
                    );
              }
            },
          ),

          const Divider(),

          // Appearance

          _SectionHeader(title: l10n.appearance),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.themeMode),
            trailing: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'system', label: Text(l10n.themeAuto)),
                ButtonSegment(value: 'light', label: Text(l10n.themeLight)),
                ButtonSegment(value: 'dark', label: Text(l10n.themeDark)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (v) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(themeMode: v.first),
                    );
              },
            ),
          ),
          SwitchListTile(
            title: Text(l10n.hapticFeedback),
            subtitle: Text(l10n.hapticFeedbackSub),
            secondary: const Icon(Icons.vibration),
            value: settings.hapticEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(hapticEnabled: value),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(l10n.notificationSound),
            trailing: DropdownButton<String>(
              value: settings.notificationSound == 'silent'
                  ? 'silent'
                  : 'default',
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                    value: 'default', child: Text(l10n.soundDefault)),
                DropdownMenuItem(
                    value: 'silent', child: Text(l10n.soundSilent)),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(notificationSound: v),
                      );
                }
              },
            ),
          ),

          const Divider(),

          // Keep alive & permissions
          ListTile(
            leading: const Icon(Icons.battery_saver),
            title: Text(l10n.keepAliveGuide),
            subtitle: Text(l10n.keepAliveGuideSub),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/keep-alive'),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(l10n.permissionStatusTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/permissions'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Confirm location deletion
void _confirmDeleteLocation(
    BuildContext context, WidgetRef ref, String id, String name,
    AppLocalizations l10n) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteLocation),
      content: Text(l10n.deleteLocationConfirm(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            ref.read(locationProvider.notifier).removeLocation(id);
            Navigator.pop(context);
          },
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
}

/// Show two time pickers to select the start and end of a silent period.
/// [initial] is an existing period string (e.g. "22:00-06:00"), null for new.
Future<String?> _pickSilentPeriod(
    BuildContext context, String? initial, AppLocalizations l10n) async {
  TimeOfDay initialStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay initialEnd = const TimeOfDay(hour: 6, minute: 0);

  if (initial != null) {
    final parts = initial.split('-');
    if (parts.length == 2) {
      initialStart = _parseTimeOfDay(parts[0]);
      initialEnd = _parseTimeOfDay(parts[1]);
    }
  }

  final start = await showTimePicker(
    context: context,
    initialTime: initialStart,
    helpText: l10n.silentStartHelp,
  );
  if (start == null || !context.mounted) return null;

  final end = await showTimePicker(
    context: context,
    initialTime: initialEnd,
    helpText: l10n.silentEndHelp,
  );
  if (end == null) return null;

  final startStr =
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
  final endStr =
      '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  return '$startStr-$endStr';
}

TimeOfDay _parseTimeOfDay(String timeStr) {
  final parts = timeStr.split(':');
  return TimeOfDay(
    hour: int.tryParse(parts[0]) ?? 0,
    minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
