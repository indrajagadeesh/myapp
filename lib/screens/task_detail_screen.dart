// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../models/enums.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({required this.taskId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final task = taskProvider.tasks.firstWhere((t) => t.id == taskId,
        orElse: () => Task(
              id: '',
              title: 'Task Not Found',
              taskType: TaskType.Task,
              folderId: '',
            ));

    if (task.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Detail')),
        body: const Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              taskProvider.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(task.description),
            const SizedBox(height: 10),
            Text('Priority: ${task.priority.toString().split('.').last}'),
            const SizedBox(height: 10),
            Text('Type: ${task.taskType.toString().split('.').last}'),
            const SizedBox(height: 10),
            if (task.taskType == TaskType.Routine && task.partOfDay != null)
              Text('Part of Day: ${task.partOfDay.toString().split('.').last}'),
            const SizedBox(height: 10),
            if (task.scheduledTime != null)
              Text(
                  'Scheduled Time: ${TimeOfDay.fromDateTime(task.scheduledTime!).format(context)}'),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Alarm'),
              value: task.hasAlarm,
              onChanged:
                  task.taskType == TaskType.Routine && task.partOfDay != null
                      ? null // Disable alarm switch if using PartOfDay
                      : (bool value) {
                          task.hasAlarm = value;
                          taskProvider.updateTask(task);
                        },
            ),
            const SizedBox(height: 10),
            const Text(
              'Subtasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: task.subtasks.length,
                itemBuilder: (context, index) {
                  final subtask = task.subtasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: (bool? value) {
                        subtask.isCompleted = value ?? false;
                        taskProvider.updateTask(task);
                      },
                    ),
                    title: Text(subtask.title),
                    // Implement stopwatch if needed
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement mark as complete or undo
                task.isCompleted = !task.isCompleted;
                if (task.isCompleted) {
                  task.completedDate = DateTime.now();
                } else {
                  task.completedDate = null;
                }
                taskProvider.updateTask(task);
              },
              child:
                  Text(task.isCompleted ? 'Undo Complete' : 'Mark as Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
