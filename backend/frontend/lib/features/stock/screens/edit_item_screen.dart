
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/stock_item.dart';
import '../../../services/api_service.dart';

class EditItemScreen extends StatefulWidget {
  final StockItem? item;

  const EditItemScreen({super.key, this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  String unitValue = "Nos";
  String taxValue = "0%";
  String taxType = "Included";
  String selectedDate = "";
  String imagePath = "";

  bool showMore = true;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now().toString().substring(0, 10);

    if (isEdit) {
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
    }
  }

  Future<void> saveItem() async {
    final box = Hive.box<StockItem>('stock');

    if (widget.item == null) return;

    final item = widget.item!;

    // 🔥 LOCAL UPDATE
    item.name = nameCtrl.text;
    item.qty = qtyCtrl.text;
    item.mrp = mrpCtrl.text;
    item.rate = rateCtrl.text;
    item.unit = unitValue;
    item.tax = taxValue;
    item.taxType = taxType;

    await item.save();

    // 🔥 👉 YAHAN ADD KARNA HAI
    final settings = Hive.box('settings');
    final mobile = settings.get('mobile');

    // 🔥 API UPDATE
    try {
      await ApiService.updateProduct(item.productCode, {
        "mobile": mobile, // ✅ yaha use hoga
        "name": nameCtrl.text,
        "qty": qtyCtrl.text,
        "mrp": mrpCtrl.text,
        "rate": rateCtrl.text,
        "unit": unitValue,
        "tax": taxValue,
        "taxType": taxType,
      });

      print("UPDATED SUCCESS ✅");
    } catch (e) {
      print("❌ UPDATE ERROR: $e");
    }

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
      appBar: AppBar(title: Text(isEdit ? "Edit Item" : "New Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            inputField("Item Name", nameCtrl),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: inputField("MRP", mrpCtrl)),
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
              inputField("Rate", rateCtrl),
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
