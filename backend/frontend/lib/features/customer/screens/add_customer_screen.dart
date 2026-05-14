// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'package:frontend/models/customer_model.dart';

// class AddCustomerScreen extends StatefulWidget {
//   final Customer? customer;
//   final bool isEdit;

//   const AddCustomerScreen({super.key, this.customer, this.isEdit = false});

//   @override
//   State<AddCustomerScreen> createState() => _AddCustomerScreenState();
// }

// class _AddCustomerScreenState extends State<AddCustomerScreen> {
//   final nameController = TextEditingController();
//   final mobileController = TextEditingController();
//   final addressController = TextEditingController();

//   String selectedType = "CUSTOMER";

//   @override
//   void initState() {
//     super.initState();

//     if (widget.isEdit && widget.customer != null) {
//       nameController.text = widget.customer!.name;
//       mobileController.text = widget.customer!.mobile;
//       addressController.text = widget.customer!.address;
//       selectedType = widget.customer!.type;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isEdit ? "Edit Customer" : "Add Customer"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             /// NAME
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Customer Name"),
//             ),

//             const SizedBox(height: 20),

//             /// MOBILE
//             TextField(
//               controller: mobileController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(labelText: "Mobile Number"),
//             ),

//             const SizedBox(height: 20),

//             /// ADDRESS
//             TextField(
//               controller: addressController,
//               decoration: const InputDecoration(labelText: "Address"),
//             ),

//             const SizedBox(height: 30),

//             /// ⭐ CUSTOMER / SUPPLIER BUTTONS (OLD STYLE)
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => selectedType = "CUSTOMER"),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       decoration: BoxDecoration(
//                         color: selectedType == "CUSTOMER"
//                             ? const Color(0xFF1E8E3E)
//                             : Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: Text(
//                         "Customer",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: selectedType == "CUSTOMER"
//                               ? Colors.white
//                               : Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => setState(() => selectedType = "SUPPLIER"),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       decoration: BoxDecoration(
//                         color: selectedType == "SUPPLIER"
//                             ? const Color(0xFF0C2752)
//                             : Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: Text(
//                         "Supplier",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: selectedType == "SUPPLIER"
//                               ? Colors.white
//                               : Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const Spacer(),

//             /// ⭐ BIG CONFIRM BUTTON (OLD STYLE)
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0C2752),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (nameController.text.isEmpty) return;

//                   if (widget.isEdit) {
//                     provider.updateCustomer(
//                       widget.customer!.name,
//                       nameController.text.trim(),
//                       mobileController.text.trim(),
//                       addressController.text.trim(),
//                     );
//                   } else {
//                     provider.addPerson(
//                       nameController.text.trim(),
//                       mobileController.text.trim(),
//                       addressController.text.trim(),
//                       selectedType,
//                     );
//                   }

//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   widget.isEdit ? "Update" : "Confirm",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Color.fromARGB(255, 248, 248, 248),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/models/customer_model.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;
  final bool isEdit;

  const AddCustomerScreen({super.key, this.customer, this.isEdit = false});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  String selectedType = "CUSTOMER";

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.customer != null) {
      nameController.text = widget.customer!.name;
      mobileController.text = widget.customer!.mobile;
      addressController.text = widget.customer!.address;
      selectedType = widget.customer!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Customer" : "Add Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Customer Name"),
            ),

            const SizedBox(height: 20),

            /// MOBILE
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Mobile Number"),
            ),

            const SizedBox(height: 20),

            /// ADDRESS
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),

            const SizedBox(height: 30),

            /// ⭐ CUSTOMER / SUPPLIER BUTTONS (OLD STYLE)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = "CUSTOMER"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selectedType == "CUSTOMER"
                            ? const Color(0xFF1E8E3E)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        "Customer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedType == "CUSTOMER"
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = "SUPPLIER"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selectedType == "SUPPLIER"
                            ? const Color(0xFF0C2752)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        "Supplier",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedType == "SUPPLIER"
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// ⭐ BIG CONFIRM BUTTON (OLD STYLE)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C2752),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty) return;

                  if (widget.isEdit) {
                    await provider.updateCustomer(
                      widget.customer!.id,
                      nameController.text.trim(),
                      mobileController.text.trim(),
                      addressController.text.trim(),
                    );
                  } else {
                    await provider.addCustomer(
                      nameController.text.trim(),
                      mobileController.text.trim(),
                      addressController.text.trim(),
                      selectedType,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  widget.isEdit ? "Update" : "Confirm",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 248, 248, 248),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
