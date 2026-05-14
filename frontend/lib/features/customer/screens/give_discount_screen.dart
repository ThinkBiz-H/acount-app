import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

class GiveDiscountScreen extends StatefulWidget {
  final String customerName;
  const GiveDiscountScreen({super.key, required this.customerName});

  @override
  State<GiveDiscountScreen> createState() => _GiveDiscountScreenState();
}

class _GiveDiscountScreenState extends State<GiveDiscountScreen> {
  final controller = TextEditingController();

  void applyDiscount() {
    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) return;

    Provider.of<CustomerProvider>(
      context,
      listen: false,
    ).applyDiscount(widget.customerName, amount);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Give Discount")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Enter discount amount",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: "₹ ",
                border: OutlineInputBorder(),
                hintText: "Enter amount",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: applyDiscount,
              child: const Text("Apply Discount"),
            ),
          ],
        ),
      ),
    );
  }
}
