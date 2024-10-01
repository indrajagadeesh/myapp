// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/folder.dart';
import '../models/enums.dart';
import '../models/subtask.dart';
import '../providers/task_provider.dart';
import '../providers/folder_provider.dart';
import '../widgets/frequency_selector.dart';
import '../widgets/priority_indicator.dart';
import '../utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskId;

  const AddTaskScreen({this.taskId, Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskType _taskType = TaskType.Task;
  TimeOfDay? _scheduledTime;
  bool _hasAlarm = false;
  TaskPriority _priority = TaskPriority.Regular;
  List<Subtask> _subtasks = [];
  String? _selectedFolderId;
  Frequency? _frequency;
  PartOfDay? _partOfDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final folderProvider = Provider.of<FolderProvider>(context, listen: false);
    _selectedFolderId = folderProvider.getDefaultFolderId();

    if (widget.taskId != null) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final existingTask = taskProvider.tasks.firstWhere(
        (task) => task.id == widget.taskId,
        orElse: () => Task(
          id: '',
          title: '',
          taskType: TaskType.Task,
          folderId: _selectedFolderId!,
        ),
      );
      if (existingTask.id.isNotEmpty) {
        setState(() {
          _title = existingTask.title;
          _description = existingTask.description;
          _taskType = existingTask.taskType;
          _scheduledTime = existingTask.scheduledTime != null
              ? TimeOfDay.fromDateTime(existingTask.scheduledTime!)
              : null;
          _hasAlarm = existingTask.hasAlarm;
          _priority = existingTask.priority;
          _subtasks = List<Subtask>.from(existingTask.subtasks);
          _selectedFolderId = existingTask.folderId;
          _frequency = existingTask.frequency;
          _partOfDay = existingTask.partOfDay;
        });
      }
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (_taskType == TaskType.Routine &&
          _scheduledTime == null &&
          _partOfDay == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please provide either a time or select a part of day.'),
          ),
        );
        return;
      }

      Task task = Task(
        id: widget.taskId ?? const Uuid().v4(),
        title: _title,
        description: _description,
        taskType: _taskType,
        scheduledTime: _scheduledTime != null
            ? DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _scheduledTime!.hour,
                _scheduledTime!.minute,
              )
            : null,
        hasAlarm: _hasAlarm,
        priority: _priority,
        subtasks: _subtasks,
        folderId: _selectedFolderId!,
        isRepetitive: _taskType == TaskType.Routine,
        frequency: _taskType == TaskType.Routine ? _frequency : null,
        partOfDay: _taskType == TaskType.Routine ? _partOfDay : null,
      );

      if (widget.taskId != null) {
        taskProvider.updateTask(task);
      } else {
        taskProvider.addTask(task);
      }

      Navigator.pop(context);
    }
  }

  void _addSubtask() {
    setState(() {
      _subtasks.add(Subtask(id: const Uuid().v4(), title: ''));
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
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
              // Title
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 10),
              // Description
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 10),
              // Task Type
              DropdownButtonFormField<TaskType>(
                value: _taskType,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: TaskType.values.map((TaskType type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (TaskType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _taskType = newValue;
                      if (_taskType != TaskType.Routine) {
                        _frequency = null;
                        _partOfDay = null;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              // Frequency (only for Routine)
              if (_taskType == TaskType.Routine)
                DropdownButtonFormField<Frequency>(
                  value: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: Frequency.values.map((Frequency freq) {
                    return DropdownMenuItem<Frequency>(
                      value: freq,
                      child: Text(frequencyNames[freq]!),
                    );
                  }).toList(),
                  onChanged: (Frequency? newValue) {
                    setState(() {
                      _frequency = newValue;
                    });
                  },
                  validator: (value) {
                    if (_taskType == TaskType.Routine && value == null) {
                      return 'Please select a frequency';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              // Scheduled Time or Part of Day
              if (_taskType == TaskType.Task)
                ListTile(
                  title: Text(_scheduledTime != null
                      ? 'Scheduled Time: ${_scheduledTime!.format(context)}'
                      : 'No Scheduled Time'),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _scheduledTime = picked;
                        });
                      }
                    },
                  ),
                )
              else if (_taskType == TaskType.Routine)
                _scheduledTime == null
                    ? DropdownButtonFormField<PartOfDay>(
                        value: _partOfDay,
                        decoration:
                            const InputDecoration(labelText: 'Part of Day'),
                        items: PartOfDay.values.map((PartOfDay part) {
                          return DropdownMenuItem<PartOfDay>(
                            value: part,
                            child: Text(partOfDayNames[part]!),
                          );
                        }).toList(),
                        onChanged: (PartOfDay? newValue) {
                          setState(() {
                            _partOfDay = newValue;
                          });
                        },
                        validator: (value) {
                          if (_taskType == TaskType.Routine && value == null) {
                            return 'Please select a part of day or provide a time';
                          }
                          return null;
                        },
                      )
                    : ListTile(
                        title: Text(
                            'Scheduled Time: ${_scheduledTime!.format(context)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _scheduledTime = picked;
                              });
                            }
                          },
                        ),
                      ),
              const SizedBox(height: 10),
              // Alarm (only if Task and time-based)
              if (_taskType == TaskType.Task && _scheduledTime != null)
                SwitchListTile(
                  title: const Text('Alarm'),
                  value: _hasAlarm,
                  onChanged: (bool value) {
                    setState(() {
                      _hasAlarm = value;
                    });
                  },
                ),
              // Notification (always enabled)
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: true, // Always true as per requirements
                onChanged: null, // Disabled switch
              ),
              const SizedBox(height: 10),
              // Priority
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priorityNames[priority]!),
                  );
                }).toList(),
                onChanged: (TaskPriority? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _priority = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              // Folder Selection
              DropdownButtonFormField<String>(
                value: _selectedFolderId,
                decoration: const InputDecoration(labelText: 'Folder'),
                items: folderProvider.folders
                    .map<DropdownMenuItem<String>>((Folder folder) {
                  return DropdownMenuItem<String>(
                    value: folder.id,
                    child: Text(folder.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFolderId = newValue;
                  });
                },
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please select a folder'
                    : null,
              ),
              const SizedBox(height: 10),
              // Subtasks
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subtasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ..._subtasks.asMap().entries.map((entry) {
                    int index = entry.key;
                    Subtask subtask = entry.value;
                    return ListTile(
                      leading: Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (bool? value) {
                          setState(() {
                            subtask.isCompleted = value ?? false;
                          });
                        },
                      ),
                      title: TextFormField(
                        initialValue: subtask.title,
                        decoration: const InputDecoration(
                          hintText: 'Subtask Title',
                        ),
                        onChanged: (value) {
                          subtask.title = value;
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeSubtask(index);
                        },
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: _addSubtask,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Subtask'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
