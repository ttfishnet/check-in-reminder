import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:check_in_reminder/features/onboarding/pages/onboarding_page.dart';
import 'package:check_in_reminder/features/home/pages/home_page.dart';
import 'package:check_in_reminder/features/records/pages/records_page.dart';
import 'package:check_in_reminder/features/statistics/pages/statistics_page.dart';
import 'package:check_in_reminder/features/settings/pages/settings_page.dart';
import 'package:check_in_reminder/features/keep_alive/pages/keep_alive_guide_page.dart';
import 'package:check_in_reminder/features/settings/pages/add_location_page.dart';
import 'package:check_in_reminder/features/settings/pages/location_types_page.dart';
import 'package:check_in_reminder/features/settings/pages/map_picker_page.dart';
import 'package:check_in_reminder/features/settings/pages/attendance_apps_page.dart';
import 'package:check_in_reminder/features/settings/pages/permission_status_page.dart';
import 'package:check_in_reminder/features/settings/pages/debug_tools_page.dart';
import 'package:check_in_reminder/models/company_location.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

GoRouter createRouter({required bool onboardingCompleted}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingCompleted ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/records',
            builder: (context, state) => const RecordsPage(),
          ),
          GoRoute(
            path: '/statistics',
            builder: (context, state) => const StatisticsPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          if (kDebugMode)
            GoRoute(
              path: '/debug-tools',
              builder: (context, state) => const DebugToolsPage(),
            ),
        ],
      ),
      GoRoute(
        path: '/keep-alive',
        builder: (context, state) => const KeepAliveGuidePage(),
      ),
      GoRoute(
        path: '/add-location',
        builder: (context, state) {
          final location = state.extra as CompanyLocation?;
          return AddLocationPage(editingLocation: location);
        },
      ),
      GoRoute(
        path: '/location-types',
        builder: (context, state) => const LocationTypesPage(),
      ),
      GoRoute(
        path: '/map-picker',
        builder: (context, state) {
          final initial = state.extra as LatLng?;
          return MapPickerPage(initialLocation: initial);
        },
      ),
      GoRoute(
        path: '/attendance-apps',
        builder: (context, state) => const AttendanceAppsPage(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionStatusPage(),
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.records,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
          if (kDebugMode)
            NavigationDestination(
              icon: const Icon(Icons.bug_report_outlined),
              selectedIcon: const Icon(Icons.bug_report),
              label: l10n.debugTools,
            ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/records')) return 1;
    if (location.startsWith('/statistics')) return 2;
    if (location.startsWith('/settings')) return 3;
    if (kDebugMode && location.startsWith('/debug-tools')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/records');
      case 2:
        context.go('/statistics');
      case 3:
        context.go('/settings');
      case 4:
        context.go('/debug-tools');
    }
  }
}
