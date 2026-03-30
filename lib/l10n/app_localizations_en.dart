// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Check-in Reminder';

  @override
  String get home => 'Home';

  @override
  String get records => 'Records';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get statusInside => 'Inside range';

  @override
  String get statusOutside => 'Outside range';

  @override
  String get monitoring => 'Monitoring';

  @override
  String get notMonitoring => 'Not started';

  @override
  String get todayRecords => 'Today\'s Records';

  @override
  String get noRecordsToday => 'No records today';

  @override
  String get enterRange => 'Entered range';

  @override
  String get exitRange => 'Left range';

  @override
  String get punched => 'Punched';

  @override
  String get noRecordsOnDate => 'No records on this date';

  @override
  String get weekView => 'Week';

  @override
  String get monthView => 'Month';

  @override
  String get weekArrival => 'This Week Arrivals';

  @override
  String get monthArrival => 'This Month Arrivals';

  @override
  String get lateThresholdHint => 'Arrival after 9:30 is marked as late';

  @override
  String get noData => 'No data';

  @override
  String get attendanceDays => 'Attendance';

  @override
  String get avgArrival => 'Avg. Arrival';

  @override
  String get lateDays => 'Late';

  @override
  String get forgotPunch => 'Missed';

  @override
  String get detail => 'Details';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get companyLocation => 'Locations';

  @override
  String get addLocation => 'Add Location';

  @override
  String get addLocationSubtitle => 'Set a new location and geofence';

  @override
  String get deleteLocation => 'Delete Location';

  @override
  String deleteLocationConfirm(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get notifyOnEnter => 'Notify on Enter';

  @override
  String get notifyOnEnterSub => 'Push notification when entering range';

  @override
  String get notifyOnExit => 'Notify on Exit';

  @override
  String get notifyOnExitSub => 'Push notification when leaving range';

  @override
  String get cooldownTime => 'Cooldown Time';

  @override
  String get cooldownTimeSub =>
      'Minimum interval between same-type notifications';

  @override
  String get reRemindInterval => 'Re-remind Interval';

  @override
  String get reRemindIntervalSub => 'Interval between repeated reminders';

  @override
  String get maxRemindCount => 'Max Reminders';

  @override
  String get maxRemindCountSub =>
      'Total number of reminders including the first';

  @override
  String minutes(Object count) {
    return '$count min';
  }

  @override
  String times(Object count) {
    return '$count times';
  }

  @override
  String get attendanceApp => 'Attendance App';

  @override
  String get workDays => 'Work Days';

  @override
  String get monToFri => 'Mon-Fri';

  @override
  String get monToSat => 'Mon-Sat';

  @override
  String get silentPeriod => 'Silent Period';

  @override
  String get addSilentPeriod => 'Add Silent Period';

  @override
  String get silentStartHelp => 'Select silent start time';

  @override
  String get silentEndHelp => 'Select silent end time';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get hapticFeedbackSub => 'Vibrate on reminder';

  @override
  String get notificationSound => 'Sound';

  @override
  String get soundDefault => 'Default';

  @override
  String get soundGentle => 'Gentle';

  @override
  String get soundUrgent => 'Urgent';

  @override
  String get soundSilent => 'Silent';

  @override
  String get keepAliveGuide => 'Keep Alive Guide';

  @override
  String get keepAliveGuideSub => 'Ensure the app runs in background';

  @override
  String get onboardingWelcome => 'Check-in Reminder';

  @override
  String get onboardingWelcomeSub =>
      'Smart geofence-based check-in reminder\nAutomatically reminds you to punch in/out';

  @override
  String get setupLocation => 'Set Location';

  @override
  String get setupLocationSub =>
      'Select your company location\nand set geofence radius';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get selectApp => 'Select App';

  @override
  String get selectAppSub => 'One tap to open the app after reminder';

  @override
  String get permissionAuth => 'Permissions';

  @override
  String get permissionAuthSub => 'The following permissions are required:';

  @override
  String get locationPermission => 'Location (Always Allow)';

  @override
  String get notificationPermission => 'Notifications';

  @override
  String get grantPermission => 'Grant Permissions';

  @override
  String get requesting => 'Requesting...';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get nextStep => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get editLocation => 'Edit Location';

  @override
  String get locationName => 'Name';

  @override
  String get locationNameHint => 'e.g. HQ Building';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get gettingLocation => 'Getting location...';

  @override
  String get manualInput => 'Enter Manually';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get fenceRadius => 'Fence Radius';

  @override
  String get wifiAssist => 'Wi-Fi Assist';

  @override
  String get bindCurrentWifi => 'Bind Current Wi-Fi';

  @override
  String get noWifiDetected => 'No Wi-Fi detected';

  @override
  String wifiAlreadyBound(Object ssid) {
    return 'Already bound: $ssid';
  }

  @override
  String get locationType => 'Location Type';

  @override
  String get saveLocation => 'Save Location';

  @override
  String get locationSaved => 'Location saved';

  @override
  String get locationUpdated => 'Location updated';

  @override
  String get noLocationSet => 'No location set';

  @override
  String monitoringCount(Object count) {
    return 'Monitoring: $count locations';
  }

  @override
  String get addLocationHint => 'Add a location first';

  @override
  String get recordsTitle => 'Records';

  @override
  String get enterRangeRecord => 'Entered range';

  @override
  String get exitRangeRecord => 'Left range';

  @override
  String fenceRadiusValue(Object meters) {
    return 'Fence radius: ${meters}m';
  }

  @override
  String radiusLabel(Object meters) {
    return 'Radius: ${meters}m';
  }

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get locationPermRequired => 'Location Permission Required';

  @override
  String get locationPermDesc =>
      'Location permission is needed to get your current position.\n\nYou can grant it in system settings, or enter coordinates manually.';

  @override
  String get goToSettingsShort => 'Go to Settings';

  @override
  String get invalidCoordinates => 'Please enter valid coordinates';

  @override
  String get enterName => 'Please enter a name';

  @override
  String get enterLatitude => 'Please enter latitude';

  @override
  String get enterLongitude => 'Please enter longitude';

  @override
  String get latitudeRange => 'Latitude range: -90 ~ 90';

  @override
  String get longitudeRange => 'Longitude range: -180 ~ 180';

  @override
  String getLocationFailed(Object error) {
    return 'Failed to get location: $error';
  }

  @override
  String get noActiveLocations => 'No active locations';

  @override
  String get simulateEnter => 'Simulate Enter';

  @override
  String get simulateExit => 'Simulate Exit';

  @override
  String simulatedEnter(Object name) {
    return 'Simulated enter: $name';
  }

  @override
  String simulatedExit(Object name) {
    return 'Simulated exit: $name';
  }

  @override
  String get debugTools => 'Debug Tools';

  @override
  String get geofenceStatus => 'Geofence Status';

  @override
  String get monitorStatus => 'Monitor Status';

  @override
  String get lastEnter => 'Last Enter';

  @override
  String get lastExit => 'Last Exit';

  @override
  String get notMonitored => 'Not monitored';

  @override
  String get keepAliveWhyTitle => 'Why keep alive?';

  @override
  String get keepAliveWhyDesc =>
      'Check-in Reminder needs to continuously monitor your location in the background. Some systems restrict background apps. Follow these steps to ensure it works properly.';

  @override
  String get resetOnboarding => 'Reset Onboarding';

  @override
  String get resetOnboardingDone => 'Onboarding has been reset';

  @override
  String get keepAliveAndroidStep1Title => 'Disable Battery Optimization';

  @override
  String get keepAliveAndroidStep1Desc =>
      'Settings → Battery → More → Disable battery optimization for Check-in Reminder';

  @override
  String get keepAliveAndroidStep2Title => 'Allow Auto-start';

  @override
  String get keepAliveAndroidStep2Desc =>
      'Settings → App Management → Check-in Reminder → Permissions → Enable auto-start';

  @override
  String get keepAliveAndroidStep3Title => 'Lock in Recent Tasks';

  @override
  String get keepAliveAndroidStep3Desc =>
      'Swipe down on Check-in Reminder in recent tasks to lock it and prevent the system from killing it';

  @override
  String get keepAliveiOSStep1Title => 'Allow Background App Refresh';

  @override
  String get keepAliveiOSStep1Desc =>
      'Settings → General → Background App Refresh → Enable for Check-in Reminder';

  @override
  String get keepAliveiOSStep2Title => 'Keep Location Permission as \"Always\"';

  @override
  String get keepAliveiOSStep2Desc =>
      'Settings → Privacy & Security → Location Services → Check-in Reminder → Always';

  @override
  String get locationNameHintWork => 'e.g. HQ Building';

  @override
  String get locationNameHintSchool => 'e.g. MIT Campus';

  @override
  String get locationNameHintGym => 'e.g. Fitness Center';

  @override
  String get locationNameHintCustom => 'e.g. Coffee Shop';

  @override
  String get manageLocationTypes => 'Manage Location Types';

  @override
  String get locationTypesTitle => 'Location Types';

  @override
  String get addLocationType => 'Add Location Type';

  @override
  String get editLocationType => 'Edit Location Type';

  @override
  String get typeLabel => 'Type Name';

  @override
  String get typeLabelHint => 'e.g. Hospital';

  @override
  String get enterText => 'Enter Notification Text';

  @override
  String get enterTextHint => 'e.g. Arrived at hospital';

  @override
  String get exitText => 'Exit Notification Text';

  @override
  String get exitTextHint => 'e.g. Left hospital';

  @override
  String get cannotDeleteBuiltin => 'Built-in types cannot be deleted';

  @override
  String typeInUse(Object count) {
    return 'This type is used by $count locations and cannot be deleted';
  }

  @override
  String get save => 'Save';

  @override
  String get labelRequired => 'Please enter a name';

  @override
  String get enterTextRequired => 'Please enter enter notification text';

  @override
  String get exitTextRequired => 'Please enter exit notification text';

  @override
  String get mapPicker => 'Pick on Map';

  @override
  String get mapPickerTitle => 'Select Location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get tapToSelectLocation => 'Tap on the map to select a location';

  @override
  String get manageAttendanceApps => 'Manage Attendance Apps';

  @override
  String get attendanceAppsTitle => 'Attendance Apps';

  @override
  String get addAttendanceApp => 'Add Attendance App';

  @override
  String get editAttendanceApp => 'Edit Attendance App';

  @override
  String get appName => 'App Name';

  @override
  String get appNameHint => 'e.g. My Clock App';

  @override
  String get urlScheme => 'URL Scheme';

  @override
  String get urlSchemeHint => 'e.g. myapp://';

  @override
  String get cannotDeleteBuiltinApp => 'Built-in apps cannot be deleted';

  @override
  String get appNameRequired => 'Please enter app name';

  @override
  String get urlSchemeRequired => 'Please enter URL Scheme';

  @override
  String get permissionStatusTitle => 'Permission Status';

  @override
  String get permLocation => 'Location';

  @override
  String get permLocationWhenInUse => 'Location When In Use';

  @override
  String get permLocationAlways => 'Location Always';

  @override
  String get permNotification => 'Notifications';

  @override
  String get permGranted => 'Granted';

  @override
  String get permDenied => 'Denied';

  @override
  String get permNotRequested => 'Not Requested';

  @override
  String get permLocationGrantedAlways => 'Always Allowed';

  @override
  String get permLocationGrantedWhenInUse => 'When In Use Only';

  @override
  String get openSystemSettings => 'Open System Settings';

  @override
  String get refreshPermissions => 'Refresh Status';

  @override
  String get permLocationHelpiOS =>
      'Go to Settings → Check-in Reminder → Location → select \"Always\"';

  @override
  String get permLocationHelpAndroid =>
      'Go to Settings → Apps → Check-in Reminder → Permissions → Location → select \"Allow all the time\"';

  @override
  String get permNotificationHelpiOS =>
      'Go to Settings → Check-in Reminder → Notifications → enable \"Allow Notifications\"';

  @override
  String get permNotificationHelpAndroid =>
      'Go to Settings → Apps → Check-in Reminder → Notifications → enable notifications';
}
