// lib/models/user_settings.dart

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'time_of_day_adapter.dart'; // Import the adapter

part 'user_settings.g.dart';

@HiveType(typeId: 5)
class UserSettings extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  TimeOfDay wakeUpTime;

  @HiveField(2)
  TimeOfDay lunchTime;

  @HiveField(3)
  TimeOfDay eveningTime;

  @HiveField(4)
  TimeOfDay dinnerTime;

  UserSettings({
    required this.name,
    required this.wakeUpTime,
    required this.lunchTime,
    required this.eveningTime,
    required this.dinnerTime,
  });
}
