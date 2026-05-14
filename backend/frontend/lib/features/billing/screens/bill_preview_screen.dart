// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import '../../billing/screens/billing_screen.dart';
// import '../../plan/screens/plan_screen.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:screenshot/screenshot.dart';
// import '../../billing/screens/select_template_screen.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../stock/models/stock_item.dart';

// class BillPreviewScreen extends StatefulWidget {
//   final String? billKey;
//   final Map<String, dynamic>? existingBill;

//   final List<Map<String, dynamic>> items;
//   final String customerName;
//   final String mobile;
//   final String address;
//   final String billNumber;
//   final DateTime billDate;

//   final double subTotal;
//   final double charges;
//   final double discount;
//   final double gstTotal;
//   final double cessTotal;
//   final double grandTotal;

//   const BillPreviewScreen({
//     super.key,
//     required this.billKey,
//     this.existingBill,
//     required this.items,
//     required this.customerName,
//     required this.mobile,
//     required this.address,
//     required this.billNumber,
//     required this.billDate,
//     required this.subTotal,
//     required this.charges,
//     required this.discount,
//     required this.gstTotal,
//     required this.cessTotal,
//     required this.grandTotal,
//   });

//   @override
//   State<BillPreviewScreen> createState() => _BillPreviewScreenState();
// }

// class _BillPreviewScreenState extends State<BillPreviewScreen> {
//   bool isPaid = false;
//   bool savedPaid = false;
//   Future<void> updateInventory(List items) async {
//     final box = Hive.box<StockItem>('stock');

//     for (var item in items) {
//       double soldQty = double.tryParse(item['qty'].toString()) ?? 0;

//       String code = item['productCode']?.toString() ?? "";

//       if (code.isEmpty || soldQty <= 0) continue;

//       for (int i = 0; i < box.length; i++) {
//         final stockItem = box.getAt(i);

//         if (stockItem != null && stockItem.productCode == code) {
//           double currentQty =
//               double.tryParse(
//                 stockItem.qty.replaceAll(RegExp(r'[^0-9.]'), ''),
//               ) ??
//               0;

//           double newQty = currentQty - soldQty;
//           if (newQty < 0) newQty = 0;

//           stockItem.qty = newQty.toString();
//           await box.putAt(i, stockItem);

//           try {
//             await ApiService.updateProduct(stockItem.productCode, {
//               "qty": newQty,
//             });
//           } catch (e) {
//             print("API error: $e");
//           }

//           print("UPDATED: ${stockItem.name} → $newQty");
//           break;
//         }
//       }
//     }
//   }

//   final ScreenshotController screenshotController = ScreenshotController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.existingBill != null) {
//       isPaid = widget.existingBill?['paid'] ?? false;
//       savedPaid = isPaid;
//     }
//   }

//   // 🔥 SHARE FUNCTION
//   Future<void> shareBillImage() async {
//     try {
//       final image = await screenshotController.capture();
//       if (image == null) return;

//       final directory = await getTemporaryDirectory();
//       final file = await File('${directory.path}/bill.png').create();
//       await file.writeAsBytes(image);

//       await Share.shareXFiles([
//         XFile(file.path),
//       ], text: "Bill ${widget.billNumber}");
//     } catch (e) {
//       debugPrint("Share error: $e");
//     }
//   }

//   Future<void> shareBillPdf() async {
//     try {
//       final image = await screenshotController.capture();

//       if (image == null) return;

//       final pdf = pw.Document();

//       final imageProvider = pw.MemoryImage(image);

//       pdf.addPage(
//         pw.Page(
//           build: (context) {
//             return pw.Center(child: pw.Image(imageProvider));
//           },
//         ),
//       );

//       await Printing.sharePdf(
//         bytes: await pdf.save(),
//         filename: "bill_${widget.billNumber}.pdf",
//       );
//     } catch (e) {
//       debugPrint("PDF error: $e");
//     }
//   }

//   /// ================= SAVE =================
//   Future<void> saveBillWithoutNavigation() async {
//     try {
//       final provider = context.read<CustomerProvider>();
//       final box = Hive.box('bills');
//       final settingsBox = Hive.box('settings');

//       bool isPremium = settingsBox.get('isPremium') ?? false;

//       if (!isPremium) {
//         final today = DateTime.now();
//         int count = 0;

//         for (var t in box.values) {
//           final date = DateTime.parse(t['date']);

//           if (date.year == today.year &&
//               date.month == today.month &&
//               date.day == today.day) {
//             count++;
//           }
//         }

//         if (count >= 1100) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 "Daily limit reached. Upgrade to continue 🚀   Bill not saved",
//               ),
//             ),
//           );

//           Future.delayed(const Duration(milliseconds: 300), () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => PlanScreen()),
//             );
//           });

//           return;
//         }
//       }
//       final settings = Hive.box('settings');
//       final ownerMobile = settings.get('mobile');

//       if (ownerMobile == null) return;

//       final billData = {
//         "ownerMobile": ownerMobile,
//         "customerName": widget.customerName,
//         "mobile": widget.mobile,
//         "address": widget.address,
//         "billNumber": widget.billNumber,
//         "date": widget.billDate.toIso8601String(),
//         "items": widget.items,
//         "subTotal": widget.subTotal,
//         "gstTotal": widget.gstTotal,
//         "cessTotal": widget.cessTotal,
//         "charges": widget.charges,
//         "discount": widget.discount,
//         "grandTotal": widget.grandTotal,
//         "paid": isPaid,
//       };

//       // if (widget.billKey != null) {
//       //   await ApiService.updateBill(widget.billKey!, billData);
//       // } else {
//       //   await ApiService.addBill(billData);
//       // }
//       if (widget.billKey != null) {
//         await ApiService.updateBill(widget.billKey!, billData);
//       } else {
//         await ApiService.addBill(billData);

//         /// 🔥 MAIN FIX
//         await box.add({...billData, "date": DateTime.now().toIso8601String()});
//       }

//       if (widget.billKey != null) {
//         bool oldPaid = widget.existingBill?['paid'] ?? false;
//         bool newPaid = isPaid;

//         if (!oldPaid && newPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber} Paid',
//             'date': DateTime.now(),
//             'type': 'RECEIVED',
//           });
//         } else if (oldPaid && !newPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber}',
//             'date': DateTime.now(),
//             'type': 'GIVEN',
//           });
//         }
//       } else {
//         if (!isPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber}',
//             'date': DateTime.now(),
//             'type': 'GIVEN',
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//     savedPaid = isPaid;
//   }

//   /// ================= POPUP =================

//   Widget row(String title, double value, {bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//           Text(
//             "₹${value.toStringAsFixed(0)}",
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,

//       // 🔥 SHARE BUTTON ADD
//       appBar: AppBar(
//         title: Text(widget.billNumber),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (_) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         title: const Text("Share as Image"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           shareBillImage();
//                         },
//                       ),
//                       ListTile(
//                         title: const Text("Share as PDF"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           shareBillPdf();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: Screenshot(
//               controller: screenshotController,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(12),
//                 child: Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               widget.customerName,
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text("Mobile: ${widget.mobile}"),
//                             Text(widget.address),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Bill No: ${widget.billNumber}"),
//                           Text(
//                             "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
//                           ),
//                         ],
//                       ),

//                       const Divider(),

//                       /// 🔥 NEW TABLE HEADER
//                       Row(
//                         children: const [
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               "Item",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               "Qty",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Rate",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Amount",
//                               textAlign: TextAlign.end,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const Divider(),

//                       /// 🔥 ITEMS LIST FIXED
//                       ...widget.items.map((item) {
//                         final qty = (item['qty'] ?? 0);
//                         final rate = (item['rate'] ?? 0);

//                         /// 🔥 FIX: amount calculate (no more null)
//                         final amount = qty * rate;

//                         return Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(item['name'] ?? ""),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     "$qty",
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "₹$rate",
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "₹$amount",
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Divider(),
//                           ],
//                         );
//                       }).toList(),

//                       row("Sub Total", widget.subTotal),
//                       row("Extra Charge", widget.charges),
//                       row("Discount", -widget.discount),
//                       row("GST", widget.gstTotal),
//                       row("Cess", widget.cessTotal),

//                       const Divider(),
//                       row("TOTAL", widget.grandTotal, bold: true),

//                       if (savedPaid)
//                         const Padding(
//                           padding: EdgeInsets.only(top: 8),
//                           child: Center(
//                             child: Text(
//                               "PAID",
//                               style: TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           if (!savedPaid)
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   /// 🔥 SELECT TEMPLATE BUTTON
//                   GestureDetector(
//                     onTap: () async {
//                       final selectedTemplate = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               SelectTemplateScreen(), // 👈 yaha apna template screen dal
//                         ),
//                       );

//                       if (selectedTemplate != null) {
//                         setState(() {
//                           // yaha template store kar sakta hai
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.green),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             "Select Template",
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           Icon(Icons.arrow_forward_ios, size: 16),
//                         ],
//                       ),
//                     ),
//                   ),

//                   /// 🔥 PAYMENT STATUS
//                   Row(
//                     children: [
//                       const Text("Payment status"),
//                       const Spacer(),
//                       Radio(
//                         value: true,
//                         groupValue: isPaid,
//                         onChanged: (_) => setState(() => isPaid = true),
//                       ),
//                       const Text("Paid"),
//                       Radio(
//                         value: false,
//                         groupValue: isPaid,
//                         onChanged: (_) => setState(() => isPaid = false),
//                       ),
//                       const Text("Unpaid"),
//                     ],
//                   ),

//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0C2752),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: () async {
//                       print("🔥 SAVE CLICKED");

//                       await updateInventory(widget.items); // ✅ stock minus

//                       print("🔥 STOCK UPDATED");

//                       await saveBillWithoutNavigation(); // ✅ bill save

//                       Navigator.pop(context, true); // ✅ back
//                     },
//                     child: const Text("Save Bill"),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import '../../billing/screens/billing_screen.dart';
// import '../../plan/screens/plan_screen.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:screenshot/screenshot.dart';
// import '../../billing/screens/select_template_screen.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../stock/models/stock_item.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BillPreviewScreen extends StatefulWidget {
//   final String? billKey;
//   final Map<String, dynamic>? existingBill;

//   final List<Map<String, dynamic>> items;
//   final String customerName;
//   final String mobile;
//   final String address;
//   final String billNumber;
//   final DateTime billDate;

//   final double subTotal;
//   final double charges;
//   final double discount;
//   final double gstTotal;
//   final double cessTotal;
//   final double grandTotal;

//   const BillPreviewScreen({
//     super.key,
//     required this.billKey,
//     this.existingBill,
//     required this.items,
//     required this.customerName,
//     required this.mobile,
//     required this.address,
//     required this.billNumber,
//     required this.billDate,
//     required this.subTotal,
//     required this.charges,
//     required this.discount,
//     required this.gstTotal,
//     required this.cessTotal,
//     required this.grandTotal,
//   });

//   @override
//   State<BillPreviewScreen> createState() => _BillPreviewScreenState();
// }

// class _BillPreviewScreenState extends State<BillPreviewScreen> {
//   bool isPaid = false;
//   bool savedPaid = false;
//   Future<void> updateInventory(List items) async {
//     final box = Hive.box<StockItem>('stock');

//     for (var item in items) {
//       double soldQty = double.tryParse(item['qty'].toString()) ?? 0;

//       String code = item['productCode']?.toString() ?? "";

//       if (code.isEmpty || soldQty <= 0) continue;

//       for (int i = 0; i < box.length; i++) {
//         final stockItem = box.getAt(i);

//         if (stockItem != null && stockItem.productCode == code) {
//           double currentQty =
//               double.tryParse(
//                 stockItem.qty.replaceAll(RegExp(r'[^0-9.]'), ''),
//               ) ??
//               0;

//           double newQty = currentQty - soldQty;
//           if (newQty < 0) newQty = 0;

//           stockItem.qty = newQty.toString();
//           await box.putAt(i, stockItem);

//           try {
//             await ApiService.updateProduct(stockItem.productCode, {
//               "qty": newQty,
//             });
//           } catch (e) {
//             print("API error: $e");
//           }

//           print("UPDATED: ${stockItem.name} → $newQty");
//           break;
//         }
//       }
//     }
//   }

//   final ScreenshotController screenshotController = ScreenshotController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.existingBill != null) {
//       isPaid = widget.existingBill?['paid'] ?? false;
//       savedPaid = isPaid;
//     }
//   }

//   // 🔥 SHARE FUNCTION
//   Future<void> shareBillImage() async {
//     try {
//       final image = await screenshotController.capture();
//       if (image == null) return;

//       final directory = await getTemporaryDirectory();
//       final file = await File('${directory.path}/bill.png').create();
//       await file.writeAsBytes(image);

//       await Share.shareXFiles([
//         XFile(file.path),
//       ], text: "Bill ${widget.billNumber}");
//     } catch (e) {
//       debugPrint("Share error: $e");
//     }
//   }

//   Future<void> shareBillPdf() async {
//     try {
//       final image = await screenshotController.capture();

//       if (image == null) return;

//       final pdf = pw.Document();

//       final imageProvider = pw.MemoryImage(image);

//       pdf.addPage(
//         pw.Page(
//           build: (context) {
//             return pw.Center(child: pw.Image(imageProvider));
//           },
//         ),
//       );

//       await Printing.sharePdf(
//         bytes: await pdf.save(),
//         filename: "bill_${widget.billNumber}.pdf",
//       );
//     } catch (e) {
//       debugPrint("PDF error: $e");
//     }
//   }

//   void _showActionSheet(bool isPdf) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return SizedBox(
//           height: 120,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               /// DOWNLOAD
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);

//                   if (isPdf) {
//                     _downloadPdf();
//                   } else {
//                     _downloadImage();
//                   }
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     CircleAvatar(radius: 28, child: Icon(Icons.download)),
//                     SizedBox(height: 8),
//                     Text("Download"),
//                   ],
//                 ),
//               ),

//               /// SHARE
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);

//                   if (isPdf) {
//                     shareBillPdf();
//                   } else {
//                     shareBillImage();
//                   }
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     CircleAvatar(radius: 28, child: Icon(Icons.share)),
//                     SizedBox(height: 8),
//                     Text("Share"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> requestStoragePermission() async {
//     if (await Permission.storage.request().isGranted) {
//       print("Storage permission granted");
//     } else {
//       print("Storage permission denied");
//     }
//   }

//   /// IMAGE DOWNLOAD
//   Future<void> _downloadImage() async {
//     await requestStoragePermission(); // 🔥 CALL HERE

//     final image = await screenshotController.capture();
//     if (image == null) return;

//     final directory = Directory('/storage/emulated/0/Download');

//     final file = File(
//       '${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.png',
//     );

//     await file.writeAsBytes(image);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Image saved in Downloads 📁")),
//     );
//   }

//   /// PDF DOWNLOAD
//   Future<void> _downloadPdf() async {
//     try {
//       await requestStoragePermission();

//       final image = await screenshotController.capture();
//       if (image == null) {
//         print("❌ Screenshot null");
//         return;
//       }

//       final pdf = pw.Document();
//       final img = pw.MemoryImage(image);

//       pdf.addPage(pw.Page(build: (context) => pw.Image(img)));

//       final directory = Directory('/storage/emulated/0/Download');

//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }

//       final filePath =
//           '${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf';

//       final file = File(filePath);

//       await file.writeAsBytes(await pdf.save());

//       print("✅ PDF saved at: $filePath");

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("PDF saved in Downloads 📁")));
//     } catch (e) {
//       print("❌ PDF ERROR: $e");
//     }
//   }

//   /// ================= SAVE =================
//   Future<void> saveBillWithoutNavigation() async {
//     try {
//       final provider = context.read<CustomerProvider>();
//       final box = Hive.box('bills');
//       final settingsBox = Hive.box('settings');

//       bool isPremium = settingsBox.get('isPremium') ?? false;

//       if (!isPremium) {
//         final today = DateTime.now();
//         int count = 0;

//         for (var t in box.values) {
//           final date = DateTime.parse(t['date']);

//           if (date.year == today.year &&
//               date.month == today.month &&
//               date.day == today.day) {
//             count++;
//           }
//         }

//         if (count >= 1) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 "Daily limit reached. Upgrade to continue 🚀   Bill not saved",
//               ),
//             ),
//           );

//           Future.delayed(const Duration(milliseconds: 300), () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => PlanScreen()),
//             );
//           });

//           return;
//         }
//       }
//       final settings = Hive.box('settings');
//       final ownerMobile = settings.get('mobile');

//       if (ownerMobile == null) return;

//       final billData = {
//         "ownerMobile": ownerMobile,
//         "customerName": widget.customerName,
//         "mobile": widget.mobile,
//         "address": widget.address,
//         "billNumber": widget.billNumber,
//         "date": widget.billDate.toIso8601String(),
//         "items": widget.items,
//         "subTotal": widget.subTotal,
//         "gstTotal": widget.gstTotal,
//         "cessTotal": widget.cessTotal,
//         "charges": widget.charges,
//         "discount": widget.discount,
//         "grandTotal": widget.grandTotal,
//         "paid": isPaid,
//       };

//       // if (widget.billKey != null) {
//       //   await ApiService.updateBill(widget.billKey!, billData);
//       // } else {
//       //   await ApiService.addBill(billData);
//       // }
//       if (widget.billKey != null) {
//         await ApiService.updateBill(widget.billKey!, billData);
//       } else {
//         await ApiService.addBill(billData);

//         /// 🔥 MAIN FIX
//         await box.add({...billData, "date": DateTime.now().toIso8601String()});
//       }

//       if (widget.billKey != null) {
//         bool oldPaid = widget.existingBill?['paid'] ?? false;
//         bool newPaid = isPaid;

//         if (!oldPaid && newPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber} Paid',
//             'date': DateTime.now(),
//             'type': 'RECEIVED',
//           });
//         } else if (oldPaid && !newPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber}',
//             'date': DateTime.now(),
//             'type': 'GIVEN',
//           });
//         }
//       } else {
//         if (!isPaid) {
//           await provider.addTransaction(widget.customerName, {
//             'amount': widget.grandTotal,
//             'note': 'Bill ${widget.billNumber}',
//             'date': DateTime.now(),
//             'type': 'GIVEN',
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//     savedPaid = isPaid;
//   }

//   /// ================= POPUP =================

//   Widget row(String title, double value, {bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//           Text(
//             "₹${value.toStringAsFixed(0)}",
//             style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,

//       // 🔥 SHARE BUTTON ADD
//       appBar: AppBar(
//         title: Text(widget.billNumber),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (_) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         height: 120,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             /// IMAGE
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _showActionSheet(false);
//                               },
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 28,
//                                     backgroundColor: Colors.green.shade100,
//                                     child: const Icon(
//                                       Icons.image,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Text("Image"),
//                                 ],
//                               ),
//                             ),

//                             /// PDF
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _showActionSheet(true);
//                               },
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 28,
//                                     backgroundColor: Colors.red.shade100,
//                                     child: const Icon(
//                                       Icons.picture_as_pdf,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Text("PDF"),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: Screenshot(
//               controller: screenshotController,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(12),
//                 child: Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               widget.customerName,
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text("Mobile: ${widget.mobile}"),
//                             Text(widget.address),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Bill No: ${widget.billNumber}"),
//                           Text(
//                             "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
//                           ),
//                         ],
//                       ),

//                       const Divider(),

//                       /// 🔥 NEW TABLE HEADER
//                       Row(
//                         children: const [
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               "Item",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               "Qty",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Rate",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Amount",
//                               textAlign: TextAlign.end,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const Divider(),

//                       /// 🔥 ITEMS LIST FIXED
//                       ...widget.items.map((item) {
//                         final qty = (item['qty'] ?? 0);
//                         final rate = (item['rate'] ?? 0);

//                         /// 🔥 FIX: amount calculate (no more null)
//                         final amount = qty * rate;

//                         return Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(item['name'] ?? ""),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     "$qty",
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "₹$rate",
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "₹$amount",
//                                     textAlign: TextAlign.end,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Divider(),
//                           ],
//                         );
//                       }).toList(),

//                       row("Sub Total", widget.subTotal),
//                       row("Extra Charge", widget.charges),
//                       row("Discount", -widget.discount),
//                       row("GST", widget.gstTotal),
//                       row("Cess", widget.cessTotal),

//                       const Divider(),
//                       row("TOTAL", widget.grandTotal, bold: true),

//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Center(
//                           child: Text(
//                             savedPaid ? "PAID" : "UNPAID",
//                             style: TextStyle(
//                               color: savedPaid ? Colors.green : Colors.red,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           if (!savedPaid)
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   /// 🔥 SELECT TEMPLATE BUTTON
//                   GestureDetector(
//                     onTap: () async {
//                       final selectedTemplate = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               SelectTemplateScreen(), // 👈 yaha apna template screen dal
//                         ),
//                       );

//                       if (selectedTemplate != null) {
//                         setState(() {
//                           // yaha template store kar sakta hai
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.green),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             "Select Template",
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           Icon(Icons.arrow_forward_ios, size: 16),
//                         ],
//                       ),
//                     ),
//                   ),

//                   /// 🔥 PAYMENT STATUS
//                   Row(
//                     children: [
//                       const Text("Payment status"),
//                       const Spacer(),
//                       Radio(
//                         value: true,
//                         groupValue: isPaid,
//                         onChanged: (_) => setState(() => isPaid = true),
//                       ),
//                       const Text("Paid"),
//                       Radio(
//                         value: false,
//                         groupValue: isPaid,
//                         onChanged: (_) => setState(() => isPaid = false),
//                       ),
//                       const Text("Unpaid"),
//                     ],
//                   ),

//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0C2752),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: () async {
//                       print("🔥 SAVE CLICKED");

//                       await updateInventory(widget.items); // ✅ stock minus

//                       print("🔥 STOCK UPDATED");

//                       await saveBillWithoutNavigation(); // ✅ bill save

//                       Navigator.pop(context, true); // ✅ back
//                     },
//                     child: const Text("Save Bill"),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// bhai abhi yaa try krna hai aaj

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../services/api_service.dart';
import '../../billing/screens/billing_screen.dart';
import '../../plan/screens/plan_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import '../../billing/screens/select_template_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../stock/models/stock_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bills_history_screen.dart';

class BillPreviewScreen extends StatefulWidget {
  final String? billKey;
  final Map<String, dynamic>? existingBill;

  final bool isViewOnly;

  final List<Map<String, dynamic>> items;
  final String customerName;
  final String mobile;
  final String address;
  final String billNumber;
  final DateTime billDate;

  final double subTotal;
  final double charges;
  final double discount;
  final double gstTotal;
  final double cessTotal;
  final double grandTotal;

  // const BillPreviewScreen({
  //   super.key,
  //   required this.billKey,
  //   this.existingBill,
  //   required this.items,
  //   required this.customerName,
  //   required this.mobile,
  //   required this.address,
  //   required this.billNumber,
  //   required this.billDate,
  //   required this.subTotal,
  //   required this.charges,
  //   required this.discount,
  //   required this.gstTotal,
  //   required this.cessTotal,
  //   required this.grandTotal,
  // });
  const BillPreviewScreen({
    super.key,
    required this.billKey,
    this.existingBill,
    required this.items,
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.billNumber,
    required this.billDate,
    required this.subTotal,
    required this.charges,
    required this.discount,
    required this.gstTotal,
    required this.cessTotal,
    required this.grandTotal,
    this.isViewOnly = false, // ✅ ADD THIS
  });

  @override
  State<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  bool isPaid = false;
  bool savedPaid = false;
  Future<void> updateInventory(List items) async {
    final box = Hive.box<StockItem>('stock');

    for (var item in items) {
      double soldQty = double.tryParse(item['qty'].toString()) ?? 0;

      String code = item['productCode']?.toString() ?? "";

      if (code.isEmpty || soldQty <= 0) continue;

      for (int i = 0; i < box.length; i++) {
        final stockItem = box.getAt(i);

        if (stockItem != null && stockItem.productCode == code) {
          double currentQty =
              double.tryParse(
                stockItem.qty.replaceAll(RegExp(r'[^0-9.]'), ''),
              ) ??
              0;

          double newQty = currentQty - soldQty;
          if (newQty < 0) newQty = 0;

          stockItem.qty = newQty.toString();
          await box.putAt(i, stockItem);

          try {
            await ApiService.updateProduct(stockItem.productCode, {
              "qty": newQty,
            });
          } catch (e) {
            print("API error: $e");
          }

          print("UPDATED: ${stockItem.name} → $newQty");
          break;
        }
      }
    }
  }

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    if (widget.existingBill != null) {
      isPaid = widget.existingBill?['paid'] ?? false;
      savedPaid = isPaid;
    }
  }

  // 🔥 SHARE FUNCTION
  Future<void> shareBillImage() async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final file = await File('${directory.path}/bill.png').create();
      await file.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: "Bill ${widget.billNumber}");
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  Future<void> shareBillPdf() async {
    try {
      final image = await screenshotController.capture();

      if (image == null) return;

      final pdf = pw.Document();

      final imageProvider = pw.MemoryImage(image);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(child: pw.Image(imageProvider));
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: "bill_${widget.billNumber}.pdf",
      );
    } catch (e) {
      debugPrint("PDF error: $e");
    }
  }

  void _showActionSheet(bool isPdf) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// DOWNLOAD
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  if (isPdf) {
                    _downloadPdf();
                  } else {
                    _downloadImage();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(radius: 28, child: Icon(Icons.download)),
                    SizedBox(height: 8),
                    Text("Download"),
                  ],
                ),
              ),

              /// SHARE
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  if (isPdf) {
                    shareBillPdf();
                  } else {
                    shareBillImage();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(radius: 28, child: Icon(Icons.share)),
                    SizedBox(height: 8),
                    Text("Share"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  /// IMAGE DOWNLOAD
  Future<void> _downloadImage() async {
    await requestStoragePermission(); // 🔥 CALL HERE

    final image = await screenshotController.capture();
    if (image == null) return;

    final directory = Directory('/storage/emulated/0/Download');

    final file = File(
      '${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    await file.writeAsBytes(image);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image saved in Downloads 📁")),
    );
  }

  /// PDF DOWNLOAD
  Future<void> _downloadPdf() async {
    try {
      await requestStoragePermission();

      final image = await screenshotController.capture();
      if (image == null) {
        print("❌ Screenshot null");
        return;
      }

      final pdf = pw.Document();
      final img = pw.MemoryImage(image);

      pdf.addPage(pw.Page(build: (context) => pw.Image(img)));

      final directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath =
          '${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());

      print("✅ PDF saved at: $filePath");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF saved in Downloads 📁")));
    } catch (e) {
      print("❌ PDF ERROR: $e");
    }
  }

  /// ================= SAVE =================
  Future<bool> saveBillWithoutNavigation() async {
    try {
      final provider = context.read<CustomerProvider>();
      final box = Hive.box('bills');

      final settings = Hive.box('settings');
      final ownerMobile = settings.get('mobile');

      if (ownerMobile == null) return false;

      final billData = {
        "ownerMobile": ownerMobile,
        "customerName": widget.customerName,
        "mobile": widget.mobile,
        "address": widget.address,
        "billNumber": widget.billNumber,
        "date": widget.billDate.toIso8601String(),
        "items": widget.items,
        "subTotal": widget.subTotal,
        "gstTotal": widget.gstTotal,
        "cessTotal": widget.cessTotal,
        "charges": widget.charges,
        "discount": widget.discount,
        "grandTotal": widget.grandTotal,
        "paid": isPaid,
      };

      /// ================= UPDATE BILL =================
      if (widget.billKey != null) {
        await ApiService.updateBill(widget.billKey!, billData);

        bool oldPaid = widget.existingBill?['paid'] ?? false;
        bool newPaid = isPaid;

        if (!oldPaid && newPaid) {
          await provider.addTransaction(widget.customerName, {
            'amount': widget.grandTotal,
            'note': 'Bill ${widget.billNumber} Paid',
            'date': DateTime.now(),
            'type': 'RECEIVED',
          });
        } else if (oldPaid && !newPaid) {
          await provider.addTransaction(widget.customerName, {
            'amount': widget.grandTotal,
            'note': 'Bill ${widget.billNumber}',
            'date': DateTime.now(),
            'type': 'GIVEN',
          });
        }

        savedPaid = isPaid;
        return true;
      }

      /// ================= ADD BILL =================
      final res = await ApiService.addBill(billData);

      print("BILL RESPONSE: $res");

      /// ✅ SUCCESS
      if (res["success"] == true) {
        await box.add({...billData, "date": DateTime.now().toIso8601String()});

        if (!isPaid) {
          await provider.addTransaction(widget.customerName, {
            'amount': widget.grandTotal,
            'note': 'Bill ${widget.billNumber}',
            'date': DateTime.now(),
            'type': 'GIVEN',
          });
        }

        savedPaid = isPaid;
        return true;
      }
      /// 🔥 LIMIT REACHED (NO PLAN SCREEN)
      else if (res["isLimitReached"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Daily limit reached 🚫 Upgrade your plan"),
          ),
        );

        // 🚀 PLAN SCREEN OPEN
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlanScreen()),
        );

        return false; // ❌ bill save nahi hoga
      }
      /// ❌ OTHER ERROR
      else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res["message"] ?? "Error")));
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  /// ================= POPUP =================

  Widget row(String title, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BillsHistoryScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,

        appBar: AppBar(
          title: Text(widget.billNumber),

          /// 🔥 BACK BUTTON FIX
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BillsHistoryScreen()),
                (route) => false,
              );
            },
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showActionSheet(false);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.green.shade100,
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text("Image"),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showActionSheet(true);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.red.shade100,
                                      child: const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text("PDF"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: screenshotController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                widget.customerName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Mobile: ${widget.mobile}"),
                              Text(widget.address),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bill No: ${widget.billNumber}"),
                            Text(
                              "${widget.billDate.day}/${widget.billDate.month}/${widget.billDate.year}",
                            ),
                          ],
                        ),

                        const Divider(),

                        /// 🔥 NEW TABLE HEADER
                        Row(
                          children: const [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Item",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Qty",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Rate",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                textAlign: TextAlign.end,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        /// 🔥 ITEMS LIST FIXED
                        ...widget.items.map((item) {
                          final qty = (item['qty'] ?? 0);
                          final rate = (item['rate'] ?? 0);

                          /// 🔥 FIX: amount calculate (no more null)
                          final amount = qty * rate;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(item['name'] ?? ""),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "$qty",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "₹$rate",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "₹$amount",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),

                        row("Sub Total", widget.subTotal),
                        row("Extra Charge", widget.charges),
                        row("Discount", -widget.discount),
                        row("GST", widget.gstTotal),
                        row("Cess", widget.cessTotal),

                        const Divider(),
                        row("TOTAL", widget.grandTotal, bold: true),

                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              savedPaid ? "PAID" : "UNPAID",
                              style: TextStyle(
                                color: savedPaid ? Colors.green : Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (!widget.isViewOnly && !savedPaid)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// 🔥 SELECT TEMPLATE BUTTON
                    GestureDetector(
                      onTap: () async {
                        final selectedTemplate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SelectTemplateScreen(), // 👈 yaha apna template screen dal
                          ),
                        );

                        if (selectedTemplate != null) {
                          setState(() {
                            // yaha template store kar sakta hai
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Select Template",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),

                    /// 🔥 PAYMENT STATUS
                    Row(
                      children: [
                        const Text("Payment status"),
                        const Spacer(),
                        Radio(
                          value: true,
                          groupValue: isPaid,
                          onChanged: (_) => setState(() => isPaid = true),
                        ),
                        const Text("Paid"),
                        Radio(
                          value: false,
                          groupValue: isPaid,
                          onChanged: (_) => setState(() => isPaid = false),
                        ),
                        const Text("Unpaid"),
                      ],
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C2752),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        print("🔥 SAVE CLICKED");

                        await updateInventory(widget.items);

                        print("🔥 STOCK UPDATED");

                        bool success = await saveBillWithoutNavigation();

                        // if (success) {
                        //   Navigator.pop(context, true); // ✅ only if success
                        // }
                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BillPreviewScreen(
                                billKey: widget.billKey,
                                existingBill: widget.existingBill,
                                customerName: widget.customerName,
                                mobile: widget.mobile,
                                address: widget.address,
                                billNumber: widget.billNumber,
                                billDate: widget.billDate,
                                items: widget.items,
                                subTotal: widget.subTotal,
                                gstTotal: widget.gstTotal,
                                cessTotal: widget.cessTotal,
                                charges: widget.charges,
                                discount: widget.discount,
                                grandTotal: widget.grandTotal,

                                isViewOnly: true, // 🔥 MOST IMPORTANT
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("Save Bill"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
