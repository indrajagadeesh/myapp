// lib/screens/folder_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/folder.dart';
import '../widgets/task_list_item.dart';

class FolderDetailScreen extends StatelessWidget {
  final Folder folder;

  const FolderDetailScreen({required this.folder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> folderTasks =
        taskProvider.getTasksByFolder(folder.id, TaskType.Task);
    final List<Task> folderRoutines =
        taskProvider.getTasksByFolder(folder.id, TaskType.Routine);

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTaskSection('Tasks', folderTasks),
            _buildTaskSection('Routines', folderRoutines),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Task> tasks) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No $title in this folder.'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ...tasks.map((task) {
            return TaskListItem(task: task);
          }).toList(),
        ],
      );
    }
  }
}
