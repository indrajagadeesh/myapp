// lib/widgets/priority_indicator.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: priorityColor(priority),
      radius: 6,
    );
  }
}