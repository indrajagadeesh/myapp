// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../models/enums.dart';
import 'folder_provider.dart';
import 'user_settings_provider.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> tasks = [];
  final FolderProvider folderProvider;
  final UserSettingsProvider userSettingsProvider;

  TaskProvider({
    required this.folderProvider,
    required this.userSettingsProvider,
  }) {
    init();
  }

  Future<void> init() async {
    _taskBox = Hive.box<Task>('tasks');
    tasks = _taskBox.values.toList();

    // Create default routines if they don't exist
    await _createDefaultRoutines();

    // Purge old tasks
    _purgeOldTasks();

    // Schedule daily routine creation
    _scheduleDailyRoutines();

    notifyListeners();
  }

  Future<void> _createDefaultRoutines() async {
    List<PartOfDay> defaultParts = [
      PartOfDay.WakeUp,
      PartOfDay.Lunch,
      PartOfDay.Evening,
      PartOfDay.Dinner,
    ];

    for (var part in defaultParts) {
      bool exists = tasks.any((task) =>
          task.taskType == TaskType.Routine && task.partOfDay == part);
      if (!exists) {
        Task routine = Task(
          id: const Uuid().v4(),
          title: '${partOfDayNames[part]} Routine',
          taskType: TaskType.Routine,
          folderId: folderProvider.getDefaultFolderId(),
          partOfDay: part,
          isRepetitive: true,
          frequency: Frequency.Daily,
          hasAlarm: false,
          priority: TaskPriority.Regular,
          subtasks: [],
          scheduledTime: _getScheduledTimeForPartOfDay(part),
        );
        await _taskBox.add(routine);
        tasks.add(routine);
      }
    }
  }

  DateTime? _getScheduledTimeForPartOfDay(PartOfDay part) {
    TimeOfDay? timeOfDay;
    switch (part) {
      case PartOfDay.WakeUp:
        timeOfDay = userSettingsProvider.userSettings?.wakeUpTime;
        break;
      case PartOfDay.Lunch:
        timeOfDay = userSettingsProvider.userSettings?.lunchTime;
        break;
      case PartOfDay.Evening:
        timeOfDay = userSettingsProvider.userSettings?.eveningTime;
        break;
      case PartOfDay.Dinner:
        timeOfDay = userSettingsProvider.userSettings?.dinnerTime;
        break;
    }
    if (timeOfDay != null) {
      return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    }
    return null;
  }

  void _purgeOldTasks() {
    DateTime cutoffDate = DateTime.now().subtract(const Duration(days: 60));
    tasks.removeWhere((task) {
      if (task.completedDate != null &&
          task.completedDate!.isBefore(cutoffDate)) {
        task.delete();
        return true;
      }
      return false;
    });
  }

  void _scheduleDailyRoutines() {
    // Check for routines that need to be scheduled today
    DateTime today = DateTime.now();
    List<Task> routinesToSchedule = [];

    for (var routine in tasks.where((t) => t.isRepetitive)) {
      bool isScheduledToday = tasks.any((t) =>
          t.isRepetitive &&
          t.title == routine.title &&
          t.scheduledTime != null &&
          t.scheduledTime!.day == today.day &&
          t.scheduledTime!.month == today.month &&
          t.scheduledTime!.year == today.year);

      if (!isScheduledToday) {
        routinesToSchedule.add(routine);
      }
    }

    for (var routine in routinesToSchedule) {
      Task newRoutine = Task(
        id: const Uuid().v4(),
        title: routine.title,
        description: routine.description,
        taskType: TaskType.Routine,
        isCompleted: false,
        scheduledTime: _getScheduledTimeForPartOfDay(routine.partOfDay!),
        hasAlarm: routine.hasAlarm,
        priority: routine.priority,
        subtasks: routine.subtasks,
        folderId: routine.folderId,
        isRepetitive: routine.isRepetitive,
        frequency: routine.frequency,
        partOfDay: routine.partOfDay,
      );
      _taskBox.add(newRoutine);
      tasks.add(newRoutine);
    }
  }

  bool _isRoutineScheduledForToday(Task routine, DateTime today) {
    return tasks.any((task) =>
        task.taskType == TaskType.Routine &&
        task.title == routine.title &&
        task.scheduledTime != null &&
        task.scheduledTime!.day == today.day &&
        task.scheduledTime!.month == today.month &&
        task.scheduledTime!.year == today.year);
  }

  void addTask(Task task) {
    _taskBox.add(task);
    tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String taskId) {
    Task? task;
    try {
      task = tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      task = null;
    }

    if (task != null) {
      task.delete();
      tasks.remove(task);
      notifyListeners();
    }
  }

  void updateTask(Task task) {
    task.save();
    notifyListeners();
  }

  void moveTaskToFolder(String taskId, String folderId) {
    Task? task;
    try {
      task = tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      task = null;
    }

    if (task != null) {
      task.folderId = folderId;
      task.save();
      notifyListeners();
    }
  }

  List<Task> getTasksForToday() {
    DateTime today = DateTime.now();
    return tasks.where((task) {
      if (task.isRepetitive) {
        return true;
      } else if (task.scheduledTime != null) {
        return task.scheduledTime!.day == today.day &&
            task.scheduledTime!.month == today.month &&
            task.scheduledTime!.year == today.year;
      }
      return false;
    }).toList();
  }

  List<Task> getCompletedTasksForToday() {
    DateTime today = DateTime.now();
    return tasks.where((task) {
      if (task.isCompleted && task.completedDate != null) {
        return task.completedDate!.day == today.day &&
            task.completedDate!.month == today.month &&
            task.completedDate!.year == today.year;
      }
      return false;
    }).toList();
  }

  List<Task> getTasksForFolder(String folderId) {
    return tasks.where((task) => task.folderId == folderId).toList();
  }

  List<Task> getArchivedTasks() {
    String archiveFolderId = folderProvider.getArchiveFolderId();
    return tasks.where((task) => task.folderId == archiveFolderId).toList();
  }
}
