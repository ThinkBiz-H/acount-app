// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:printing/printing.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import '../services/bill_pdf_service.dart';
// import '../widgets/bill_photo_widget.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/bill_template_provider.dart';

// class BillSharePreviewScreen extends StatefulWidget {
//   final Map bill;
//   const BillSharePreviewScreen({super.key, required this.bill});

//   @override
//   State<BillSharePreviewScreen> createState() => _BillSharePreviewScreenState();
// }

// class _BillSharePreviewScreenState extends State<BillSharePreviewScreen> {
//   final controller = ScreenshotController();
//   bool isPdf = true;

//   /// DOWNLOAD FILE
//   Future<void> downloadFile() async {
//     final templateProvider = context.read<BillTemplateProvider>();

//     if (isPdf) {
//       final pdf = await BillPdfService.generateBillPdf(
//         widget.bill,
//         templateProvider.selectedTemplate,
//       );
//       await Printing.layoutPdf(onLayout: (_) async => pdf);
//     } else {
//       final image = await controller.capture(pixelRatio: 3);
//       await Share.shareXFiles([
//         XFile.fromData(image!, name: "bill.png", mimeType: "image/png"),
//       ]);
//     }
//   }

//   /// SHARE FILE (REAL SHARE FIX)
//   Future<void> shareFile() async {
//     final templateProvider = context.read<BillTemplateProvider>();

//     if (isPdf) {
//       final pdf = await BillPdfService.generateBillPdf(
//         widget.bill,
//         templateProvider.selectedTemplate,
//       );

//       await Share.shareXFiles([
//         XFile.fromData(
//           pdf,
//           name: "Bill_${widget.bill['billNumber']}.pdf",
//           mimeType: "application/pdf",
//         ),
//       ]);
//     } else {
//       final image = await controller.capture(pixelRatio: 3);
//       await Share.shareXFiles([
//         XFile.fromData(image!, name: "bill.png", mimeType: "image/png"),
//       ]);
//     }
//   }

//   /// LOGO WIDGET
//   Widget buildLogo() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Image.asset("assets/images/main-screen20.png", height: 60),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Share Bill")),
//       body: Column(
//         children: [
//           /// LOGO
//           buildLogo(),

//           /// BILL PREVIEW
//           Expanded(
//             child: isPdf
//                 ? PdfPreview(
//                     build: (format) {
//                       final template = context
//                           .read<BillTemplateProvider>()
//                           .selectedTemplate;
//                       return BillPdfService.generateBillPdf(
//                         widget.bill,
//                         template,
//                       );
//                     },
//                   )
//                 : Screenshot(
//                     controller: controller,
//                     child: BillPhotoWidget(bill: widget.bill),
//                   ),
//           ),

//           /// BOTTOM ACTION BAR
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 /// PDF / PHOTO SWITCH
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Radio(
//                       value: true,
//                       groupValue: isPdf,
//                       onChanged: (_) => setState(() => isPdf = true),
//                     ),
//                     const Text("PDF"),
//                     const SizedBox(width: 30),
//                     Radio(
//                       value: false,
//                       groupValue: isPdf,
//                       onChanged: (_) => setState(() => isPdf = false),
//                     ),
//                     const Text("Photo"),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.download),
//                         label: const Text("Download"),
//                         onPressed: downloadFile,
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.share),
//                         label: const Text("Share"),
//                         onPressed: shareFile,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           minimumSize: const Size(double.infinity, 50),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../services/bill_pdf_service.dart';
import '../widgets/bill_photo_widget.dart';
import 'package:provider/provider.dart';
import '../../../providers/bill_template_provider.dart';

class BillSharePreviewScreen extends StatefulWidget {
  final Map bill;
  const BillSharePreviewScreen({super.key, required this.bill});

  @override
  State<BillSharePreviewScreen> createState() => _BillSharePreviewScreenState();
}

class _BillSharePreviewScreenState extends State<BillSharePreviewScreen> {
  final controller = ScreenshotController();
  bool isPdf = true;

  /// DOWNLOAD FILE
  Future<void> downloadFile() async {
    final templateProvider = context.read<BillTemplateProvider>();

    if (isPdf) {
      final pdf = await BillPdfService.generateBillPdf(
        widget.bill,
        templateProvider.selectedTemplate,
      );
      await Printing.layoutPdf(onLayout: (_) async => pdf);
    } else {
      final image = await controller.capture(pixelRatio: 3);
      await Share.shareXFiles([
        XFile.fromData(image!, name: "bill.png", mimeType: "image/png"),
      ]);
    }
  }

  /// SHARE FILE (REAL SHARE FIX)
  Future<void> shareFile() async {
    final templateProvider = context.read<BillTemplateProvider>();

    if (isPdf) {
      final pdf = await BillPdfService.generateBillPdf(
        widget.bill,
        templateProvider.selectedTemplate,
      );

      await Share.shareXFiles([
        XFile.fromData(
          pdf,
          name: "Bill_${widget.bill['billNumber']}.pdf",
          mimeType: "application/pdf",
        ),
      ]);
    } else {
      final image = await controller.capture(pixelRatio: 3);
      await Share.shareXFiles([
        XFile.fromData(image!, name: "bill.png", mimeType: "image/png"),
      ]);
    }
  }

  /// LOGO WIDGET
  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset("assets/images/main-screen20.png", height: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Bill")),
      body: Column(
        children: [
          /// LOGO
          buildLogo(),

          /// BILL PREVIEW
          Expanded(
            child: isPdf
                ? PdfPreview(
                    build: (format) {
                      final template = context
                          .read<BillTemplateProvider>()
                          .selectedTemplate;
                      return BillPdfService.generateBillPdf(
                        widget.bill,
                        template,
                      );
                    },
                  )
                : Screenshot(
                    controller: controller,
                    child: BillPhotoWidget(bill: widget.bill),
                  ),
          ),

          /// BOTTOM ACTION BAR
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                /// PDF / PHOTO SWITCH
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: true,
                      groupValue: isPdf,
                      onChanged: (_) => setState(() => isPdf = true),
                    ),
                    const Text("PDF"),
                    const SizedBox(width: 30),
                    Radio(
                      value: false,
                      groupValue: isPdf,
                      onChanged: (_) => setState(() => isPdf = false),
                    ),
                    const Text("Photo"),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                        onPressed: downloadFile,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                        onPressed: shareFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
