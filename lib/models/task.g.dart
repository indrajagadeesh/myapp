// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 7;

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
      isCompleted: fields[4] as bool,
      completedDate: fields[5] as DateTime?,
      scheduledTime: fields[6] as DateTime?,
      hasAlarm: fields[7] as bool,
      priority: fields[8] as TaskPriority,
      subtasks: (fields[9] as List?)?.cast<Subtask>(),
      folderId: fields[10] as String,
      isRepetitive: fields[11] as bool,
      frequency: fields[12] as Frequency?,
      partOfDay: fields[13] as PartOfDay?,
      timeSpentMicroseconds: fields[14] as int?,
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
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.completedDate)
      ..writeByte(6)
      ..write(obj.scheduledTime)
      ..writeByte(7)
      ..write(obj.hasAlarm)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.subtasks)
      ..writeByte(10)
      ..write(obj.folderId)
      ..writeByte(11)
      ..write(obj.isRepetitive)
      ..writeByte(12)
      ..write(obj.frequency)
      ..writeByte(13)
      ..write(obj.partOfDay)
      ..writeByte(14)
      ..write(obj.timeSpentMicroseconds);
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
