
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class CustomerStatementScreen extends StatelessWidget {
  final String customerName;
  const CustomerStatementScreen({super.key, required this.customerName});

  //================ PDF BUILDER =================//
  Future<Uint8List> _generatePdfBytes(
    String customerName,
    String customerPhone,
    List transactions,
    double balance,
    double payment,
    double credit,
  ) async {
    final pdf = pw.Document();

    /// ⭐ STORE DATA FROM HIVE
    final settings = Hive.box('settings');
    final storeName = settings.get('businessName', defaultValue: 'My Store');
    final storePhone = settings.get('mobile', defaultValue: '');
    final storeAddress = settings.get('address', defaultValue: '');

    final today = DateTime.now();
    final date = "${today.day} ${_month(today.month)} ${today.year}";

    // Sort transactions by date (oldest first for statement)
    final sortedTransactions = List.from(transactions);
    sortedTransactions.sort((a, b) {
      final DateTime da = DateTime.tryParse(a['time'] ?? "") ?? DateTime.now();
      final DateTime db = DateTime.tryParse(b['time'] ?? "") ?? DateTime.now();
      return da.compareTo(db);
    });

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// TITLE
              pw.Center(
                child: pw.Text(
                  "Customer Statement",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              /// HEADER STRIP - EXACTLY LIKE SCREENSHOT
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                color: PdfColor.fromInt(0xfff0f0f0),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    /// STORE INFO (LEFT SIDE)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          storeName,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text("My Store"),
                        pw.Text(storePhone),
                      ],
                    ),

                    /// CUSTOMER INFO (RIGHT SIDE)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Created On"),
                        pw.Text(
                          date,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text("Customer"),
                        pw.Text(
                          customerName,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          customerPhone.isNotEmpty ? customerPhone : "No Phone",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 25),

              /// BALANCE - EXACTLY LIKE SCREENSHOT
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Rs ${balance.abs()}",
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text("Balance | Statement Period"),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              /// TABLE HEADER - EXACTLY LIKE SCREENSHOT
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                color: PdfColor.fromInt(0xffe0e0e0),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "Date",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "Payment (Rs $payment)",
                        style: pw.TextStyle(
                          color: PdfColors.green,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "SmartBahi (Rs $credit)",
                        style: pw.TextStyle(
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              /// TRANSACTIONS - EXACT MATCH
              ...sortedTransactions.map((t) {
                final d = DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();
                final isGiven = t['type'] == 'GIVEN';
                final monthStr = _month(d.month);

                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey300),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      // Date column with bold day
                      pw.Expanded(
                        flex: 2,
                        child: pw.Row(
                          children: [
                            pw.Text(
                              "${d.day} ",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(monthStr),
                          ],
                        ),
                      ),

                      // Payment column - shows only if RECEIVED
                      pw.Expanded(
                        flex: 3,
                        child: !isGiven
                            ? pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Rs ${t['amount']}",
                                    style: pw.TextStyle(
                                      color: PdfColors.green,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : pw.Container(),
                      ),

                      // Credit/SmartBahi column - shows only if GIVEN
                      pw.Expanded(
                        flex: 3,
                        child: isGiven
                            ? pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Rs ${t['amount']}",
                                    style: pw.TextStyle(
                                      color: PdfColors.red,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : pw.Container(),
                      ),
                    ],
                  ),
                );
              }),

              pw.Spacer(),

              /// FOOTER
              pw.Container(
                width: double.infinity,
                color: PdfColor.fromInt(0xfff0f0f0),
                padding: const pw.EdgeInsets.all(10),
                child: pw.Center(
                  child: pw.Text(
                    "Generated by SmartBahi",
                    style: const pw.TextStyle(color: PdfColors.grey),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  //================ SHARE =================//
  Future<void> _sharePdf(BuildContext context) async {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    final transactions = provider.getTransactions(customerName);
    final customer = provider.getCustomer(customerName);

    double balance = 0, credit = 0, payment = 0;
    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        credit += t['amount'];
        balance += t['amount'];
      } else {
        payment += t['amount'];
        balance -= t['amount'];
      }
    }

    final bytes = await _generatePdfBytes(
      customer.name,
      customer.mobile,
      transactions,
      balance,
      payment,
      credit,
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/statement.pdf");
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: "Customer Statement - ${customer.name}");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final transactions = provider.getTransactions(customerName);
    final customer = provider.getCustomer(customerName);

    double balance = 0, credit = 0, payment = 0;
    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        credit += t['amount'];
        balance += t['amount'];
      } else {
        payment += t['amount'];
        balance -= t['amount'];
      }
    }

    // Sort transactions by date (newest first for display)
    final sortedTransactions = List.from(transactions);
    sortedTransactions.sort((a, b) {
      final DateTime da = DateTime.tryParse(a['time'] ?? "") ?? DateTime.now();
      final DateTime db = DateTime.tryParse(b['time'] ?? "") ?? DateTime.now();
      return db.compareTo(da);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Customer Statement",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          /// Current Balance header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey.shade100,
            child: const Text(
              "Current Balance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),

          /// Balance amount
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(
                  "₹${balance.abs()}",
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Balance",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade300),

          /// Date range and filter options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  "Overall",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "This Month",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "Last 7 days",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          /// Balance with date range
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  "₹$balance",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  " Balance",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "20 - 25 Feb, 2026",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),

          /// Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Payment (${transactions.where((t) => t['type'] == 'RECEIVED').length}) ₹$payment",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Credit (${transactions.where((t) => t['type'] == 'GIVEN').length}) ₹$credit",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          /// Transaction list
          Expanded(
            child: sortedTransactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : ListView.builder(
                    itemCount: sortedTransactions.length,
                    itemBuilder: (context, index) {
                      final t = sortedTransactions[index];
                      final isGiven = t['type'] == 'GIVEN';
                      final DateTime d =
                          DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();
                      final monthStr = _month(d.month);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Date column
                            Expanded(
                              flex: 2,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${d.day} ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: monthStr),
                                  ],
                                ),
                              ),
                            ),

                            // Payment column (Received) - ONLY shows if RECEIVED
                            Expanded(
                              flex: 2,
                              child: !isGiven
                                  ? Text(
                                      "₹${t['amount']}",
                                      style: TextStyle(
                                        color: Colors.green.shade600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.right,
                                    )
                                  : Container(),
                            ),

                            // Credit column (Given) - ONLY shows if GIVEN
                            Expanded(
                              flex: 2,
                              child: isGiven
                                  ? Text(
                                      "₹${t['amount']}",
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.right,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          /// Download and Share buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final bytes = await _generatePdfBytes(
                        customer.name,
                        customer.mobile,
                        transactions,
                        balance,
                        payment,
                        credit,
                      );

                      if (kIsWeb) {
                        await Printing.layoutPdf(onLayout: (_) async => bytes);
                        return;
                      }

                      final dir = await getTemporaryDirectory();
                      final file = File("${dir.path}/statement.pdf");
                      await file.writeAsBytes(bytes);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("PDF Downloaded")),
                      );
                    },
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Download"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sharePdf(context),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text("Share"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _month(int m) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    return months[m - 1];
  }
}
