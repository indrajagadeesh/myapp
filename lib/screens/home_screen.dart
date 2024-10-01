// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/enums.dart'; // Ensure enums are imported

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _navigateToTaskDetail(BuildContext context, String taskId) {
    Navigator.pushNamed(
      context,
      '/task-detail',
      arguments: {'taskId': taskId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> todayTasks = taskProvider.getTasksForToday();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () {
              Navigator.pushNamed(context, '/reports');
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              Navigator.pushNamed(context, '/folders');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todayTasks.length,
        itemBuilder: (context, index) {
          final task = todayTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: task.taskType == TaskType.Task &&
                    task.scheduledTime != null
                ? Text(
                    '${task.scheduledTime!.day}/${task.scheduledTime!.month}/${task.scheduledTime!.year} at ${TimeOfDay.fromDateTime(task.scheduledTime!).format(context)}')
                : task.taskType == TaskType.Routine
                    ? Text(task.frequency != null
                        ? 'Frequency: ${task.frequency.toString().split('.').last}'
                        : 'Part of Day: ${task.partOfDay.toString().split('.').last}')
                    : null,
            trailing: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            onTap: () => _navigateToTaskDetail(context, task.id),
            onLongPress: () {
              // Toggle completion status
              task.isCompleted = !task.isCompleted;
              task.completedDate = task.isCompleted ? DateTime.now() : null;
              taskProvider.updateTask(task);

              // Move to archive folder if completed
              if (task.isCompleted) {
                taskProvider.moveTaskToFolder(
                    task.id, taskProvider.folderProvider.getArchiveFolderId());
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
