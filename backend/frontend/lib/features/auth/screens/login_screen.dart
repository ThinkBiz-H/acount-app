// import 'package:flutter/material.dart';
// import '../../../core/widgets/app_bottom_nav.dart';
// import 'otp_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   void sendOtp() {
//     if (_formKey.currentState?.validate() ?? false) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OTPScreen(phone: phoneController.text),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 60),

//                   // App Logo or Icon
//                   Center(
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.blue.shade400,
//                             Colors.purple.shade400,
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: const Icon(
//                         Icons.chat_bubble_outline,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Welcome Text
//                   const Text(
//                     "Welcome Back!",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: -0.5,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     "Please enter your mobile number to continue",
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   ),

//                   const SizedBox(height: 40),

//                   // Phone Number Field
//                   TextFormField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.phone,
//                     maxLength: 10,
//                     decoration: InputDecoration(
//                       labelText: "Mobile Number",
//                       hintText: "9876543210",
//                       prefixIcon: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 16,
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.asset(
//                               'assets/images/india_flag.png',
//                               width: 24,
//                               height: 16,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                     width: 24,
//                                     height: 16,
//                                     color: Colors.blue,
//                                     child: const Icon(
//                                       Icons.flag,
//                                       size: 12,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               "+91",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Container(
//                               height: 24,
//                               width: 1,
//                               color: Colors.grey.shade300,
//                             ),
//                           ],
//                         ),
//                       ),
//                       prefixIconConstraints: const BoxConstraints(minWidth: 0),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(
//                           color: Colors.blue.shade400,
//                           width: 2,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(color: Colors.red.shade400),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade50,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     style: const TextStyle(fontSize: 16),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter mobile number";
//                       } else if (value.length != 10) {
//                         return "Please enter valid 10-digit mobile number";
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 24),

//                   // Send OTP Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: sendOtp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade400,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: const Text(
//                         "Send OTP",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Terms and Conditions
//                   Center(
//                     child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                         children: [
//                           const TextSpan(
//                             text: "By continuing, you agree to our ",
//                           ),
//                           TextSpan(
//                             text: "Terms of Service",
//                             style: TextStyle(
//                               color: Colors.blue.shade400,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const TextSpan(text: " and "),
//                           TextSpan(
//                             text: "Privacy Policy",
//                             style: TextStyle(
//                               color: Colors.blue.shade400,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Alternative Login Options
//                   Row(
//                     children: [
//                       Expanded(child: Divider(color: Colors.grey.shade300)),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           "OR",
//                           style: TextStyle(
//                             color: Colors.grey.shade500,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       Expanded(child: Divider(color: Colors.grey.shade300)),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Social Login Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildSocialButton(
//                         icon: Icons.g_mobiledata,
//                         color: Colors.red.shade400,
//                         onTap: () {
//                           // Handle Google Sign In
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Google Sign In coming soon!"),
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(width: 20),
//                       _buildSocialButton(
//                         icon: Icons.facebook,
//                         color: Colors.blue.shade800,
//                         onTap: () {
//                           // Handle Facebook Sign In
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Facebook Sign In coming soon!"),
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(width: 20),
//                       _buildSocialButton(
//                         icon: Icons.apple,
//                         color: Colors.black,
//                         onTap: () {
//                           // Handle Apple Sign In
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Apple Sign In coming soon!"),
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey.shade300),
//           color: Colors.white,
//         ),
//         child: Icon(icon, color: color, size: 30),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

 
  Future<void> sendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      try {
        print("🔥 BUTTON CLICKED");

        final res = await ApiService.sendOtp(phoneController.text);

        print("🔥 API RESPONSE: $res");

        if (res["success"] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(phone: phoneController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res["message"] ?? "OTP failed")),
          );
        }
      } catch (e) {
        print("❌ ERROR: $e");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Server error")));
      }

      setState(() {
        loading = false;
      });
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
