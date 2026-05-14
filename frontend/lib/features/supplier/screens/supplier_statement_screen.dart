import 'package:flutter/material.dart';

class SupplierStatementScreen extends StatelessWidget {
  const SupplierStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"name": "ramu", "amount": 500, "type": "credit"},
      {"name": "ramu", "amount": 25, "type": "payment"},
    ];

    int totalCredit = 500;
    int totalPayment = 25;
    int netBalance = totalCredit - totalPayment;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier Statement"),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 6),
                Text("TODAY"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // BALANCE CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text("NET BALANCE DUE"),
                const SizedBox(height: 6),
                Text(
                  "₹$netBalance",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.red),
                        Text(
                          "₹$totalCredit",
                          style: const TextStyle(color: Colors.red),
                        ),
                        const Text("CREDIT"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.green),
                        Text(
                          "₹$totalPayment",
                          style: const TextStyle(color: Colors.green),
                        ),
                        const Text("PAYMENT"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // CHAT LIST
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                bool isCredit = tx["type"] == "credit";

                return Align(
                  alignment: isCredit
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCredit
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx["name"].toString()),
                        Text(
                          "₹${tx["amount"]}",
                          style: TextStyle(
                            color: isCredit ? Colors.red : Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Today 12:14 PM"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Download"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
