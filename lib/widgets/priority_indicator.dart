// lib/widgets/priority_indicator.dart

import 'package:flutter/material.dart';
import '../models/task.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case TaskPriority.Regular:
        color = Colors.green;
        break;
      case TaskPriority.Important:
        color = Colors.blue;
        break;
      case TaskPriority.VeryImportant:
        color = Colors.orange;
        break;
      case TaskPriority.Urgent:
        color = Colors.red;
        break;
    }
    return CircleAvatar(
      backgroundColor: color,
      radius: 5,
    );
  }
}