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
import '../utils/notification_service.dart';

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
          scheduledTime: null,
        );
        await _taskBox.add(routine);
        tasks.add(routine);

        // Schedule notification based on part of day
        _scheduleRoutineNotification(routine);
      }
    }
  }

  void _scheduleRoutineNotification(Task routine) {
    if (routine.partOfDay != null) {
      TimeOfDay? time = _getTimeFromPartOfDay(routine.partOfDay!);
      if (time != null) {
        DateTime scheduledDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          time.hour,
          time.minute,
        );

        NotificationService.showNotification(
          id: routine.id.hashCode, // Unique ID based on task ID
          title: routine.title,
          body: 'It\'s time for your ${routine.title.toLowerCase()}!',
          payload: routine.id,
        );
      }
    }
  }

  TimeOfDay? _getTimeFromPartOfDay(PartOfDay part) {
    if (userSettingsProvider.userSettings == null) return null;

    switch (part) {
      case PartOfDay.WakeUp:
        return userSettingsProvider.userSettings!.wakeUpTime;
      case PartOfDay.Lunch:
        return userSettingsProvider.userSettings!.lunchTime;
      case PartOfDay.Evening:
        return userSettingsProvider.userSettings!.eveningTime;
      case PartOfDay.Dinner:
        return userSettingsProvider.userSettings!.dinnerTime;
      default:
        return null;
    }
  }

  void _purgeOldTasks() {
    DateTime cutoffDate = DateTime.now().subtract(const Duration(days: 60));
    tasks.removeWhere((task) {
      if (task.isCompleted &&
          task.completedDate != null &&
          task.completedDate!.isBefore(cutoffDate)) {
        task.delete();
        return true;
      }
      return false;
    });
  }

  void _scheduleDailyRoutines() {
    // This method should be called at the end of each day to add new routines
    // For simplicity, we'll check and add routines when the app initializes
    // Implement a more robust scheduling mechanism as needed

    DateTime today = DateTime.now();
    List<Task> routinesToSchedule = tasks
        .where((t) => t.isRepetitive && t.taskType == TaskType.Routine)
        .toList();

    for (var routine in routinesToSchedule) {
      bool isScheduledToday = tasks.any((task) =>
          task.taskType == TaskType.Routine &&
          task.id != routine.id &&
          task.title == routine.title &&
          task.scheduledTime != null &&
          task.scheduledTime!.day == today.day &&
          task.scheduledTime!.month == today.month &&
          task.scheduledTime!.year == today.year);

      if (!isScheduledToday) {
        Task newRoutine = Task(
          id: const Uuid().v4(),
          title: routine.title,
          description: routine.description,
          taskType: TaskType.Routine,
          isCompleted: false,
          scheduledTime: routine.partOfDay != null
              ? DateTime(
                  today.year,
                  today.month,
                  today.day,
                  _getTimeFromPartOfDay(routine.partOfDay!)!.hour,
                  _getTimeFromPartOfDay(routine.partOfDay!)!.minute,
                )
              : null,
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

        // Schedule notification based on part of day or specific time
        if (newRoutine.partOfDay != null) {
          _scheduleRoutineNotification(newRoutine);
        } else if (newRoutine.scheduledTime != null) {
          // Schedule notification based on specific time
          NotificationService.showNotification(
            id: newRoutine.id.hashCode,
            title: newRoutine.title,
            body: 'It\'s time for your ${newRoutine.title.toLowerCase()}!',
            payload: newRoutine.id,
          );
        }
      }
    }
  }

  void addTask(Task task) {
    _taskBox.add(task);
    tasks.add(task);
    notifyListeners();

    // Schedule notification if necessary
    if (task.taskType == TaskType.Routine) {
      _scheduleRoutineNotification(task);
    } else if (task.taskType == TaskType.Task && task.scheduledTime != null) {
      NotificationService.showNotification(
        id: task.id.hashCode,
        title: task.title,
        body: 'Reminder for ${task.title}',
        payload: task.id,
      );
    }
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

    // Reschedule notifications if necessary
    if (task.taskType == TaskType.Routine) {
      _scheduleRoutineNotification(task);
    } else if (task.taskType == TaskType.Task && task.scheduledTime != null) {
      NotificationService.showNotification(
        id: task.id.hashCode,
        title: task.title,
        body: 'Reminder for ${task.title}',
        payload: task.id,
      );
    }
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
