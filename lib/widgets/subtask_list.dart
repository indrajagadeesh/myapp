// lib/widgets/subtask_list.dart

import 'package:flutter/material.dart';
import '../models/subtask.dart';

class SubtaskList extends StatelessWidget {
  final List<Subtask> subtasks;
  final Function(Subtask) onToggle;

  SubtaskList({required this.subtasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: subtasks.map((subtask) {
        return CheckboxListTile(
          value: subtask.isCompleted,
          onChanged: (bool? value) {
            onToggle(subtask);
          },
          title: Text(subtask.title),
        );
      }).toList(),
    );
  }
}