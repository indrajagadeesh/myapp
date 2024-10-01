// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({required this.taskId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final Task? task = _findTask(taskProvider, taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Not Found')),
        body: Center(child: Text('Task with ID $taskId not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-task',
                arguments: {'taskId': task.id},
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context, taskProvider, task.id);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              task.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Priority: ${priorityText(task.priority)}'),
                const SizedBox(width: 20),
                Text('Status: ${task.isCompleted ? "Completed" : "Pending"}'),
              ],
            ),
            const SizedBox(height: 10),
            if (task.hasAlarm && task.scheduledTime != null)
              Row(
                children: [
                  Text('Scheduled Time: ${task.scheduledTime!.toLocal()}'),
                ],
              ),
            const SizedBox(height: 10),
            if (task.subtasks.isNotEmpty)
              Expanded(
                child: ListView(
                  children: task.subtasks.map((subtask) {
                    return CheckboxListTile(
                      value: subtask.isCompleted,
                      onChanged: (bool? value) {
                        if (value != null) {
                          subtask.isCompleted = value;
                          taskProvider.updateTask(task);
                        }
                      },
                      title: Text(subtask.title),
                    );
                  }).toList(),
                ),
              ),
            if (!task.isCompleted)
              ElevatedButton(
                onPressed: () {
                  taskProvider.markTaskCompleted(task);
                  Navigator.pop(context);
                },
                child: const Text('Mark as Complete'),
              ),
          ],
        ),
      ),
    );
  }

  Task? _findTask(TaskProvider taskProvider, String taskId) {
    try {
      return taskProvider.tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      try {
        return taskProvider.routines.firstWhere((t) => t.id == taskId);
      } catch (e) {
        return null;
      }
    }
  }

  void _confirmDelete(
      BuildContext context, TaskProvider taskProvider, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteTask(taskId);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
