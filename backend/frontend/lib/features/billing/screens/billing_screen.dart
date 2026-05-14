import 'package:flutter/material.dart';

import 'bills_history_screen.dart';
import 'create_bill_screen.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          Icon(Icons.receipt_long, size: 90, color: Colors.grey.shade400),
          const SizedBox(height: 16),

          const Text(
            'No bills created yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ⭐ VIEW SAVED BILLS BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C2752),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BillsHistoryScreen(),
                        ),
                      );
                    },
                    child: const Text("View Saved Bills"),
                  ),
                ),

                const SizedBox(height: 10),

                /// CREATE BILL BUTTON (OLD)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const SelectTemplateScreen(),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateBillScreen(),
                        ),
                      );
                    },
                    child: const Text('Create Bill'),
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
