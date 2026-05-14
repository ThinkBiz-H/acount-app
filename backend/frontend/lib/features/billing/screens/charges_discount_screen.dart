
import 'package:flutter/material.dart';

class ChargesDiscountScreen extends StatefulWidget {
  final double subTotal;

  const ChargesDiscountScreen({super.key, required this.subTotal});

  @override
  State<ChargesDiscountScreen> createState() => _ChargesDiscountScreenState();
}

class _ChargesDiscountScreenState extends State<ChargesDiscountScreen> {
  final chargesController = TextEditingController(text: "0");
  final discountController = TextEditingController(text: "0");

  bool discountIsPercent = false;

  double get charges => double.tryParse(chargesController.text) ?? 0;

  double get discountInput => double.tryParse(discountController.text) ?? 0;

  double get discount {
    if (discountIsPercent) {
      return (widget.subTotal * discountInput) / 100;
    } else {
      return discountInput;
    }
  }

  double get grandTotal => widget.subTotal + charges - discount;

  Widget buildField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Charges & Discount")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(label: "Extra Charges", controller: chargesController),

            buildField(
              label: discountIsPercent ? "Discount (%)" : "Discount Amount",
              controller: discountController,
            ),

            SwitchListTile(
              value: discountIsPercent,
              title: const Text("Discount in Percentage"),
              onChanged: (v) {
                setState(() {
                  discountIsPercent = v;
                });
              },
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sub Total"),
                      Text("₹ ${widget.subTotal.toStringAsFixed(2)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Charges"),
                      Text("+ ₹ ${charges.toStringAsFixed(2)}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Discount"),
                      Text("- ₹ ${discount.toStringAsFixed(2)}"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Grand Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "₹ ${grandTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {
                        "charges": charges,
                        "discount": discount,
                      });
                    },
                    child: const Text("Done"),
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
