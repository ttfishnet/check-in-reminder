import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/attendance_app.dart';
import 'package:check_in_reminder/providers/attendance_app_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class AttendanceAppsPage extends ConsumerWidget {
  const AttendanceAppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final apps = ref.watch(attendanceAppProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.attendanceAppsTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAppDialog(context, ref, null, l10n),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return ListTile(
            leading: const Icon(Icons.apps),
            title: Text(app.name),
            subtitle: Text(app.scheme),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showAppDialog(context, ref, app, l10n),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: app.isBuiltin
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(l10n.cannotDeleteBuiltinApp)),
                          );
                        }
                      : () => _confirmDelete(context, ref, app, l10n),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      AttendanceApp app, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteLocationConfirm(app.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(attendanceAppProvider.notifier)
                  .removeAttendanceApp(app.key);
              Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAppDialog(BuildContext context, WidgetRef ref,
      AttendanceApp? existing, AppLocalizations l10n) {
    final nameController =
        TextEditingController(text: existing?.name ?? '');
    final schemeController =
        TextEditingController(text: existing?.scheme ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing != null
            ? l10n.editAttendanceApp
            : l10n.addAttendanceApp),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.appName,
                    hintText: l10n.appNameHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.appNameRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: schemeController,
                  decoration: InputDecoration(
                    labelText: l10n.urlScheme,
                    hintText: l10n.urlSchemeHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.urlSchemeRequired
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              final key = existing?.key ??
                  nameController.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(RegExp(r'[^a-z0-9]'), '_');

              final app = AttendanceApp(
                key: key,
                name: nameController.text.trim(),
                scheme: schemeController.text.trim(),
                isBuiltin: existing?.isBuiltin ?? false,
              );

              if (existing != null) {
                ref
                    .read(attendanceAppProvider.notifier)
                    .updateAttendanceApp(app);
              } else {
                ref
                    .read(attendanceAppProvider.notifier)
                    .addAttendanceApp(app);
              }
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
