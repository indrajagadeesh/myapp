// lib/widgets/task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../screens/task_detail_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor(task.priority),
          child: Icon(
            task.taskType == TaskType.Task ? Icons.task : Icons.repeat,
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${taskTypeText(task.taskType)} • ${priorityText(task.priority)}',
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailScreen(taskId: task.id),
            ),
          );
        },
      ),
    );
  }
}
