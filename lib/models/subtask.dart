// lib/models/subtask.dart

import 'package:hive/hive.dart';

part 'subtask.g.dart';

@HiveType(typeId: 8) // Ensure this typeId is unique
class Subtask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  int timeSpentMicroseconds;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    int? timeSpentMicroseconds,
  }) : timeSpentMicroseconds = timeSpentMicroseconds ?? 0;

  Duration get timeSpent => Duration(microseconds: timeSpentMicroseconds);

  set timeSpent(Duration value) {
    timeSpentMicroseconds = value.inMicroseconds;
  }
}
