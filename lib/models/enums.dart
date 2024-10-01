// lib/models/enums.dart

import 'package:hive/hive.dart';

part 'enums.g.dart';

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

@HiveType(typeId: 3)
enum PartOfDay {
  @HiveField(0)
  WakeUp,
  @HiveField(1)
  Lunch,
  @HiveField(2)
  Evening,
  @HiveField(3)
  Dinner,
}
