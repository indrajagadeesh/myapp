// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskProvider.tasks;
    final List<Task> routines = taskProvider.routines;

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
          // Display Tasks
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (tasks.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('No tasks available.'),
            )
          else
            ...tasks.map((task) => ListTile(
                  title: Text(task.title),
                  subtitle: Text(priorityText(task.priority)),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/task-detail',
                      arguments: {'taskId': task.id},
                    );
                  },
                )),
          // Display Routines
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Routines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (routines.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('No routines available.'),
            )
          else
            ...routines.map((routine) => ListTile(
                  title: Text(routine.title),
                  subtitle: Text(frequencyText(routine.frequency)),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/task-detail',
                      arguments: {'taskId': routine.id},
                    );
                  },
                )),
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