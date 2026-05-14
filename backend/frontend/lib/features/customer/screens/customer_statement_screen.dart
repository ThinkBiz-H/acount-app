import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'package:frontend/models/customer_model.dart';

class CustomerStatementScreen extends StatelessWidget {
  final Customer customer;

  const CustomerStatementScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    /// ⭐ REAL TRANSACTIONS
    final transactions = customer.transactions;

    double totalGiven = 0;
    double totalGot = 0;

    for (var t in transactions) {
      if (t['type'] == "GIVEN") {
        totalGiven += t['amount'];
      } else {
        totalGot += t['amount'];
      }
    }

    double netBalance = totalGiven - totalGot;

    return Scaffold(
      appBar: AppBar(title: Text(customer.name), leading: const BackButton()),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// DATE CHIP
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

          /// NET BALANCE CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text("NET BALANCE YOU WILL GET"),
                const SizedBox(height: 6),
                Text(
                  "₹${netBalance.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// GIVEN / GOT STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.red),
                        Text(
                          "₹${totalGiven.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.red),
                        ),
                        const Text("YOU GAVE"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.green),
                        Text(
                          "₹${totalGot.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.green),
                        ),
                        const Text("YOU GOT"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// TRANSACTION CHAT LIST
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No transactions yet"))
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      bool isGiven = tx["type"] == "GIVEN";

                      return Align(
                        alignment: isGiven
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isGiven
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customer.name),
                              Text(
                                "₹${tx["amount"]}",
                                style: TextStyle(
                                  color: isGiven ? Colors.red : Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("Today"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// DOWNLOAD BUTTON (later PDF per customer)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Download"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C2752),
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
