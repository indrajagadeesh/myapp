import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text('No tasks available.'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskTile(task: tasks[index]),
    );
  }
}