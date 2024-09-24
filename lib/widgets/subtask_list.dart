// lib/widgets/subtask_list.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../providers/task_provider.dart';

class SubtaskList extends StatefulWidget {
  final Task task;

  SubtaskList({required this.task});

  @override
  _SubtaskListState createState() => _SubtaskListState();
}

class _SubtaskListState extends State<SubtaskList> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 2,
      child: ExpansionTile(
        title: Text('Subtasks'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.task.subtasks.length,
            itemBuilder: (context, index) {
              Subtask subtask = widget.task.subtasks[index];
              return ListTile(
                leading: Checkbox(
                  value: subtask.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      subtask.isCompleted = value!;
                    });
                    taskProvider.updateTask(widget.task);
                  },
                ),
                title: Text(subtask.title),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Add Subtask',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSubtask,
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addSubtask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        widget.task.subtasks.add(
          Subtask(
            id: DateTime.now().toString(),
            title: _controller.text,
            isCompleted: false,
          ),
        );
      });
      Provider.of<TaskProvider>(context, listen: false).updateTask(widget.task);
      _controller.clear();
    }
  }
}
