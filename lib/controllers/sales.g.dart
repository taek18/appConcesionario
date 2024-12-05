// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesAdapter extends TypeAdapter<Sales> {
  @override
  final int typeId = 3;

  @override
  Sales read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sales(
      vehicle: fields[0] as Vehicle,
      client: fields[1] as Client,
      date: fields[2] as DateTime,
      paymentType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sales obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.vehicle)
      ..writeByte(1)
      ..write(obj.client)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.paymentType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
