// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../../providers/customer_provider.dart';

// // class CustomerSmsSettingsScreen extends StatelessWidget {
// //   final String customerName;

// //   const CustomerSmsSettingsScreen({super.key, required this.customerName});

// //   @override
// //   Widget build(BuildContext context) {
// //     final provider = Provider.of<CustomerProvider>(context);
// //     final customer = provider.getCustomer(customerName);

// //     return Scaffold(
// //       appBar: AppBar(title: const Text("SMS Settings")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             SwitchListTile(
// //               title: const Text("Instant alert on SMS"),
// //               subtitle: const Text("SMS will be sent after every transaction"),
// //               value: customer.smsEnabled,
// //               onChanged: (value) {
// //                 provider.toggleCustomerSMS(customer, value);
// //               },
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               "SIM charges may apply for SMS",
// //               style: TextStyle(color: Colors.grey),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';

// class CustomerSmsSettingsScreen extends StatelessWidget {
//   final String customerName;

//   const CustomerSmsSettingsScreen({super.key, required this.customerName});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//     final customer = provider.getCustomer(customerName);

//     return Scaffold(
//       appBar: AppBar(title: const Text("SMS Settings")),
//       body: SwitchListTile(
//         title: const Text("Instant alert on SMS"),
//         subtitle: const Text("SMS will be sent after every transaction"),
//         value: customer.smsEnabled,
//         onChanged: (value) {
//           provider.toggleCustomerSMS(customer, value);
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

class CustomerSmsSettingsScreen extends StatelessWidget {
  final String customerName;

  const CustomerSmsSettingsScreen({super.key, required this.customerName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.getCustomer(customerName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("SMS Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Instant alert on SMS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "SMS will be automatically sent after every transaction",
                ),
                value: customer.smsEnabled,
                onChanged: (value) {
                  provider.toggleCustomerSMS(customer, value);
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "SIM charges may apply for SMS",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
