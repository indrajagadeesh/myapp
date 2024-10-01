// lib/models/task.dart

import 'package:hive/hive.dart';
import 'subtask.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  TaskType taskType;

  @HiveField(4)
  DateTime? scheduledTime;

  @HiveField(5)
  bool hasAlarm;

  @HiveField(6)
  TaskPriority priority;

  @HiveField(7)
  List<Subtask> subtasks;

  // Changed from Duration to int (microseconds)
  @HiveField(8)
  int timeSpentMicroseconds;

  @HiveField(9)
  String? folderId;

  @HiveField(10)
  bool isCompleted;

  @HiveField(11)
  DateTime? completedDate;

  // Additional fields for routines
  @HiveField(12)
  bool isRepetitive;

  @HiveField(13)
  Frequency frequency;

  @HiveField(14)
  List<Weekday>? selectedWeekdays;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.taskType = TaskType.Task,
    this.scheduledTime,
    this.hasAlarm = false,
    this.priority = TaskPriority.Regular,
    this.subtasks = const [],
    Duration timeSpent = Duration.zero,
    this.folderId,
    this.isCompleted = false,
    this.completedDate,
    this.isRepetitive = false,
    this.frequency = Frequency.Daily,
    this.selectedWeekdays,
  }) : timeSpentMicroseconds = timeSpent.inMicroseconds;

  // Getter and setter for timeSpent as Duration
  Duration get timeSpent => Duration(microseconds: timeSpentMicroseconds);

  set timeSpent(Duration value) {
    timeSpentMicroseconds = value.inMicroseconds;
  }
}

@HiveType(typeId: 0)
enum TaskType {
  @HiveField(0)
  Task,
  @HiveField(1)
  Routine,
}

@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  Regular,
  @HiveField(1)
  Important,
  @HiveField(2)
  VeryImportant,
  @HiveField(3)
  Urgent,
}

@HiveType(typeId: 5)
enum Frequency {
  @HiveField(0)
  Daily,
  @HiveField(1)
  Weekly,
  @HiveField(2)
  BiWeekly,
  @HiveField(3)
  Monthly,
}

@HiveType(typeId: 6)
enum Weekday {
  @HiveField(0)
  Monday,
  @HiveField(1)
  Tuesday,
  @HiveField(2)
  Wednesday,
  @HiveField(3)
  Thursday,
  @HiveField(4)
  Friday,
  @HiveField(5)
  Saturday,
  @HiveField(6)
  Sunday,
}
