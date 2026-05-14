
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'customer_statement_screen.dart';
import 'package:frontend/models/customer_model.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customers = provider.customers;

    return Scaffold(
      appBar: AppBar(title: const Text("Customers")),
      body: customers.isEmpty
          ? const Center(child: Text("No customers added"))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(customer.name),
                  subtitle: Text(customer.mobile),
                  trailing: Text(
                    "₹${customer.balance.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CustomerStatementScreen(customer: customer),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
