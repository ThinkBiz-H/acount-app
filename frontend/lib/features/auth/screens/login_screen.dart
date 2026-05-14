import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'otp_screen.dart';
import '../../../services/sms_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // Future<void> sendOtp() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() {
  //       loading = true;
  //     });

  //     try {
  //       print("🔥 BUTTON CLICKED");

  //       final res = await ApiService.sendOtp(phoneController.text);

  //       print("🔥 API RESPONSE: $res");

  //       if (res["success"] == true) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => OTPScreen(phone: phoneController.text),
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(res["message"] ?? "OTP failed")),
  //         );
  //       }
  //     } catch (e) {
  //       print("❌ ERROR: $e");

  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("Server error")));
  //     }

  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
  Future<void> sendOtp() async {
    // prevent multiple clicks
    if (loading) return;

    // validate mobile
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      print("🔥 BUTTON CLICKED");

      final res = await ApiService.sendOtp(phoneController.text.trim());

      print("🔥 API RESPONSE: $res");

      if (!mounted) return;

      if (res["success"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(phone: phoneController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res["message"] ?? "OTP failed")));
      }
    } catch (e) {
      print("❌ ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Server error")));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Please enter your mobile number to continue",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 40),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "9876543210",
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/india_flag.png',
                              width: 24,
                              height: 16,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 24,
                                    height: 16,
                                    color: Colors.blue,
                                    child: const Icon(
                                      Icons.flag,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "+91",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blue.shade400,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.red.shade400),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter mobile number";
                      } else if (value.length != 10) {
                        return "Please enter valid 10-digit mobile number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: loading ? null : sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Send OTP",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
