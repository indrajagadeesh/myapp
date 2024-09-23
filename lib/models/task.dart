// lib/models/task.dart

import 'package:hive/hive.dart';
import 'subtask.dart';

part 'task.g.dart';

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

  @HiveField(8)
  Duration timeSpent;

  @HiveField(9)
  String? folderId;

  @HiveField(10)
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.taskType,
    this.scheduledTime,
    this.hasAlarm = false,
    required this.priority,
    this.subtasks = const [],
    this.timeSpent = Duration.zero,
    this.folderId,
    this.isCompleted = false,
  });
}