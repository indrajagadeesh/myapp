// lib/widgets/task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../screens/task_detail_screen.dart';
import 'priority_indicator.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PriorityIndicator(priority: task.priority),
      title: Text(task.title),
      subtitle: Text(taskTypeText(task.taskType)),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(taskId: task.id),
          ),
        );
      },
    );
  }
}