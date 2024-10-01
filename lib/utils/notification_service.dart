// lib/utils/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings for both platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification(Task task) async {
    if (task.scheduledTime == null) return;

    // Ensure the scheduled time is in the future
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(task.scheduledTime!, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      // Do not schedule the notification if the time is in the past
      print('Cannot schedule notification for a past date/time.');
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      task.key as int, // Unique ID for the notification
      task.title,
      task.description,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'Notifications for your tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
