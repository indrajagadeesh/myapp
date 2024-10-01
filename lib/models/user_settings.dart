// lib/models/user_settings.dart

import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 8)
class UserSettings extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime wakeUpTime;

  @HiveField(2)
  DateTime lunchTime;

  @HiveField(3)
  DateTime eveningTime;

  @HiveField(4)
  DateTime dinnerTime;

  UserSettings({
    required this.name,
    required this.wakeUpTime,
    required this.lunchTime,
    required this.eveningTime,
    required this.dinnerTime,
  });
}
