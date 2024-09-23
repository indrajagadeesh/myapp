import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import 'package:uuid/uuid.dart';

class SubtaskList extends StatefulWidget {
  final Task task;

  SubtaskList({required this.task});

  @override
  _SubtaskListState createState() => _SubtaskListState();
}

class _SubtaskListState extends State<SubtaskList> {
  final TextEditingController _subtaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Subtask
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _subtaskController,
                  decoration: InputDecoration(labelText: 'New Subtask'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_subtaskController.text.isNotEmpty) {
                    setState(() {
                      widget.task.subtasks.add(Subtask(
                        id: Uuid().v4(),
                        title: _subtaskController.text,
                      ));
                      _subtaskController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        // Subtask List
        Expanded(
          child: ListView.builder(
            itemCount: widget.task.subtasks.length,
            itemBuilder: (context, index) {
              final subtask = widget.task.subtasks[index];
              return CheckboxListTile(
                title: Text(subtask.title),
                value: subtask.isCompleted,
                onChanged: (value) {
                  setState(() {
                    subtask.isCompleted = value!;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}