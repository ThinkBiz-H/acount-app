import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'add_transaction_screen.dart';
import 'customer_profile_screen.dart';
import 'customer_presonal_statement_screen.dart';
import '../../help/help_screen.dart';
import 'give_discount_screen.dart';
import 'auto_reminder_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customerName;
  const CustomerDetailScreen({super.key, required this.customerName});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double calculateBalance(List transactions) {
    double b = 0;
    for (var t in transactions) {
      if (t['type'] == 'GIVEN') {
        b += t['amount'];
      } else {
        b -= t['amount'];
      }
    }
    return b;
  }

  void openTransaction(bool isGiven) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          isGiven: isGiven,
          customerName: widget.customerName,
        ),
      ),
    );

    if (result != null) {
      Provider.of<CustomerProvider>(
        context,
        listen: false,
      ).addTransaction(widget.customerName, result);
    }
  }

  void _openMoreSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            children: [
              /// DELETE CUSTOMER
              _MoreItem(
                Icons.delete,
                "Delete",
                Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  ).deleteCustomer(widget.customerName);
                  Navigator.pop(context);
                },
              ),

              /// HELP
              _MoreItem(
                Icons.help,
                "Help",
                Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  );
                },
              ),

              /// REPORT → STATEMENT SCREEN
              _MoreItem(
                Icons.description,
                "Report",
                Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerStatementScreen(
                        customerName: widget.customerName,
                      ),
                    ),
                  );
                },
              ),

              /// GIVE DISCOUNT (future)
              _MoreItem(
                Icons.settings,
                "Give Discount",
                Colors.pink,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GiveDiscountScreen(customerName: widget.customerName),
                    ),
                  );
                },
              ),

              /// AUTO REMINDER (future)
              _MoreItem(
                Icons.notifications,
                "Auto Reminder",
                Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AutoReminderScreen(customerName: widget.customerName),
                    ),
                  );
                },
              ),

              /// CALL
              _MoreItem(
                Icons.call,
                "Call",
                Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  final provider = Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  );
                  provider.callCustomer(
                    provider.getCustomer(widget.customerName),
                  );
                },
              ),

              /// SMS
              _MoreItem(
                Icons.sms,
                "SMS",
                Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  final provider = Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  );
                  final customer = provider.getCustomer(widget.customerName);

                  final Uri smsUri = Uri(scheme: 'sms', path: customer.mobile);
                  await launchUrl(smsUri);
                },
              ),

              /// WHATSAPP
              _MoreItem(
                Icons.message,
                "Whatsapp",
                Colors.green,
                onTap: () async {
                  Navigator.pop(context);
                  final provider = Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  );
                  final customer = provider.getCustomer(widget.customerName);

                  final url = Uri.parse("https://wa.me/91${customer.mobile}");
                  await launchUrl(url);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.getCustomer(widget.customerName);
    final image = provider.getCustomerImage(customer);

    final transactions = provider.getTransactions(widget.customerName);
    final balance = calculateBalance(transactions);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// ⭐ APPBAR WITH IMAGE
      appBar: AppBar(
        leading: const BackButton(),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CustomerProfileScreen(customerName: widget.customerName),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.deepPurple.shade100,
                backgroundImage: image,
                child: image == null
                    ? Text(
                        widget.customerName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.deepPurple),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.customerName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    "View Profile",
                    style: TextStyle(fontSize: 13, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerStatementScreen(
                    customerName: widget.customerName,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              final provider = Provider.of<CustomerProvider>(
                context,
                listen: false,
              );
              final customer = provider.getCustomer(widget.customerName);
              provider.callCustomer(customer);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No transactions yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final isGiven = t['type'] == 'GIVEN';
                      final DateTime d =
                          DateTime.tryParse(t['time'] ?? "") ?? DateTime.now();

                      return Align(
                        alignment: isGiven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: isGiven
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${t['amount']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isGiven ? Colors.red : Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              if (t["note"] != null &&
                                  t["note"].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(t["note"]),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                "${d.day}/${d.month}/${d.year}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// ⭐⭐ FULL KHATABOOK BOTTOM PANEL BACK ⭐⭐
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      /// LEFT ICONS GROUP
                      Row(
                        children: [
                          _ActionIcon(Icons.description, onTap: _openMoreSheet),
                          const SizedBox(width: 18),
                          _ActionIcon(Icons.chat_bubble, onTap: _openMoreSheet),
                          const SizedBox(width: 18),
                          _ActionIcon(Icons.call, onTap: _openMoreSheet),
                          const SizedBox(width: 18),
                          _ActionIcon(Icons.sms, onTap: _openMoreSheet),
                        ],
                      ),

                      const Spacer(),

                      /// RIGHT MORE BUTTON
                      GestureDetector(
                        onTap: _openMoreSheet,
                        child: const Row(
                          children: [
                            Text(
                              "More",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 📅 SET DUE DATE
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        );

                        if (pickedDate == null) return;

                        context.read<CustomerProvider>().setDueDate(
                          widget.customerName,
                          pickedDate,
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),

                          Builder(
                            builder: (context) {
                              final dueDate = context
                                  .watch<CustomerProvider>()
                                  .getCustomer(widget.customerName)
                                  .dueDate;

                              return Text(
                                dueDate == null
                                    ? "Set Due Date"
                                    : "${dueDate.day}/${dueDate.month}/${dueDate.year}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: dueDate == null
                                      ? Colors.black
                                      : Colors.green,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    /// 🔔 AUTO REMINDER BUTTON
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.notifications),
                      label: const Text("Auto Reminder"),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Balance Due"),
                    Text(
                      "₹${balance.abs()}",
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => openTransaction(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.green,
                        ),
                        child: const Text("Received"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => openTransaction(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Given"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const _MoreItem(this.icon, this.title, this.color, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback? onTap;

  const _ActionIcon(this.icon, {this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: imagePath != null
            ? Image.asset(imagePath!, height: 18)
            : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
