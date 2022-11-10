// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_db_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoDbEntityAdapter extends TypeAdapter<TodoDbEntity> {
  @override
  final int typeId = 0;

  @override
  TodoDbEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoDbEntity(
      title: fields[0] as String,
      description: fields[1] as String,
      date: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoDbEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoDbEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
