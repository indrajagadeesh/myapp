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
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.isCompleted);
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
