import 'package:flutter/material.dart';

class TransactionEntrySheet extends StatefulWidget {
  final bool isGiven; // true = Given, false = Received

  const TransactionEntrySheet({super.key, required this.isGiven});

  @override
  State<TransactionEntrySheet> createState() => _TransactionEntrySheetState();
}

class _TransactionEntrySheetState extends State<TransactionEntrySheet> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isGiven ? 'You Gave' : 'You Received',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Add notes',
                prefixIcon: Icon(Icons.note),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isGiven ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  if (amountController.text.isEmpty) return;

                  Navigator.pop(context, {
                    'amount': int.parse(amountController.text),
                    'note': noteController.text,
                    'type': widget.isGiven ? 'GIVEN' : 'RECEIVED',
                  });
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
