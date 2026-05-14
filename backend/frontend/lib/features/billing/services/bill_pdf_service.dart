// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:typed_data';

// class BillPdfService {
//   static Future<Uint8List> generateBillPdf(Map bill) async {
//     /// ⭐ FONT (₹ fix)
//     final font = pw.Font.ttf(
//       await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
//     );

//     /// ⭐ WATERMARK LOGO LOAD
//     final logoBytes = await rootBundle.load("assets/images/main-screen20.png");
//     final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         margin: const pw.EdgeInsets.all(24),
//         build: (context) => pw.DefaultTextStyle(
//           style: pw.TextStyle(font: font),

//           /// ⭐ STACK → watermark + content
//           child: pw.Stack(
//             children: [
//               /// 🌟 WATERMARK BACKGROUND LOGO
//               pw.Center(
//                 child: pw.Opacity(
//                   opacity: 0.08,
//                   child: pw.Image(logoImage, width: 300, height: 300),
//                 ),
//               ),

//               /// 🌟 MAIN BILL
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(20),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.grey300),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     /// 👤 CUSTOMER INFO
//                     pw.Center(
//                       child: pw.Column(
//                         children: [
//                           pw.Text(
//                             bill['customerName'] ?? "",
//                             style: pw.TextStyle(
//                               fontSize: 18,
//                               fontWeight: pw.FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 4),
//                           pw.Text("Mobile: ${bill['mobile'] ?? ""}"),
//                           pw.Text(bill['address'] ?? ""),
//                         ],
//                       ),
//                     ),

//                     pw.SizedBox(height: 20),

//                     /// BILL NO + DATE
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text("Bill No: ${bill['billNumber']}"),
//                         pw.Text(bill['date']),
//                       ],
//                     ),

//                     pw.Divider(),

//                     /// TABLE HEADER
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text("Item"),
//                         pw.Text("Qty"),
//                         pw.Text("Rate"),
//                         pw.Text("Total"),
//                       ],
//                     ),

//                     pw.Divider(),

//                     /// ITEMS LOOP (NULL FIX + TOTAL FIX)
//                     ...List.generate(bill['items'].length, (i) {
//                       final item = bill['items'][i];

//                       final qty = double.tryParse(item['qty'].toString()) ?? 0;
//                       final rate =
//                           double.tryParse(item['rate'].toString()) ?? 0;
//                       final total = qty * rate;

//                       return pw.Padding(
//                         padding: const pw.EdgeInsets.symmetric(vertical: 4),
//                         child: pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text(item['name']),
//                             pw.Text(qty.toStringAsFixed(0)),
//                             pw.Text("₹${rate.toStringAsFixed(0)}"),
//                             pw.Text("₹${total.toStringAsFixed(0)}"),
//                           ],
//                         ),
//                       );
//                     }),

//                     pw.Divider(),

//                     /// ⭐ TOTAL SECTION (NULL SAFE)
//                     _row("Sub Total", bill['subTotal'] ?? 0),
//                     _row("Extra Charge", bill['charges'] ?? 0),
//                     _row("Discount", -(bill['discount'] ?? 0)),
//                     _row("GST", bill['gst'] ?? 0),
//                     _row("Cess", bill['cess'] ?? 0),

//                     pw.Divider(),

//                     /// ⭐ GRAND TOTAL
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Text(
//                           "TOTAL",
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                         pw.Text(
//                           "₹${(bill['grandTotal'] ?? 0).toString()}",
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     return pdf.save();
//   }

//   /// ⭐ COMMON ROW
//   static pw.Widget _row(String title, dynamic value) {
//     final val = double.tryParse(value.toString()) ?? 0;
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 2),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [pw.Text(title), pw.Text("₹${val.toStringAsFixed(0)}")],
//       ),
//     );
//   }
// }

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import '../../../providers/bill_template_provider.dart';

class BillPdfService {
  static Future<Uint8List> generateBillPdf(
    Map bill,
    BillTemplate template,
  ) async {
    final font = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => pw.Theme(
          data: pw.ThemeData.withFont(
            base: font,
            bold: font,
            italic: font,
            boldItalic: font,
          ),
          child: template == BillTemplate.normal
              ? _buildNormalTemplate(bill)
              : _buildPrimeTemplate(bill),
        ),
      ),
    );

    return pdf.save();
  }

  // ================= NORMAL TEMPLATE =================

  static pw.Widget _buildNormalTemplate(Map bill) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            bill['customerName'],
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text("Mobile: ${bill['mobile']}"),
        pw.Text(bill['address']),
        pw.Divider(),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Bill No: ${bill['billNumber']}"),
            pw.Text(bill['date']),
          ],
        ),

        pw.SizedBox(height: 15),
        _itemsTable(bill),
        pw.Divider(),

        _totalRow("SubTotal", bill['subTotal']),
        _totalRow("GST", bill['gst']),
        _totalRow("Cess", bill['cess']),
        _totalRow("Extra", bill['charges']),
        _totalRow("Discount", -(bill['discount'] ?? 0)),

        pw.Divider(),

        _totalRow("TOTAL", bill['grandTotal'], bold: true),
      ],
    );
  }

  // ================= PRIME TEMPLATE =================

  static pw.Widget _buildPrimeTemplate(Map bill) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /// TOP 2 COLUMN HEADER ⭐
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "BILL TO",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(bill['customerName']),
                pw.Text(bill['mobile']),
                pw.Text(bill['address']),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  "FROM",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("SmartBahi User"),
                pw.Text("Your Business Address"),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Bill No: ${bill['billNumber']}"),
            pw.Text(bill['date']),
          ],
        ),

        pw.SizedBox(height: 15),
        _itemsTable(bill),
        pw.Divider(),

        _totalRow("SubTotal", bill['subTotal']),
        _totalRow("GST", bill['gst']),
        _totalRow("Cess", bill['cess']),
        _totalRow("Extra", bill['charges']),
        _totalRow("Discount", -(bill['discount'] ?? 0)),

        pw.Divider(),
        _totalRow("GRAND TOTAL", bill['grandTotal'], bold: true),
      ],
    );
  }

  // ================= COMMON WIDGETS =================

  static pw.Widget _itemsTable(Map bill) {
    return pw.Column(
      children: List.generate(bill['items'].length, (i) {
        final item = bill['items'][i];
        final qty = double.tryParse(item['qty'].toString()) ?? 0;
        final rate = double.tryParse(item['rate'].toString()) ?? 0;
        final total = qty * rate;

        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(item['name']),
            pw.Text(qty.toStringAsFixed(0)),
            pw.Text("₹${rate.toStringAsFixed(0)}"),
            pw.Text("₹${total.toStringAsFixed(0)}"),
          ],
        );
      }),
    );
  }

  static pw.Widget _totalRow(String title, dynamic value, {bool bold = false}) {
    final val = double.tryParse(value.toString()) ?? 0;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
        ),
        pw.Text(
          "₹${val.toStringAsFixed(0)}",
          style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
        ),
      ],
    );
  }
}
