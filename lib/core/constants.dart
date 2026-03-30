/// Default geofence radius (meters)
const int kDefaultRadiusMeters = 200;

/// Default dwell confirmation delay (seconds)
const int kDefaultDwellDelaySeconds = 180;

/// Default cooldown time (minutes)
const int kDefaultCooldownMinutes = 120;

/// Default re-remind interval (minutes)
const int kDefaultReRemindMinutes = 5;

/// Default max reminder count
const int kDefaultMaxRemindCount = 2;

/// Supported attendance apps (seed data only)
const Map<String, Map<String, String>> kDefaultAttendanceApps = {
  'dingtalk': {'name': 'DingTalk', 'scheme': 'dingtalk://'},
  'weixin': {'name': 'WeCom', 'scheme': 'wxwork://'},
  'lark': {'name': 'Lark', 'scheme': 'lark://'},
  'slack': {'name': 'Slack', 'scheme': 'slack://'},
  'teams': {'name': 'Microsoft Teams', 'scheme': 'msteams://'},
  'google_calendar': {'name': 'Google Calendar', 'scheme': 'com.google.calendar://'},
};

/// Location types (seed data only)
const Map<String, Map<String, dynamic>> kDefaultLocationTypes = {
  'work': {'label': 'Office', 'enterText': 'Remember to check in', 'exitText': 'Remember to check out'},
  'school': {'label': 'School', 'enterText': 'Arrived at school', 'exitText': 'Left school'},
  'gym': {'label': 'Gym', 'enterText': 'Time to work out!', 'exitText': 'Great workout!'},
  'custom': {'label': 'Custom', 'enterText': 'Arrived at destination', 'exitText': 'Left destination'},
};

/// Hive box names
const String kBoxLocations = 'locations';
const String kBoxRecords = 'records';
const String kBoxSettings = 'settings';
const String kBoxLocationTypes = 'location_types';
const String kBoxAttendanceApps = 'attendance_apps';
