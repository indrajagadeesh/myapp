// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/folder_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../models/enums.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

class AddTaskScreen extends StatefulWidget {
  final String? taskId;

  const AddTaskScreen({Key? key, this.taskId}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskType _taskType = TaskType.Task;
  Frequency? _frequency;
  PartOfDay? _partOfDay;
  bool _hasAlarm = false;
  TaskPriority _priority = TaskPriority.Regular;
  List<String> _subtasks = [];
  String? _folderId;
  DateTime? _selectedDate; // For date-based tasks
  TimeOfDay? _selectedTime; // For time-based tasks

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      // If editing an existing task, populate fields
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final Task? task =
          taskProvider.tasks.firstWhereOrNull((t) => t.id == widget.taskId);
      if (task != null) {
        _title = task.title;
        _description = task.description;
        _taskType = task.taskType;
        _frequency = task.frequency;
        _partOfDay = task.partOfDay;
        _hasAlarm = task.hasAlarm;
        _priority = task.priority;
        _subtasks = task.subtasks.map((sub) => sub.title).toList();
        _folderId = task.folderId;
        _selectedDate = task.scheduledTime;
        _selectedTime = task.scheduledTime != null
            ? TimeOfDay(
                hour: task.scheduledTime!.hour,
                minute: task.scheduledTime!.minute)
            : null;
      }
    }
  }

  void _addSubtask() {
    setState(() {
      _subtasks.add('');
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final folderProvider =
          Provider.of<FolderProvider>(context, listen: false);

      // Ensure folder is selected
      if (_folderId == null) {
        // Assign to default folder
        _folderId = folderProvider.getDefaultFolderId();
      }

      // Create Subtasks
      List<Subtask> subtaskObjects = _subtasks
          .where((subtask) => subtask.trim().isNotEmpty)
          .map((subtask) => Subtask(
                id: const Uuid().v4(),
                title: subtask.trim(),
              ))
          .toList();

      // Create or Update Task
      if (widget.taskId != null) {
        // Update existing task
        Task? existingTask =
            taskProvider.tasks.firstWhereOrNull((t) => t.id == widget.taskId);
        if (existingTask != null) {
          existingTask.title = _title;
          existingTask.description = _description;
          existingTask.taskType = _taskType;
          existingTask.frequency = _frequency;
          existingTask.partOfDay = _partOfDay;
          existingTask.hasAlarm = _hasAlarm;
          existingTask.priority = _priority;
          existingTask.subtasks = subtaskObjects;
          existingTask.folderId = _folderId!;
          existingTask.scheduledTime =
              _taskType == TaskType.Task && _selectedDate != null
                  ? DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime?.hour ?? 0,
                      _selectedTime?.minute ?? 0,
                    )
                  : null;
          taskProvider.updateTask(existingTask);
        }
      } else {
        // Create new task
        Task newTask = Task(
          id: const Uuid().v4(),
          title: _title,
          description: _description,
          taskType: _taskType,
          hasAlarm: _hasAlarm,
          priority: _priority,
          subtasks: subtaskObjects,
          folderId: _folderId!,
          isRepetitive: _taskType == TaskType.Routine,
          frequency: _frequency,
          partOfDay: _partOfDay,
          scheduledTime: _taskType == TaskType.Task && _selectedDate != null
              ? DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime?.hour ?? 0,
                  _selectedTime?.minute ?? 0,
                )
              : null,
        );
        taskProvider.addTask(newTask);
      }

      Navigator.pop(context);
    }
  }

  bool _taskProviderUsesPartOfDay() {
    return _partOfDay != null;
  }

  bool _enableStopwatch() {
    // Determine if stopwatch should be enabled based on subtasks
    return _subtasks.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Task Title
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 10),
              // Task Description
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 10),
              // Task Type
              DropdownButtonFormField<TaskType>(
                value: _taskType,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: TaskType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (TaskType? newType) {
                  setState(() {
                    _taskType = newType!;
                    if (_taskType == TaskType.Task) {
                      _partOfDay = null;
                    } else {
                      _selectedDate = null;
                      _selectedTime = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              // Frequency (only for Routine)
              if (_taskType == TaskType.Routine)
                DropdownButtonFormField<Frequency>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: Frequency.values
                      .map((freq) => DropdownMenuItem(
                            value: freq,
                            child: Text(freq.toString().split('.').last),
                          ))
                      .toList(),
                  validator: (value) {
                    if (_taskType == TaskType.Routine &&
                        value == null &&
                        _partOfDay == null) {
                      return 'Please select a frequency or part of the day';
                    }
                    return null;
                  },
                  onChanged: (Frequency? newFreq) {
                    setState(() {
                      _frequency = newFreq;
                      if (_frequency != null) {
                        _partOfDay = null;
                      }
                    });
                  },
                ),
              const SizedBox(height: 10),
              // Part of Day (only for Routine without specific time)
              if (_taskType == TaskType.Routine)
                DropdownButtonFormField<PartOfDay>(
                  value: _partOfDay,
                  decoration: const InputDecoration(labelText: 'Part of Day'),
                  items: PartOfDay.values
                      .map((part) => DropdownMenuItem(
                            value: part,
                            child: Text(part.toString().split('.').last),
                          ))
                      .toList(),
                  validator: (value) {
                    if (_taskType == TaskType.Routine &&
                        _frequency == null &&
                        value == null) {
                      return 'Please select a frequency or part of the day';
                    }
                    return null;
                  },
                  onChanged: (PartOfDay? newPart) {
                    setState(() {
                      _partOfDay = newPart;
                      if (_partOfDay != null) {
                        _frequency = null;
                      }
                    });
                  },
                ),
              const SizedBox(height: 10),
              // Date and Time Selection for Task
              if (_taskType == TaskType.Task) ...[
                // Date Picker
                ListTile(
                  title: const Text('Select Date'),
                  subtitle: Text(_selectedDate != null
                      ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                      : 'No date selected'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                // Time Picker
                ListTile(
                  title: const Text('Select Time'),
                  subtitle: Text(_selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'No time selected'),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              // Alarm (only if Task or Routine has specific time)
              if (_taskType == TaskType.Task ||
                  (_taskType == TaskType.Routine &&
                      !_taskProviderUsesPartOfDay()))
                SwitchListTile(
                  title: const Text('Enable Alarm'),
                  value: _hasAlarm,
                  onChanged: (bool value) {
                    setState(() {
                      _hasAlarm = value;
                    });
                  },
                ),
              const SizedBox(height: 10),
              // Priority
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (TaskPriority? newPriority) {
                  setState(() {
                    _priority = newPriority!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Folder Selection
              DropdownButtonFormField<String>(
                value: _folderId,
                decoration: const InputDecoration(labelText: 'Folder'),
                items: folders
                    .map((folder) => DropdownMenuItem(
                          value: folder.id,
                          child: Text(folder.name),
                        ))
                    .toList(),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a folder'
                    : null,
                onChanged: (String? newFolderId) {
                  setState(() {
                    _folderId = newFolderId;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Subtasks
              Text(
                'Subtasks',
                style: Theme.of(context).textTheme.headlineSmall, // Updated
              ),
              const SizedBox(height: 10),
              ..._subtasks.asMap().entries.map((entry) {
                int index = entry.key;
                String subtask = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: subtask,
                        decoration: InputDecoration(
                          labelText: 'Subtask ${index + 1}',
                        ),
                        onChanged: (value) {
                          _subtasks[index] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeSubtask(index),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addSubtask,
                child: const Text('Add Subtask'),
              ),
              const SizedBox(height: 20),
              // Stopwatch Toggle
              SwitchListTile(
                title: const Text('Enable Stopwatch'),
                value: _enableStopwatch(),
                onChanged: (bool value) {
                  setState(() {
                    // Implement logic to handle stopwatch enabling
                    // This could involve additional fields or state management
                  });
                },
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.taskId != null ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
