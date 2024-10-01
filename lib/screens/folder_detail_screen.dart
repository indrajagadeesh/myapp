// lib/screens/folder_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/folder.dart';
import '../providers/folder_provider.dart';
import '../widgets/task_list_item.dart';

class FolderDetailScreen extends StatelessWidget {
  final String folderId;

  const FolderDetailScreen({required this.folderId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final folder = folderProvider.folders.firstWhere(
      (f) => f.id == folderId,
      orElse: () => Folder(id: '', name: 'Folder Not Found'),
    );

    final tasksInFolder = taskProvider.getTasksForFolder(folderId);

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: tasksInFolder.isEmpty
          ? const Center(child: Text('No tasks in this folder.'))
          : ListView.builder(
              itemCount: tasksInFolder.length,
              itemBuilder: (context, index) {
                final task = tasksInFolder[index];
                return TaskListItem(task: task);
              },
            ),
    );
  }
}
