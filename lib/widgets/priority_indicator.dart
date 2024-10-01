// lib/widgets/priority_indicator.dart

import 'package:flutter/material.dart';
import '../models/enums.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  const PriorityIndicator({required this.priority, Key? key}) : super(key: key);

  Color _getColor() {
    switch (priority) {
      case TaskPriority.Regular:
        return Colors.green;
      case TaskPriority.Important:
        return Colors.blue;
      case TaskPriority.VeryImportant:
        return Colors.orange;
      case TaskPriority.Urgent:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: _getColor(),
      radius: 5,
    );
  }
}
