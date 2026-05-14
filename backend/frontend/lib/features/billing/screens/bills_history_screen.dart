// import 'bill_preview_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import 'create_bill_screen.dart';
// import 'package:printing/printing.dart';
// import '../services/bill_pdf_service.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'bill_share_preview_screen.dart';
// import '../../../providers/bill_template_provider.dart';
// class BillsHistoryScreen extends StatefulWidget {
//   const BillsHistoryScreen({super.key});

//   @override
//   State<BillsHistoryScreen> createState() => _BillsHistoryScreenState();
// }

// class _BillsHistoryScreenState extends State<BillsHistoryScreen> {
//   /// ⭐ DELETE BILL (NOW INSIDE STATE CLASS → setState WORKS)
//   Future<void> _deleteBill(BuildContext context, dynamic billKey) async {
//     final confirm = await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Delete Bill?"),
//         content: const Text("This bill will be permanently deleted."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       /// ⭐ close dialog safely first
//       Navigator.of(context, rootNavigator: true).pop();

//       /// ⭐ delete bill
//       Hive.box('bills').delete(billKey);

//       /// ⭐ refresh list safely after frame
//       if (mounted) {
//         setState(() {});
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Bill Deleted")));
//     }
//   }

//   /// ⭐ BOTTOM SHEET
//   void _openBillActionsSheet(BuildContext context, dynamic billKey, Map bill) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               /// TOP BILL CARD
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 22,
//                       backgroundColor: Colors.green.shade200,
//                       child: const Icon(
//                         Icons.receipt_long,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Bill ${bill['billNumber']}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(bill['customerName']),
//                       ],
//                     ),
//                     const Spacer(),
//                     Text(
//                       "₹${bill['grandTotal']}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               /// ACTION GRID
//               GridView.count(
//                 shrinkWrap: true,
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 18,
//                 crossAxisSpacing: 10,
//                 children: [
//                   /// SHARE PDF
//                   _BillAction(Icons.share, "Share", () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BillSharePreviewScreen(bill: bill),
//                       ),
//                     );
//                   }),

//                   /// DOWNLOAD PDF
//                   _BillAction(Icons.download, "Download", () async {
//                    final template = context.read<BillTemplateProvider>().selectedTemplate;
// final pdfData = await BillPdfService.generateBillPdf(bill, template);
//                     await Printing.layoutPdf(
//                       onLayout: (format) async => pdfData,
//                     );
//                   }),

//                   /// EDIT BILL
//                   _BillAction(Icons.edit, "Edit", () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CreateBillScreen(
//                           billKey: billKey,
//                           existingBill: bill,
//                         ),
//                       ),
//                     );
//                   }),

//                   /// DELETE BILL
//                   _BillAction(Icons.delete, "Delete", () {
//                     _deleteBill(context, billKey);
//                   }),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final box = Hive.box('bills');

//     return Scaffold(
//       appBar: AppBar(title: const Text("Saved Bills")),

//       body: ValueListenableBuilder(
//         valueListenable: box.listenable(),
//         builder: (context, Box box, _) {
//           final keys = box.keys.toList().reversed.toList();

//           if (keys.isEmpty) {
//             return const Center(child: Text("No Bills Saved Yet"));
//           }

//           return ListView.builder(
//             itemCount: keys.length,
//             itemBuilder: (context, index) {
//               final key = keys[index];
//               final bill = box.get(key);
//               final bool isPaid = bill['paid'] ?? false;

//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   title: Text("Bill ${bill['billNumber']}"),
//                   subtitle: Text(bill['customerName']),

//                   trailing: SizedBox(
//                     width: 90,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("₹${bill['grandTotal']}"),
//                             Text(
//                               isPaid ? "Paid" : "Unpaid",
//                               style: TextStyle(
//                                 color: isPaid ? Colors.green : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         IconButton(
//                           icon: const Icon(Icons.more_vert),
//                           onPressed: () =>
//                               _openBillActionsSheet(context, key, bill),
//                         ),
//                       ],
//                     ),
//                   ),

//                   /// ⭐ TOGGLE PAID / UNPAID (NO setState needed now)
//                   onLongPress: () {
//                     final provider = Provider.of<CustomerProvider>(
//                       context,
//                       listen: false,
//                     );

//                     final newStatus = !isPaid;
//                     box.put(key, {...bill, 'paid': newStatus});

//                     provider.addTransaction(bill['customerName'], {
//                       'amount': (bill['grandTotal'] as num).toDouble(),
//                       'note':
//                           'Bill ${bill['billNumber']} ${newStatus ? "Paid" : "Unpaid"}',
//                       'date': DateTime.now(),
//                       'type': newStatus ? 'RECEIVED' : 'GIVEN',
//                     });
//                   },

//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BillPreviewScreen(
//                           billKey: key,
//                           customerName: bill['customerName'],
//                           mobile: bill['mobile'] ?? "",
//                           address: bill['address'] ?? "",
//                           billNumber: bill['billNumber'],
//                           billDate: DateTime.parse(bill['date']),
//                           items: List<Map<String, dynamic>>.from(bill['items']),
//                           subTotal: (bill['subTotal'] as num).toDouble(),
//                           gstTotal: (bill['gst'] as num).toDouble(),
//                           cessTotal: (bill['cess'] as num).toDouble(),
//                           charges: (bill['charges'] as num).toDouble(),
//                           discount: (bill['discount'] as num).toDouble(),
//                           grandTotal: (bill['grandTotal'] as num).toDouble(),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class _BillAction extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const _BillAction(this.icon, this.title, this.onTap);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 26,
//             backgroundColor: Colors.grey.shade200,
//             child: Icon(icon, color: Colors.black87),
//           ),
//           const SizedBox(height: 6),
//           Text(title, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
// }
// //
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../../services/api_service.dart';
// import 'bill_preview_screen.dart';

// class BillsHistoryScreen extends StatefulWidget {
//   const BillsHistoryScreen({super.key});

//   @override
//   State<BillsHistoryScreen> createState() => _BillsHistoryScreenState();
// }

// class _BillsHistoryScreenState extends State<BillsHistoryScreen> {
//   List bills = [];
//   bool loading = true;

//   Future loadBills() async {
//     final settings = Hive.box('settings');
//     final mobile = settings.get('mobile');

//     final res = await ApiService.getBills(mobile);

//     if (res["success"] == true) {
//       setState(() {
//         bills = res["data"];
//         loading = false;
//       });
//     }
//   }

//   Future deleteBill(String id) async {
//     await ApiService.deleteBill(id);
//     loadBills();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadBills();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Saved Bills")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : bills.isEmpty
//           ? const Center(child: Text("No Bills Found"))
//           : ListView.builder(
//               itemCount: bills.length,
//               itemBuilder: (context, index) {
//                 final bill = bills[index];

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text("Bill ${bill['billNumber']}"),
//                     subtitle: Text(bill['customerName']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("₹${bill['grandTotal']}"),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () => deleteBill(bill["_id"]),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BillPreviewScreen(
//                             billKey: bill["_id"],
//                              existingBill: bill,
//                             customerName: bill['customerName'],
//                             mobile: bill['mobile'] ?? "",
//                             address: bill['address'] ?? "",
//                             billNumber: bill['billNumber'],
//                             billDate: DateTime.parse(bill['date']),
//                             items: List<Map<String, dynamic>>.from(
//                               bill['items'],
//                             ),
//                             subTotal: (bill['subTotal'] as num).toDouble(),
//                             gstTotal: (bill['gstTotal'] as num).toDouble(),
//                             cessTotal: (bill['cessTotal'] as num).toDouble(),
//                             charges: (bill['charges'] as num).toDouble(),
//                             discount: (bill['discount'] as num).toDouble(),
//                             grandTotal: (bill['grandTotal'] as num).toDouble(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../../services/api_service.dart';
// import 'bill_preview_screen.dart';

// class BillsHistoryScreen extends StatefulWidget {
//   const BillsHistoryScreen({super.key});

//   @override
//   State<BillsHistoryScreen> createState() => _BillsHistoryScreenState();
// }

// class _BillsHistoryScreenState extends State<BillsHistoryScreen> {
//   List bills = [];
//   bool loading = true;

//   Future loadBills() async {
//     final settings = Hive.box('settings');
//     final mobile = settings.get('mobile');

//     final res = await ApiService.getBills(mobile);

//     if (res["success"] == true) {
//       setState(() {
//         bills = res["data"];
//         loading = false;
//       });
//     }
//   }

//   Future deleteBill(String id) async {
//     await ApiService.deleteBill(id);
//     loadBills();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadBills();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Saved Bills")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : bills.isEmpty
//               ? const Center(child: Text("No Bills Found"))
//               : ListView.builder(
//                   itemCount: bills.length,
//                   itemBuilder: (context, index) {
//                     final bill = bills[index];

//                     return Card(
//                       margin: const EdgeInsets.all(10),
//                       child: ListTile(
//                         title: Text("Bill ${bill['billNumber']}"),
//                         subtitle: Text(bill['customerName']),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text("₹${bill['grandTotal']}"),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () => deleteBill(bill["_id"]),
//                             ),
//                           ],
//                         ),

//                         // 🔥 FINAL FIX HERE
//                         onTap: () async {
//                           final result = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BillPreviewScreen(
//                                 billKey: bill["_id"],
//                                 existingBill: bill,
//                                 customerName: bill['customerName'],
//                                 mobile: bill['mobile'] ?? "",
//                                 address: bill['address'] ?? "",
//                                 billNumber: bill['billNumber'],
//                                 billDate: DateTime.parse(bill['date']),
//                                 items: List<Map<String, dynamic>>.from(
//                                   bill['items'],
//                                 ),
//                                 subTotal:
//                                     (bill['subTotal'] as num).toDouble(),
//                                 gstTotal:
//                                     (bill['gstTotal'] as num).toDouble(),
//                                 cessTotal:
//                                     (bill['cessTotal'] as num).toDouble(),
//                                 charges:
//                                     (bill['charges'] as num).toDouble(),
//                                 discount:
//                                     (bill['discount'] as num).toDouble(),
//                                 grandTotal:
//                                     (bill['grandTotal'] as num).toDouble(),
//                               ),
//                             ),
//                           );

//                           // 🔥 REFRESH AFTER BACK
//                           if (result == true) {
//                             loadBills(); // 🔥 IMPORTANT
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../services/api_service.dart';
import 'bill_preview_screen.dart';

class BillsHistoryScreen extends StatefulWidget {
  const BillsHistoryScreen({super.key});

  @override
  State<BillsHistoryScreen> createState() => _BillsHistoryScreenState();
}

class _BillsHistoryScreenState extends State<BillsHistoryScreen> {
  List bills = [];
  bool loading = true;

  Future loadBills() async {
    final settings = Hive.box('settings');
    final mobile = settings.get('mobile');

    final res = await ApiService.getBills(mobile);

    if (res["success"] == true) {
      setState(() {
        bills = res["data"];
        loading = false;
      });
    }
  }

  Future deleteBill(String id) async {
    await ApiService.deleteBill(id);
    loadBills();
  }

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Bills")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bills.isEmpty
          ? const Center(child: Text("No Bills Found"))
          : ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Bill ${bill['billNumber']}"),
                    subtitle: Text(bill['customerName']),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text("₹${bill['grandTotal']}"),
                        Text(
                          "₹${bill['grandTotal']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bill['paid'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "view") {
                              openBill(bill, true);
                            } else if (value == "edit") {
                              openBill(bill, false);
                            } else if (value == "delete") {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Bill"),
                                  content: const Text("Are you sure?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteBill(bill["_id"]);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "view", child: Text("View")),
                            PopupMenuItem(value: "edit", child: Text("Edit")),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future openBill(dynamic bill, bool isView) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillPreviewScreen(
          billKey: bill["_id"],
          existingBill: bill,
          customerName: bill['customerName'],
          mobile: bill['mobile'] ?? "",
          address: bill['address'] ?? "",
          billNumber: bill['billNumber'],
          billDate: DateTime.parse(bill['date']),
          items: List<Map<String, dynamic>>.from(bill['items']),
          subTotal: (bill['subTotal'] as num).toDouble(),
          gstTotal: (bill['gstTotal'] as num).toDouble(),
          cessTotal: (bill['cessTotal'] as num).toDouble(),
          charges: (bill['charges'] as num).toDouble(),
          discount: (bill['discount'] as num).toDouble(),
          grandTotal: (bill['grandTotal'] as num).toDouble(),
          isViewOnly: isView, // 🔥 MAIN FIX
        ),
      ),
    );

    if (result == true) {
      loadBills();
    }
  }
}
