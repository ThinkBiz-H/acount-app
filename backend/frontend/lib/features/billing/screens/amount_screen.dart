
import 'package:flutter/material.dart';
import 'select_template_screen.dart';

class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  String amount = "0";

  void addDigit(String digit) {
    setState(() {
      if (amount == "0") {
        amount = digit;
      } else {
        amount += digit;
      }
    });
  }

  void deleteDigit() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0";
      }
    });
  }

  Widget numButton(String num) {
    return GestureDetector(
      onTap: () => addDigit(num),
      child: Container(
        alignment: Alignment.center,
        child: Text(num, style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showCreateBillBtn = amount != "0";

    return Scaffold(
      appBar: AppBar(title: const Text("You Gave")),
      body: Column(
        children: [
          const SizedBox(height: 30),

          Text(
            "₹$amount",
            style: const TextStyle(
              fontSize: 40,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // 🔢 Keypad
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            children: [
              numButton("1"),
              numButton("2"),
              numButton("3"),
              numButton("4"),
              numButton("5"),
              numButton("6"),
              numButton("7"),
              numButton("8"),
              numButton("9"),
              const SizedBox(),
              numButton("0"),
              GestureDetector(
                onTap: deleteDigit,
                child: const Icon(Icons.backspace),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ⭐ BOTTOM BUTTONS (FINAL WORKING)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 👉 Create Bill (only when amount > 0)
                if (showCreateBillBtn)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectTemplateScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade200,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: const Text("Create Bill"),
                    ),
                  ),

                if (showCreateBillBtn) const SizedBox(width: 10),

                // 👉 Confirm (always visible)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
