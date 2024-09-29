// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../utils/constants.dart'; // Added import
import '../widgets/subtask_list.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskId;

  // Constructor accepts optional taskId for editing
  AddTaskScreen({this.taskId});

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
  // Add other fields as necessary

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      Task? task;
      try {
        task = taskProvider.tasks.firstWhere((t) => t.id == widget.taskId);
      } catch (e) {
        try {
          task = taskProvider.routines.firstWhere((t) => t.id == widget.taskId);
        } catch (e) {
          task = null;
        }
      }

      if (task != null) {
        _title = task.title;
        _description = task.description;
        _taskType = task.taskType;
        _scheduledTime = task.scheduledTime;
        _hasAlarm = task.hasAlarm;
        _priority = task.priority;
        _subtasks = List.from(task.subtasks);
        // Initialize other fields as necessary
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (widget.taskId != null) {
        // Update existing task
        final task = taskProvider.tasks.firstWhere(
          (t) => t.id == widget.taskId,
          orElse: () {
            try {
              return taskProvider.routines.firstWhere((t) => t.id == widget.taskId);
            } catch (e) {
              return null;
            }
          },
        );
        if (task != null) {
          task.title = _title;
          task.description = _description;
          task.taskType = _taskType;
          task.scheduledTime = _scheduledTime;
          task.hasAlarm = _hasAlarm;
          task.priority = _priority;
          task.subtasks = _subtasks;
          // Update other fields as necessary
          taskProvider.updateTask(task);
        }
      } else {
        // Create new task
        final newTask = Task(
          id: Uuid().v4(),
          title: _title,
          description: _description,
          taskType: _taskType,
          scheduledTime: _scheduledTime,
          hasAlarm: _hasAlarm,
          priority: _priority,
          subtasks: _subtasks,
          // Initialize other fields as necessary
        );
        taskProvider.addTask(newTask);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 10),
              // Description Field
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 10),
              // Task Type Dropdown
              DropdownButtonFormField<TaskType>(
                value: _taskType,
                decoration: InputDecoration(labelText: 'Task Type'),
                items: TaskType.values.map((TaskType type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(taskTypeText(type)), // Now defined via constants.dart
                  );
                }).toList(),
                onChanged: (TaskType? newValue) {
                  setState(() {
                    _taskType = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              // Scheduled Time Picker
              ListTile(
                title: Text(_scheduledTime == null
                    ? 'No Scheduled Time'
                    : 'Scheduled Time: ${_scheduledTime!.toLocal()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _scheduledTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _scheduledTime != null
                          ? TimeOfDay.fromDateTime(_scheduledTime!)
                          : TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _scheduledTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _hasAlarm = true;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              // Priority Dropdown
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priorityText(priority)), // Now defined via constants.dart
                  );
                }).toList(),
                onChanged: (TaskPriority? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              // Subtasks List
              Text(
                'Subtasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _subtasks.isEmpty
                  ? Padding(
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
                  final String? newSubtaskTitle = await _showAddSubtaskDialog(context);
                  if (newSubtaskTitle != null && newSubtaskTitle.isNotEmpty) {
                    setState(() {
                      _subtasks.add(Subtask(id: Uuid().v4(), title: newSubtaskTitle));
                    });
                  }
                },
                child: Text('Add Subtask'),
              ),
              // Add other fields as necessary
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddSubtaskDialog(BuildContext context) {
    String subtaskTitle = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subtask'),
          content: TextField(
            onChanged: (value) {
              subtaskTitle = value;
            },
            decoration: InputDecoration(hintText: 'Subtask Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(subtaskTitle); // Save
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}