// lib/utils/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize time zones
    tz.initializeTimeZones();

    // Android initialization
    var androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS (Darwin) initialization
    var darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(settings);
  }

  static Future<void> scheduleNotification(Task task) async {
    if (task.scheduledTime == null) return;

    var androidDetails = AndroidNotificationDetails(
      'taskflow_channel',
      'TaskFlow Notifications',
      channelDescription: 'Notifications for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    var darwinDetails = DarwinNotificationDetails();

    var details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.zonedSchedule(
      task.key.hashCode, // Unique ID for the notification
      'Task Reminder',
      task.title,
      tz.TZDateTime.from(task.scheduledTime!, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: task.taskType == TaskType.Routine
          ? DateTimeComponents.time
          : null,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}