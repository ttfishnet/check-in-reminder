# Check-in Reminder

[![CI](https://github.com/ttfishnet/check-in-reminder/actions/workflows/ci.yml/badge.svg)](https://github.com/ttfishnet/check-in-reminder/actions/workflows/ci.yml)

A smart Flutter app that reminds you to clock in/out based on geofencing and Wi-Fi detection.

## Features

- **Geofence Reminders** — Triggers clock-in/out prompts when entering or leaving the workplace area
- **Wi-Fi Awareness** — Detects connection/disconnection from the office Wi-Fi
- **Local Notifications** — Fully offline, no backend required
- **Attendance Records** — Logs and summarizes daily check-in/out times
- **Holiday Support** — Automatically skips public holidays to avoid false alerts
- **Home Screen Widget** — Quick status view from the home screen
- **Internationalization** — Chinese and English supported

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.x / Dart 3.x |
| State Management | flutter_riverpod 3.x (Notifier) |
| Routing | go_router 17.x |
| Local Storage | hive_ce + hive_ce_flutter |
| Maps | flutter_map + OpenStreetMap (no API key required) |
| Notifications | flutter_local_notifications 21.x |
| Geofencing | flutter_background_geolocation |
| Wi-Fi | network_info_plus |
| Home Widget | home_widget |
| i18n | flutter_localizations + gen-l10n |

## Getting Started

### Requirements

- Flutter 3.x / Dart 3.x
- iOS 14+ / Android 8+ (API 26+)

### Setup

```bash
# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run code generation (Freezed, Hive, JSON)
dart run build_runner build --delete-conflicting-outputs

# Run on iOS simulator
flutter build ios --simulator --debug

# Run on Android
flutter run
```

### iOS — Additional Step

```bash
cd ios && pod install
```

## Project Structure

```
lib/
├── core/          # Constants, theme, router
├── models/        # Freezed data models
├── services/      # Business services (storage, notifications, geofence, Wi-Fi, etc.)
├── providers/     # Riverpod state management
├── features/      # UI pages (home, records, statistics, settings)
└── l10n/          # Localization ARB files
```

## Notes

- Pure local app — no backend or cloud dependency
- Geofencing requires "Always Allow" location permission
- iOS WidgetKit extension requires manual setup in Xcode
