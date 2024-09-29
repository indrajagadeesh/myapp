// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/folder.dart';
import '../providers/task_provider.dart';
import '../providers/folder_provider.dart';
import '../utils/constants.dart';
import '../widgets/frequency_selector.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String title = '';
  String description = '';
  TaskType taskType = TaskType.Task;
  TaskPriority priority = TaskPriority.Regular;
  DateTime? scheduledTime;
  bool hasAlarm = false;
  String? selectedFolderId;

  // Routine specific fields
  bool isRepetitive = false;
  Frequency frequency = Frequency.Daily;
  List<Weekday> selectedWeekdays = [];

  // Providers
  late TaskProvider taskProvider;
  late FolderProvider folderProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the providers here
    taskProvider = Provider.of<TaskProvider>(context, listen: false);
    folderProvider = Provider.of<FolderProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${taskType == TaskType.Task ? 'Task' : 'Routine'}'),
      ),
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
                _buildFolderSelector(folders),
                SizedBox(height: 16),
                // Scheduled Time Picker & Alarm
                if (taskType == TaskType.Routine) _buildRoutineOptions(),
                // Save Button
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: Text('Save ${taskType == TaskType.Task ? 'Task' : 'Routine'}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
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
                // Reset routine-specific fields
                isRepetitive = false;
                frequency = Frequency.Daily;
                selectedWeekdays = [];
                hasAlarm = false;
                scheduledTime = null;
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

  Widget _buildFolderSelector(List<Folder> folders) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Folder',
        border: OutlineInputBorder(),
      ),
      value: selectedFolderId,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text('No Folder'),
        ),
        ...folders.map((folder) {
          return DropdownMenuItem(
            value: folder.id,
            child: Text(folder.name),
          );
        }).toList(),
      ],
      onChanged: (value) => setState(() => selectedFolderId = value),
      hint: Text('Select Folder (Optional)'),
      isExpanded: true,
    );
  }

  Widget _buildRoutineOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Repetitive Switch
        SwitchListTile(
          title: Text('Is Repetitive'),
          value: isRepetitive,
          onChanged: (value) {
            setState(() {
              isRepetitive = value;
              if (!isRepetitive) {
                frequency = Frequency.Daily;
                selectedWeekdays = [];
              }
            });
          },
        ),
        SizedBox(height: 16),
        // Frequency Selector
        if (isRepetitive)
          FrequencySelector(
            selectedFrequency: frequency,
            selectedWeekdays: selectedWeekdays,
            onFrequencyChanged: (freq) {
              setState(() {
                frequency = freq;
              });
            },
            onWeekdaysChanged: (days) {
              setState(() {
                selectedWeekdays = days;
              });
            },
          ),
        SizedBox(height: 16),
        // Alarm Option
        SwitchListTile(
          title: Text('Set Notification Alarm'),
          value: hasAlarm,
          onChanged: (value) {
            setState(() {
              hasAlarm = value;
              if (!hasAlarm) {
                scheduledTime = null;
              }
            });
          },
        ),
        if (hasAlarm)
          ListTile(
            title: Text('Alert Time'),
            subtitle: Text(
                '${scheduledTime?.hour.toString().padLeft(2, '0')}:${scheduledTime?.minute.toString().padLeft(2, '0') ?? '00'}'),
            trailing: IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: scheduledTime != null
                      ? TimeOfDay(hour: scheduledTime!.hour, minute: scheduledTime!.minute)
                      : TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    scheduledTime = DateTime(
                        0, 0, 0, picked.hour, picked.minute); // Date part unused
                  });
                }
              },
            ),
          ),
      ],
    );
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
        scheduledTime: hasAlarm ? scheduledTime : null,
        hasAlarm: hasAlarm,
        folderId: selectedFolderId, // If null, provider assigns default
        isRepetitive: isRepetitive,
        frequency: frequency,
        selectedWeekdays: isRepetitive ? selectedWeekdays : null,
      );
      taskProvider.addTask(newTask);
      Navigator.pop(context);
    }
  }
}