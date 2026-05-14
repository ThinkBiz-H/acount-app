// // import 'package:telephony/telephony.dart';\
// import 'package:telephony_fix/telephony.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SmsService {
//   static final Telephony telephony = Telephony.instance;

//   /// Permission request
//   static Future<bool> requestPermission() async {
//     PermissionStatus status = await Permission.sms.request();
//     return status == PermissionStatus.granted;
//   }

//   /// SEND SMS FUNCTION
//   static Future<void> sendTransactionSMS({
//     required String phone,
//     required String name,
//     required double amount,
//     required double balance,
//     required bool isGiven,
//   }) async {
//     bool granted = await requestPermission();
//     if (!granted) return;

//     String message;

//     if (isGiven) {
//       message =
//           "Dear $name, ₹$amount udhaar diya gaya.\nCurrent balance: ₹$balance\n- SmartBahi";
//     } else {
//       message =
//           "Dear $name, ₹$amount receive hua.\nCurrent balance: ₹$balance\n- SmartBahi";
//     }

//     await telephony.sendSms(to: phone, message: message);
//   }
// }




import 'package:url_launcher/url_launcher.dart';

class SmsService {
  static Future sendSms({
    required String phone,
    required String message,
  }) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }
}
