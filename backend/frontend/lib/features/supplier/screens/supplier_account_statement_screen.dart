// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// class SupplierAccountStatementScreen extends StatelessWidget {
//   const SupplierAccountStatementScreen({super.key});
//   String _formatTime(String? time) {
//     if (time == null) return "";

//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final suppliers = provider.suppliers;

//     /// ⭐ ALL SUPPLIER TRANSACTIONS MERGE
//     List<Map<String, dynamic>> allTx = [];

//     for (var s in suppliers) {
//       for (var tx in s.transactions) {
//         allTx.add({
//           "name": s.name,
//           "amount": tx["amount"],
//           "type": tx["type"],
//           "time": tx["time"], // ⭐ YE ADD KARO
//         });
//       }
//     }

//     /// CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Supplier Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// DATE CHIP
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.calendar_today, size: 16),
//                 SizedBox(width: 6),
//                 Text("Today"),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// TIMELINE LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: allTx.length,
//               itemBuilder: (context, index) {
//                 final tx = allTx[index];
//                 bool isCredit = tx["type"] == "GIVEN";

//                 return Align(
//                   alignment: isCredit
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isCredit
//                           ? Colors.red.shade50
//                           : Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(tx["name"]),
//                         Text(
//                           "₹${tx["amount"]}",
//                           style: TextStyle(
//                             color: isCredit ? Colors.red : Colors.green,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           tx["time"] != null
//                               ? _formatTime(tx["time"])
//                               : "No Time",
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// enum DateFilter { today, week, month }

// class SupplierAccountStatementScreen extends StatefulWidget {
//   const SupplierAccountStatementScreen({super.key});

//   @override
//   State<SupplierAccountStatementScreen> createState() =>
//       _SupplierAccountStatementScreenState();
// }

// class _SupplierAccountStatementScreenState
//     extends State<SupplierAccountStatementScreen> {
//   DateFilter selectedFilter = DateFilter.today;

//   /// 🕒 time format
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   /// 📅 Filter logic
//   bool _isInFilter(DateTime date) {
//     final now = DateTime.now();

//     if (selectedFilter == DateFilter.today) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     if (selectedFilter == DateFilter.week) {
//       final weekAgo = now.subtract(const Duration(days: 7));
//       return date.isAfter(weekAgo);
//     }

//     if (selectedFilter == DateFilter.month) {
//       return date.year == now.year && date.month == now.month;
//     }

//     return true;
//   }

//   /// 🟢 Filter chip
//   Widget _filterChip(String text, DateFilter filter) {
//     final isSelected = selectedFilter == filter;

//     return GestureDetector(
//       onTap: () => setState(() => selectedFilter = filter),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.green : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final suppliers = provider.suppliers;

//     /// 🔥 MERGE + FILTER SUPPLIER TRANSACTIONS
//     List<Map<String, dynamic>> allTx = [];

//     for (var s in suppliers) {
//       for (var tx in s.transactions) {
//         final DateTime time =
//             DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();

//         if (_isInFilter(time)) {
//           allTx.add({
//             "name": s.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     /// 💰 CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Supplier Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// 🔘 FILTER TABS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _filterChip("Today", DateFilter.today),
//               const SizedBox(width: 8),
//               _filterChip("Week", DateFilter.week),
//               const SizedBox(width: 8),
//               _filterChip("Month", DateFilter.month),
//             ],
//           ),

//           const SizedBox(height: 10),

//           /// 📊 TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📜 TIMELINE
//           Expanded(
//             child: ListView.builder(
//               itemCount: allTx.length,
//               itemBuilder: (context, index) {
//                 final tx = allTx[index];
//                 bool isCredit = tx["type"] == "GIVEN";

//                 return Align(
//                   alignment: isCredit
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isCredit
//                           ? Colors.red.shade50
//                           : Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(tx["name"]),
//                         Text(
//                           "₹${tx["amount"]}",
//                           style: TextStyle(
//                             color: isCredit ? Colors.red : Colors.green,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           _formatTime(tx["time"]),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../customer/screens/date_range_screen.dart';

// class SupplierAccountStatementScreen extends StatefulWidget {
//   const SupplierAccountStatementScreen({super.key});

//   @override
//   State<SupplierAccountStatementScreen> createState() =>
//       _SupplierAccountStatementScreenState();
// }

// class _SupplierAccountStatementScreenState
//     extends State<SupplierAccountStatementScreen> {
//   DateTime? startDate;
//   DateTime? endDate;

//   /// 🕒 time format
//   String _formatTime(String? time) {
//     if (time == null) return "";
//     final dt = DateTime.tryParse(time);
//     if (dt == null) return "";

//     final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour >= 12 ? "PM" : "AM";

//     return "$hour:$minute $period";
//   }

//   /// 📅 RANGE FILTER
//   bool _isInRange(DateTime date) {
//     final now = DateTime.now();

//     /// Default → TODAY
//     if (startDate == null || endDate == null) {
//       return date.year == now.year &&
//           date.month == now.month &&
//           date.day == now.day;
//     }

//     return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
//         date.isBefore(endDate!.add(const Duration(days: 1)));
//   }

//   String get dateText {
//     if (startDate == null) return "Today";

//     return "${startDate!.day}/${startDate!.month}/${startDate!.year} - "
//         "${endDate!.day}/${endDate!.month}/${endDate!.year}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final suppliers = provider.suppliers;

//     /// 🔥 MERGE + FILTER SUPPLIER TRANSACTIONS
//     List<Map<String, dynamic>> allTx = [];

//     for (var s in suppliers) {
//       for (var tx in s.transactions) {
//         final DateTime time =
//             DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();

//         if (_isInRange(time)) {
//           allTx.add({
//             "name": s.name,
//             "amount": tx["amount"],
//             "type": tx["type"],
//             "time": tx["time"],
//           });
//         }
//       }
//     }

//     /// 💰 CALCULATIONS
//     double totalCredit = 0;
//     double totalPayment = 0;

//     for (var tx in allTx) {
//       if (tx["type"] == "GIVEN") {
//         totalCredit += tx["amount"];
//       } else {
//         totalPayment += tx["amount"];
//       }
//     }

//     double netBalance = totalCredit - totalPayment;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Supplier Statement")),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// 📅 DATE CHIP
//           GestureDetector(
//             onTap: () async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       DateRangeScreen(startDate: startDate, endDate: endDate),
//                 ),
//               );

//               if (result != null) {
//                 setState(() {
//                   startDate = result["start"];
//                   endDate = result["end"];
//                 });
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.green),
//                 color: Colors.green.shade50,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     size: 18,
//                     color: Colors.green,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     dateText,
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   const Icon(Icons.keyboard_arrow_down, color: Colors.green),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📊 TOP CARD
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 const Text("Net Balance"),
//                 Text(
//                   "₹${netBalance.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_downward, color: Colors.green),
//                         Text(
//                           "₹${totalPayment.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.green),
//                         ),
//                         const Text("Payments"),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Icon(Icons.arrow_upward, color: Colors.red),
//                         Text(
//                           "₹${totalCredit.toStringAsFixed(0)}",
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const Text("Credits"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           /// 📜 LIST
//           Expanded(
//             child: allTx.isEmpty
//                 ? const Center(child: Text("No transactions"))
//                 : ListView.builder(
//                     itemCount: allTx.length,
//                     itemBuilder: (context, index) {
//                       final tx = allTx[index];
//                       bool isCredit = tx["type"] == "GIVEN";

//                       return Align(
//                         alignment: isCredit
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isCredit
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(tx["name"]),
//                               Text(
//                                 "₹${tx["amount"]}",
//                                 style: TextStyle(
//                                   color: isCredit ? Colors.red : Colors.green,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 _formatTime(tx["time"]),
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../providers/customer_provider.dart';
import '../../customer/screens/date_range_screen.dart';

class SupplierAccountStatementScreen extends StatefulWidget {
  const SupplierAccountStatementScreen({super.key});

  @override
  State<SupplierAccountStatementScreen> createState() =>
      _SupplierAccountStatementScreenState();
}

class _SupplierAccountStatementScreenState
    extends State<SupplierAccountStatementScreen> {
  DateTime? startDate;
  DateTime? endDate;

  String formatDate(String? time) {
    if (time == null) return "";
    final dt = DateTime.tryParse(time);
    if (dt == null) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
  }

  bool isInRange(DateTime date) {
    final now = DateTime.now();

    if (startDate == null || endDate == null) {
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    return date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate!.add(const Duration(days: 1)));
  }

  String get dateText {
    if (startDate == null) return "Today";
    return "${DateFormat("dd MMM yyyy").format(startDate!)} - ${DateFormat("dd MMM yyyy").format(endDate!)}";
  }

  // ================= PDF SAME AS ACCOUNT =================

  Future<void> _downloadPdf(
    List<Map<String, dynamic>> allTx,
    double totalPayment,
    double totalCredit,
    double netBalance,
  ) async {
    final pdf = pw.Document();
    final formatter = DateFormat("dd MMM yyyy");

    String rangeText = startDate == null
        ? "Today"
        : "${formatter.format(startDate!)} - ${formatter.format(endDate!)}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            color: PdfColors.green,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "SmartBahi",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "7852865819",
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 15),

          pw.Center(
            child: pw.Text(
              "SUPPLIER ACCOUNT STATEMENT",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text(rangeText)),
          pw.SizedBox(height: 20),

          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              children: [
                pw.Text("NET BALANCE"),
                pw.SizedBox(height: 8),
                pw.Text(
                  netBalance.toStringAsFixed(0),
                  style: pw.TextStyle(
                    fontSize: 26,
                    color: PdfColors.red,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text("PAYMENTS"),
                        pw.Text(
                          totalPayment.toStringAsFixed(0),
                          style: pw.TextStyle(color: PdfColors.green),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text("CREDITS"),
                        pw.Text(
                          totalCredit.toStringAsFixed(0),
                          style: pw.TextStyle(color: PdfColors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 25),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("DATE"),
              pw.Text("SUPPLIER-NAME"),
              pw.Text("PAYMENT"),
              pw.Text("CREDIT"),
            ],
          ),

          pw.Divider(),

          ...allTx.map((tx) {
            final dt = DateTime.parse(tx["time"]);
            final date = DateFormat("dd MMM").format(dt);
            final isCredit = tx["type"] == "GIVEN";

            return pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(date),
                      pw.Text(tx["name"]),
                      pw.Text(isCredit ? "" : tx["amount"].toString()),
                      pw.Text(isCredit ? tx["amount"].toString() : ""),
                    ],
                  ),
                ),
                pw.Divider(color: PdfColors.grey300),
              ],
            );
          }),

          pw.SizedBox(height: 30),
          pw.Center(
            child: pw.Text(
              "Generated by SmartBahi",
              style: pw.TextStyle(color: PdfColors.green),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // ================= UI SAME AS ACCOUNT =================

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final suppliers = provider.suppliers;

    List<Map<String, dynamic>> allTx = [];

    for (var s in suppliers) {
      for (var tx in s.transactions) {
        final time = DateTime.tryParse(tx["time"] ?? "") ?? DateTime.now();
        if (isInRange(time)) {
          allTx.add({
            "name": s.name,
            "amount": tx["amount"],
            "type": tx["type"],
            "time": tx["time"],
          });
        }
      }
    }

    double totalCredit = 0;
    double totalPayment = 0;

    for (var tx in allTx) {
      if (tx["type"] == "GIVEN") {
        totalCredit += tx["amount"];
      } else {
        totalPayment += tx["amount"];
      }
    }

    double netBalance = totalCredit - totalPayment;

    return Scaffold(
      appBar: AppBar(title: const Text("Supplier Statement")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// DATE CHIP
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DateRangeScreen(startDate: startDate, endDate: endDate),
                ),
              );
              if (result != null) {
                setState(() {
                  startDate = result["start"];
                  endDate = result["end"];
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green),
                color: Colors.green.shade50,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.calendar_today, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// SUMMARY CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xffe9f5ee),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text("Net Balance"),
                    const Spacer(),
                    Text(
                      "₹${netBalance.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.green),
                          Text(
                            "₹${totalPayment.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const Text("Payments"),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_upward, color: Colors.red),
                          Text(
                            "₹${totalCredit.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.red),
                          ),
                          const Text("Credits"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: allTx.length,
              itemBuilder: (context, index) {
                final tx = allTx[index];
                bool isCredit = tx["type"] == "GIVEN";

                return Align(
                  alignment: isCredit
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹${tx["amount"]}",
                          style: TextStyle(
                            color: isCredit ? Colors.red : Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(tx["time"]),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C2752),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () =>
                  _downloadPdf(allTx, totalPayment, totalCredit, netBalance),
              icon: const Icon(Icons.download),
              label: const Text(
                "Download",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
