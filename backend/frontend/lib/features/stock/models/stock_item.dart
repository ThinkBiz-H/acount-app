// import 'package:hive/hive.dart';

// part 'stock_item.g.dart';

// @HiveType(typeId: 1)
// class StockItem extends HiveObject {

//   @HiveField(0)
//   String name;

//   @HiveField(1)
//   String mrp;

//   @HiveField(2)
//   String qty;

//   @HiveField(3)
//   String unit;

//   @HiveField(4)
//   String rate;

//   @HiveField(5)
//   String date;

//   @HiveField(6)
//   String tax;

//   @HiveField(7)
//   String taxType; // Included / Excluded

//   @HiveField(8)
//   String productCode;

//   @HiveField(9)
//   String imagePath;

//   StockItem({
//     required this.name,
//     required this.mrp,
//     required this.qty,
//     required this.unit,
//     required this.rate,
//     required this.date,
//     required this.tax,
//     required this.taxType,
//     required this.productCode,
//     required this.imagePath,
//   });
// }

import 'package:hive/hive.dart';

part 'stock_item.g.dart';

@HiveType(typeId: 1)
class StockItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String mrp;

  @HiveField(2)
  String qty;

  @HiveField(3)
  String unit;

  @HiveField(4)
  String rate;

  @HiveField(5)
  String date;

  @HiveField(6)
  String tax;

  @HiveField(7)
  String taxType; // Included / Excluded

  @HiveField(8)
  String productCode;

  @HiveField(9)
  String imagePath;

  StockItem({
    required this.name,
    required this.mrp,
    required this.qty,
    required this.unit,
    required this.rate,
    required this.date,
    required this.tax,
    required this.taxType,
    required this.productCode,
    required this.imagePath,
  });
}
