import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../utils/notification_service.dart';

class TaskProvider with ChangeNotifier {
  late Box<Task> _taskBox;

  List<Task> get tasks => _taskBox.values.toList();

  Future<void> init() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    notifyListeners();
  }

  void addTask(Task task) {
    _taskBox.put(task.id, task);
    if (task.scheduledTime != null) {
      NotificationService.scheduleNotification(task);
    }
    notifyListeners();
  }

  void updateTask(Task task) {
    _taskBox.put(task.id, task);
    if (task.scheduledTime != null) {
      NotificationService.scheduleNotification(task);
    }
    notifyListeners();
  }

  void deleteTask(String id) {
    _taskBox.delete(id);
    NotificationService.cancelNotification(id.hashCode);
    notifyListeners();
  }
}