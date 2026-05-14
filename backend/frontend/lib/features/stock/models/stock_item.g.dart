// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockItemAdapter extends TypeAdapter<StockItem> {
  @override
  final int typeId = 1;

  @override
  StockItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockItem(
      name: fields[0] as String,
      mrp: fields[1] as String,
      qty: fields[2] as String,
      unit: fields[3] as String,
      rate: fields[4] as String,
      date: fields[5] as String,
      tax: fields[6] as String,
      taxType: fields[7] as String,
      productCode: fields[8] as String,
      imagePath: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StockItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mrp)
      ..writeByte(2)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.tax)
      ..writeByte(7)
      ..write(obj.taxType)
      ..writeByte(8)
      ..write(obj.productCode)
      ..writeByte(9)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
