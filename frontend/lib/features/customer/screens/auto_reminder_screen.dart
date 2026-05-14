import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

class AutoReminderScreen extends StatefulWidget {
  final String customerName;
  const AutoReminderScreen({super.key, required this.customerName});

  @override
  State<AutoReminderScreen> createState() => _AutoReminderScreenState();
}

class _AutoReminderScreenState extends State<AutoReminderScreen> {
  int? selectedDays;

  Widget checkbox(int days) {
    return CheckboxListTile(
      title: Text("Start after $days days"),
      value: selectedDays == days,
      onChanged: (_) => setState(() => selectedDays = days),
    );
  }

  void saveReminder() {
    if (selectedDays == null) return;

    Provider.of<CustomerProvider>(
      context,
      listen: false,
    ).setAutoReminder(widget.customerName, selectedDays!);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auto Reminder")),
      body: Column(
        children: [
          checkbox(3),
          checkbox(7),
          checkbox(10),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveReminder,
            child: const Text("Save Reminder"),
          ),
        ],
      ),
    );
  }
}
