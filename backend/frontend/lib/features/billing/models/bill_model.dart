// import 'bill_item_model.dart';

// class BillModel {
//   String id; // ⭐ unique id for edit/update
//   String billNo;
//   DateTime date;
//   String customerName;
//   List<BillItem> items;
//   double discount;
//   double extraCharges;
//   bool isPaid; // ⭐ VERY IMPORTANT

//   BillModel({
//     required this.id,
//     required this.billNo,
//     required this.date,
//     required this.customerName,
//     required this.items,
//     this.discount = 0,
//     this.extraCharges = 0,
//     this.isPaid = false,
//   });

//   double get subTotal => items.fold(0, (sum, item) => sum + item.total);

//   double get grandTotal => subTotal - discount + extraCharges;
// }

import 'bill_item_model.dart';

class BillModel {
  String id;
  String billNo;
  DateTime date;
  String customerName;
  List<BillItem> items;
  double discount;
  double extraCharges;
  bool isPaid;

  BillModel({
    required this.id,
    required this.billNo,
    required this.date,
    required this.customerName,
    required this.items,
    this.discount = 0,
    this.extraCharges = 0,
    this.isPaid = false,
  });

  /// SUB TOTAL
  double get subTotal => items.fold(0, (sum, item) => sum + item.total);

  /// GRAND TOTAL
  double get grandTotal => subTotal - discount + extraCharges;

  /// ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "billNo": billNo,
      "date": date.toIso8601String(),
      "customerName": customerName,
      "items": items.map((e) => e.toJson()).toList(),
      "discount": discount,
      "extraCharges": extraCharges,
      // "isPaid": isPaid,
      "paid": isPaid,
    };
  }

  /// ================= FROM JSON =================

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json["id"] ?? "",
      billNo: json["billNo"] ?? "",
      date: DateTime.parse(json["date"]),
      customerName: json["customerName"] ?? "",
      items: (json["items"] as List).map((e) => BillItem.fromJson(e)).toList(),
      discount: (json["discount"] ?? 0).toDouble(),
      extraCharges: (json["extraCharges"] ?? 0).toDouble(),
      // isPaid: json["isPaid"] ?? false,
      isPaid: json["paid"] ?? false,
    );
  }
}
