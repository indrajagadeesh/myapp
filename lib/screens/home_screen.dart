import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
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
      body: TaskList(tasks: taskProvider.tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}