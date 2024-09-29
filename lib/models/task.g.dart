// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 2;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      taskType: fields[3] as TaskType,
      scheduledTime: fields[4] as DateTime?,
      hasAlarm: fields[5] as bool,
      priority: fields[6] as TaskPriority,
      subtasks: (fields[7] as List).cast<Subtask>(),
      timeSpent: fields[8] as Duration,
      folderId: fields[9] as String?,
      isCompleted: fields[10] as bool,
      completedDate: fields[11] as DateTime?,
      isRepetitive: fields[12] as bool,
      frequency: fields[13] as Frequency,
      selectedWeekdays: (fields[14] as List?)?.cast<Weekday>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.taskType)
      ..writeByte(4)
      ..write(obj.scheduledTime)
      ..writeByte(5)
      ..write(obj.hasAlarm)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.subtasks)
      ..writeByte(8)
      ..write(obj.timeSpent)
      ..writeByte(9)
      ..write(obj.folderId)
      ..writeByte(10)
      ..write(obj.isCompleted)
      ..writeByte(11)
      ..write(obj.completedDate)
      ..writeByte(12)
      ..write(obj.isRepetitive)
      ..writeByte(13)
      ..write(obj.frequency)
      ..writeByte(14)
      ..write(obj.selectedWeekdays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
  final int typeId = 5;

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

class WeekdayAdapter extends TypeAdapter<Weekday> {
  @override
  final int typeId = 6;

  @override
  Weekday read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Weekday.Monday;
      case 1:
        return Weekday.Tuesday;
      case 2:
        return Weekday.Wednesday;
      case 3:
        return Weekday.Thursday;
      case 4:
        return Weekday.Friday;
      case 5:
        return Weekday.Saturday;
      case 6:
        return Weekday.Sunday;
      default:
        return Weekday.Monday;
    }
  }

  @override
  void write(BinaryWriter writer, Weekday obj) {
    switch (obj) {
      case Weekday.Monday:
        writer.writeByte(0);
        break;
      case Weekday.Tuesday:
        writer.writeByte(1);
        break;
      case Weekday.Wednesday:
        writer.writeByte(2);
        break;
      case Weekday.Thursday:
        writer.writeByte(3);
        break;
      case Weekday.Friday:
        writer.writeByte(4);
        break;
      case Weekday.Saturday:
        writer.writeByte(5);
        break;
      case Weekday.Sunday:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekdayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
