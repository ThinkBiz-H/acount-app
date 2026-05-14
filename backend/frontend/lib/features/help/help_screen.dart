import 'package:flutter/material.dart';
import 'faq_detail_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HelpSection(
            title: "Frequently Asked Questions",
            icon: Icons.help_outline,
            questions: [
              "What is SmartBahi?",
              "Why use SmartBahi?",
              "How to use this app?",
              "Do my customers need this app?",
              "How to share the app?",
            ],
          ),

          HelpSection(
            title: "Customer Related Questions",
            icon: Icons.person_outline,
            questions: [
              "How to add a customer from phonebook?",
              "How to add a customer manually?",
              "How to delete a customer?",
            ],
          ),

          HelpSection(
            title: "Transaction related questions",
            icon: Icons.currency_rupee,
            questions: [
              "How to add a credit entry?",
              "How to add a payment entry?",
              "How to delete a transaction?",
            ],
          ),

          HelpSection(
            title: "Account statement related questions",
            icon: Icons.description_outlined,
            questions: [
              "How to download statement?",
              "How to share statement?",
            ],
          ),

          HelpSection(
            title: "Account Security Related Questions",
            icon: Icons.security,
            questions: ["Is my data safe?", "Can I recover lost data?"],
          ),

          HelpSection(
            title: "Common Ledger Related Questions",
            icon: Icons.sync_alt,
            questions: ["What is Common Ledger?", "How to use Common Ledger?"],
          ),

          HelpSection(
            title: "Supplier Related Questions",
            icon: Icons.local_shipping_outlined,
            questions: [
              "How to add supplier?",
              "How to record supplier payment?",
            ],
          ),

          SizedBox(height: 80),
        ],
      ),

      /// WHATSAPP BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.chat, color: Colors.white),
          label: const Text(
            "Chat with Us (11AM-8PM)",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class HelpSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> questions;

  const HelpSection({
    super.key,
    required this.title,
    required this.icon,
    required this.questions,
  });

  @override
  State<HelpSection> createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icon, color: Colors.green),
            title: Text(widget.title),
            trailing: Icon(
              expanded ? Icons.expand_less : Icons.chevron_right,
              color: Colors.green,
            ),
            onTap: () => setState(() => expanded = !expanded),
          ),

          if (expanded)
            Column(
              children: widget.questions
                  .map(
                    (q) => ListTile(
                      title: Text(q),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FaqDetailScreen(
                              question: q,
                              answer: _getAnswer(q),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

String _getAnswer(String question) {
  switch (question) {
    case "How to add a customer from phonebook?":
      return "Open Customers screen → Tap Add Customer → Choose From Phonebook.";

    case "How to add a customer manually?":
      return "Tap Add Customer → Enter name & phone → Save.";

    case "How to delete a customer?":
      return "Open customer → Tap menu → Delete.";

    case "How to add a credit entry?":
      return "Open customer → Tap Give Credit → Enter amount.";

    case "How to add a payment entry?":
      return "Open customer → Tap Receive Payment.";

    case "How to delete a transaction?":
      return "Open transaction → Tap delete icon.";

    case "How to download statement?":
      return "Open customer → Tap Share → Download PDF.";

    case "How to share statement?":
      return "Open customer → Tap Share → WhatsApp.";

    case "Is my data safe?":
      return "Yes. Your data is securely stored and backed up.";

    case "Can I recover lost data?":
      return "Yes. Just login again to restore your data.";

    default:
      return "This feature will be available soon.";
  }
}
