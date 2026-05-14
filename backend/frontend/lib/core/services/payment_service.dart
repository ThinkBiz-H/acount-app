import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  void init(BuildContext context, {required VoidCallback onSuccess}) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Payment Successful")));
      onSuccess();
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Payment Failed")));
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {});
  }

  void openCheckout(int price) {
    var options = {
      'key': 'rzp_test_lQ0iNCGCnEu0x3', // apni Razorpay key
      'amount': price * 100,
      'name': 'SmartBahi',
      'description': 'Plan Purchase',
      'prefill': {'contact': '9999999999', 'email': 'test@smartbahi.com'},
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
