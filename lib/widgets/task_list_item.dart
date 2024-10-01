// lib/widgets/task_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(task.title),
        subtitle: Text(
            '${priorityText(task.priority)} • ${taskTypeText(task.taskType)}'),
        trailing: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            final taskProvider =
                Provider.of<TaskProvider>(context, listen: false);
            taskProvider.markTaskCompleted(task);
          },
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/task-detail',
            arguments: {'taskId': task.id},
          );
        },
      ),
    );
  }
}
