// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/subtask_list.dart';
import '../widgets/stopwatch_widget.dart';
import '../utils/constants.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  TaskDetailScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.tasks.firstWhere((t) => t.id == taskId);

    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Column(
        children: [
          // Task Details
          ListTile(
            title: Text('Description'),
            subtitle: Text(task.description),
          ),
          ListTile(
            title: Text('Priority'),
            subtitle: Text(priorityText(task.priority)),
          ),
          // Subtasks
          Expanded(child: SubtaskList(task: task)),
          // Stopwatch
          StopwatchWidget(task: task),
        ],
      ),
    );
  }
}