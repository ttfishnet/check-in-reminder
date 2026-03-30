import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class PermissionStatusPage extends StatefulWidget {
  const PermissionStatusPage({super.key});

  @override
  State<PermissionStatusPage> createState() => _PermissionStatusPageState();
}

class _PermissionStatusPageState extends State<PermissionStatusPage> {
  PermissionStatus? _locationWhenInUse;
  PermissionStatus? _locationAlways;
  PermissionStatus? _notification;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final locWhenInUse = await Permission.location.status;
    final locAlways = await Permission.locationAlways.status;
    final notif = await Permission.notification.status;

    if (mounted) {
      setState(() {
        _locationWhenInUse = locWhenInUse;
        _locationAlways = locAlways;
        _notification = notif;
      });
    }
  }

  /// Merge locationAlways + locationWhenInUse into a combined status description
  (String, Color, IconData) _locationStatusInfo(AppLocalizations l10n) {
    if (_locationAlways == null && _locationWhenInUse == null) {
      return (l10n.permNotRequested, Colors.grey, Icons.circle_outlined);
    }
    if (_locationAlways == PermissionStatus.granted) {
      return (l10n.permLocationGrantedAlways, Colors.green, Icons.check_circle);
    }
    if (_locationWhenInUse == PermissionStatus.granted) {
      return (l10n.permLocationGrantedWhenInUse, Colors.orange, Icons.warning_amber_rounded);
    }
    return (l10n.permDenied, Colors.red, Icons.cancel);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isIOS = Platform.isIOS;
    final (locStatusText, locStatusColor, locStatusIcon) = _locationStatusInfo(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionStatusTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshPermissions,
            onPressed: _checkPermissions,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PermissionCard(
            icon: Icons.location_on,
            title: l10n.permLocation,
            statusText: locStatusText,
            statusColor: locStatusColor,
            statusIcon: locStatusIcon,
            helpText: _locationAlways != PermissionStatus.granted
                ? (isIOS ? l10n.permLocationHelpiOS : l10n.permLocationHelpAndroid)
                : null,
          ),
          const SizedBox(height: 12),
          _PermissionCard(
            icon: Icons.notifications,
            title: l10n.permNotification,
            statusText: _notificationStatusText(l10n),
            statusColor: _notificationStatusColor(),
            statusIcon: _notificationStatusIcon(),
            helpText: _notification != null && _notification != PermissionStatus.granted
                ? (isIOS ? l10n.permNotificationHelpiOS : l10n.permNotificationHelpAndroid)
                : null,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => openAppSettings(),
            icon: const Icon(Icons.settings),
            label: Text(l10n.openSystemSettings),
          ),
        ],
      ),
    );
  }

  String _notificationStatusText(AppLocalizations l10n) => switch (_notification) {
        PermissionStatus.granted => l10n.permGranted,
        PermissionStatus.denied ||
        PermissionStatus.permanentlyDenied ||
        PermissionStatus.restricted =>
          l10n.permDenied,
        _ => l10n.permNotRequested,
      };

  Color _notificationStatusColor() => switch (_notification) {
        PermissionStatus.granted => Colors.green,
        PermissionStatus.denied ||
        PermissionStatus.permanentlyDenied ||
        PermissionStatus.restricted =>
          Colors.red,
        _ => Colors.grey,
      };

  IconData _notificationStatusIcon() => switch (_notification) {
        PermissionStatus.granted => Icons.check_circle,
        PermissionStatus.denied ||
        PermissionStatus.permanentlyDenied ||
        PermissionStatus.restricted =>
          Icons.cancel,
        _ => Icons.circle_outlined,
      };
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String statusText;
  final Color statusColor;
  final IconData statusIcon;
  final String? helpText;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.statusIcon,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (helpText != null) ...[
              const SizedBox(height: 8),
              Text(
                helpText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
