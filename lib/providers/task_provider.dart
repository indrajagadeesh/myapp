// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/folder.dart';
import '../utils/notification_service.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  late Box<Folder> _folderBox;
  List<Task> tasks = [];
  List<Task> routines = [];

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<Task>('tasks');
    _folderBox = Hive.box<Folder>('folders');
    tasks = _taskBox.values
        .where((task) => task.taskType == TaskType.Task)
        .toList();
    routines = _taskBox.values
        .where((task) => task.taskType == TaskType.Routine)
        .toList();
    notifyListeners();
  }

  void addTask(Task task) {
    // Assign default folder if none selected
    if (task.folderId == null) {
      task.folderId = _getDefaultFolderId();
    }
    _taskBox.add(task);
    if (task.taskType == TaskType.Task) {
      tasks.add(task);
    } else {
      routines.add(task);
    }
    if (task.hasAlarm && task.scheduledTime != null) {
      NotificationService.scheduleNotification(task);
    }
    notifyListeners();
  }

  String _getDefaultFolderId() {
    // Fetch the default folder from Hive or create one if it doesn't exist
    Folder defaultFolder;
    try {
      defaultFolder =
          _folderBox.values.firstWhere((folder) => folder.isDefault);
    } catch (e) {
      // Create a default folder if it doesn't exist
      defaultFolder = Folder(
        id: const Uuid().v4(),
        name: 'Default',
        isDefault: true,
      );
      _folderBox.add(defaultFolder);
    }
    return defaultFolder.id;
  }

  void updateTask(Task task) {
    task.save();
    notifyListeners();
  }

  void deleteTask(String taskId) {
    Task? task;
    try {
      task = _taskBox.values.firstWhere((t) => t.id == taskId);
    } catch (e) {
      task = null;
    }
    if (task != null) {
      if (task.hasAlarm) {
        NotificationService.cancelNotification(task.key as int);
      }
      task.delete();
      if (task.taskType == TaskType.Task) {
        tasks.removeWhere((t) => t.id == taskId);
      } else {
        routines.removeWhere((t) => t.id == taskId);
      }
      notifyListeners();
    }
  }

  void markTaskCompleted(Task task) {
    task.isCompleted = true;
    task.completedDate = DateTime.now();
    task.save();
    if (task.hasAlarm) {
      NotificationService.cancelNotification(task.key as int);
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

  void moveTaskToFolder(Task task, String newFolderId) {
    task.folderId = newFolderId;
    updateTask(task);
  }
}
