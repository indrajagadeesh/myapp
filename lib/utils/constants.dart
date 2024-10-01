// lib/utils/constants.dart

import '../models/enums.dart';

const Map<PartOfDay, String> partOfDayNames = {
  PartOfDay.WakeUp: 'Wake Up',
  PartOfDay.Lunch: 'Lunch',
  PartOfDay.Evening: 'Evening',
  PartOfDay.Dinner: 'Dinner',
};

const Map<Frequency, String> frequencyNames = {
  Frequency.Daily: 'Daily',
  Frequency.Weekly: 'Weekly',
  Frequency.BiWeekly: 'Bi-Weekly',
  Frequency.Monthly: 'Monthly',
};

const Map<TaskPriority, String> priorityNames = {
  TaskPriority.Regular: 'Regular',
  TaskPriority.Important: 'Important',
  TaskPriority.VeryImportant: 'Very Important',
  TaskPriority.Urgent: 'Urgent',
};
