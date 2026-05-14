import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/billing/screens/amount_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String amount = '/amount'; // ⭐ new route

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    amount: (context) => const AmountScreen(), // ⭐ new screen added
  };
}
