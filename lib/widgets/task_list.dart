// lib/widgets/task_list.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_list_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({required this.tasks, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks available.'),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskListItem(task: tasks[index]);
      },
    );
  }
}
