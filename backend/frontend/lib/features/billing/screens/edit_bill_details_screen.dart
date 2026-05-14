import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import 'package:frontend/models/customer_model.dart';

class EditBillDetailsScreen extends StatefulWidget {
  final String name;
  final String mobile;
  final String address;
  final String billNumber;
  final DateTime date;

  const EditBillDetailsScreen({
    super.key,
    required this.name,
    required this.mobile,
    required this.address,
    required this.billNumber,
    required this.date,
  });

  @override
  State<EditBillDetailsScreen> createState() => _EditBillDetailsScreenState();
}

class _EditBillDetailsScreenState extends State<EditBillDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController billNumberController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    mobileController = TextEditingController(text: widget.mobile);
    addressController = TextEditingController(text: widget.address);
    billNumberController = TextEditingController(text: widget.billNumber);
    selectedDate = widget.date;
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void save() async {
    final provider = context.read<CustomerProvider>();

    String name = nameController.text.trim();
    String mobile = mobileController.text.trim();
    String address = addressController.text.trim();

    /// 🔥 CHECK EMPTY
    if (name.isNotEmpty && mobile.isNotEmpty) {
      final exists = provider.customers.any((c) => c.mobile == mobile);

      /// 🔥 ADD NEW CUSTOMER
      if (!exists) {
        await provider.addCustomer(name, mobile, address, "CUSTOMER");

        print("NEW CUSTOMER ADDED ✅");
      }
    }

    /// 🔥 RETURN DATA BACK
    Navigator.pop(context, {
      "name": name,
      "mobile": mobile,
      "address": address,
      "billNumber": billNumberController.text.trim(),
      "date": selectedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Edit Bill Details"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: save,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// ⭐ CUSTOMER AUTOCOMPLETE
                  Autocomplete<Customer>(
                    displayStringForOption: (c) => c.name,
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Customer>.empty();
                      }
                      return provider.customers.where(
                        (c) => c.name.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
                    },
                    onSelected: (customer) {
                      nameController.text = customer.name;
                      mobileController.text = customer.mobile;
                      addressController.text = customer.address;
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onSubmit) {
                          nameController = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: "Customer Name",
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: billNumberController,
                    decoration: const InputDecoration(
                      labelText: "Bill Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: save,
              child: const Text("Save", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
