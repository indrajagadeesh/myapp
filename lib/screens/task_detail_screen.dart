// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../widgets/stopwatch_widget.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  // Constructor requires taskId
  TaskDetailScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    Task? task;
    try {
      task = taskProvider.tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      try {
        task = taskProvider.routines.firstWhere((t) => t.id == taskId);
      } catch (e) {
        task = null;
      }
    }

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Task Not Found')),
        body: Center(child: Text('Task with ID $taskId not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-task',
                arguments: {'taskId': task.id},
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context, taskProvider, task.id);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              task.description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            // Display additional task details here
            Row(
              children: [
                Text('Priority: ${priorityText(task.priority)}'),
                SizedBox(width: 20),
                Text('Status: ${task.isCompleted ? "Completed" : "Pending"}'),
              ],
            ),
            SizedBox(height: 10),
            if (task.hasAlarm && task.scheduledTime != null)
              Row(
                children: [
                  Text('Scheduled Time: ${task.scheduledTime!.toLocal()}'),
                ],
              ),
            SizedBox(height: 10),
            // Display subtasks
            if (task.subtasks.isNotEmpty)
              Expanded(
                child: ListView(
                  children: task.subtasks.map((subtask) {
                    return CheckboxListTile(
                      value: subtask.isCompleted,
                      onChanged: (bool? value) {
                        // Toggle subtask completion
                        subtask.isCompleted = value ?? false;
                        taskProvider.updateTask(task);
                      },
                      title: Text(subtask.title),
                    );
                  }).toList(),
                ),
              ),
            // Stopwatch Widget (if needed)
            if (!task.isCompleted)
              StopwatchWidget(),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskProvider taskProvider, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteTask(taskId);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}