// class Customer {
//   String name;
//   String mobile;
//   String address;
//   String type;
//   bool smsEnabled;
//   String? imageBase64;

//   bool isHidden; // ⭐ dashboard se hide karne ke liye

//   /// ⭐ AUTO REMINDER FIELDS
//   DateTime? reminderStartDate;
//   int? reminderDays;
//   DateTime? dueDate;

//   List<Map<String, dynamic>> transactions = [];

//   Customer({
//     required this.name,
//     required this.mobile,
//     required this.address,
//     required this.type,
//     this.smsEnabled = false,
//     this.imageBase64,
//     this.reminderStartDate,
//     this.reminderDays,
//     this.isHidden = false,
//   });

//   double get balance {
//     double b = 0;
//     for (var t in transactions) {
//       if (t['type'] == 'GIVEN') {
//         b += t['amount'];
//       } else {
//         b -= t['amount'];
//       }
//     }
//     return b;
//   }
// }
class Customer {
  /// ⭐ DATABASE ID
  String id;

  String name;
  String mobile;
  String address;
  String type;

  bool smsEnabled;
  String? imageBase64;

  bool isHidden;

  /// AUTO REMINDER
  DateTime? reminderStartDate;
  int? reminderDays;
  DateTime? dueDate;

  /// TRANSACTIONS
  List<Map<String, dynamic>> transactions;

  Customer({
    this.id = "",
    required this.name,
    required this.mobile,
    required this.address,
    required this.type,
    this.smsEnabled = false,
    this.imageBase64,
    this.reminderStartDate,
    this.reminderDays,
    this.isHidden = false,
    List<Map<String, dynamic>>? transactions,
  }) : transactions = transactions ?? [];

  /// ⭐ BALANCE CALCULATION
  double get balance {
    double b = 0;

    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        b += (t['amount'] ?? 0);
      } else {
        b -= (t['amount'] ?? 0);
      }
    }

    return b;
  }

  /// ⭐ BACKEND JSON → MODEL
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      mobile: json["mobile"] ?? "",
      address: json["address"] ?? "",
      type: json["type"] ?? "CUSTOMER",
      imageBase64: json["imageBase64"],
    );
  }
}
