// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/stock_item.dart';
// import 'edit_item_screen.dart';
// import '../../../services/api_service.dart';

// class StockScreen extends StatefulWidget {
//   const StockScreen({super.key});

//   @override
//   State<StockScreen> createState() => _StockScreenState();
// }

// class _StockScreenState extends State<StockScreen> {
//   String search = "";

//   Future<void> loadProducts() async {
//     try {
//       final settingsBox = Hive.box('settings');
//       final mobile = settingsBox.get('mobile');

//       final data = await ApiService.getProducts(mobile);

//       final box = Hive.box<StockItem>('stock');

//       await box.clear();

//       for (var p in data) {
//         await box.add(
//           StockItem(
//             name: p["name"] ?? "",
//             mrp: p["mrp"]?.toString() ?? "0",
//             qty: p["qty"]?.toString() ?? "0",
//             unit: p["unit"] ?? "",
//             rate: p["rate"]?.toString() ?? "0",
//             date: p["date"] ?? "",
//             tax: p["tax"] ?? "0%",
//             taxType: p["taxType"] ?? "Included",
//             productCode: p["productCode"] ?? "",
//             imagePath: p["imagePath"] ?? "",
//           ),
//         );
//       }

//       setState(() {});
//     } catch (e) {
//       debugPrint("Stock load error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final box = Hive.box<StockItem>('stock');

//     return Scaffold(
//       appBar: AppBar(title: const Text("Stock Items"), centerTitle: true),

//       /// ➕ ADD ITEM
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF0C2752),
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const EditItemScreen()),
//           );

//           /// reload after add
//           loadProducts();
//         },
//       ),

//       body: Column(
//         children: [
//           /// SEARCH
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Search item...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade200,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               onChanged: (val) {
//                 setState(() {
//                   search = val;
//                 });
//               },
//             ),
//           ),

//           /// LIST
//           Expanded(
//             child: ValueListenableBuilder<Box<StockItem>>(
//               valueListenable: box.listenable(),
//               builder: (context, box, _) {
//                 final allItems = box.values.toList();

//                 final items = allItems.where((item) {
//                   return item.name.toLowerCase().contains(search.toLowerCase());
//                 }).toList();

//                 if (items.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No stock items yet",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (_, i) {
//                     final item = items[i];

//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.green.shade100,
//                           child: const Icon(
//                             Icons.inventory,
//                             color: Colors.green,
//                           ),
//                         ),

//                         title: Text(
//                           item.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),

//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text("MRP: ₹${item.mrp}"),
//                             Text("Qty: ${item.qty} ${item.unit}"),
//                             Text("Tax: ${item.tax} (${item.taxType})"),
//                           ],
//                         ),

//                         // trailing: const Icon(Icons.edit, size: 18),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             /// EDIT BUTTON
//                             IconButton(
//                               icon: const Icon(Icons.edit, size: 18),
//                               onPressed: () async {
//                                 await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => EditItemScreen(item: item),
//                                   ),
//                                 );

//                                 loadProducts();
//                               },
//                             ),

//                             /// DELETE BUTTON
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 if (item.productCode.isEmpty) {
//                                   debugPrint("Product code missing");
//                                   return;
//                                 }

//                                 try {
//                                   await ApiService.deleteProduct(
//                                     item.productCode,
//                                   );

//                                   await item.delete();

//                                   setState(() {});
//                                 } catch (e) {
//                                   debugPrint("Delete error: $e");
//                                 }
//                               },
//                             ),
//                           ],
//                         ),

//                         /// EDIT
//                         onTap: () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => EditItemScreen(item: item),
//                             ),
//                           );

//                           loadProducts();
//                         },

//                         /// DELETE
//                         onLongPress: () async {
//                           try {
//                             await ApiService.deleteProduct(item.productCode);

//                             await item.delete();

//                             setState(() {});
//                           } catch (e) {
//                             debugPrint("Delete error: $e");
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock_item.dart';
import 'edit_item_screen.dart';
import '../../../services/api_service.dart';
import 'add_stock_item_screen.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String search = "";

  Future<void> loadProducts() async {
    try {
      final settingsBox = Hive.box('settings');
      final mobile = settingsBox.get('mobile');

      final data = await ApiService.getProducts(mobile);

      final box = Hive.box<StockItem>('stock');

      /// ❌ REMOVE clear (important fix)
      // await box.clear();

      for (var p in data) {
        final existing = box.values
            .where((e) => e.productCode == p["productCode"])
            .toList();

        if (existing.isNotEmpty) {
          final item = existing.first;

          item
            ..name = p["name"] ?? ""
            ..mrp = p["mrp"]?.toString() ?? "0"
            ..qty = p["qty"]?.toString() ?? "0"
            ..unit = p["unit"] ?? ""
            ..rate = p["rate"]?.toString() ?? "0"
            ..date = p["date"] ?? ""
            ..tax = p["tax"] ?? "0%"
            ..taxType = p["taxType"] ?? "Included"
            ..save();
        } else {
          await box.add(
            StockItem(
              name: p["name"] ?? "",
              mrp: p["mrp"]?.toString() ?? "0",
              qty: p["qty"]?.toString() ?? "0",
              unit: p["unit"] ?? "",
              rate: p["rate"]?.toString() ?? "0",
              date: p["date"] ?? "",
              tax: p["tax"] ?? "0%",
              taxType: p["taxType"] ?? "Included",
              productCode: p["productCode"] ?? "",
              imagePath: p["imagePath"] ?? "",
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Stock load error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts(); // first load ok
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<StockItem>('stock');

    return Scaffold(
      appBar: AppBar(title: const Text("Stock Items"), centerTitle: true),

      /// ➕ ADD ITEM
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C2752),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,

            // MaterialPageRoute(builder: (_) => const EditItemScreen()),
            MaterialPageRoute(builder: (_) => AddStockItemScreen()),
          );

          /// ❌ API reload hata diya
          if (result == true) {
            setState(() {}); // optional (listener already handle karega)
          }
        },
      ),

      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search item...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  search = val;
                });
              },
            ),
          ),

          /// LIST
          Expanded(
            child: ValueListenableBuilder<Box<StockItem>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                final allItems = box.values.toList();

                final items = allItems.where((item) {
                  return item.name.toLowerCase().contains(search.toLowerCase());
                }).toList();

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "No stock items yet",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(
                            Icons.inventory,
                            color: Colors.green,
                          ),
                        ),

                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("MRP: ₹${item.mrp}"),
                            Text("Qty: ${item.qty} ${item.unit}"),
                            Text("Tax: ${item.tax} (${item.taxType})"),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// EDIT
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditItemScreen(item: item),
                                  ),
                                );

                                if (result == true) {
                                  setState(() {});
                                }
                              },
                            ),

                            /// DELETE
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  if (item.productCode.isNotEmpty) {
                                    await ApiService.deleteProduct(
                                      item.productCode,
                                    );
                                  }

                                  await item.delete();
                                } catch (e) {
                                  debugPrint("Delete error: $e");
                                }
                              },
                            ),
                          ],
                        ),

                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditItemScreen(item: item),
                            ),
                          );

                          if (result == true) {
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
