// lib/utils/constants.dart

import 'package:flutter/material.dart';
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
    default:
      return 'Unknown';
  }
}

String taskTypeText(TaskType taskType) {
  switch (taskType) {
    case TaskType.Task:
      return 'Task';
    case TaskType.Routine:
      return 'Routine';
    default:
      return 'Unknown';
  }
}

Color priorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.Regular:
      return Colors.green;
    case TaskPriority.Important:
      return Colors.blue;
    case TaskPriority.VeryImportant:
      return Colors.orange;
    case TaskPriority.Urgent:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String frequencyText(Frequency frequency) {
  switch (frequency) {
    case Frequency.Daily:
      return 'Daily';
    case Frequency.Weekly:
      return 'Weekly';
    case Frequency.BiWeekly:
      return 'Bi-Weekly';
    case Frequency.Monthly:
      return 'Monthly';
    default:
      return 'Unknown';
  }
}

String weekdayText(Weekday weekday) {
  switch (weekday) {
    case Weekday.Monday:
      return 'Monday';
    case Weekday.Tuesday:
      return 'Tuesday';
    case Weekday.Wednesday:
      return 'Wednesday';
    case Weekday.Thursday:
      return 'Thursday';
    case Weekday.Friday:
      return 'Friday';
    case Weekday.Saturday:
      return 'Saturday';
    case Weekday.Sunday:
      return 'Sunday';
    default:
      return 'Unknown';
  }
}

String partOfDayText(PartOfDay partOfDay) {
  switch (partOfDay) {
    case PartOfDay.WakeUp:
      return 'Wake Up';
    case PartOfDay.Lunch:
      return 'Lunch';
    case PartOfDay.Evening:
      return 'Evening';
    case PartOfDay.Dinner:
      return 'Dinner';
    default:
      return 'Unknown';
  }
}
