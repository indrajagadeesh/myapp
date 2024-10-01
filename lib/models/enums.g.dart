// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTypeAdapter extends TypeAdapter<TaskType> {
  @override
  final int typeId = 0;

  @override
  TaskType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskType.Task;
      case 1:
        return TaskType.Routine;
      default:
        return TaskType.Task;
    }
  }

  @override
  void write(BinaryWriter writer, TaskType obj) {
    switch (obj) {
      case TaskType.Task:
        writer.writeByte(0);
        break;
      case TaskType.Routine:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.Regular;
      case 1:
        return TaskPriority.Important;
      case 2:
        return TaskPriority.VeryImportant;
      case 3:
        return TaskPriority.Urgent;
      default:
        return TaskPriority.Regular;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.Regular:
        writer.writeByte(0);
        break;
      case TaskPriority.Important:
        writer.writeByte(1);
        break;
      case TaskPriority.VeryImportant:
        writer.writeByte(2);
        break;
      case TaskPriority.Urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 2;

  @override
  Frequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Frequency.Daily;
      case 1:
        return Frequency.Weekly;
      case 2:
        return Frequency.BiWeekly;
      case 3:
        return Frequency.Monthly;
      default:
        return Frequency.Daily;
    }
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    switch (obj) {
      case Frequency.Daily:
        writer.writeByte(0);
        break;
      case Frequency.Weekly:
        writer.writeByte(1);
        break;
      case Frequency.BiWeekly:
        writer.writeByte(2);
        break;
      case Frequency.Monthly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartOfDayAdapter extends TypeAdapter<PartOfDay> {
  @override
  final int typeId = 3;

  @override
  PartOfDay read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartOfDay.WakeUp;
      case 1:
        return PartOfDay.Lunch;
      case 2:
        return PartOfDay.Evening;
      case 3:
        return PartOfDay.Dinner;
      default:
        return PartOfDay.WakeUp;
    }
  }

  @override
  void write(BinaryWriter writer, PartOfDay obj) {
    switch (obj) {
      case PartOfDay.WakeUp:
        writer.writeByte(0);
        break;
      case PartOfDay.Lunch:
        writer.writeByte(1);
        break;
      case PartOfDay.Evening:
        writer.writeByte(2);
        break;
      case PartOfDay.Dinner:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
