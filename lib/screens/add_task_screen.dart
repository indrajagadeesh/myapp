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
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                // Description Input
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                ),
                // Task Type Selector
                DropdownButtonFormField<TaskType>(
                  decoration: InputDecoration(labelText: 'Task Type'),
                  value: taskType,
                  items: TaskType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child:
                                Text(type == TaskType.Task ? 'Task' : 'Routine'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => taskType = value!),
                ),
                // Priority Selector
                DropdownButtonFormField<TaskPriority>(
                  decoration: InputDecoration(labelText: 'Priority'),
                  value: priority,
                  items: TaskPriority.values
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(priorityText(p)),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => priority = value!),
                ),
                // Folder Selector
                Consumer<FolderProvider>(
                  builder: (context, folderProvider, child) {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Folder'),
                      value: selectedFolderId,
                      items: folderProvider.folders.map((folder) {
                        return DropdownMenuItem(
                          value: folder.id,
                          child: Text(folder.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedFolderId = value),
                    );
                  },
                ),
                // Scheduled Time Picker
                SwitchListTile(
                  title: Text('Set Scheduled Time'),
                  value: scheduledTime != null,
                  onChanged: (value) async {
                    if (value) {
                      DateTime? picked = await showDateTimePicker(context);
                      if (picked != null) {
                        setState(() => scheduledTime = picked);
                      }
                    } else {
                      setState(() => scheduledTime = null);
                    }
                  },
                ),
                // Has Alarm
                if (scheduledTime != null)
                  SwitchListTile(
                    title: Text('Set Alarm'),
                    value: hasAlarm,
                    onChanged: (value) => setState(() => hasAlarm = value),
                  ),
                // Save Button
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
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
                      taskProvider.addTask(newTask);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}