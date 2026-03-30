import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_in_reminder/core/theme.dart';
import 'package:check_in_reminder/core/router.dart';
import 'package:check_in_reminder/providers/settings_provider.dart';
import 'package:check_in_reminder/main.dart' show initGeofenceService;
import 'package:check_in_reminder/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool _geofenceInitialized = false;
  GoRouter? _router;
  bool? _lastOnboardingCompleted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_geofenceInitialized) {
        _geofenceInitialized = true;
        final container = ProviderScope.containerOf(context);
        initGeofenceService(container);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingCompleted = ref.watch(
      settingsProvider.select((s) => s.onboardingCompleted),
    );
    final themeModeSetting = ref.watch(
      settingsProvider.select((s) => s.themeMode),
    );

    // Only rebuild router when onboardingCompleted changes
    if (_router == null || _lastOnboardingCompleted != onboardingCompleted) {
      _lastOnboardingCompleted = onboardingCompleted;
      _router = createRouter(onboardingCompleted: onboardingCompleted);
    }

    final themeMode = switch (themeModeSetting) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return MaterialApp.router(
      title: 'Check-in Reminder',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router!,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
