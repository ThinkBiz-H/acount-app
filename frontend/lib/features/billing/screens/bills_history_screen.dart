
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../services/api_service.dart';
import 'bill_preview_screen.dart';

class BillsHistoryScreen extends StatefulWidget {
  const BillsHistoryScreen({super.key});

  @override
  State<BillsHistoryScreen> createState() => _BillsHistoryScreenState();
}

class _BillsHistoryScreenState extends State<BillsHistoryScreen> {
  List bills = [];
  bool loading = true;

  Future loadBills() async {
    final settings = Hive.box('settings');
    final mobile = settings.get('mobile');

    final res = await ApiService.getBills(mobile);

    if (res["success"] == true) {
      setState(() {
        bills = res["data"];
        loading = false;
      });
    }
  }

  Future deleteBill(String id) async {
    await ApiService.deleteBill(id);
    loadBills();
  }

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Bills")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bills.isEmpty
          ? const Center(child: Text("No Bills Found"))
          : ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Bill ${bill['billNumber']}"),
                    subtitle: Text(bill['customerName']),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text("₹${bill['grandTotal']}"),
                        Text(
                          "₹${bill['grandTotal']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bill['paid'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "view") {
                              openBill(bill, true);
                            } else if (value == "edit") {
                              openBill(bill, false);
                            } else if (value == "delete") {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Bill"),
                                  content: const Text("Are you sure?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteBill(bill["_id"]);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "view", child: Text("View")),
                            PopupMenuItem(value: "edit", child: Text("Edit")),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future openBill(dynamic bill, bool isView) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillPreviewScreen(
          billKey: bill["_id"],
          existingBill: bill,
          customerName: bill['customerName'],
          mobile: bill['mobile'] ?? "",
          address: bill['address'] ?? "",
          billNumber: bill['billNumber'],
          billDate: DateTime.parse(bill['date']),
          items: List<Map<String, dynamic>>.from(bill['items']),
          subTotal: (bill['subTotal'] as num).toDouble(),
          gstTotal: (bill['gstTotal'] as num).toDouble(),
          cessTotal: (bill['cessTotal'] as num).toDouble(),
          charges: (bill['charges'] as num).toDouble(),
          discount: (bill['discount'] as num).toDouble(),
          grandTotal: (bill['grandTotal'] as num).toDouble(),
          isViewOnly: isView, // 🔥 MAIN FIX
        ),
      ),
    );

    if (result == true) {
      loadBills();
    }
  }
}
