// import 'package:url_launcher/url_launcher.dart';

// class SmsService {
//   static Future sendSms({
//     required String phone,
//     required String message,
//   }) async {
//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: phone,
//       queryParameters: {'body': message},
//     );

//     if (await canLaunchUrl(smsUri)) {
//       await launchUrl(smsUri);
//     }
//   }
// }
//
//

import 'package:http/http.dart' as http;

class SmsService {
  static Future<bool> sendSms({
    required String phone,
    required String message,
  }) async {
    try {
      // only numbers
      String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

      // add India code if only 10 digits
      if (cleanPhone.length == 10) {
        cleanPhone = "91$cleanPhone";
      }

      final encodedMessage = Uri.encodeComponent(message);

      final url =
          "https://api.amazesms.com/api/sms"
          "?key=zcUevq9g"
          "&from=ARTHNX"
          "&to=$cleanPhone"
          "&body=$encodedMessage"
          "&templateid=100726095"; // full template id verify kar lena

      print("FINAL URL: $url");

      final response = await http.get(Uri.parse(url));

      print("SMS STATUS: ${response.statusCode}");
      print("SMS RESPONSE: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("SMS ERROR: $e");
      return false;
    }
  }
}
