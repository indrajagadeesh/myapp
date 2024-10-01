// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool _isTaskStopwatchRunning = false;
  Stopwatch _taskStopwatch = Stopwatch();

  Map<String, bool> _subtaskStopwatchesRunning = {};
  Map<String, Stopwatch> _subtaskStopwatches = {};

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final Task? task = _getTask(taskProvider);
    if (task != null) {
      for (var subtask in task.subtasks) {
        _subtaskStopwatchesRunning[subtask.id] = false;
        _subtaskStopwatches[subtask.id] = Stopwatch();
      }
    }
  }

  Task? _getTask(TaskProvider taskProvider) {
    try {
      return taskProvider.tasks.firstWhere((t) => t.id == widget.taskId);
    } catch (e) {
      return null;
    }
  }

  void _toggleTaskStopwatch(Task task) {
    setState(() {
      if (_isTaskStopwatchRunning) {
        _taskStopwatch.stop();
        task.timeSpent += _taskStopwatch.elapsed;
        _taskStopwatch.reset();
      } else {
        _taskStopwatch.start();
      }
      _isTaskStopwatchRunning = !_isTaskStopwatchRunning;
      Provider.of<TaskProvider>(context, listen: false).updateTask(task);
    });
  }

  void _toggleSubtaskStopwatch(Task task, String subtaskId) {
    setState(() {
      if (_subtaskStopwatchesRunning[subtaskId]!) {
        _subtaskStopwatches[subtaskId]!.stop();
        task.timeSpent += _subtaskStopwatches[subtaskId]!.elapsed;
        _subtaskStopwatches[subtaskId]!.reset();
      } else {
        _subtaskStopwatches[subtaskId]!.start();
      }
      _subtaskStopwatchesRunning[subtaskId] =
          !_subtaskStopwatchesRunning[subtaskId]!;
      Provider.of<TaskProvider>(context, listen: false).updateTask(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final Task? task = _getTask(taskProvider);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: const Center(
          child: Text('Task not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Handle task deletion
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
            // Task Description
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Subtasks
            Expanded(
              child: ListView.builder(
                itemCount: task.subtasks.length,
                itemBuilder: (context, index) {
                  final subtask = task.subtasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: (bool? value) {
                        // Update subtask completion status
                        subtask.isCompleted = value ?? false;
                        subtask.save();
                        taskProvider.updateTask(task);
                      },
                    ),
                    title: Text(subtask.title),
                    trailing: IconButton(
                      icon: Icon(
                        _subtaskStopwatchesRunning[subtask.id]!
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () =>
                          _toggleSubtaskStopwatch(task, subtask.id),
                    ),
                  );
                },
              ),
            ),
            // Stopwatch for Task
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time Spent: ${task.timeSpent.inMinutes} mins',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    _isTaskStopwatchRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () => _toggleTaskStopwatch(task),
                ),
              ],
            ),
            // Mark as Complete Button
            ElevatedButton(
              onPressed: () {
                task.isCompleted = !task.isCompleted;
                task.completedDate = task.isCompleted ? DateTime.now() : null;
                taskProvider.updateTask(task);

                // Move to archive folder if completed
                if (task.isCompleted) {
                  taskProvider.moveTaskToFolder(task.id,
                      taskProvider.folderProvider.getArchiveFolderId());
                }
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
