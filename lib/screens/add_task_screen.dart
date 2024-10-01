// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../utils/constants.dart';
import '../widgets/subtask_list.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskId;

  // Constructor accepts optional taskId for editing
  const AddTaskScreen({this.taskId, Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskType _taskType = TaskType.Task;
  DateTime? _scheduledTime;
  bool _hasAlarm = false;
  TaskPriority _priority = TaskPriority.Regular;
  List<Subtask> _subtasks = [];

  // New fields for frequency and weekdays
  bool _isRepetitive = false;
  Frequency _frequency = Frequency.Daily;
  List<Weekday> _selectedWeekdays = [];

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final Task? task = _findTask(taskProvider, widget.taskId!);

      if (task != null) {
        _title = task.title;
        _description = task.description;
        _taskType = task.taskType;
        _scheduledTime = task.scheduledTime;
        _hasAlarm = task.hasAlarm;
        _priority = task.priority;
        _subtasks = List.from(task.subtasks);
        _isRepetitive = task.isRepetitive;
        _frequency = task.frequency;
        _selectedWeekdays = task.selectedWeekdays ?? [];
      }
    }
  }

  Task? _findTask(TaskProvider taskProvider, String taskId) {
    try {
      return taskProvider.tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      try {
        return taskProvider.routines.firstWhere((t) => t.id == taskId);
      } catch (e) {
        return null;
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Validate that scheduledTime is in the future if hasAlarm is true
      if (_hasAlarm && _scheduledTime != null) {
        if (_scheduledTime!.isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Scheduled time must be in the future.'),
            ),
          );
          return;
        }
      }

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.taskId != null) {
        // Update existing task
        final Task? task = _findTask(taskProvider, widget.taskId!);
        if (task != null) {
          task.title = _title;
          task.description = _description;
          task.taskType = _taskType;
          task.scheduledTime = _scheduledTime;
          task.hasAlarm = _hasAlarm;
          task.priority = _priority;
          task.subtasks = _subtasks;
          task.isRepetitive = _isRepetitive;
          task.frequency = _frequency;
          task.selectedWeekdays = _selectedWeekdays;
          taskProvider.updateTask(task);
        }
      } else {
        // Create new task
        final newTask = Task(
          id: const Uuid().v4(),
          title: _title,
          description: _description,
          taskType: _taskType,
          scheduledTime: _scheduledTime,
          hasAlarm: _hasAlarm,
          priority: _priority,
          subtasks: _subtasks,
          isRepetitive: _isRepetitive,
          frequency: _frequency,
          selectedWeekdays: _selectedWeekdays,
        );
        taskProvider.addTask(newTask);
      }
      Navigator.pop(context);
    }
  }

  void _showWeekdaySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Weekday> weekdays = Weekday.values;
        return AlertDialog(
          title: const Text('Select Days'),
          content: SingleChildScrollView(
            child: Column(
              children: weekdays.map((weekday) {
                return CheckboxListTile(
                  title: Text(weekdayText(weekday)),
                  value: _selectedWeekdays.contains(weekday),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedWeekdays.add(weekday);
                      } else {
                        _selectedWeekdays.remove(weekday);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickScheduledTime() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _scheduledTime ?? now;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _scheduledTime != null
            ? TimeOfDay.fromDateTime(_scheduledTime!)
            : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (pickedDateTime.isBefore(now)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Scheduled time must be in the future.'),
            ),
          );
          return;
        }
        setState(() {
          _scheduledTime = pickedDateTime;
          _hasAlarm = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 10),
              // Description Field
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 10),
              // Task Type Dropdown
              DropdownButtonFormField<TaskType>(
                value: _taskType,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: TaskType.values.map((TaskType type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(taskTypeText(type)),
                  );
                }).toList(),
                onChanged: (TaskType? newValue) {
                  setState(() {
                    _taskType = newValue ?? TaskType.Task;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Repetitive Task Switch
              SwitchListTile(
                title: const Text('Is Repetitive'),
                value: _isRepetitive,
                onChanged: (bool value) {
                  setState(() {
                    _isRepetitive = value;
                  });
                },
              ),
              if (_isRepetitive) ...[
                // Frequency Dropdown
                DropdownButtonFormField<Frequency>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: Frequency.values.map((Frequency freq) {
                    return DropdownMenuItem<Frequency>(
                      value: freq,
                      child: Text(frequencyText(freq)),
                    );
                  }).toList(),
                  onChanged: (Frequency? newValue) {
                    setState(() {
                      _frequency = newValue ?? Frequency.Daily;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Weekday Selection
                ElevatedButton(
                  onPressed: _showWeekdaySelectionDialog,
                  child: const Text('Select Days'),
                ),
                if (_selectedWeekdays.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: _selectedWeekdays.map((weekday) {
                      return Chip(
                        label: Text(weekdayText(weekday)),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10),
              ],
              // Scheduled Time Picker
              ListTile(
                title: Text(_scheduledTime == null
                    ? 'No Scheduled Time'
                    : 'Scheduled Time: ${_scheduledTime!.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickScheduledTime,
              ),
              const SizedBox(height: 10),
              // Priority Dropdown
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priorityText(priority)),
                  );
                }).toList(),
                onChanged: (TaskPriority? newValue) {
                  setState(() {
                    _priority = newValue ?? TaskPriority.Regular;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Subtasks List
              const Text(
                'Subtasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _subtasks.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No subtasks added.'),
                    )
                  : SubtaskList(
                      subtasks: _subtasks,
                      onToggle: (Subtask subtask) {
                        setState(() {
                          subtask.isCompleted = !subtask.isCompleted;
                        });
                      },
                    ),
              ElevatedButton(
                onPressed: () async {
                  final String? newSubtaskTitle =
                      await _showAddSubtaskDialog(context);
                  if (newSubtaskTitle != null && newSubtaskTitle.isNotEmpty) {
                    setState(() {
                      _subtasks.add(Subtask(
                          id: const Uuid().v4(), title: newSubtaskTitle));
                    });
                  }
                },
                child: const Text('Add Subtask'),
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Update Task' : 'Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddSubtaskDialog(BuildContext context) async {
    String subtaskTitle = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subtask'),
          content: TextField(
            onChanged: (value) {
              subtaskTitle = value;
            },
            decoration: const InputDecoration(hintText: 'Subtask Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(subtaskTitle); // Save
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
