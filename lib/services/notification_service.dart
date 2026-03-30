import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Notification tap callback - set by main.dart
  static void Function(String payload)? onNotificationTapped;

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Android 13+ requires runtime notification permission
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      // Clean up old notification channels
      await androidPlugin.deleteNotificationChannel(
          channelId: 'check_in_reminder');
    }
  }

  /// Handle notification tap
  static void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && onNotificationTapped != null) {
      onNotificationTapped!(payload);
    }
  }

  Future<void> showCheckInReminder({
    required String title,
    required String body,
    int id = 0,
    String? payload,
    String soundSetting = 'default',
  }) async {
    final isSilent = soundSetting == 'silent';
    final androidDetails = AndroidNotificationDetails(
      isSilent ? 'checkin_reminder_silent' : 'checkin_reminder',
      isSilent ? 'Check-in Reminder (Silent)' : 'Check-in Reminder',
      channelDescription: 'Check-in/out reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: !isSilent,
    );
    final iosDetails = DarwinNotificationDetails(
      presentSound: !isSilent,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    try {
      print('[Notification] show id=$id, title=$title, body=$body');
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
      print('[Notification] show succeeded');
    } catch (e, stack) {
      print('[Notification] show failed: $e');
      print('[Notification] stack: $stack');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
