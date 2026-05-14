// import 'package:flutter/material.dart';

// class DateRangeScreen extends StatefulWidget {
//   final DateTime? startDate;
//   final DateTime? endDate;

//   const DateRangeScreen({super.key, this.startDate, this.endDate});

//   @override
//   State<DateRangeScreen> createState() => _DateRangeScreenState();
// }

// class _DateRangeScreenState extends State<DateRangeScreen> {
//   DateTime? start;
//   DateTime? end;

//   @override
//   void initState() {
//     super.initState();
//     start = widget.startDate ?? DateTime.now();
//     end = widget.endDate ?? DateTime.now();
//   }

//   Future<void> pickRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       initialDateRange: DateTimeRange(start: start!, end: end!),
//     );

//     if (picked != null) {
//       setState(() {
//         start = picked.start;
//         end = picked.end;
//       });
//     }
//   }

//   String format(DateTime d) => "${d.day}/${d.month}/${d.year}";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Date Range"),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 30),

//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.green.shade50,
//               ),
//               child: Column(
//                 children: [
//                   Text("Start: ${format(start!)}"),
//                   Text("End: ${format(end!)}"),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: pickRange,
//                     child: const Text("Change Date Range"),
//                   ),
//                 ],
//               ),
//             ),

//             const Spacer(),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () {
//                 Navigator.pop(context, {"start": start, "end": end});
//               },
//               child: const Text("Confirm"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

  int selectedQuick = -1; // 👈 active button track

  @override
  void initState() {
    super.initState();
    start = widget.startDate ?? DateTime.now();
    end = widget.endDate ?? DateTime.now();
  }

  /// 📅 Manual picker
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
        selectedQuick = -1; // reset quick selection
      });
    }
  }

  /// ⚡ Quick button widget
  Widget _quickBtn(String text, int days, int index) {
    final isActive = selectedQuick == index;

    return GestureDetector(
      onTap: () {
        final today = DateTime.now();
        final newStart = today.subtract(Duration(days: days));
        final newEnd = today;

        setState(() {
          start = newStart;
          end = newEnd;
          selectedQuick = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
          color: isActive ? Colors.green : Colors.green.shade50,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
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
            const SizedBox(height: 20),

            /// 📅 Selected Date Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text("Start: ${formatDate(start)}"),
                  Text("End: ${formatDate(end)}"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📅 Manual picker button
            ElevatedButton(
              onPressed: pickRange,
              child: const Text("Select Date Range"),
            ),

            const SizedBox(height: 20),

            /// ⚡ QUICK FILTER BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _quickBtn("Today", 0, 0),
                const SizedBox(width: 8),
                _quickBtn("3 Days", 3, 1),
                const SizedBox(width: 8),
                _quickBtn("5 Days", 5, 2),
              ],
            ),

            const Spacer(),

            /// ✅ Confirm Button
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
