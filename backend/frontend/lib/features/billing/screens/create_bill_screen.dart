// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'add_item_screen.dart';
// import 'charges_discount_screen.dart';
// import 'bill_preview_screen.dart';
// import 'edit_bill_details_screen.dart';

// class CreateBillScreen extends StatefulWidget {
//   final int? billKey;
//   final Map? existingBill;

//   const CreateBillScreen({super.key, this.billKey, this.existingBill});

//   @override
//   State<CreateBillScreen> createState() => _CreateBillScreenState();
// }

// class _CreateBillScreenState extends State<CreateBillScreen> {
//   List<Map<String, dynamic>> items = [];

//   String customerName = "Add Customer";
//   String mobile = "";
//   String address = "";
//   String billNumber = "";
//   DateTime billDate = DateTime.now();

//   double charges = 0;
//   double discount = 0;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.existingBill != null) {
//       final bill = widget.existingBill!;
//       customerName = bill['customerName'];
//       mobile = bill['mobile'];
//       billNumber = bill['billNumber'];
//       billDate = DateTime.parse(bill['date']);
//       items = List<Map<String, dynamic>>.from(bill['items']);
//       charges = (bill['charges'] as num).toDouble();
//       discount = (bill['discount'] as num).toDouble();
//     } else {
//       final box = Hive.box('bills');
//       billNumber = "BILL-${box.length + 1}";
//     }
//   }

//   double get subTotal =>
//       items.fold(0, (sum, i) => sum + (i['baseAmount'] ?? 0));
//   double get totalGST => items.fold(0, (sum, i) => sum + (i['gstAmount'] ?? 0));
//   double get totalCESS =>
//       items.fold(0, (sum, i) => sum + (i['cessAmount'] ?? 0));
//   double get beforeCharges => subTotal + totalGST + totalCESS;
//   double get grandTotal => beforeCharges + charges - discount;

//   void addItem() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const AddItemScreen()),
//     );
//     if (result != null) setState(() => items.addAll(result));
//   }

//   void openCharges() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChargesDiscountScreen(subTotal: beforeCharges),
//       ),
//     );
//     if (result != null) {
//       setState(() {
//         charges = result['charges'] ?? 0;
//         discount = result['discount'] ?? 0;
//       });
//     }
//   }

//   void openEdit() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditBillDetailsScreen(
//           name: customerName,
//           mobile: mobile,
//           address: address,
//           billNumber: billNumber,
//           date: billDate,
//         ),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         customerName = result['name'];
//         mobile = result['mobile'];
//         address = result['address'];
//         billNumber = result['billNumber'];
//         billDate = result['date'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text("Bill To\n$customerName"),
//         actions: [
//           TextButton.icon(
//             onPressed: openEdit,
//             icon: const Icon(Icons.edit, size: 16),
//             label: const Text("Edit"),
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           /// ITEMS LIST
//           Expanded(
//             child: items.isEmpty
//                 ? const Center(child: Text("No Items Added"))
//                 : ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, i) {
//                       final item = items[i];
//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text(item['name']),
//                           subtitle: Text("${item['qty']} x ₹${item['rate']}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text("₹${item['baseAmount']}"),
//                               IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () =>
//                                     setState(() => items.removeAt(i)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           /// ADD ITEM BUTTON
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton.icon(
//               onPressed: addItem,
//               icon: const Icon(Icons.add),
//               label: const Text("Add Item"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0C2752),
//                 minimumSize: const Size(double.infinity, 45),
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// SUMMARY + PREVIEW
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextButton(
//                   onPressed: items.isEmpty ? null : openCharges,
//                   child: const Text("Add Charges & Discount"),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: items.isEmpty
//                       ? null
//                       : () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BillPreviewScreen(
//                                 billKey: widget.billKey,
//                                 customerName: customerName,
//                                 mobile: mobile,
//                                 address: address,
//                                 billNumber: billNumber,
//                                 billDate: billDate,
//                                 items: items,
//                                 subTotal: subTotal,
//                                 gstTotal: totalGST,
//                                 cessTotal: totalCESS,
//                                 charges: charges,
//                                 discount: discount,
//                                 grandTotal: grandTotal,
//                               ),
//                             ),
//                           );
//                         },
//                   child: const Text("Preview Bill"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// //
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../../services/api_service.dart';

// import 'add_item_screen.dart';
// import 'charges_discount_screen.dart';
// import 'bill_preview_screen.dart';
// import 'edit_bill_details_screen.dart';

// class CreateBillScreen extends StatefulWidget {
//   final String? billKey;
//   final Map<String, dynamic>? existingBill;

//   const CreateBillScreen({super.key, this.billKey, this.existingBill});

//   @override
//   State<CreateBillScreen> createState() => _CreateBillScreenState();
// }

// class _CreateBillScreenState extends State<CreateBillScreen> {
//   List<Map<String, dynamic>> items = [];

//   String customerName = "Add Customer";
//   String mobile = "";
//   String address = "";
//   String billNumber = "";
//   DateTime billDate = DateTime.now();

//   double charges = 0;
//   double discount = 0;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.existingBill != null) {
//       final bill = widget.existingBill!;

//       customerName = bill['customerName'] ?? "";
//       mobile = bill['mobile'] ?? "";
//       address = bill['address'] ?? "";
//       billNumber = bill['billNumber'] ?? "";
//       billDate = DateTime.parse(bill['date']);
//       items = List<Map<String, dynamic>>.from(bill['items']);
//       charges = (bill['charges'] as num).toDouble();
//       discount = (bill['discount'] as num).toDouble();
//     } else {
//       billNumber = "BILL-${DateTime.now().millisecondsSinceEpoch}";
//     }
//   }

//   double get subTotal =>
//       items.fold(0, (sum, i) => sum + (i['baseAmount'] ?? 0));

//   double get totalGST => items.fold(0, (sum, i) => sum + (i['gstAmount'] ?? 0));

//   double get totalCESS =>
//       items.fold(0, (sum, i) => sum + (i['cessAmount'] ?? 0));

//   double get beforeCharges => subTotal + totalGST + totalCESS;

//   double get grandTotal => beforeCharges + charges - discount;

//   Future saveBill() async {
//     final settings = Hive.box('settings');
//     final ownerMobile = settings.get('mobile');

//     await ApiService.addBill({
//       "ownerMobile": ownerMobile,
//       "customerName": customerName,
//       "mobile": mobile,
//       "address": address,
//       "billNumber": billNumber,
//       "date": billDate.toIso8601String(),
//       "items": items,
//       "charges": charges,
//       "discount": discount,
//       "subTotal": subTotal,
//       "gstTotal": totalGST,
//       "cessTotal": totalCESS,
//       "grandTotal": grandTotal,
//     });
//   }

//   void addItem() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const AddItemScreen()),
//     );

//     if (result != null) {
//       setState(() {
//         items.addAll(result);
//       });
//     }
//   }

//   void openCharges() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChargesDiscountScreen(subTotal: beforeCharges),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         charges = result['charges'] ?? 0;
//         discount = result['discount'] ?? 0;
//       });
//     }
//   }

//   void openEdit() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditBillDetailsScreen(
//           name: customerName,
//           mobile: mobile,
//           address: address,
//           billNumber: billNumber,
//           date: billDate,
//         ),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         customerName = result['name'];
//         mobile = result['mobile'];
//         address = result['address'];
//         billNumber = result['billNumber'];
//         billDate = result['date'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text("Bill To\n$customerName"),
//         actions: [
//           TextButton.icon(
//             onPressed: openEdit,
//             icon: const Icon(Icons.edit, size: 16),
//             label: const Text("Edit"),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: items.isEmpty
//                 ? const Center(child: Text("No Items Added"))
//                 : ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, i) {
//                       final item = items[i];

//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text(item['name']),
//                           subtitle: Text("${item['qty']} x ₹${item['rate']}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text("₹${item['baseAmount']}"),
//                               IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () {
//                                   setState(() {
//                                     items.removeAt(i);
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton.icon(
//               onPressed: addItem,
//               icon: const Icon(Icons.add),
//               label: const Text("Add Item"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0C2752),
//                 minimumSize: const Size(double.infinity, 45),
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextButton(
//                   onPressed: items.isEmpty ? null : openCharges,
//                   child: const Text("Add Charges & Discount"),
//                 ),

//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   onPressed: items.isEmpty
//                       ? null
//                       : () async {
//                           final result = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BillPreviewScreen(
//                                 billKey: widget.billKey,
//                                 existingBill: widget.existingBill,
//                                 customerName: customerName,
//                                 mobile: mobile,
//                                 address: address,
//                                 billNumber: billNumber,
//                                 billDate: billDate,
//                                 items: items,
//                                 subTotal: subTotal,
//                                 gstTotal: totalGST,
//                                 cessTotal: totalCESS,
//                                 charges: charges,
//                                 discount: discount,
//                                 grandTotal: grandTotal,
//                               ),
//                             ),
//                           );

//                           if (result == true) {
//                             await saveBill();
//                             Navigator.pop(context);
//                           }
//                         },
//                   child: const Text("Preview Bill"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../services/api_service.dart';

import 'add_item_screen.dart';
import 'charges_discount_screen.dart';
import 'bill_preview_screen.dart';
import 'edit_bill_details_screen.dart';

class CreateBillScreen extends StatefulWidget {
  final String? billKey;
  final Map<String, dynamic>? existingBill;

  const CreateBillScreen({super.key, this.billKey, this.existingBill});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  List<Map<String, dynamic>> items = [];

  String customerName = "Add Customer";
  String mobile = "";
  String address = "";
  String billNumber = "";
  DateTime billDate = DateTime.now();

  double charges = 0;
  double discount = 0;

  @override
  void initState() {
    super.initState();

    if (widget.existingBill != null) {
      final bill = widget.existingBill!;

      customerName = bill['customerName'] ?? "";
      mobile = bill['mobile'] ?? "";
      address = bill['address'] ?? "";
      billNumber = bill['billNumber'] ?? "";
      billDate = DateTime.parse(bill['date']);
      items = List<Map<String, dynamic>>.from(bill['items']);
      charges = (bill['charges'] as num).toDouble();
      discount = (bill['discount'] as num).toDouble();
    } else {
      billNumber = "BILL-${DateTime.now().millisecondsSinceEpoch}";
    }
  }

  double get subTotal =>
      items.fold(0, (sum, i) => sum + (i['baseAmount'] ?? 0));

  double get totalGST => items.fold(0, (sum, i) => sum + (i['gstAmount'] ?? 0));

  double get totalCESS =>
      items.fold(0, (sum, i) => sum + (i['cessAmount'] ?? 0));

  double get beforeCharges => subTotal + totalGST + totalCESS;

  double get grandTotal => beforeCharges + charges - discount;

  void addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddItemScreen()),
    );

    if (result != null) {
      setState(() {
        items.addAll(result);
      });
    }
  }

  void openCharges() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChargesDiscountScreen(subTotal: beforeCharges),
      ),
    );

    if (result != null) {
      setState(() {
        charges = result['charges'] ?? 0;
        discount = result['discount'] ?? 0;
      });
    }
  }

  void openEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBillDetailsScreen(
          name: customerName,
          mobile: mobile,
          address: address,
          billNumber: billNumber,
          date: billDate,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        customerName = result['name'];
        mobile = result['mobile'];
        address = result['address'];
        billNumber = result['billNumber'];
        billDate = result['date'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Bill To\n$customerName"),
        actions: [
          TextButton.icon(
            onPressed: openEdit,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text("Edit"),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("No Items Added"))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(item['name']),
                          subtitle: Text("${item['qty']} x ₹${item['rate']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹${item['baseAmount']}"),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    items.removeAt(i);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: addItem,
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C2752),
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextButton(
                  onPressed: items.isEmpty ? null : openCharges,
                  child: const Text("Add Charges & Discount"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C2752),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: items.isEmpty
                      ? null
                      : () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BillPreviewScreen(
                                billKey: widget.billKey,
                                existingBill: widget.existingBill,
                                customerName: customerName,
                                mobile: mobile,
                                address: address,
                                billNumber: billNumber,
                                billDate: billDate,
                                items: items,
                                subTotal: subTotal,
                                gstTotal: totalGST,
                                cessTotal: totalCESS,
                                charges: charges,
                                discount: discount,
                                grandTotal: grandTotal,
                              ),
                            ),
                          );

                          // 🔥 FINAL FIX (NO DOUBLE SAVE)
                          if (result == true) {
                            Navigator.pop(context); // back to BillingScreen
                          }
                        },
                  child: const Text("Preview Bill"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
