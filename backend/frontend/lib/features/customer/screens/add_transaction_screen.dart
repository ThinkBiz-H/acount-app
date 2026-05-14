// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../billing/screens/select_template_screen.dart';
// import '../../plan/screens/plan_screen.dart';

// class AddTransactionScreen extends StatefulWidget {
//   final bool isGiven;
//   final String customerName;

//   const AddTransactionScreen({
//     super.key,
//     required this.isGiven,
//     required this.customerName,
//   });

//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   String amount = '0';
//   final TextEditingController noteController = TextEditingController();
//   DateTime selectedDate = DateTime.now();

//   bool get showCreateBillBtn => widget.isGiven && amount != '0';

//   void addDigit(String d) {
//     setState(() {
//       amount = amount == '0' ? d : amount + d;
//     });
//   }

//   void deleteDigit() {
//     setState(() {
//       amount = amount.length <= 1
//           ? '0'
//           : amount.substring(0, amount.length - 1);
//     });
//   }

//   Future<void> pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = widget.isGiven ? Colors.red : Colors.green;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isGiven ? 'You Gave' : 'You Received'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),

//           Text(
//             '₹$amount',
//             style: TextStyle(
//               fontSize: 36,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),

//           const SizedBox(height: 16),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: TextField(
//               controller: noteController,
//               decoration: const InputDecoration(
//                 hintText: 'Add note',
//                 prefixIcon: Icon(Icons.edit),
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 TextButton.icon(
//                   onPressed: pickDate,
//                   icon: const Icon(Icons.calendar_today),
//                   label: Text(
//                     '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//                   ),
//                 ),
//                 const Spacer(),
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.receipt_long),
//                   label: const Text('Add Bill'),
//                 ),
//               ],
//             ),
//           ),

//           const Spacer(),

//           _keypad(),

//           /// ⭐ FINAL BUTTON ROW
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 if (showCreateBillBtn)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const SelectTemplateScreen(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green.shade200,
//                         foregroundColor: Colors.black,
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                       child: const Text("Create Bill"),
//                     ),
//                   ),

//                 if (showCreateBillBtn) const SizedBox(width: 10),

//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: color),
//                     onPressed: () {
//                       if (amount == '0') return;

//                       final provider = Provider.of<CustomerProvider>(
//                         context,
//                         listen: false,
//                       );

//                       /// ⭐ CHECK DAILY LIMIT
//                       if (!provider.canAddTransaction()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const PlanScreen()),
//                         );
//                         return;
//                       }

//                       Navigator.pop(context, {
//                         'amount': double.parse(amount),
//                         'note': noteController.text,
//                         'date': selectedDate,
//                         'type': widget.isGiven ? 'GIVEN' : 'RECEIVED',
//                       });
//                     },
//                     child: const Text('Confirm'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ---------- KEYPAD ----------

//   Widget _keypad() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           _row(['1', '2', '3']),
//           _row(['4', '5', '6']),
//           _row(['7', '8', '9']),
//           Row(
//             children: [
//               _btn('0'),
//               const Spacer(),
//               IconButton(
//                 onPressed: deleteDigit,
//                 icon: const Icon(Icons.backspace),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _row(List<String> nums) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: nums.map(_btn).toList(),
//     );
//   }

//   Widget _btn(String v) {
//     return TextButton(
//       onPressed: () => addDigit(v),
//       child: Text(v, style: const TextStyle(fontSize: 24)),
//     );
//   }
//}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../billing/screens/select_template_screen.dart';
import '../../plan/screens/plan_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isGiven;
  final String customerName;

  const AddTransactionScreen({
    super.key,
    required this.isGiven,
    required this.customerName,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String amount = '0';
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  bool get showCreateBillBtn => widget.isGiven && amount != '0';

  void addDigit(String d) {
    setState(() {
      amount = amount == '0' ? d : amount + d;
    });
  }

  void deleteDigit() {
    setState(() {
      amount = amount.length <= 1
          ? '0'
          : amount.substring(0, amount.length - 1);
    });
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // Future<void> confirmTransaction() async {
  //   if (amount == '0') return;

  //   final provider = Provider.of<CustomerProvider>(context, listen: false);

  //   try {
  //     /// DAILY LIMIT CHECK
  //     if (!provider.canAddTransaction()) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => const PlanScreen()),
  //       );
  //       return;
  //     }

  //     /// SAVE TRANSACTION
  //     await provider.addTransaction(widget.customerName, {
  //       'amount': double.parse(amount),
  //       'note': noteController.text,
  //       'type': widget.isGiven ? 'GIVEN' : 'RECEIVED',
  //     });

  //     /// CLOSE SCREEN
  //     if (mounted) {
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     debugPrint("Transaction Error: $e");

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error saving transaction")));
  //   }
  // }
  Future<void> confirmTransaction() async {
    if (amount == '0') return;

    final provider = context.read<CustomerProvider>();

    try {
      if (!provider.canAddTransaction()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlanScreen()),
        );
        return;
      }

      /// 🔥 NO WAIT (FAST UX)
      provider.addTransaction(widget.customerName, {
        'amount': double.parse(amount),
        'note': noteController.text,
        'type': widget.isGiven ? 'GIVEN' : 'RECEIVED',
      });

      /// 🔥 INSTANT BACK
      if (mounted) {
        Navigator.pop(context, true); // 👈 IMPORTANT
      }
    } catch (e) {
      debugPrint("Transaction Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving transaction")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isGiven ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isGiven ? 'You Gave' : 'You Received'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            '₹$amount',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Add note',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Add Bill'),
                ),
              ],
            ),
          ),

          const Spacer(),

          _keypad(),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
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
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Create Bill"),
                    ),
                  ),

                if (showCreateBillBtn) const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: confirmTransaction,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- KEYPAD ----------

  Widget _keypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _row(['1', '2', '3']),
          _row(['4', '5', '6']),
          _row(['7', '8', '9']),
          Row(
            children: [
              _btn('0'),
              const Spacer(),
              IconButton(
                onPressed: deleteDigit,
                icon: const Icon(Icons.backspace),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(List<String> nums) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: nums.map(_btn).toList(),
    );
  }

  Widget _btn(String v) {
    return TextButton(
      onPressed: () => addDigit(v),
      child: Text(v, style: const TextStyle(fontSize: 24)),
    );
  }
}
