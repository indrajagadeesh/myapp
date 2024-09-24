// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Task Details Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Chip(
                          label: Text(priorityText(task.priority)),
                          backgroundColor:
                              priorityColor(task.priority).withOpacity(0.1),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text(taskTypeText(task.taskType)),
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Subtasks
            SubtaskList(task: task),
            // Stopwatch
            StopwatchWidget(task: task),
          ],
        ),
      ),
    );
  }
}
