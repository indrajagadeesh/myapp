// lib/widgets/subtask_list.dart

import 'package:flutter/material.dart';
import '../models/subtask.dart';

class SubtaskList extends StatelessWidget {
  final List<Subtask> subtasks;
  final void Function(int index) onToggle;
  final void Function(int index) onRemoveSubtask;
  final void Function(int index, String title) onUpdateSubtask;
  final VoidCallback onAddSubtask;

  const SubtaskList({
    Key? key,
    required this.subtasks,
    required this.onToggle,
    required this.onRemoveSubtask,
    required this.onUpdateSubtask,
    required this.onAddSubtask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subtasks.length,
          itemBuilder: (context, index) {
            final subtask = subtasks[index];
            return ListTile(
              leading: Checkbox(
                value: subtask.isCompleted,
                onChanged: (bool? value) {
                  onToggle(index);
                },
              ),
              title: TextFormField(
                initialValue: subtask.title,
                onChanged: (value) {
                  onUpdateSubtask(index, value);
                },
                decoration: const InputDecoration(
                  hintText: 'Subtask Title',
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onRemoveSubtask(index);
                },
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: onAddSubtask,
          icon: const Icon(Icons.add),
          label: const Text('Add Subtask'),
        ),
      ],
    );
  }
}
