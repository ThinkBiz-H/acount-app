// class BillItem {
//   String name;
//   int qty;
//   double price;

//   BillItem({required this.name, required this.qty, required this.price});

//   double get total => qty * price;
// }

class BillItem {
  String name;
  int qty;
  double price;

  BillItem({required this.name, required this.qty, required this.price});

  double get total => qty * price;

  /// ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {"name": name, "qty": qty, "price": price};
  }

  /// ================= FROM JSON =================

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      name: json["name"] ?? "",
      qty: json["qty"] ?? 0,
      price: (json["price"] ?? 0).toDouble(),
    );
  }
}
