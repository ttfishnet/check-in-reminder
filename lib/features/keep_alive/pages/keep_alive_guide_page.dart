import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:check_in_reminder/l10n/app_localizations.dart';

class KeepAliveGuidePage extends StatelessWidget {
  const KeepAliveGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAndroid = Platform.isAndroid;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.keepAliveGuide),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.keepAliveWhyTitle,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.keepAliveWhyDesc),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isAndroid) ...[
            _GuideStep(
              step: 1,
              title: l10n.keepAliveAndroidStep1Title,
              description: l10n.keepAliveAndroidStep1Desc,
            ),
            _GuideStep(
              step: 2,
              title: l10n.keepAliveAndroidStep2Title,
              description: l10n.keepAliveAndroidStep2Desc,
            ),
            _GuideStep(
              step: 3,
              title: l10n.keepAliveAndroidStep3Title,
              description: l10n.keepAliveAndroidStep3Desc,
            ),
          ] else ...[
            _GuideStep(
              step: 1,
              title: l10n.keepAliveiOSStep1Title,
              description: l10n.keepAliveiOSStep1Desc,
            ),
            _GuideStep(
              step: 2,
              title: l10n.keepAliveiOSStep2Title,
              description: l10n.keepAliveiOSStep2Desc,
            ),
          ],
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final int step;
  final String title;
  final String description;

  const _GuideStep({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$step',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description),
        ),
      ),
    );
  }
}
