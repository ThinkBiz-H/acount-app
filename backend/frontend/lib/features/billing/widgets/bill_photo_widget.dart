import 'package:flutter/material.dart';

class BillPhotoWidget extends StatelessWidget {
  final Map bill;
  const BillPhotoWidget({super.key, required this.bill});

  Widget row(String title, dynamic value, {bool bold = false}) {
    final val = double.tryParse(value.toString()) ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹${val.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🌟 WATERMARK LOGO BACKGROUND
        Center(
          child: Opacity(
            opacity: 0.56,
            child: Image.asset("assets/images/main-screen20.png", width: 260),
          ),
        ),

        /// 🌟 MAIN BILL
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CUSTOMER INFO
              Center(
                child: Column(
                  children: [
                    Text(
                      bill['customerName'] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Mobile: ${bill['mobile'] ?? ""}"),
                    Text(bill['address'] ?? ""),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// BILL NO + DATE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bill No: ${bill['billNumber']}"),
                  Text(bill['date']),
                ],
              ),

              const Divider(height: 25),

              /// HEADER
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Item", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),

              /// ITEMS
              ...List.generate(bill['items'].length, (i) {
                final item = bill['items'][i];
                final qty = double.tryParse(item['qty'].toString()) ?? 0;
                final rate = double.tryParse(item['rate'].toString()) ?? 0;
                final total = qty * rate;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['name']),
                      Text(qty.toStringAsFixed(0)),
                      Text("₹${rate.toStringAsFixed(0)}"),
                      Text("₹${total.toStringAsFixed(0)}"),
                    ],
                  ),
                );
              }),

              const Divider(height: 25),

              /// TOTALS
              row("Sub Total", bill['subTotal'] ?? 0),
              row("Extra Charge", bill['charges'] ?? 0),
              row("Discount", -(bill['discount'] ?? 0)),
              row("GST", bill['gst'] ?? 0),
              row("Cess", bill['cess'] ?? 0),

              const Divider(),

              row("TOTAL", bill['grandTotal'] ?? 0, bold: true),
            ],
          ),
        ),
      ],
    );
  }
}
