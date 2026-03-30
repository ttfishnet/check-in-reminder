import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:check_in_reminder/providers/settings_provider.dart';
import 'package:check_in_reminder/providers/attendance_app_provider.dart';
import 'package:check_in_reminder/l10n/app_localizations.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pageCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: const [
                  _WelcomePage(),
                  _LocationSetupPage(),
                  _AppSelectorPage(),
                  _PermissionPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  Row(
                    children: List.generate(_pageCount, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.3),
                        ),
                      );
                    }),
                  ),
                  // Next/Done button
                  FilledButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pageCount - 1
                          ? l10n.getStarted
                          : l10n.nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.onboardingWelcome,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingWelcomeSub,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSetupPage extends StatelessWidget {
  const _LocationSetupPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.setupLocation,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.setupLocationSub,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                context.push('/add-location');
              },
              icon: const Icon(Icons.add_location_alt),
              label: Text(l10n.selectLocation),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSelectorPage extends ConsumerStatefulWidget {
  const _AppSelectorPage();

  @override
  ConsumerState<_AppSelectorPage> createState() => _AppSelectorPageState();
}

class _AppSelectorPageState extends ConsumerState<_AppSelectorPage> {
  late String _selectedApp;

  @override
  void initState() {
    super.initState();
    _selectedApp = ref.read(settingsProvider).attendanceApp;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final apps = ref.watch(attendanceAppProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apps,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.selectApp,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectAppSub,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            ...apps.map((app) {
              final icon = switch (app.key) {
                'dingtalk' => Icons.chat,
                'wxwork' => Icons.work,
                'lark' => Icons.flight,
                _ => Icons.apps,
              };
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: RadioListTile<String>(
                  title: Text(app.name),
                  secondary: Icon(icon),
                  value: app.key,
                  groupValue: _selectedApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onChanged: (v) {
                    setState(() => _selectedApp = v!);
                    final settings = ref.read(settingsProvider);
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(attendanceApp: v!),
                        );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PermissionPage extends StatefulWidget {
  const _PermissionPage();

  @override
  State<_PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<_PermissionPage> {
  bool? _locationGranted;
  bool? _notificationGranted;
  bool _requesting = false;

  Future<void> _requestPermissions() async {
    setState(() => _requesting = true);

    // 1. Request location permission
    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      // Try to request "always allow"
      await Permission.locationAlways.request();
    }

    // 2. Request notification permission
    await Permission.notification.request();

    // 3. Check final permission status
    final locGranted = await Permission.location.isGranted;
    final notifGranted = await Permission.notification.isGranted;

    if (mounted) {
      setState(() {
        _locationGranted = locGranted;
        _notificationGranted = notifGranted;
        _requesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.permissionAuth,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.permissionAuthSub,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),

            // Permission status list
            _PermissionItem(
              icon: Icons.location_on,
              label: l10n.locationPermission,
              granted: _locationGranted,
            ),
            const SizedBox(height: 12),
            _PermissionItem(
              icon: Icons.notifications,
              label: l10n.notificationPermission,
              granted: _notificationGranted,
            ),

            const SizedBox(height: 32),

            if (_locationGranted == null) ...[
              // Not yet requested
              FilledButton.icon(
                onPressed: _requesting ? null : _requestPermissions,
                icon: _requesting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_requesting ? l10n.requesting : l10n.grantPermission),
              ),
            ] else if (_locationGranted == false ||
                _notificationGranted == false) ...[
              // Some permissions denied
              OutlinedButton.icon(
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings),
                label: Text(l10n.goToSettings),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool? granted;

  const _PermissionItem({
    required this.icon,
    required this.label,
    required this.granted,
  });

  @override
  Widget build(BuildContext context) {
    final statusIcon = switch (granted) {
      true => Icon(Icons.check_circle, color: Colors.green),
      false => Icon(Icons.cancel, color: Colors.red),
      null => Icon(Icons.circle_outlined,
          color: Theme.of(context).colorScheme.outline),
    };

    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: statusIcon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
