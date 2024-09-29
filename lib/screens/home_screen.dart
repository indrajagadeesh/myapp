// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/folder_provider.dart';
import '../widgets/pop_out_tile.dart';
import '../screens/task_detail_screen.dart';
import '../utils/constants.dart';
import '../models/task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final folderProvider = Provider.of<FolderProvider>(context);
    final folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: Text('TaskFlow'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: () {
              Navigator.pushNamed(context, '/folders');
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/reports');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Tasks Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...folders.map((folder) {
            final tasks = taskProvider.getTasksByFolder(folder.id, TaskType.Task);
            if (tasks.isEmpty) return SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    folder.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                ...tasks.map((task) => PopOutTile(
                      leading: CircleAvatar(
                        backgroundColor: priorityColor(task.priority),
                        child: Icon(
                          task.taskType == TaskType.Task
                              ? Icons.task
                              : Icons.repeat,
                          color: Colors.white,
                        ),
                      ),
                      title: task.title,
                      subtitle: task.description.isNotEmpty
                          ? task.description
                          : null,
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(taskId: task.id),
                          ),
                        );
                      },
                    )),
              ],
            );
          }).toList(),
          // Routines Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Routines',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...folders.map((folder) {
            final routines =
                taskProvider.getTasksByFolder(folder.id, TaskType.Routine);
            if (routines.isEmpty) return SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    folder.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                ...routines.map((routine) => PopOutTile(
                      leading: CircleAvatar(
                        backgroundColor: priorityColor(routine.priority),
                        child: Icon(
                          routine.taskType == TaskType.Task
                              ? Icons.task
                              : Icons.repeat,
                          color: Colors.white,
                        ),
                      ),
                      title: routine.title,
                      subtitle: routine.description.isNotEmpty
                          ? routine.description
                          : null,
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(taskId: routine.id),
                          ),
                        );
                      },
                    )),
              ],
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}