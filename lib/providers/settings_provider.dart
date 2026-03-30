import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/models/app_settings.dart';
import 'package:check_in_reminder/providers/location_provider.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.read(storageServiceProvider).getSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await ref.read(storageServiceProvider).saveSettings(settings);
    state = settings;
  }

  Future<void> completeOnboarding() async {
    final updated = state.copyWith(onboardingCompleted: true);
    await updateSettings(updated);
  }

  Future<void> resetOnboarding() async {
    final updated = state.copyWith(onboardingCompleted: false);
    await updateSettings(updated);
  }
}
