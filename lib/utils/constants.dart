// lib/utils/constants.dart

import '../models/task.dart';

String priorityText(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.Regular:
      return 'Regular';
    case TaskPriority.Important:
      return 'Important';
    case TaskPriority.VeryImportant:
      return 'Very Important';
    case TaskPriority.Urgent:
      return 'Urgent';
  }
}

String taskTypeText(TaskType taskType) {
  return taskType == TaskType.Task ? 'Task' : 'Routine';
}