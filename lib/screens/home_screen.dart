// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_list_item.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasksForToday = taskProvider.getTasksForToday();
    final completedTasks = taskProvider.getCompletedTasksForToday();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: tasksForToday.isEmpty && completedTasks.isEmpty
            ? const Center(child: Text('No tasks for today.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tasksForToday.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Tasks',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          _buildTaskList(tasksForToday),
                        ],
                      ),
                    if (completedTasks.isNotEmpty)
                      ExpansionTile(
                        title: const Text('Completed Tasks'),
                        children: completedTasks
                            .map((task) => TaskListItem(task: task))
                            .toList(),
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
