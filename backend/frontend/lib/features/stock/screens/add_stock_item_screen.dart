// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/stock_item.dart';

// class AddStockItemScreen extends StatefulWidget {
//   final String? prefillName;
//   final StockItem? item;

//   const AddStockItemScreen({super.key, this.prefillName, this.item});

//   @override
//   State<AddStockItemScreen> createState() => _AddStockItemScreenState();
// }

// class _AddStockItemScreenState extends State<AddStockItemScreen> {
//   final nameCtrl = TextEditingController();
//   final qtyCtrl = TextEditingController();
//   final mrpCtrl = TextEditingController();
//   final rateCtrl = TextEditingController();
//   final codeCtrl = TextEditingController();

//   String unitValue = "Nos";
//   String taxValue = "0%";
//   String taxType = "Included";
//   String selectedDate = "";
//   String imagePath = "";

//   bool showMore = true;

//   bool get isEdit => widget.item != null;

//   @override
//   void initState() {
//     super.initState();

//     selectedDate = DateTime.now().toString().substring(0, 10);

//     /// 🔥 prefill from billing
//     if (widget.prefillName != null) {
//       nameCtrl.text = widget.prefillName!;
//     }

//     /// 🔥 edit case
//     if (isEdit) {
//       final item = widget.item!;

//       nameCtrl.text = item.name;
//       qtyCtrl.text = item.qty;
//       mrpCtrl.text = item.mrp;
//       rateCtrl.text = item.rate;
//       codeCtrl.text = item.productCode;

//       unitValue = item.unit;
//       taxValue = item.tax;
//       taxType = item.taxType;
//       selectedDate = item.date;
//       imagePath = item.imagePath;
//     }
//   }

//   void saveItem() {
//     final box = Hive.box<StockItem>('stock');

//     String productCode = codeCtrl.text.isEmpty
//         ? DateTime.now().millisecondsSinceEpoch.toString()
//         : codeCtrl.text;

//     final newItem = StockItem(
//       name: nameCtrl.text,
//       mrp: mrpCtrl.text,
//       qty: qtyCtrl.text,
//       unit: unitValue,
//       rate: rateCtrl.text,
//       date: selectedDate,
//       tax: taxValue,
//       taxType: taxType,
//       productCode: productCode,
//       imagePath: imagePath,
//     );

//     if (isEdit) {
//       widget.item!
//         ..name = newItem.name
//         ..mrp = newItem.mrp
//         ..qty = newItem.qty
//         ..unit = newItem.unit
//         ..rate = newItem.rate
//         ..date = newItem.date
//         ..tax = newItem.tax
//         ..taxType = newItem.taxType
//         ..productCode = newItem.productCode
//         ..imagePath = newItem.imagePath
//         ..save();
//     } else {
//       box.add(newItem);
//     }

//     Navigator.pop(context, true);
//   }

//   Widget inputField(String hint, TextEditingController ctrl) {
//     return TextField(
//       controller: ctrl,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget dropdown(List<String> items, String value, Function(String) onChange) {
//     return DropdownButtonFormField(
//       value: value,
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: (v) => onChange(v.toString()),
//       decoration: const InputDecoration(border: OutlineInputBorder()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? "Edit Item" : "Add Stock Item")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             inputField("Item Name", nameCtrl),
//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Expanded(child: inputField("MRP", mrpCtrl)),
//                 const SizedBox(width: 10),
//                 Expanded(child: inputField("Qty", qtyCtrl)),
//               ],
//             ),
//             const SizedBox(height: 12),

//             dropdown(
//               ["Nos", "Kg", "Litres", "Packets", "Pieces"],
//               unitValue,
//               (v) => setState(() => unitValue = v),
//             ),

//             TextButton(
//               onPressed: () => setState(() => showMore = !showMore),
//               child: Text(showMore ? "Hide details" : "View more details"),
//             ),

//             if (showMore) ...[
//               inputField("Rate", rateCtrl),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["0%", "5%", "12%", "18%"],
//                 taxValue,
//                 (v) => setState(() => taxValue = v),
//               ),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["Included", "Excluded"],
//                 taxType,
//                 (v) => setState(() => taxType = v),
//               ),
//               const SizedBox(height: 12),

//               inputField("Product Code", codeCtrl),
//             ],

//             const SizedBox(height: 25),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: saveItem,
//                 child: const Text("SAVE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/stock_item.dart';
// import '../../../services/api_service.dart';

// class AddStockItemScreen extends StatefulWidget {
//   final String? prefillName;
//   final StockItem? item;

//   const AddStockItemScreen({super.key, this.prefillName, this.item});

//   @override
//   State<AddStockItemScreen> createState() => _AddStockItemScreenState();
// }

// class _AddStockItemScreenState extends State<AddStockItemScreen> {
//   final nameCtrl = TextEditingController();
//   final qtyCtrl = TextEditingController(text: "1"); // ✅ default
//   final mrpCtrl = TextEditingController(text: "0");
//   final rateCtrl = TextEditingController(text: "0");
//   final codeCtrl = TextEditingController();

//   String unitValue = "Nos";
//   String taxValue = "0%";
//   String taxType = "Included";
//   String selectedDate = "";
//   String imagePath = "";

//   bool showMore = true;

//   bool get isEdit => widget.item != null;

//   @override
//   void initState() {
//     super.initState();

//     selectedDate = DateTime.now().toString().substring(0, 10);

//     /// 🔥 prefill from billing
//     if (widget.prefillName != null) {
//       nameCtrl.text = widget.prefillName!;
//     }

//     /// 🔥 edit case
//     if (isEdit) {
//       final item = widget.item!;

//       nameCtrl.text = item.name;
//       qtyCtrl.text = item.qty;
//       mrpCtrl.text = item.mrp;
//       rateCtrl.text = item.rate;
//       codeCtrl.text = item.productCode;

//       unitValue = item.unit;
//       taxValue = item.tax;
//       taxType = item.taxType;
//       selectedDate = item.date;
//       imagePath = item.imagePath;
//     }
//   }

//   // void saveItem() {
//   //   final box = Hive.box<StockItem>('stock');

//   //   String name = nameCtrl.text.trim();
//   //   double qty = double.tryParse(qtyCtrl.text) ?? 0;

//   //   /// ❌ validation
//   //   if (name.isEmpty) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("Enter item name")));
//   //     return;
//   //   }

//   //   if (qty <= 0) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("Enter valid quantity")));
//   //     return;
//   //   }

//   //   /// 🔍 check existing item
//   //   final existingList = box.values
//   //       .where((e) => e.name.toLowerCase() == name.toLowerCase())
//   //       .toList();

//   //   if (existingList.isNotEmpty) {
//   //     /// ✅ update existing
//   //     final item = existingList.first;

//   //     double oldQty = double.tryParse(item.qty) ?? 0;

//   //     item.qty = (oldQty + qty).toString();
//   //     item.rate = rateCtrl.text;
//   //     item.mrp = mrpCtrl.text;
//   //     item.unit = unitValue;
//   //     item.tax = taxValue;
//   //     item.date = DateTime.now().toIso8601String();

//   //     item.save();
//   //   } else {
//   //     /// ✅ new item add
//   //     box.add(
//   //       StockItem(
//   //         name: name,
//   //         mrp: mrpCtrl.text,
//   //         qty: qty.toString(),
//   //         unit: unitValue,
//   //         rate: rateCtrl.text,
//   //         date: DateTime.now().toIso8601String(),
//   //         tax: taxValue,
//   //         taxType: taxType,
//   //         productCode: codeCtrl.text.isEmpty
//   //             ? DateTime.now().millisecondsSinceEpoch.toString()
//   //             : codeCtrl.text,
//   //         imagePath: imagePath,
//   //       ),
//   //     );
//   //   }

//   //   /// ✅ success feedback
//   //   ScaffoldMessenger.of(
//   //     context,
//   //   ).showSnackBar(const SnackBar(content: Text("Stock saved")));

//   //   /// 🔥 DEBUG PRINT (yahi daal)
//   //   print("BOX COUNT: ${Hive.box<StockItem>('stock').length}");
//   //   Navigator.pop(context, true);
//   // }
//   void saveItem() async {
//     final box = Hive.box<StockItem>('stock');
//     final settingsBox = Hive.box('settings');
//     final mobile = settingsBox.get('mobile');

//     String name = nameCtrl.text.trim();
//     double qty = double.tryParse(qtyCtrl.text) ?? 0;

//     if (name.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter item name")));
//       return;
//     }

//     if (qty <= 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter valid quantity")));
//       return;
//     }

//     String productCode = codeCtrl.text.isEmpty
//         ? DateTime.now().millisecondsSinceEpoch.toString()
//         : codeCtrl.text;

//     final newItem = StockItem(
//       name: name,
//       mrp: mrpCtrl.text,
//       qty: qty.toString(),
//       unit: unitValue,
//       rate: rateCtrl.text,
//       date: DateTime.now().toIso8601String(),
//       tax: taxValue,
//       taxType: taxType,
//       productCode: productCode,
//       imagePath: imagePath,
//     );

//     /// ✅ LOCAL SAVE
//     box.add(newItem);

//     /// 🔥 BACKEND SAVE (IMPORTANT)
//     try {
//       await ApiService.addProduct({
//         "mobile": mobile,
//         "name": name,
//         "mrp": mrpCtrl.text,
//         "qty": qty.toString(),
//         "unit": unitValue,
//         "rate": rateCtrl.text,
//         "date": newItem.date,
//         "tax": taxValue,
//         "taxType": taxType,
//         "productCode": productCode,
//         "imagePath": imagePath,
//       });

//       debugPrint("✅ Product saved to server");
//     } catch (e) {
//       debugPrint("❌ API error: $e");
//     }

//     Navigator.pop(context, true);
//   }

//   Widget inputField(String hint, TextEditingController ctrl) {
//     return TextField(
//       controller: ctrl,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget dropdown(List<String> items, String value, Function(String) onChange) {
//     return DropdownButtonFormField(
//       value: value,
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: (v) => onChange(v.toString()),
//       decoration: const InputDecoration(border: OutlineInputBorder()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? "Edit Item" : "Add Stock Item")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             inputField("Item Name", nameCtrl),
//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Expanded(child: inputField("MRP", mrpCtrl)),
//                 const SizedBox(width: 10),
//                 Expanded(child: inputField("Qty", qtyCtrl)),
//               ],
//             ),
//             const SizedBox(height: 12),

//             dropdown(
//               ["Nos", "Kg", "Litres", "Packets", "Pieces"],
//               unitValue,
//               (v) => setState(() => unitValue = v),
//             ),

//             TextButton(
//               onPressed: () => setState(() => showMore = !showMore),
//               child: Text(showMore ? "Hide details" : "View more details"),
//             ),

//             if (showMore) ...[
//               inputField("Rate", rateCtrl),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["0%", "5%", "12%", "18%"],
//                 taxValue,
//                 (v) => setState(() => taxValue = v),
//               ),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["Included", "Excluded"],
//                 taxType,
//                 (v) => setState(() => taxType = v),
//               ),
//               const SizedBox(height: 12),

//               inputField("Product Code", codeCtrl),
//             ],

//             const SizedBox(height: 25),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: saveItem,
//                 child: const Text("SAVE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/stock_item.dart';
// import '../../../services/api_service.dart';

// class AddStockItemScreen extends StatefulWidget {
//   final String? prefillName;
//   final StockItem? item;

//   const AddStockItemScreen({super.key, this.prefillName, this.item});

//   @override
//   State<AddStockItemScreen> createState() => _AddStockItemScreenState();
// }

// class _AddStockItemScreenState extends State<AddStockItemScreen> {
//   final nameCtrl = TextEditingController();
//   final qtyCtrl = TextEditingController(text: "1");
//   final mrpCtrl = TextEditingController(text: "0");
//   final rateCtrl = TextEditingController(text: "0");
//   final codeCtrl = TextEditingController();

//   String unitValue = "Nos";
//   String taxValue = "0%";
//   String taxType = "Included";
//   String selectedDate = "";
//   String imagePath = "";

//   bool showMore = true;

//   bool get isEdit => widget.item != null;

//   @override
//   void initState() {
//     super.initState();

//     selectedDate = DateTime.now().toString().substring(0, 10);

//     if (isEdit) {
//       final item = widget.item!;
//       nameCtrl.text = item.name;
//       qtyCtrl.text = item.qty;
//       mrpCtrl.text = item.mrp;
//       rateCtrl.text = item.rate;
//       codeCtrl.text = item.productCode;
//       unitValue = item.unit;
//       taxValue = item.tax;
//       taxType = item.taxType;
//       selectedDate = item.date;
//       imagePath = item.imagePath;
//     } else {
//       nameCtrl.text = widget.prefillName ?? "";
//     }
//   }

//   Future<void> saveItem() async {
//     final box = Hive.box<StockItem>('stock');
//     final settingsBox = Hive.box('settings');
//     final mobile = settingsBox.get('mobile');

//     String name = nameCtrl.text.trim();
//     double qty = double.tryParse(qtyCtrl.text) ?? 0;

//     if (name.isEmpty || qty <= 0) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter valid data")));
//       return;
//     }

//     String key = name.toLowerCase().trim();

//     if (isEdit) {
//       /// 🔥 UPDATE ONLY
//       final existingItem = widget.item!;

//       double oldQty = double.tryParse(existingItem.qty) ?? 0;

//       existingItem.qty = (oldQty + qty).toString();
//       existingItem.mrp = mrpCtrl.text;
//       existingItem.rate = rateCtrl.text;
//       existingItem.unit = unitValue;
//       existingItem.tax = taxValue;
//       existingItem.taxType = taxType;

//       await existingItem.save();

//       /// 🔥 UPDATE API (agar hai)
//       // try {
//       //   await ApiService.updateProduct(existingItem.productCode, {
//       //     "mobile": mobile,
//       //     "name": name,
//       //     "mrp": mrpCtrl.text,
//       //     "qty": existingItem.qty,
//       //     "unit": unitValue,
//       //     "rate": rateCtrl.text,
//       //     "tax": taxValue,
//       //     "taxType": taxType,
//       //   });
//       // } catch (e) {
//       //   debugPrint("❌ Update API error: $e");
//       // }
//     } else {
//       /// 🔥 ADD ONLY
//       String productCode = codeCtrl.text.isEmpty
//           ? DateTime.now().millisecondsSinceEpoch.toString()
//           : codeCtrl.text;

//       final newItem = StockItem(
//         name: name,
//         mrp: mrpCtrl.text,
//         qty: qty.toString(),
//         unit: unitValue,
//         rate: rateCtrl.text,
//         date: DateTime.now().toIso8601String(),
//         tax: taxValue,
//         taxType: taxType,
//         productCode: productCode,
//         imagePath: imagePath,
//       );

//       await box.put(key, newItem); // ✅ FIXED

//       try {
//         await ApiService.addProduct({
//           "mobile": mobile,
//           "name": name,
//           "mrp": mrpCtrl.text,
//           "qty": qty.toString(),
//           "unit": unitValue,
//           "rate": rateCtrl.text,
//           "date": newItem.date,
//           "tax": taxValue,
//           "taxType": taxType,
//           "productCode": productCode,
//           "imagePath": imagePath,
//         });
//       } catch (e) {
//         debugPrint("❌ Add API error: $e");
//       }
//     }

//     Navigator.pop(context, true);
//   }

//   Widget inputField(String hint, TextEditingController ctrl) {
//     return TextField(
//       controller: ctrl,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget dropdown(List<String> items, String value, Function(String) onChange) {
//     return DropdownButtonFormField(
//       value: value,
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: (v) => onChange(v.toString()),
//       decoration: const InputDecoration(border: OutlineInputBorder()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? "Update Stock" : "Add Stock Item")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             inputField("Item Name", nameCtrl),
//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Expanded(child: inputField("MRP", mrpCtrl)),
//                 const SizedBox(width: 10),
//                 Expanded(child: inputField("Qty", qtyCtrl)),
//               ],
//             ),
//             const SizedBox(height: 12),

//             dropdown(
//               ["Nos", "Kg", "Litres", "Packets", "Pieces"],
//               unitValue,
//               (v) => setState(() => unitValue = v),
//             ),

//             TextButton(
//               onPressed: () => setState(() => showMore = !showMore),
//               child: Text(showMore ? "Hide details" : "View more details"),
//             ),

//             if (showMore) ...[
//               inputField("Rate", rateCtrl),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["0%", "5%", "12%", "18%"],
//                 taxValue,
//                 (v) => setState(() => taxValue = v),
//               ),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["Included", "Excluded"],
//                 taxType,
//                 (v) => setState(() => taxType = v),
//               ),
//               const SizedBox(height: 12),

//               inputField("Product Code", codeCtrl),
//             ],

//             const SizedBox(height: 25),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: saveItem,
//                 child: Text(isEdit ? "UPDATE" : "SAVE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/stock_item.dart';
// import '../../../services/api_service.dart';

// class AddStockItemScreen extends StatefulWidget {
//   final String? prefillName;
//   final StockItem? item;

//   const AddStockItemScreen({super.key, this.prefillName, this.item});

//   @override
//   State<AddStockItemScreen> createState() => _AddStockItemScreenState();
// }

// class _AddStockItemScreenState extends State<AddStockItemScreen> {
//   final nameCtrl = TextEditingController();
//   final qtyCtrl = TextEditingController(text: "1");
//   final mrpCtrl = TextEditingController(text: "0");
//   final rateCtrl = TextEditingController(text: "0");
//   final codeCtrl = TextEditingController();

//   String unitValue = "Nos";
//   String taxValue = "0%";
//   String taxType = "Included";
//   String selectedDate = "";
//   String imagePath = "";

//   bool showMore = true;
//   bool isSaving = false; // 🔥 double click fix

//   @override
//   void initState() {
//     super.initState();

//     selectedDate = DateTime.now().toString().substring(0, 10);

//     if (widget.item != null) {
//       final item = widget.item!;
//       nameCtrl.text = item.name;
//       qtyCtrl.text = item.qty;
//       mrpCtrl.text = item.mrp;
//       rateCtrl.text = item.rate;
//       codeCtrl.text = item.productCode;
//       unitValue = item.unit;
//       taxValue = item.tax;
//       taxType = item.taxType;
//       selectedDate = item.date;
//       imagePath = item.imagePath;
//     } else {
//       nameCtrl.text = widget.prefillName ?? "";
//     }
//   }

//   Future<void> saveItem() async {
//     if (isSaving) return; // 🔥 double call block
//     isSaving = true;

//     final box = Hive.box<StockItem>('stock');
//     final settingsBox = Hive.box('settings');
//     final mobile = settingsBox.get('mobile');

//     String name = nameCtrl.text.trim();
//     double qty = double.tryParse(qtyCtrl.text) ?? 0;

//     if (name.isEmpty || qty <= 0) {
//       isSaving = false;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter valid data")));
//       return;
//     }

//     String key = name.toLowerCase().trim();

//     /// 🔥 CHECK EXISTING
//     StockItem? existingItem = box.get(key);

//     if (existingItem != null) {
//       /// ✅ UPDATE ONLY
//       double oldQty = double.tryParse(existingItem.qty) ?? 0;

//       existingItem.qty = (oldQty + qty).toString();
//       existingItem.mrp = mrpCtrl.text;
//       existingItem.rate = rateCtrl.text;
//       existingItem.unit = unitValue;
//       existingItem.tax = taxValue;
//       existingItem.taxType = taxType;

//       await existingItem.save();

//       print("UPDATED ITEM ✅");

//       isSaving = false;
//       Navigator.pop(context, true);
//       return; // 🔥 VERY IMPORTANT (duplicate rokega)
//     }

//     /// ✅ ADD NEW ONLY
//     String productCode = codeCtrl.text.isEmpty
//         ? DateTime.now().millisecondsSinceEpoch.toString()
//         : codeCtrl.text;

//     final newItem = StockItem(
//       name: name,
//       mrp: mrpCtrl.text,
//       qty: qty.toString(),
//       unit: unitValue,
//       rate: rateCtrl.text,
//       date: DateTime.now().toIso8601String(),
//       tax: taxValue,
//       taxType: taxType,
//       productCode: productCode,
//       imagePath: imagePath,
//     );

//     await box.put(key, newItem);

//     print("NEW ITEM ADDED ✅");

//     /// optional API
//     try {
//       await ApiService.addProduct({
//         "mobile": mobile,
//         "name": name,
//         "mrp": mrpCtrl.text,
//         "qty": qty.toString(),
//         "unit": unitValue,
//         "rate": rateCtrl.text,
//         "date": newItem.date,
//         "tax": taxValue,
//         "taxType": taxType,
//         "productCode": productCode,
//         "imagePath": imagePath,
//       });
//     } catch (e) {
//       debugPrint("❌ API error: $e");
//     }

//     isSaving = false;
//     Navigator.pop(context, true);
//   }

//   Widget inputField(String hint, TextEditingController ctrl) {
//     return TextField(
//       controller: ctrl,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget dropdown(List<String> items, String value, Function(String) onChange) {
//     return DropdownButtonFormField(
//       value: value,
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: (v) => onChange(v.toString()),
//       decoration: const InputDecoration(border: OutlineInputBorder()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add / Update Stock")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             inputField("Item Name", nameCtrl),
//             const SizedBox(height: 12),

//             Row(
//               children: [
//                 Expanded(child: inputField("MRP", mrpCtrl)),
//                 const SizedBox(width: 10),
//                 Expanded(child: inputField("Qty", qtyCtrl)),
//               ],
//             ),
//             const SizedBox(height: 12),

//             dropdown(
//               ["Nos", "Kg", "Litres", "Packets", "Pieces"],
//               unitValue,
//               (v) => setState(() => unitValue = v),
//             ),

//             TextButton(
//               onPressed: () => setState(() => showMore = !showMore),
//               child: Text(showMore ? "Hide details" : "View more details"),
//             ),

//             if (showMore) ...[
//               inputField("Rate", rateCtrl),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["0%", "5%", "12%", "18%"],
//                 taxValue,
//                 (v) => setState(() => taxValue = v),
//               ),
//               const SizedBox(height: 12),

//               dropdown(
//                 ["Included", "Excluded"],
//                 taxType,
//                 (v) => setState(() => taxType = v),
//               ),
//               const SizedBox(height: 12),

//               inputField("Product Code", codeCtrl),
//             ],

//             const SizedBox(height: 25),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: saveItem,
//                 child: const Text("SAVE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/stock_item.dart';
import '../../../services/api_service.dart';

class AddStockItemScreen extends StatefulWidget {
  final String? prefillName;
  final StockItem? item;

  const AddStockItemScreen({super.key, this.prefillName, this.item});

  @override
  State<AddStockItemScreen> createState() => _AddStockItemScreenState();
}

class _AddStockItemScreenState extends State<AddStockItemScreen> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: "1");
  final mrpCtrl = TextEditingController(text: "0");
  final rateCtrl = TextEditingController(text: "0");
  final codeCtrl = TextEditingController();

  String unitValue = "Nos";
  String taxValue = "0%";
  String taxType = "Included";
  String selectedDate = "";
  String imagePath = "";

  bool showMore = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now().toString().substring(0, 10);

    if (widget.item != null) {
      final item = widget.item!;
      nameCtrl.text = item.name;
      qtyCtrl.text = item.qty;
      mrpCtrl.text = item.mrp;
      rateCtrl.text = item.rate;
      codeCtrl.text = item.productCode;
      unitValue = item.unit;
      taxValue = item.tax;
      taxType = item.taxType;
      selectedDate = item.date;
      imagePath = item.imagePath;
    } else {
      nameCtrl.text = widget.prefillName ?? "";
    }
  }

  Future<void> saveItem() async {
    String productCode = codeCtrl.text.isNotEmpty
        ? codeCtrl.text.trim()
        : DateTime.now().millisecondsSinceEpoch.toString();

    // IMPORTANT
    codeCtrl.text = productCode;
    if (isSaving) return;
    isSaving = true;

    final box = Hive.box<StockItem>('stock');
    final settingsBox = Hive.box('settings');
    final mobile = settingsBox.get('mobile');

    String name = nameCtrl.text.trim();
    double qty = double.tryParse(qtyCtrl.text) ?? 0;

    if (name.isEmpty || qty <= 0) {
      isSaving = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid data")));
      return;
    }

    String key = name.toLowerCase().trim();

    /// 🔥 CHECK EXISTING ITEM
    StockItem? existingItem;

    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);

      if (item != null &&
          (item.productCode == productCode ||
              item.name.toLowerCase().trim() == name.toLowerCase().trim())) {
        existingItem = item;
        break;
      }
    }

    if (existingItem != null) {
      double oldQty = double.tryParse(existingItem.qty) ?? 0;
      double newQty = oldQty + qty;

      existingItem.qty = newQty.toString();
      existingItem.mrp = mrpCtrl.text;
      existingItem.rate = rateCtrl.text;
      existingItem.unit = unitValue;
      existingItem.tax = taxValue;
      existingItem.taxType = taxType;

      await existingItem.save();

      /// 🔥🔥 MAIN FIX (API UPDATE)
      try {
        await ApiService.updateProduct(existingItem.productCode, {
          "qty": newQty,
          "mrp": mrpCtrl.text,
          "rate": rateCtrl.text,
          "unit": unitValue,
          "tax": taxValue,
          "taxType": taxType,
        });
        print("API UPDATED ✅");
      } catch (e) {
        debugPrint("❌ Update API error: $e");
      }

      print("UPDATED ITEM (LOCAL + SERVER) ✅");

      isSaving = false;
      Navigator.pop(context, true);
      return;
    }

    /// 🔥 ADD NEW ITEM

    final newItem = StockItem(
      name: name,
      mrp: mrpCtrl.text,
      qty: qty.toString(),
      unit: unitValue,
      rate: rateCtrl.text,
      date: DateTime.now().toIso8601String(),
      tax: taxValue,
      taxType: taxType,
      productCode: productCode,
      imagePath: imagePath,
    );

    await box.add(newItem);

    print("NEW ITEM ADDED ✅");

    /// 🔥 API ADD
    try {
      await ApiService.addProduct({
        "mobile": mobile,
        "name": name,
        "mrp": mrpCtrl.text,
        "qty": qty.toString(),
        "unit": unitValue,
        "rate": rateCtrl.text,
        "date": newItem.date,
        "tax": taxValue,
        "taxType": taxType,
        "productCode": productCode,
        "imagePath": imagePath,
      });
      print("API ADD SUCCESS ✅");
    } catch (e) {
      debugPrint("❌ API error: $e");
    }

    isSaving = false;
    Navigator.pop(context, true);
  }

  Widget inputField(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget dropdown(List<String> items, String value, Function(String) onChange) {
    return DropdownButtonFormField(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChange(v.toString()),
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add / Update Stock")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            inputField("Item Name", nameCtrl),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: inputField("Buy MRP", mrpCtrl)),
                const SizedBox(width: 10),
                Expanded(child: inputField("Qty", qtyCtrl)),
              ],
            ),
            const SizedBox(height: 12),

            dropdown(
              ["Nos", "Kg", "Litres", "Packets", "Pieces"],
              unitValue,
              (v) => setState(() => unitValue = v),
            ),

            TextButton(
              onPressed: () => setState(() => showMore = !showMore),
              child: Text(showMore ? "Hide details" : "View more details"),
            ),

            if (showMore) ...[
              inputField("Sale MRP", rateCtrl),
              const SizedBox(height: 12),

              dropdown(
                ["0%", "5%", "12%", "18%"],
                taxValue,
                (v) => setState(() => taxValue = v),
              ),
              const SizedBox(height: 12),

              dropdown(
                ["Included", "Excluded"],
                taxType,
                (v) => setState(() => taxType = v),
              ),
              const SizedBox(height: 12),

              inputField("Product Code", codeCtrl),
            ],

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveItem,
                child: const Text("SAVE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
