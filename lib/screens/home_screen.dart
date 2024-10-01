// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildTaskList(BuildContext context, List<Task> tasks, String title) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('No $title available.'),
      );
    } else {
      return Column(
        children: tasks.map((task) {
          return ListTile(
            title: Text(task.title),
            subtitle: Text(priorityText(task.priority)),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/task-detail',
                arguments: {'taskId': task.id},
              );
            },
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskProvider.tasks;
    final List<Task> routines = taskProvider.routines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              Navigator.pushNamed(context, '/folders');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/reports');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Display Tasks
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildTaskList(context, tasks, 'tasks'),
          // Display Routines
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Routines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildTaskList(context, routines, 'routines'),
        ],
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
