// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../utils/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> tasks = [];
  List<Task> routines = [];

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<Task>('tasks');
    tasks = _taskBox.values.where((task) => task.taskType == TaskType.Task).toList();
    routines = _taskBox.values.where((task) => task.taskType == TaskType.Routine).toList();
    notifyListeners();
  }

  void addTask(Task task) {
    _taskBox.add(task);
    if (task.taskType == TaskType.Task) {
      tasks = _taskBox.values.where((t) => t.taskType == TaskType.Task).toList();
    } else {
      routines = _taskBox.values.where((t) => t.taskType == TaskType.Routine).toList();
    }
    if (task.hasAlarm && task.scheduledTime != null) {
      NotificationService.scheduleNotification(task);
    }
    notifyListeners();
  }

  void updateTask(Task task) {
    task.save();
    if (task.taskType == TaskType.Task) {
      tasks = _taskBox.values.where((t) => t.taskType == TaskType.Task).toList();
    } else {
      routines = _taskBox.values.where((t) => t.taskType == TaskType.Routine).toList();
    }
    notifyListeners();
  }

  void deleteTask(String taskId) {
    final task = _taskBox.values.firstWhere((t) => t.id == taskId);
    if (task.hasAlarm) {
      NotificationService.cancelNotification(task.key as int);
    }
    task.delete();
    if (task.taskType == TaskType.Task) {
      tasks = _taskBox.values.where((t) => t.taskType == TaskType.Task).toList();
    } else {
      routines = _taskBox.values.where((t) => t.taskType == TaskType.Routine).toList();
    }
    notifyListeners();
  }

  void markTaskCompleted(Task task) {
    task.isCompleted = true;
    task.completedDate = DateTime.now();
    task.save();
    if (task.hasAlarm) {
      NotificationService.cancelNotification(task.key as int);
    }
    if (task.taskType == TaskType.Task) {
      tasks = _taskBox.values.where((t) => t.taskType == TaskType.Task).toList();
    } else {
      routines = _taskBox.values.where((t) => t.taskType == TaskType.Routine).toList();
    }
    notifyListeners();
  }

  List<Task> getTasksByFolder(String? folderId, TaskType type) {
    if (type == TaskType.Task) {
      return tasks.where((task) => task.folderId == folderId).toList();
    } else {
      return routines.where((task) => task.folderId == folderId).toList();
    }
  }
}