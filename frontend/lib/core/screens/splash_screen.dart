

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../core/widgets/app_bottom_nav.dart'; // 👈 Dashboard

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final box = Hive.box('settings');

    bool isLoggedIn = box.get("isLoggedIn", defaultValue: false);

    if (isLoggedIn) {
      // ✅ Direct Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppBottomNav()),
      );
    } else {
      // ❌ Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/main-screen1.png",
          width: 720,
          // 👈 UI better (optional)
        ),
      ),
    );
  }
}
