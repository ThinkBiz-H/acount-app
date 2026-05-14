import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../stock/models/stock_item.dart';

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

  StockItem? selectedStockItem;

  double get baseAmount =>
      (double.tryParse(qtyController.text) ?? 0) *
      (double.tryParse(rateController.text) ?? 0);

  double get gstAmount => baseAmount * gstPercent / 100;
  double get cessAmount => double.tryParse(cessController.text) ?? 0;

  void autoFillFromStock(StockItem item) {
    selectedStockItem = item;

    rateController.text = item.rate;
    selectedUnit = item.unit;
    gstPercent = double.tryParse(item.tax.replaceAll("%", "")) ?? 0;

    setState(() {});
  }

  void saveItem() {
    if (nameController.text.isEmpty) return;

    int enteredQty = int.tryParse(qtyController.text) ?? 0;

    if (selectedStockItem != null) {
      int stockQty = int.tryParse(selectedStockItem!.qty) ?? 0;

      if (enteredQty > stockQty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Not enough stock")));
        return;
      }
    }

    /// ❌❌❌ YAHAN STOCK CUT NAHI HOGA
    /// Sirf item return hoga bill ko

    Navigator.pop(context, [
      {
        "name": nameController.text,
        "productCode": selectedStockItem?.productCode,
        "qty": enteredQty.toDouble(),
        "unit": selectedUnit,
        "rate": double.parse(rateController.text),
        "gstPercent": gstPercent,
        "baseAmount": baseAmount,
        "gstAmount": gstAmount,
        "cessAmount": cessAmount,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final stockBox = Hive.box<StockItem>('stock');
    final stockItems = stockBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<StockItem>(
              decoration: const InputDecoration(labelText: "Select Item"),
              items: stockItems
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text("${item.name} (Stock: ${item.qty})"),
                    ),
                  )
                  .toList(),
              onChanged: (item) {
                if (item != null) {
                  nameController.text = item.name;
                  autoFillFromStock(item);
                }
              },
            ),

            const SizedBox(height: 10),

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
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Rate"),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 10),

            TextField(
              controller: cessController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Cess"),
              onChanged: (_) => setState(() {}),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveItem,
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
