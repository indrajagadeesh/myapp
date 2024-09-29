// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../utils/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> tasks = [];

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    // Open the 'tasks' box
    _taskBox = Hive.box<Task>('tasks');
    // Load existing tasks
    tasks = _taskBox.values.toList();
    notifyListeners();
  }

  void addTask(Task task) {
    _taskBox.add(task);
    tasks = _taskBox.values.toList();
    if (task.hasAlarm && task.scheduledTime != null) {
      NotificationService.scheduleNotification(task);
    }
    notifyListeners();
  }

  void updateTask(Task task) {
    task.save();
    tasks = _taskBox.values.toList();
    notifyListeners();
  }

  void deleteTask(String taskId) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    if (task.hasAlarm) {
      NotificationService.cancelNotification(task.key as int);
    }
    task.delete();
    tasks = _taskBox.values.toList();
    notifyListeners();
  }

  void markTaskCompleted(Task task) {
    task.isCompleted = true;
    task.completedDate = DateTime.now();
    task.save();
    if (task.hasAlarm) {
      NotificationService.cancelNotification(task.key as int);
    }
    tasks = _taskBox.values.toList();
    notifyListeners();
  }
}