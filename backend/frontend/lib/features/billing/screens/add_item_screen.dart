// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../../stock/models/stock_item.dart';
// import '../../stock/screens/add_stock_item_screen.dart';

// class AddItemScreen extends StatefulWidget {
//   const AddItemScreen({super.key});

//   @override
//   State<AddItemScreen> createState() => _AddItemScreenState();
// }

// class _AddItemScreenState extends State<AddItemScreen> {
//   final nameController = TextEditingController();
//   final qtyController = TextEditingController(text: "1");
//   final rateController = TextEditingController(text: "0");
//   final cessController = TextEditingController(text: "0");

//   double gstPercent = 0;
//   String selectedUnit = "Nos";

//   List<StockItem> stockItems = [];
//   List<StockItem> suggestions = [];

//   StockItem? selectedItem; // 🔥 NEW

//   @override
//   void initState() {
//     super.initState();
//     stockItems = Hive.box<StockItem>('stock').values.toList();
//   }

//   void searchItem(String value) {
//     final box = Hive.box<StockItem>('stock');
//     stockItems = box.values.toList();

//     suggestions = stockItems
//         .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
//         .toList();

//     selectedItem = null;

//     for (var item in stockItems) {
//       if (item.name.toLowerCase().trim() == value.toLowerCase().trim()) {
//         selectedItem = item;
//         break;
//       }
//     }

//     setState(() {});
//   }

//   void selectStockItem(StockItem item) {
//     selectedItem = item; // 🔥 IMPORTANT

//     nameController.text = item.name;
//     rateController.text = item.rate;
//     selectedUnit = item.unit;
//     gstPercent = double.tryParse(item.tax.replaceAll("%", "")) ?? 0;

//     suggestions.clear();
//     setState(() {});
//   }

//   double get baseAmount =>
//       (double.tryParse(qtyController.text) ?? 0) *
//       (double.tryParse(rateController.text) ?? 0);

//   double get gstAmount => baseAmount * gstPercent / 100;
//   double get cessAmount => double.tryParse(cessController.text) ?? 0;

//   void saveItem() {
//     if (nameController.text.isEmpty) return;

//     Navigator.pop(context, [
//       {
//         "name": nameController.text,
//         "qty": double.parse(qtyController.text),
//         "unit": selectedUnit,
//         "rate": double.parse(rateController.text),
//         "gstPercent": gstPercent,
//         "baseAmount": baseAmount,
//         "gstAmount": gstAmount,
//         "cessAmount": cessAmount,
//       },
//     ]);
//   }

//   /// 🔥 UPDATED NAVIGATION
//   Future<void> openAddStockScreen() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddStockItemScreen(
//           prefillName: nameController.text,
//           item: selectedItem, // 🔥 MAGIC
//         ),
//       ),
//     );

//     searchItem(nameController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add New Item")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// ITEM NAME
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Item Name"),
//               onChanged: searchItem,
//             ),

//             /// SUGGESTIONS
//             if (suggestions.isNotEmpty)
//               Container(
//                 margin: const EdgeInsets.only(top: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: suggestions.length,
//                   itemBuilder: (_, i) {
//                     final item = suggestions[i];
//                     return ListTile(
//                       title: Text(item.name),
//                       subtitle: Text(
//                         "Stock: ${item.qty} ${item.unit} | Rate: ₹${item.rate}",
//                       ),
//                       onTap: () => selectStockItem(item),
//                     );
//                   },
//                 ),
//               ),

//             const SizedBox(height: 16),

//             /// QTY + UNIT
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     controller: qtyController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "Quantity"),
//                     onChanged: (_) => setState(() {}),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: TextEditingController(text: selectedUnit),
//                     readOnly: true,
//                     decoration: const InputDecoration(labelText: "Unit"),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// RATE
//             TextField(
//               controller: rateController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Rate"),
//               onChanged: (_) => setState(() {}),
//             ),

//             const SizedBox(height: 16),

//             /// GST
//             DropdownButtonFormField<double>(
//               value: gstPercent,
//               decoration: const InputDecoration(labelText: "GST"),
//               items: [0, 5, 12, 18, 28]
//                   .map(
//                     (g) => DropdownMenuItem(
//                       value: g.toDouble(),
//                       child: Text("$g %"),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (v) => setState(() => gstPercent = v!),
//             ),

//             const SizedBox(height: 16),

//             /// CESS
//             TextField(
//               controller: cessController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Cess"),
//               onChanged: (_) => setState(() {}),
//             ),

//             /// 🔥 SMART BUTTON (FINAL)
//             if (nameController.text.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: ElevatedButton(
//                   onPressed: openAddStockScreen,
//                   child: Text(
//                     selectedItem == null ? "Add Stock Item" : "Update Stock",
//                   ),
//                 ),
//               ),

//             const Spacer(),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: saveItem,
//               child: const Text("Done"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// AddItemScreen FIXED 🔥

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../../stock/models/stock_item.dart';
// import '../../stock/screens/add_stock_item_screen.dart';

// class AddItemScreen extends StatefulWidget {
//   const AddItemScreen({super.key});

//   @override
//   State<AddItemScreen> createState() => _AddItemScreenState();
// }

// class _AddItemScreenState extends State<AddItemScreen> {
//   final nameController = TextEditingController();
//   final qtyController = TextEditingController(text: "1");
//   final rateController = TextEditingController(text: "0");
//   final cessController = TextEditingController(text: "0");

//   double gstPercent = 0;
//   String selectedUnit = "Nos";

//   List<StockItem> stockItems = [];
//   List<StockItem> suggestions = [];

//   StockItem? selectedItem;

//   @override
//   void initState() {
//     super.initState();
//     loadStock();
//   }

//   void loadStock() {
//     final box = Hive.box<StockItem>('stock');
//     stockItems = box.values.toList();
//   }

//   void searchItem(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         suggestions.clear();
//         selectedItem = null;
//       });
//       return;
//     }

//     suggestions = stockItems
//         .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
//         .toList();

//     selectedItem = null;

//     for (var item in stockItems) {
//       if (item.name.toLowerCase().trim() == value.toLowerCase().trim()) {
//         selectedItem = item;
//         break;
//       }
//     }

//     setState(() {});
//   }

//   void selectStockItem(StockItem item) {
//     selectedItem = item;

//     nameController.text = item.name;
//     rateController.text = item.rate;
//     selectedUnit = item.unit;
//     gstPercent = double.tryParse(item.tax.replaceAll("%", "")) ?? 0;

//     suggestions.clear();
//     setState(() {});
//   }

//   double get baseAmount =>
//       (double.tryParse(qtyController.text) ?? 0) *
//       (double.tryParse(rateController.text) ?? 0);

//   double get gstAmount => baseAmount * gstPercent / 100;
//   double get cessAmount => double.tryParse(cessController.text) ?? 0;

//   void saveItem() {
//     if (nameController.text.isEmpty) return;

//     Navigator.pop(context, [
//       {
//         "name": nameController.text,
//         "qty": double.parse(qtyController.text),
//         "unit": selectedUnit,
//         "rate": double.parse(rateController.text),
//         "gstPercent": gstPercent,
//         "baseAmount": baseAmount,
//         "gstAmount": gstAmount,
//         "cessAmount": cessAmount,
//       },
//     ]);
//   }

//   Future<void> openAddStockScreen() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddStockItemScreen(
//           prefillName: nameController.text,
//           item: selectedItem,
//         ),
//       ),
//     );

//     loadStock(); // 🔥 reload after coming back
//     searchItem(nameController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add New Item")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// ITEM NAME
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Item Name"),
//               onChanged: searchItem,
//             ),

//             /// 🔥 SUGGESTIONS FIXED
//             if (suggestions.isNotEmpty)
//               Container(
//                 height: 150,
//                 margin: const EdgeInsets.only(top: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: ListView.builder(
//                   itemCount: suggestions.length,
//                   itemBuilder: (_, i) {
//                     final item = suggestions[i];
//                     return ListTile(
//                       title: Text(item.name),
//                       subtitle: Text(
//                         "Stock: ${item.qty} ${item.unit} | ₹${item.rate}",
//                       ),
//                       onTap: () => selectStockItem(item),
//                     );
//                   },
//                 ),
//               ),

//             const SizedBox(height: 16),

//             /// QTY + UNIT
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     controller: qtyController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "Quantity"),
//                     onChanged: (_) => setState(() {}),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: TextEditingController(text: selectedUnit),
//                     readOnly: true,
//                     decoration: const InputDecoration(labelText: "Unit"),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// RATE
//             TextField(
//               controller: rateController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Rate"),
//               onChanged: (_) => setState(() {}),
//             ),

//             const SizedBox(height: 16),

//             /// GST
//             DropdownButtonFormField<double>(
//               value: gstPercent,
//               decoration: const InputDecoration(labelText: "GST"),
//               items: [0, 5, 12, 18, 28]
//                   .map(
//                     (g) => DropdownMenuItem(
//                       value: g.toDouble(),
//                       child: Text("$g %"),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (v) => setState(() => gstPercent = v!),
//             ),

//             const SizedBox(height: 16),

//             /// CESS
//             TextField(
//               controller: cessController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Cess"),
//               onChanged: (_) => setState(() {}),
//             ),

//             /// BUTTON
//             if (nameController.text.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: ElevatedButton(
//                   onPressed: openAddStockScreen,
//                   child: Text(
//                     selectedItem == null ? "Add Stock Item" : "Update Stock",
//                   ),
//                 ),
//               ),

//             const Spacer(),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: saveItem,
//               child: const Text("Done"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../stock/models/stock_item.dart';
import '../../stock/screens/add_stock_item_screen.dart';
import '../../../services/api_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final nameController = TextEditingController();
  final qtyController = TextEditingController(text: "1");
  final rateController = TextEditingController(text: "0");
  final cessController = TextEditingController(text: "0");

  double gstPercent = 0;
  String selectedUnit = "Nos";

  List<StockItem> stockItems = [];
  List<StockItem> suggestions = [];

  StockItem? selectedItem;

  @override
  void initState() {
    super.initState();
    loadStock();
  }

  /// 🔥 FINAL FIXED LOAD STOCK
  Future<void> loadStock() async {
    try {
      final settings = Hive.box('settings');
      final mobile = settings.get('mobile');

      final products = await ApiService.getProducts(mobile);

      print("RAW PRODUCTS: $products");

      /// 🔥 FILTER + SAFE MAP
      stockItems = products
          .where((e) => e is Map && e.containsKey('name'))
          .map<StockItem>((e) {
            return StockItem(
              name: e['name']?.toString() ?? '',
              mrp: e['mrp']?.toString() ?? '0',
              qty: e['qty']?.toString() ?? '0',
              unit: e['unit']?.toString() ?? '',
              rate: e['rate']?.toString() ?? '0',
              date: e['date']?.toString() ?? '',
              tax: e['tax']?.toString() ?? '0',
              taxType: e['taxType']?.toString() ?? '',
              productCode: e['productCode']?.toString() ?? '',
              imagePath: e['imagePath']?.toString() ?? '',
            );
          })
          .toList();

      print("STOCK COUNT: ${stockItems.length}");

      setState(() {});

      if (nameController.text.isNotEmpty) {
        searchItem(nameController.text);
      }
    } catch (e) {
      print("Stock load error: $e");
    }
  }

  /// 🔥 SEARCH FIXED
  void searchItem(String value) {
    if (value.isEmpty) {
      setState(() {
        suggestions.clear();
        selectedItem = null;
      });
      return;
    }

    final filtered = stockItems
        .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    StockItem? found;

    for (var item in stockItems) {
      if (item.name.toLowerCase().trim() == value.toLowerCase().trim()) {
        found = item;
        break;
      }
    }

    setState(() {
      suggestions = filtered;
      selectedItem = found;
    });
  }

  void selectStockItem(StockItem item) {
    selectedItem = item;

    nameController.text = item.name;
    rateController.text = item.rate;
    selectedUnit = item.unit;
    gstPercent = double.tryParse(item.tax.replaceAll("%", "")) ?? 0;

    suggestions.clear();
    setState(() {});
  }

  double get baseAmount =>
      (double.tryParse(qtyController.text) ?? 0) *
      (double.tryParse(rateController.text) ?? 0);

  double get gstAmount => baseAmount * gstPercent / 100;
  double get cessAmount => double.tryParse(cessController.text) ?? 0;

  void saveItem() {
    if (nameController.text.isEmpty) return;

    Navigator.pop(context, [
      {
        "name": nameController.text,
        "qty": double.parse(qtyController.text),
        "unit": selectedUnit,
        "rate": double.parse(rateController.text),
        "gstPercent": gstPercent,
        "baseAmount": baseAmount,
        "gstAmount": gstAmount,
        "cessAmount": cessAmount,
      },
    ]);
  }

  Future<void> openAddStockScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddStockItemScreen(
          prefillName: nameController.text,
          item: selectedItem,
        ),
      ),
    );

    await loadStock(); // 🔥 IMPORTANT
    searchItem(nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
              onChanged: (value) {
                searchItem(value);
              },
            ),

            if (suggestions.isNotEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (_, i) {
                    final item = suggestions[i];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        "Stock: ${item.qty} ${item.unit} | ₹${item.rate}",
                      ),
                      onTap: () => selectStockItem(item),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: selectedUnit),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Unit"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Rate"),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<double>(
              value: gstPercent,
              decoration: const InputDecoration(labelText: "GST"),
              items: [0, 5, 12, 18, 28]
                  .map(
                    (g) => DropdownMenuItem(
                      value: g.toDouble(),
                      child: Text("$g %"),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => gstPercent = v!),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: cessController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Cess"),
              onChanged: (_) => setState(() {}),
            ),

            if (nameController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: openAddStockScreen,
                  child: Text(
                    selectedItem == null ? "Add Stock Item" : "Update Stock",
                  ),
                ),
              ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: saveItem,
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
