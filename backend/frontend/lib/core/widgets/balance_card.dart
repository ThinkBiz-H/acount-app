// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';

// class BalanceCard extends StatelessWidget {
//   const BalanceCard({super.key, required this.showYouGive});

//   final bool showYouGive;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CustomerProvider>();
//     final customers = provider.customers;
//     final suppliers = provider.suppliers;

//     double amount = 0;
//     int count = 0;
//     String label = "";

//     if (showYouGive) {
//       /// YOU GIVE → suppliers jinko paisa dena hai
//       for (var s in suppliers) {
//         if (s.balance < 0) {
//           amount += s.balance.abs();
//           count++;
//         }
//       }
//       label = "You Give";
//     } else {
//       /// YOU GET → customers se paisa lena hai
//       for (var c in customers) {
//         if (c.balance > 0) {
//           amount += c.balance;
//           count++;
//         }
//       }
//       label = "You Get";
//     }

//     for (var c in customers) {
//       if (c.balance > 0) {
//         totalYouGet += c.balance;
//         youGetCount++;
//       }
//     }

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.green),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           /// LEFT SIDE
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Net Balance",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 "$count Customers",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),

//           /// RIGHT SIDE
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "₹${amount.toStringAsFixed(0)}",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(" label", style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.showYouGive});

  final bool showYouGive;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final customers = provider.customers;
    final suppliers = provider.suppliers;

    double amount = 0;
    int count = 0;
    String label = "";

    if (showYouGive) {
      /// YOU GIVE → suppliers jinko paisa dena hai
      for (var s in suppliers) {
        if (s.balance < 0) {
          amount += s.balance.abs();
          count++;
        }
      }
      label = "You Give";
    } else {
      /// YOU GET → customers se paisa lena hai
      for (var c in customers) {
        if (c.balance > 0) {
          amount += c.balance;
          count++;
        }
      }
      label = "You Get";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Net Balance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "$count Customers",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
