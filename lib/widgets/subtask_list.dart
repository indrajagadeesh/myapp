// lib/widgets/subtask_list.dart

import 'package:flutter/material.dart';
import '../models/subtask.dart';

class SubtaskList extends StatelessWidget {
  final List<Subtask> subtasks;
  final Function(Subtask) onToggle;

  const SubtaskList({required this.subtasks, required this.onToggle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subtasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No subtasks added.'),
      );
    } else {
      return Column(
        children: subtasks.map((subtask) {
          return CheckboxListTile(
            value: subtask.isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                onToggle(subtask);
              }
            },
            title: Text(subtask.title),
          );
        }).toList(),
      );
    }
  }
}
