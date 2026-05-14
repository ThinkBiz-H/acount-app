
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfBackupService {
  static Future<void> generateBackupPdf({
    required String mobileNumber,
    required int customerDue,
    required int supplierDue,
    required List<Map<String, dynamic>> customers,
    required List<Map<String, dynamic>> suppliers,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoRegular();
    final bold = await PdfGoogleFonts.nunitoBold();
    final date = DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(0),
        build: (context) => [
          _greenHeader(mobileNumber, bold),
          pw.SizedBox(height: 20),

          _reportSection(
            "CUSTOMER REPORT",
            date,
            customerDue,
            customers,
            bold,
            font,
          ),
          pw.SizedBox(height: 40),
          _reportSection(
            "SUPPLIER REPORT",
            date,
            supplierDue,
            suppliers,
            bold,
            font,
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/OkCredit_Backup.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "OkCredit_Backup.pdf",
    );
  }

  // GREEN HEADER
  static pw.Widget _greenHeader(String mobile, pw.Font bold) {
    return pw.Container(
      height: 110,
      color: PdfColors.green,
      padding: const pw.EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Container(
            width: 60,
            height: 60,
            decoration: const pw.BoxDecoration(
              color: PdfColors.white,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                mobile,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  font: bold,
                  fontSize: 22,
                ),
              ),
              pw.Text(
                mobile,
                style: pw.TextStyle(color: PdfColors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // REPORT SECTION
  static pw.Widget _reportSection(
    String title,
    String date,
    int total,
    List<Map<String, dynamic>> list,
    pw.Font bold,
    pw.Font font,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 25),
      child: pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 16)),
          pw.SizedBox(height: 8),

          // DATE CHIP
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(20),
            ),
            child: pw.Text(date, style: pw.TextStyle(font: font)),
          ),

          pw.SizedBox(height: 14),

          // BALANCE CARD
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(18),
            ),
            child: pw.Column(
              children: [
                pw.Text("NET BALANCE", style: pw.TextStyle(font: bold)),
                pw.SizedBox(height: 6),
                pw.Text(
                  "₹ $total",
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 28,
                    color: PdfColors.red,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 18),

          _table(list, font, bold),

          pw.SizedBox(height: 20),

          // STAMP
          pw.Container(
            width: 95,
            height: 95,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green, width: 3),
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
              child: pw.Text(
                "SmartBahi",
                style: pw.TextStyle(
                  color: PdfColors.green,
                  font: bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ⭐ FINAL TABLE (Advance/Due FIXED)
  static pw.Widget _table(
    List<Map<String, dynamic>> list,
    pw.Font font,
    pw.Font bold,
  ) {
    return pw.Column(
      children: [
        // HEADER
        pw.Row(
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Text("Name", style: pw.TextStyle(font: bold)),
            ),
            pw.Expanded(
              child: pw.Text("Advance", style: pw.TextStyle(font: bold)),
            ),
            pw.Expanded(
              child: pw.Text("Due", style: pw.TextStyle(font: bold)),
            ),
          ],
        ),
        pw.Divider(),

        // ROWS
        ...list.map((e) {
          int balance = e['due'];

          String advance = "-";
          String due = "-";

          if (balance < 0) {
            advance = "₹ ${balance.abs()}";
          } else if (balance > 0) {
            due = "₹ $balance";
          }

          return pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(e['name'], style: pw.TextStyle(font: font)),
                  ),
                  pw.Expanded(
                    child: pw.Text(advance, style: pw.TextStyle(font: font)),
                  ),
                  pw.Expanded(
                    child: pw.Text(due, style: pw.TextStyle(font: font)),
                  ),
                ],
              ),
              pw.Divider(), // ⭐ row divider line
            ],
          );
        }),
      ],
    );
  }
}
