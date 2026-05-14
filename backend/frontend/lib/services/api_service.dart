// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   /// ⭐ SERVER
//   // static const String baseUrl = "http://127.0.0.1:5000/api";
//   // static const String baseUrl = "https://smart-bahi-app.onrender.com/api";
//   static const String baseUrl =
//       "https://captivating-achievement-production-7fbd.up.railway.app/";
//   static const headers = {"Content-Type": "application/json"};

//   /// ================= OTP =================

//   static Future sendOtp(String mobile) async {
//     final res = await http
//         .post(
//           Uri.parse("$baseUrl/auth/send-otp"),
//           headers: headers,
//           body: jsonEncode({"mobile": mobile}),
//         )
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   /// ⭐ VERIFY OTP + SAVE DEVICE

//   static Future verifyOtp(
//     String mobile,
//     String otp,
//     String deviceName,
//     String deviceId,
//   ) async {
//     final res = await http
//         .post(
//           Uri.parse("$baseUrl/auth/verify-otp"),
//           headers: headers,
//           body: jsonEncode({
//             "mobile": mobile,
//             "otp": otp,
//             "deviceName": deviceName,
//             "deviceId": deviceId,
//           }),
//         )
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   /// ================= CUSTOMERS =================

//   static Future getCustomers(String mobile) async {
//     final res = await http
//         .get(Uri.parse("$baseUrl/customers/$mobile"))
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   static Future addCustomer(Map data) async {
//     final res = await http
//         .post(
//           Uri.parse("$baseUrl/customers"),
//           headers: headers,
//           body: jsonEncode(data),
//         )
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   static Future updateCustomer(String id, Map data) async {
//     final res = await http.put(
//       Uri.parse("$baseUrl/customers/$id"),
//       headers: headers,
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   static Future deleteCustomer(String id) async {
//     final res = await http.delete(Uri.parse("$baseUrl/customers/$id"));

//     return jsonDecode(res.body);
//   }

//   /// ================= PROFILE =================

//   static Future getProfile(String mobile) async {
//     final res = await http
//         .get(Uri.parse("$baseUrl/profile/$mobile"))
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   static Future updateProfile(Map data) async {
//     final res = await http
//         .post(
//           Uri.parse("$baseUrl/profile"),
//           headers: headers,
//           body: jsonEncode(data),
//         )
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   /// ================= PRODUCTS =================

//   static Future getProducts(String mobile) async {
//     final res = await http
//         .get(Uri.parse("$baseUrl/products/$mobile"))
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   static Future addProduct(Map data) async {
//     final res = await http
//         .post(
//           Uri.parse("$baseUrl/products"),
//           headers: headers,
//           body: jsonEncode(data),
//         )
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   static Future deleteProduct(String code) async {
//     final res = await http
//         .delete(Uri.parse("$baseUrl/products/$code"))
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   /// ================= TRANSACTIONS =================

//   // static Future addTransaction(Map data) async {
//   //   final res = await http
//   //       .post(
//   //         Uri.parse("$baseUrl/transactions/add"),
//   //         headers: headers,
//   //         body: jsonEncode(data),
//   //       )
//   //       .timeout(const Duration(seconds: 10));

//   //   final body = jsonDecode(res.body);

//   //   if (res.statusCode != 200) {
//   //     throw Exception(body["message"] ?? "Transaction failed");
//   //   }

//   //   return body;
//   // }
//   static Future addTransaction(Map data) async {
//     try {
//       final res = await http
//           .post(
//             Uri.parse("$baseUrl/transactions/add"),
//             headers: headers,
//             body: jsonEncode(data),
//           )
//           .timeout(const Duration(seconds: 10));

//       return jsonDecode(res.body);
//     } catch (e) {
//       return {"success": true};
//     }
//   }

//   static Future getTransactions(String customerId) async {
//     final res = await http
//         .get(Uri.parse("$baseUrl/transactions/$customerId"))
//         .timeout(const Duration(seconds: 10));

//     return jsonDecode(res.body);
//   }

//   /// ================= BILLS =================

//   static Future addBill(Map data) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/bills"),
//       headers: headers,
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   static Future getBills(String mobile) async {
//     final res = await http.get(Uri.parse("$baseUrl/bills/$mobile"));

//     return jsonDecode(res.body);
//   }

//   static Future updateBill(String id, Map data) async {
//     final res = await http.put(
//       Uri.parse("$baseUrl/bills/$id"),
//       headers: headers,
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   static Future deleteBill(String id) async {
//     final res = await http.delete(Uri.parse("$baseUrl/bills/$id"));

//     return jsonDecode(res.body);
//   }

//   /// ================= CHANGE MOBILE =================

//   static Future sendChangeMobileOtp(String oldMobile, String newMobile) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/profile/send-change-mobile-otp"),
//       headers: headers,
//       body: jsonEncode({"oldMobile": oldMobile, "newMobile": newMobile}),
//     );

//     return jsonDecode(res.body);
//   }

//   static Future verifyChangeMobile(String newMobile, String otp) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/profile/verify-change-mobile"),
//       headers: headers,
//       body: jsonEncode({"newMobile": newMobile, "otp": otp}),
//     );

//     return jsonDecode(res.body);
//   }

//   /// ================= DEVICES =================

//   static Future getDevices(String mobile) async {
//     final res = await http.get(Uri.parse("$baseUrl/devices/$mobile"));

//     return jsonDecode(res.body);
//   }

//   static Future logoutDevice(String deviceId) async {
//     final res = await http.post(
//       Uri.parse("$baseUrl/devices/logout"),
//       headers: headers,
//       body: jsonEncode({"deviceId": deviceId}),
//     );

//     return jsonDecode(res.body);
//   }
// }
// bhai yaa se code start hai aaj ka 17/03/2026
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl =
  //     "https://captivating-achievement-production-7fbd.up.railway.app/api";
  static const String baseUrl =
      "https://captivating-achievement-production-bcb2.up.railway.app/api";

  // static const String baseUrl = "http://192.168.1.4:5000/api";
  static const headers = {"Content-Type": "application/json"};

  /// ================= OTP =================

  static Future sendOtp(String mobile) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/send-otp"),
        headers: headers,
        body: jsonEncode({"mobile": mobile}),
      );

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {"success": false, "message": "Server error ${res.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  static Future verifyOtp(
    String mobile,
    String otp,
    String deviceName,
    String deviceId,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: headers,
      body: jsonEncode({
        "mobile": mobile,
        "otp": otp,
        "deviceName": deviceName,
        "deviceId": deviceId,
      }),
    );
    return jsonDecode(res.body);
  }

  /// ================= CUSTOMERS =================

  static Future getCustomers(String mobile) async {
    final res = await http.get(Uri.parse("$baseUrl/customers/$mobile"));
    return jsonDecode(res.body);
  }

  static Future addCustomer(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/customers"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future updateCustomer(String id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/customers/$id"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future deleteCustomer(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/customers/$id"));
    return jsonDecode(res.body);
  }

  /// ================= PROFILE =================

  static Future getProfile(String mobile) async {
    final res = await http.get(Uri.parse("$baseUrl/profile/$mobile"));
    return jsonDecode(res.body);
  }

  static Future updateProfile(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/profile"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  /// ================= PRODUCTS =================

  // static Future getProducts(String mobile) async {
  //   final res = await http.get(Uri.parse("$baseUrl/products/$mobile"));
  //   return jsonDecode(res.body);
  // }
  static Future<List<dynamic>> getProducts(String mobile) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/products/$mobile"));

      if (res.statusCode != 200) {
        print("API ERROR: ${res.statusCode}");
        return [];
      }

      final data = jsonDecode(res.body);

      print("PARSED DATA: $data");

      /// 🔥 CASE 1: direct list
      if (data is List) {
        return data;
      }

      /// 🔥 CASE 2: wrapped response
      if (data is Map && data["success"] == true) {
        return data["data"];
      }

      return [];
    } catch (e) {
      print("API ERROR: $e");
      return [];
    }
  }

  static Future addProduct(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/products"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future deleteProduct(String code) async {
    final res = await http.delete(Uri.parse("$baseUrl/products/$code"));
    return jsonDecode(res.body);
  }

  /// ================= TRANSACTIONS =================

  static Future addTransaction(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/transactions/add"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future getTransactions(String customerId) async {
    final res = await http.get(Uri.parse("$baseUrl/transactions/$customerId"));
    return jsonDecode(res.body);
  }

  /// ================= BILLS =================

  static Future addBill(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/bills"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future getBills(String mobile) async {
    final res = await http.get(Uri.parse("$baseUrl/bills/$mobile"));
    return jsonDecode(res.body);
  }

  static Future updateBill(String id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/bills/$id"),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future deleteBill(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/bills/$id"));
    return jsonDecode(res.body);
  }

  /// ================= CHANGE MOBILE =================

  static Future sendChangeMobileOtp(String oldMobile, String newMobile) async {
    final res = await http.post(
      Uri.parse("$baseUrl/profile/send-change-mobile-otp"),
      headers: headers,
      body: jsonEncode({"oldMobile": oldMobile, "newMobile": newMobile}),
    );
    return jsonDecode(res.body);
  }

  static Future verifyChangeMobile(String newMobile, String otp) async {
    final res = await http.post(
      Uri.parse("$baseUrl/profile/verify-change-mobile"),
      headers: headers,
      body: jsonEncode({"newMobile": newMobile, "otp": otp}),
    );
    return jsonDecode(res.body);
  }

  /// ================= DEVICES =================

  static Future getDevices(String mobile) async {
    final res = await http.get(Uri.parse("$baseUrl/devices/$mobile"));
    return jsonDecode(res.body);
  }

  // static Future logoutDevice(String deviceId) async {
  //   final res = await http.post(
  //     Uri.parse("$baseUrl/devices/logout"),
  //     headers: headers,
  //     body: jsonEncode({"deviceId": deviceId}),
  //   );
  //   return jsonDecode(res.body);
  // }
  static Future logoutDevice(String mobile, String deviceId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/devices/logout"),
      headers: headers,
      body: jsonEncode({"mobile": mobile, "deviceId": deviceId}),
    );

    return jsonDecode(res.body);
  }

  static Future logoutAllDevices(String mobile) async {
    final res = await http.post(
      Uri.parse("$baseUrl/devices/logout-all"),
      headers: headers,
      body: jsonEncode({"mobile": mobile}),
    );

    return jsonDecode(res.body);
  }

  static Future getFilteredTransactions(
    String customerId,
    String start,
    String end,
  ) async {
    final res = await http.get(
      Uri.parse(
        "$baseUrl/api/transactions?startDate=$start&endDate=$end&customerId=$customerId",
      ),
    );

    return jsonDecode(res.body);
  }

  static Future<void> updateProduct(String code, Map data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/products/update/$code"), // ✅ FIX
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to update product");
    }
  }

  static Future<Map<String, dynamic>> activatePlan(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/activate-plan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }
}
