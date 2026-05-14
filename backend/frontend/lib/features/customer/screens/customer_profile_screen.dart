import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'add_customer_screen.dart';
import 'customer_sms_settings_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  final String customerName;

  const CustomerProfileScreen({super.key, required this.customerName});

  Widget tile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
      ),
      onTap: onTap,
    );
  }

  /// ⭐ IMAGE PICKER FUNCTION
  Future<void> pickImage(BuildContext context, String name) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    Uint8List bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    context.read<CustomerProvider>().updateCustomerImage(name, base64Image);
  }

  void _confirmDelete(BuildContext context, CustomerProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Customer"),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCustomer(customerName);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.getCustomer(customerName);
    final image = provider.getCustomerImage(customer);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddCustomerScreen(customer: customer, isEdit: true),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          /// ⭐⭐ IMAGE UPLOAD AVATAR ⭐⭐
          Center(
            child: GestureDetector(
              onTap: () => pickImage(context, customer.name),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xffE8DEF8),
                backgroundImage: image,
                child: image == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 35,
                        color: Colors.deepPurple,
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 25),

          tile(Icons.person, customer.name),
          tile(Icons.phone, customer.mobile),
          tile(Icons.location_on, customer.address),

          const Divider(height: 30),

          tile(
            Icons.sms,
            "SMS Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomerSmsSettingsScreen(customerName: customer.name),
                ),
              );
            },
          ),

          const Divider(height: 30),

          tile(Icons.block, "Block", color: Colors.red),

          tile(
            Icons.delete,
            "Delete Customer",
            color: Colors.red,
            onTap: () => _confirmDelete(context, provider),
          ),
        ],
      ),
    );
  }
}
