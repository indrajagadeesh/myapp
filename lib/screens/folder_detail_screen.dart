import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/folder.dart';
import '../providers/folder_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import '../models/task.dart';

class FolderDetailScreen extends StatelessWidget {
  final String folderId;

  FolderDetailScreen({required this.folderId});

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final Folder folder = folderProvider.folders.firstWhere((f) => f.id == folderId);
    final List<Task> tasksInFolder =
        taskProvider.tasks.where((task) => task.folderId == folderId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: TaskList(tasks: tasksInFolder),
    );
  }
}