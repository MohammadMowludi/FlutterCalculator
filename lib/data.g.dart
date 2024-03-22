// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 0;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History()
      ..calculate = fields[0] as String
      ..time = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.calculate)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeLightNightAdapter extends TypeAdapter<ThemeLightNight> {
  @override
  final int typeId = 1;

  @override
  ThemeLightNight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeLightNight()..darkMode = fields[0] as bool;
  }

  @override
  void write(BinaryWriter writer, ThemeLightNight obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.darkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeLightNightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
