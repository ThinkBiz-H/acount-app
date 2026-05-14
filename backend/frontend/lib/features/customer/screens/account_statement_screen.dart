import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../providers/customer_provider.dart';
import '../screens/date_range_screen.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({super.key});

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  DateTime? startDate;
  DateTime? endDate;

  /// time format
  String formatTime(String? time) {
    if (time == null) return "";
    final dt = DateTime.tryParse(time);
    if (dt == null) return "";
    return DateFormat("hh:mm a").format(dt);
  }

  /// date format
  String formatDate(String? time) {
    if (time == null) return "";
    final dt = DateTime.tryParse(time);
    if (dt == null) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
  }

  /// filter logic
  bool isInRange(DateTime date) {
    final now = DateTime.now();

    /// default = TODAY
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
          /// HEADER (GREEN STRIP)
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

          /// TITLE
          pw.Center(
            child: pw.Text(
              "ACCOUNT STATEMENT",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),
          pw.Center(child: pw.Text(rangeText)),
          pw.SizedBox(height: 20),

          /// NET BALANCE CARD
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

          /// TABLE HEADER
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("DATE"),
              pw.Text("CUSTOMER-NAME"),
              pw.Text("PAYMENT"),
              pw.Text("CREDIT"),
            ],
          ),
          pw.Divider(),

          /// TRANSACTION LIST
          /// TRANSACTION LIST WITH ROW DIVIDER
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

                /// 👇 THIS IS THE LINE YOU WANT
                pw.Divider(color: PdfColors.grey300, thickness: 1.0),
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customers = provider.customers;

    /// 🔥 MERGE + FILTER ALL TX

    final allTx =
        provider.allTransactions.map((tx) {
          return {
            "name": tx["customerId"]?["name"] ?? "Walk-in",
            "amount": tx["amount"],
            "type": tx["type"] == "gave" ? "GIVEN" : "RECEIVED",
            "time": tx["createdAt"],
          };
        }).toList()..sort(
          (a, b) =>
              DateTime.parse(a["time"]).compareTo(DateTime.parse(b["time"])),
        );

    /// CALCULATIONS
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
      appBar: AppBar(title: const Text("Account Statement")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// 🔥 DATE CHIP (LIKE SmartBahi)
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DateRangeScreen(startDate: startDate, endDate: endDate),
                ),
              );

              // if (result != null) {
              //   setState(() {
              //     startDate = result["start"];
              //     endDate = result["end"];
              //   });
              // }
              if (result != null) {
                DateTime start = result["start"];
                DateTime end = result["end"];

                setState(() {
                  startDate = start;
                  endDate = end;
                });

                // 🔥 API CALL (MAIN FIX)
                // for (var c in customers) {
                //   await Provider.of<CustomerProvider>(
                //     context,
                //     listen: false,
                //   ).fetchTransactionsByDate(c.id, c.name, start, end);
                // }
                await Provider.of<CustomerProvider>(
                  context,
                  listen: false,
                ).fetchAllTransactionsByDate(start, end);
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
                // children: const [
                //   Icon(Icons.calendar_today, color: Colors.green, size: 18),
                //   SizedBox(width: 6),
                //   Text(
                //     "Today",
                //     style: TextStyle(
                //       color: Colors.green,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   Icon(Icons.keyboard_arrow_down, color: Colors.green),
                // ],
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 SUMMARY CARD (EXACT DESIGN)
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

          /// 🔥 TRANSACTION CHAT LIST (FINAL)
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

          /// 🔥 BOTTOM DOWNLOAD BUTTON
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
