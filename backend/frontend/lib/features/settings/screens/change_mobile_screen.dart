// import 'package:flutter/material.dart';
// import '../../../services/api_service.dart';
// import '../../auth/screens/login_screen.dart';

// class ChangeMobileScreen extends StatefulWidget {
//   const ChangeMobileScreen({super.key});

//   @override
//   State<ChangeMobileScreen> createState() => _ChangeMobileScreenState();
// }

// class _ChangeMobileScreenState extends State<ChangeMobileScreen> {
//   final oldController = TextEditingController();
//   final newController = TextEditingController();
//   final otpController = TextEditingController();

//   bool otpSent = false;
//   bool loading = false;

//   // ================= SEND OTP =================

//   void sendOtp() async {
//     if (oldController.text.isEmpty || newController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter mobile numbers")));
//       return;
//     }

//     setState(() => loading = true);

//     final res = await ApiService.sendChangeMobileOtp(
//       oldController.text.trim(),
//       newController.text.trim(),
//     );

//     setState(() => loading = false);

//     if (res["success"]) {
//       setState(() => otpSent = true);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP Sent (Check Terminal)")),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(res["message"] ?? "Failed")));
//     }
//   }

//   // ================= VERIFY OTP =================

//   void verifyOtp() async {
//     if (otpController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter OTP")));
//       return;
//     }

//     setState(() => loading = true);

//     final res = await ApiService.verifyChangeMobile(
//       newController.text.trim(),
//       otpController.text.trim(),
//     );

//     setState(() => loading = false);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(res["message"])));

//     if (res["success"]) {
//       // 🔐 Logout + redirect to login

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Change Mobile Number")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: oldController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "Old Mobile Number",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextField(
//               controller: newController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "New Mobile Number",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             if (!otpSent)
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: loading ? null : sendOtp,
//                   child: loading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Send OTP"),
//                 ),
//               ),

//             if (otpSent) ...[
//               TextField(
//                 controller: otpController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Enter OTP",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: loading ? null : verifyOtp,
//                   child: loading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Verify OTP"),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../services/api_service.dart';
import '../../auth/screens/login_screen.dart';

class ChangeMobileScreen extends StatefulWidget {
  const ChangeMobileScreen({super.key});

  @override
  State<ChangeMobileScreen> createState() => _ChangeMobileScreenState();
}

class _ChangeMobileScreenState extends State<ChangeMobileScreen> {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  /// ================= SEND OTP =================

  void sendOtp() async {
    if (oldController.text.isEmpty || newController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter mobile numbers")));
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.sendChangeMobileOtp(
        oldController.text.trim(),
        newController.text.trim(),
      );

      setState(() => loading = false);

      if (res["success"]) {
        setState(() => otpSent = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent (Check Terminal)")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res["message"] ?? "Failed")));
      }
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// ================= VERIFY OTP =================

  void verifyOtp() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter OTP")));
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.verifyChangeMobile(
        newController.text.trim(),
        otpController.text.trim(),
      );

      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res["message"] ?? "")));

      if (res["success"]) {
        /// ⭐ SAVE NEW MOBILE IN HIVE
        final box = Hive.box('settings');
        box.put("mobile", newController.text.trim());

        /// ⭐ AUTO LOGOUT → LOGIN SCREEN
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Mobile Number")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Old Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: newController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "New Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (!otpSent)
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: loading ? null : sendOtp,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send OTP"),
                ),
              ),

            if (otpSent) ...[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: loading ? null : verifyOtp,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify OTP"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
