import 'package:flutter/material.dart';

class DateRangeScreen extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const DateRangeScreen({super.key, this.startDate, this.endDate});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    start = widget.startDate ?? DateTime.now();
    end = widget.endDate ?? DateTime.now();
  }

  Future<void> pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: start!, end: end!),
    );

    if (picked != null) {
      setState(() {
        start = picked.start;
        end = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Range"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: pickRange,
              child: const Text("Select Date Range"),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context, {"start": start, "end": end});
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
