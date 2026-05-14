import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final controller = TextEditingController();

  void verifyPin() {
    final box = Hive.box('settings');

    final savedPin = box.get("appPin");

    if (controller.text == savedPin) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wrong PIN")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.lock, size: 60, color: Colors.green),

              const SizedBox(height: 20),

              const Text(
                "Enter App PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "PIN",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(onPressed: verifyPin, child: const Text("Unlock")),
            ],
          ),
        ),
      ),
    );
  }
}
