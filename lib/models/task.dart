// lib/models/task.dart

import 'package:hive/hive.dart';
import 'subtask.dart';
import 'enums.dart';
import 'package:flutter/material.dart';

part 'task.g.dart';

@HiveType(typeId: 7) // Ensure this typeId is unique
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
  bool isCompleted;

  @HiveField(5)
  DateTime? completedDate;

  @HiveField(6)
  DateTime? scheduledTime; // For time-based tasks

  @HiveField(7)
  bool hasAlarm;

  @HiveField(8)
  TaskPriority priority;

  @HiveField(9)
  List<Subtask> subtasks;

  @HiveField(10)
  String folderId;

  @HiveField(11)
  bool isRepetitive;

  @HiveField(12)
  Frequency? frequency;

  @HiveField(13)
  PartOfDay? partOfDay; // For part-of-day based routines

  @HiveField(14)
  int timeSpentMicroseconds;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.taskType,
    this.isCompleted = false,
    this.completedDate,
    this.scheduledTime,
    this.hasAlarm = false,
    this.priority = TaskPriority.Regular,
    List<Subtask>? subtasks,
    required this.folderId,
    this.isRepetitive = false,
    this.frequency,
    this.partOfDay,
    int? timeSpentMicroseconds,
  })  : subtasks = subtasks ?? [],
        timeSpentMicroseconds = timeSpentMicroseconds ?? 0;

  Duration get timeSpent => Duration(microseconds: timeSpentMicroseconds);

  set timeSpent(Duration value) {
    timeSpentMicroseconds = value.inMicroseconds;
  }

  // Determine if the routine uses part of the day
  bool get usesPartOfDay => partOfDay != null;
}
