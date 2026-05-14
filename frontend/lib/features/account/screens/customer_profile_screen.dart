import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'edit_customer_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  final String customerName;
  const CustomerProfileScreen({super.key, required this.customerName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.getCustomer(customerName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCustomerScreen(customer: customer),
                ),
              );

              if (result != null) {
                Provider.of<CustomerProvider>(
                  context,
                  listen: false,
                ).updateCustomer(
                  customer.name,
                  result['name'],
                  result['phone'],
                  result['address'],
                );
              }
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.person),
            title: Text(customer.name),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(customer.mobile),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(customer.address),
          ),

          const Divider(),
          const ListTile(title: Text("SMS Settings")),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: const Text("Block"),
          ),

          /// DELETE CUSTOMER WORKING 🔥
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Customer"),
            onTap: () {
              provider.deleteCustomer(customerName);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
