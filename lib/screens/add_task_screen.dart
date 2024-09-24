// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/folder_provider.dart';
import '../utils/constants.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  TaskType taskType = TaskType.Task;
  TaskPriority priority = TaskPriority.Regular;
  DateTime? scheduledTime;
  bool hasAlarm = false;
  String? selectedFolderId;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final folderProvider = Provider.of<FolderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                SizedBox(height: 16),
                // Description Input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => description = value!,
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                // Task Type Selector
                _buildTaskTypeSelector(),
                SizedBox(height: 16),
                // Priority Selector
                _buildPrioritySelector(),
                SizedBox(height: 16),
                // Folder Selector
                _buildFolderSelector(folderProvider),
                SizedBox(height: 16),
                // Scheduled Time Picker
                _buildScheduledTimePicker(),
                // Save Button
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: Text('Save Task'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Type', style: TextStyle(fontSize: 16)),
        ListTile(
          title: const Text('Task'),
          leading: Radio<TaskType>(
            value: TaskType.Task,
            groupValue: taskType,
            onChanged: (TaskType? value) {
              setState(() {
                taskType = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Routine'),
          leading: Radio<TaskType>(
            value: TaskType.Routine,
            groupValue: taskType,
            onChanged: (TaskType? value) {
              setState(() {
                taskType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: TextStyle(fontSize: 16)),
        Column(
          children: TaskPriority.values.map((p) {
            return ListTile(
              title: Text(priorityText(p)),
              leading: Radio<TaskPriority>(
                value: p,
                groupValue: priority,
                onChanged: (TaskPriority? value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFolderSelector(FolderProvider folderProvider) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Folder',
        border: OutlineInputBorder(),
      ),
      value: selectedFolderId,
      items: folderProvider.folders.map((folder) {
        return DropdownMenuItem(
          value: folder.id,
          child: Text(folder.name),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedFolderId = value),
    );
  }

  Widget _buildScheduledTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text('Set Scheduled Time'),
          value: scheduledTime != null,
          onChanged: (value) async {
            if (value) {
              DateTime? picked = await _showDateTimePicker(context);
              if (picked != null) {
                setState(() => scheduledTime = picked);
              }
            } else {
              setState(() => scheduledTime = null);
            }
          },
        ),
        if (scheduledTime != null)
          ListTile(
            title: Text('Scheduled Time'),
            subtitle: Text('${scheduledTime!}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                DateTime? picked = await _showDateTimePicker(context);
                if (picked != null) {
                  setState(() => scheduledTime = picked);
                }
              },
            ),
          ),
        if (scheduledTime != null)
          SwitchListTile(
            title: Text('Set Alarm'),
            value: hasAlarm,
            onChanged: (value) => setState(() => hasAlarm = value),
          ),
      ],
    );
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
    DateTime? date;
    TimeOfDay? time;

    date = await showDatePicker(
      context: context,
      initialDate: scheduledTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;

    time = await showTimePicker(
      context: context,
      initialTime: scheduledTime != null
          ? TimeOfDay.fromDateTime(scheduledTime!)
          : TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var newTask = Task(
        id: Uuid().v4(),
        title: title,
        description: description,
        taskType: taskType,
        priority: priority,
        scheduledTime: scheduledTime,
        hasAlarm: hasAlarm,
        folderId: selectedFolderId,
      );
      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      Navigator.pop(context);
    }
  }
}
