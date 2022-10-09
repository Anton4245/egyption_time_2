// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingAdapter extends TypeAdapter<Meeting> {
  @override
  final int typeId = 1;

  @override
  Meeting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meeting()
      .._id = fields[10] as String
      .._version = fields[11] as int
      .._fieldsVersion = fields[12] as int
      ..nameOfLastModifyingField = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, Meeting obj) {
    writer
      ..writeByte(4)
      ..writeByte(10)
      ..write(obj._id)
      ..writeByte(11)
      ..write(obj._version)
      ..writeByte(12)
      ..write(obj._fieldsVersion)
      ..writeByte(13)
      ..write(obj.nameOfLastModifyingField);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
