import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/location_type.dart';
import 'package:check_in_reminder/providers/location_type_provider.dart';
import 'package:check_in_reminder/providers/location_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class LocationTypesPage extends ConsumerWidget {
  const LocationTypesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final types = ref.watch(locationTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.locationTypesTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTypeDialog(context, ref, null, l10n),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          return ListTile(
            leading: const Icon(Icons.label),
            title: Text(type.label),
            subtitle: Text('${type.enterText} / ${type.exitText}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showTypeDialog(context, ref, type, l10n),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: type.isBuiltin
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(l10n.cannotDeleteBuiltin)),
                          );
                        }
                      : () => _confirmDelete(context, ref, type, l10n),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref,
      LocationType type, AppLocalizations l10n) {
    // Check if any location is using this type
    final locations = ref.read(locationProvider);
    final usageCount =
        locations.where((l) => l.locationType == type.key).length;
    if (usageCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.typeInUse(usageCount))),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteLocationConfirm(type.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(locationTypeProvider.notifier).removeLocationType(type.key);
              Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showTypeDialog(BuildContext context, WidgetRef ref,
      LocationType? existing, AppLocalizations l10n) {
    final labelController =
        TextEditingController(text: existing?.label ?? '');
    final enterController =
        TextEditingController(text: existing?.enterText ?? '');
    final exitController =
        TextEditingController(text: existing?.exitText ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            existing != null ? l10n.editLocationType : l10n.addLocationType),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: l10n.typeLabel,
                    hintText: l10n.typeLabelHint,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.labelRequired : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: enterController,
                  decoration: InputDecoration(
                    labelText: l10n.enterText,
                    hintText: l10n.enterTextHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.enterTextRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: exitController,
                  decoration: InputDecoration(
                    labelText: l10n.exitText,
                    hintText: l10n.exitTextHint,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.exitTextRequired
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
                  labelController.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(RegExp(r'[^a-z0-9]'), '_');

              final type = LocationType(
                key: key,
                label: labelController.text.trim(),
                enterText: enterController.text.trim(),
                exitText: exitController.text.trim(),
                isBuiltin: existing?.isBuiltin ?? false,
              );

              if (existing != null) {
                ref.read(locationTypeProvider.notifier).updateLocationType(type);
              } else {
                ref.read(locationTypeProvider.notifier).addLocationType(type);
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
