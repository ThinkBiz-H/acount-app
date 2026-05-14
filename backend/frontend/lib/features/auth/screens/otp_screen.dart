// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../../core/widgets/app_bottom_nav.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/customer_provider.dart';
// import '../../../services/api_service.dart';
// import 'package:uuid/uuid.dart';

// class OTPScreen extends StatefulWidget {
//   final String phone;

//   const OTPScreen({super.key, required this.phone});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final List<TextEditingController> otpControllers = List.generate(
//     6,
//     (index) => TextEditingController(),
//   );
//   final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

//   int _secondsRemaining = 120;
//   Timer? _timer;
//   bool _canResend = false;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _canResend = false;
//     _secondsRemaining = 120;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_secondsRemaining > 0) {
//           _secondsRemaining--;
//         } else {
//           _canResend = true;
//           _timer?.cancel();
//         }
//       });
//     });
//   }

//   String get timerText {
//     int minutes = _secondsRemaining ~/ 60;
//     int seconds = _secondsRemaining % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }

//   /// ✅ VERIFY OTP (MAIN FIX)
//   void verifyOtp() async {
//     String otp = otpControllers.map((c) => c.text).join();

//     if (otp.length == 6) {
//       FocusScope.of(context).unfocus();

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const Center(child: CircularProgressIndicator()),
//       );

//       try {
//         final box = Hive.box('settings');

//         /// ⭐ UNIQUE DEVICE ID (IMPORTANT)
//         String deviceId = box.get("deviceId") ?? const Uuid().v4();
//         await box.put("deviceId", deviceId);

//         /// ⭐ DEVICE NAME
//         String deviceName = "Android Device";

//         /// ⭐ API CALL
//         final res = await ApiService.verifyOtp(
//           widget.phone,
//           otp,
//           deviceName,
//           deviceId,
//         );

//         Navigator.pop(context);

//         if (res["success"] == true) {
//           box.put('mobile', widget.phone);

//           await Provider.of<CustomerProvider>(
//             context,
//             listen: false,
//           ).loadCustomers(widget.phone);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const AppBottomNav()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(res["message"] ?? "OTP failed")),
//           );
//         }
//       } catch (e) {
//         Navigator.pop(context);

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Server error")));
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Enter 6 digit OTP")));
//     }
//   }

//   void _onOtpChanged(int index, String value) {
//     if (value.length == 1 && index < 5) {
//       focusNodes[index + 1].requestFocus();
//     } else if (value.isEmpty && index > 0) {
//       focusNodes[index - 1].requestFocus();
//     }
//   }

//   void _resendOtp() {
//     if (_canResend) {
//       _startTimer();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("OTP resent to +91 ${widget.phone}")),
//       );

//       for (var c in otpControllers) {
//         c.clear();
//       }

//       focusNodes[0].requestFocus();
//     }
//   }

//   Color _getTimerColor() {
//     if (_secondsRemaining > 60) return Colors.green;
//     if (_secondsRemaining > 30) return Colors.orange;
//     return Colors.red;
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var c in otpControllers) {
//       c.dispose();
//     }
//     for (var n in focusNodes) {
//       n.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Verify OTP")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             Text("OTP sent to +91 ${widget.phone}"),

//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(
//                 6,
//                 (index) => SizedBox(
//                   width: 45,
//                   child: TextField(
//                     controller: otpControllers[index],
//                     focusNode: focusNodes[index],
//                     onChanged: (v) => _onOtpChanged(index, v),
//                     textAlign: TextAlign.center,
//                     keyboardType: TextInputType.number,
//                     maxLength: 1,
//                     decoration: const InputDecoration(counterText: ""),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             Text(
//               "Expires in $timerText",
//               style: TextStyle(color: _getTimerColor()),
//             ),

//             const SizedBox(height: 20),

//             TextButton(
//               onPressed: _canResend ? _resendOtp : null,
//               child: const Text("Resend OTP"),
//             ),

//             const Spacer(),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: verifyOtp,
//                 child: const Text("Verify & Continue"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/widgets/app_bottom_nav.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../services/api_service.dart';
import 'package:uuid/uuid.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int _secondsRemaining = 120;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 120;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  String get timerText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  /// VERIFY OTP
  void verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length == 6) {
      FocusScope.of(context).unfocus();

      setState(() {
        _isVerifying = true;
      });

      try {
        final box = Hive.box('settings');

        /// UNIQUE DEVICE ID
        String deviceId = box.get("deviceId") ?? const Uuid().v4();
        await box.put("deviceId", deviceId);

        /// DEVICE NAME (Better detection)
        String deviceName = _getDeviceName();

        /// API CALL
        final res = await ApiService.verifyOtp(
          widget.phone,
          otp,
          deviceName,
          deviceId,
        );

        if (mounted) {
          if (res["success"] == true) {
            await box.put('mobile', widget.phone);

            await Provider.of<CustomerProvider>(
              context,
              listen: false,
            ).loadCustomers(widget.phone);

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AppBottomNav()),
              );
            }
          } else {
            _showSnackBar(
              res["message"] ?? "Invalid OTP. Please try again.",
              isError: true,
            );
            _clearOtpFields();
          }
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar("Server error. Please try again.", isError: true);
          _clearOtpFields();
        }
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    } else {
      _showSnackBar("Please enter the 6-digit OTP", isError: true);
    }
  }

  String _getDeviceName() {
    // You can enhance this with device_info_plus package for better accuracy
    return Theme.of(context).platform == TargetPlatform.iOS
        ? "iOS Device"
        : "Android Device";
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all 6 digits are entered
    if (otpControllers.every((c) => c.text.length == 1) && !_isVerifying) {
      verifyOtp();
    }
  }

  void _resendOtp() async {
    if (_canResend && !_isVerifying) {
      setState(() {
        _isVerifying = true;
      });

      try {
        final res = await ApiService.sendOtp(widget.phone);

        if (mounted) {
          if (res["success"] == true) {
            _startTimer();
            _clearOtpFields();
            _showSnackBar("OTP resent successfully to +91 ${widget.phone}");
          } else {
            _showSnackBar(
              res["message"] ?? "Failed to resend OTP",
              isError: true,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar(
            "Failed to resend OTP. Please try again.",
            isError: true,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    }
  }

  Color _getTimerColor() {
    if (_secondsRemaining > 60) return Colors.green.shade600;
    if (_secondsRemaining > 30) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var n in focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Verify OTP",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Welcome back text
              const Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "We've sent a 6-digit verification code to",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/india_flag.png',
                          width: 20,
                          height: 14,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.flag,
                                size: 16,
                                color: Colors.blue,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "+91 ${widget.phone}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 52,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey.shade50, Colors.grey.shade100],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: otpControllers[index].text.isNotEmpty
                            ? Colors.blue.shade400
                            : Colors.grey.shade300,
                        width: otpControllers[index].text.isNotEmpty ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      onChanged: (v) => _onOtpChanged(index, v),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Timer and Resend
              Center(
                child: Column(
                  children: [
                    if (_secondsRemaining > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getTimerColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: _getTimerColor(),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Code expires in $timerText",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _getTimerColor(),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed: _canResend && !_isVerifying
                              ? _resendOtp
                              : null,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _isVerifying ? "Sending..." : "Resend",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _canResend && !_isVerifying
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.blue.shade200,
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Verify & Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Back to Login option
              Center(
                child: TextButton(
                  onPressed: _isVerifying ? null : () => Navigator.pop(context),
                  child: Text(
                    "Wrong number? Go back",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
