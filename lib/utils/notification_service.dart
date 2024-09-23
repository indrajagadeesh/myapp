// lib/utils/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final _notifications = fln.FlutterLocalNotificationsPlugin();

  static Future init() async {
    final androidSettings = fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinSettings = fln.DarwinInitializationSettings();

    final settings = fln.InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: null,
    );

    await _notifications.initialize(settings);
  }

  static Future scheduleNotification(Task task) async {
    if (task.scheduledTime == null) return;

    final androidDetails = fln.AndroidNotificationDetails(
      'taskflow_channel',
      'TaskFlow Notifications',
      channelDescription: 'Reminder notifications for TaskFlow app',
      importance: fln.Importance.max,
      priority: fln.Priority.high,
      playSound: task.hasAlarm,
    );

    final darwinDetails = fln.DarwinNotificationDetails();

    final details = fln.NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: null,
    );

    await _notifications.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      task.title,
      tz.TZDateTime.from(task.scheduledTime!, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          fln.UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: task.taskType == TaskType.Routine
          ? fln.DateTimeComponents.time
          : null,
    );
  }

  static Future cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}