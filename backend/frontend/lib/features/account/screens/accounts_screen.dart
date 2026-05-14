
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../services/pdf_backup_service.dart';
import '../../customer/screens/account_statement_screen.dart';
import '../../supplier/screens/supplier_account_statement_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    final customers = provider.customers;
    final suppliers = provider.suppliers;

    double customerTotal = 0;
    for (var c in customers) {
      customerTotal += c.balance;
    }

    double supplierTotal = 0;
    for (var s in suppliers) {
      supplierTotal += s.balance;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Accounts")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CUSTOMER KHATA CARD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountStatementScreen()),
                );
              },
              child: _card(
                icon: Icons.menu_book_rounded,
                title: "Customer Khata",
                subtitle: "${customers.length} Customers",
                amount: customerTotal,
                isYouGet: true,
              ),
            ),

            const SizedBox(height: 16),

            // SUPPLIER KHATA CARD
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SupplierAccountStatementScreen(),
                  ),
                );
              },
              child: _card(
                icon: Icons.local_shipping_outlined,
                title: "Supplier Khata",
                subtitle: "${suppliers.length} Suppliers",
                amount: supplierTotal,
                isYouGet: false,
              ),
            ),

            const Spacer(),

            // 🔥 DOWNLOAD BACKUP BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text(
                  "Download Backup",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C2752),
                ),
                onPressed: () async {
                  // Provider → PDF data convert
                  final customerList = customers
                      .map((c) => {"name": c.name, "due": c.balance.toInt()})
                      .toList();

                  final supplierList = suppliers
                      .map((s) => {"name": s.name, "due": s.balance.toInt()})
                      .toList();

                  await PdfBackupService.generateBackupPdf(
                    mobileNumber: "7852865819",
                    customerDue: customerTotal.toInt(),
                    supplierDue: supplierTotal.toInt(),
                    customers: customerList,
                    suppliers: supplierList,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String subtitle,
    required double amount,
    required bool isYouGet,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade50,
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Net Balance", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${amount.abs().toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                isYouGet ? "You Get" : "You Give",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
