// lib/widgets/task_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_indicator.dart';
import '../utils/constants.dart';
import '../screens/task_detail_screen.dart';
import '../models/enums.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          task.isCompleted = value ?? false;
          if (task.isCompleted) {
            task.completedDate = DateTime.now();
          } else {
            task.completedDate = null;
          }
          taskProvider.updateTask(task);
        },
      ),
      title: Text(task.title),
      subtitle: Text(
        task.taskType == TaskType.Routine && task.partOfDay != null
            ? 'Routine - ${partOfDayNames[task.partOfDay]!}'
            : 'Task',
      ),
      trailing: PriorityIndicator(priority: task.priority),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(taskId: task.id),
          ),
        );
      },
    );
  }
}
