// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberAdapter extends TypeAdapter<Number> {
  @override
  final int typeId = 0;

  @override
  Number read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Number(
      text: fields[0] as String,
      year: fields[1] as int?,
      number: fields[2] as int,
      found: fields[3] as bool,
      type: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Number obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.found)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
