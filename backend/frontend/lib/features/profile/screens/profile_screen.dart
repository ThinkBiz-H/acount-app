// import 'package:flutter/material.dart';
// import 'edit_field_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/customer_provider.dart';
// import 'dart:convert';
// import 'package:frontend/services/api_service.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final settingsBox = Hive.box('settings');
//   File? logoFile;

//   String businessName = 'My Business';
//   String mobile = '+91 98765 43210';
//   String gst = 'Not Added';
//   String businessType = 'Retail';
//   String category = 'General Store';
//   String address = 'Add address';
//   String email = 'Add email';
//   String about = 'Add details';
//   String contactPerson = 'Owner';

//   /// MOBILE CLEAN
//   String cleanMobileNumber(String mobile) {
//     final digits = mobile.replaceAll(RegExp(r'\D'), '');
//     return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
//   }

//   /// SHARE CARD
//   void shareBusinessCard() {
//     final message =
//         '''
// 🏪 *$businessName*

// 👤 Contact: $contactPerson
// 📞 Phone: $mobile
// 📍 Address: $address
// 📧 Email: $email

// Manage your credit easily with SmartBahi App:
// https://play.google.com/store/apps/details?id=com.smartbahi.app
// ''';

//     Share.share(message);
//   }

//   /// LOAD PROFILE
//   Future<void> loadProfile() async {
//     try {
//       final cleanMobile = cleanMobileNumber(mobile);

//       final res = await ApiService.getProfile(cleanMobile);

//       if (res == null || res["data"] == null) return;

//       final data = res["data"];

//       setState(() {
//         businessName = data["businessName"]?.toString() ?? businessName;
//         gst = data["gst"]?.toString() ?? gst;
//         businessType = data["businessType"]?.toString() ?? businessType;
//         category = data["category"]?.toString() ?? category;
//         address = data["address"]?.toString() ?? address;
//         email = data["email"]?.toString() ?? email;
//         about = data["about"]?.toString() ?? about;
//         contactPerson = data["contactPerson"]?.toString() ?? contactPerson;
//       });
//     } catch (e) {
//       debugPrint("Profile load error: $e");
//     }
//   }

//   /// SAVE PROFILE
//   Future<void> saveProfile() async {
//     try {
//       final cleanMobile = cleanMobileNumber(mobile);

//       await ApiService.updateProfile({
//         "mobile": cleanMobile,
//         "businessName": businessName,
//         "gst": gst,
//         "businessType": businessType,
//         "category": category,
//         "address": address,
//         "email": email,
//         "about": about,
//         "contactPerson": contactPerson,
//       });
//     } catch (e) {
//       debugPrint("Profile save error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     businessName = settingsBox.get('businessName', defaultValue: businessName);
//     mobile = settingsBox.get('mobile', defaultValue: mobile);
//     gst = settingsBox.get('gst', defaultValue: gst);
//     businessType = settingsBox.get('businessType', defaultValue: businessType);
//     category = settingsBox.get('category', defaultValue: category);
//     address = settingsBox.get('address', defaultValue: address);
//     email = settingsBox.get('email', defaultValue: email);
//     about = settingsBox.get('about', defaultValue: about);
//     contactPerson = settingsBox.get(
//       'contactPerson',
//       defaultValue: contactPerson,
//     );

//     final path = settingsBox.get('logo');
//     if (path != null && !kIsWeb) {
//       logoFile = File(path);
//     }

//     Future.microtask(() => loadProfile());
//   }

//   Future<void> pickLogo() async {
//     final picker = ImagePicker();

//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 60,
//     );

//     if (image == null) return;

//     settingsBox.put('logo', image.path);

//     String? base64Image;

//     if (kIsWeb) {
//       final bytes = await image.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() {});
//     } else {
//       final file = File(image.path);
//       final bytes = await file.readAsBytes();
//       base64Image = base64Encode(bytes);
//       setState(() => logoFile = file);
//     }

//     final provider = context.read<CustomerProvider>();

//     provider.updateBusinessProfile(
//       name: businessName,
//       phone: mobile,
//       base64Image: base64Image,
//     );
//   }

//   Future<void> _editField(
//     String key,
//     String title,
//     String currentValue,
//     Function(String) onSave,
//   ) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>
//             EditFieldScreen(title: title, initialValue: currentValue),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         onSave(result);
//         settingsBox.put(key, result);
//       });

//       final provider = context.read<CustomerProvider>();

//       provider.updateBusinessProfile(name: businessName, phone: mobile);

//       await saveProfile();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final logoPath = settingsBox.get('logo');

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Center(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: pickLogo,
//                   child: CircleAvatar(
//                     radius: 44,
//                     backgroundColor: Colors.green.shade100,
//                     backgroundImage: logoFile != null
//                         ? FileImage(logoFile!)
//                         : (logoPath != null && kIsWeb)
//                         ? NetworkImage(logoPath)
//                         : null,
//                     child: logoFile == null && logoPath == null
//                         ? const Icon(Icons.store, size: 40, color: Colors.green)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   businessName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(mobile, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: shareBusinessCard,
//                   icon: const Icon(Icons.share),
//                   label: const Text("Share Business Card"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C2752),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           const _SectionTitle('Business Information'),

//           _tile(
//             Icons.store,
//             'Business Name',
//             businessName,
//             () => _editField(
//               'businessName',
//               'Business Name',
//               businessName,
//               (v) => businessName = v,
//             ),
//           ),

//           _tile(
//             Icons.phone,
//             'Mobile Number',
//             mobile,
//             () => _editField(
//               'mobile',
//               'Mobile Number',
//               mobile,
//               (v) => mobile = v,
//             ),
//           ),

//           _tile(
//             Icons.receipt,
//             'GST Number',
//             gst,
//             () => _editField('gst', 'GST Number', gst, (v) => gst = v),
//           ),

//           _tile(
//             Icons.business,
//             'Business Type',
//             businessType,
//             () => _editField(
//               'businessType',
//               'Business Type',
//               businessType,
//               (v) => businessType = v,
//             ),
//           ),

//           _tile(
//             Icons.category,
//             'Category',
//             category,
//             () => _editField(
//               'category',
//               'Category',
//               category,
//               (v) => category = v,
//             ),
//           ),

//           _tile(
//             Icons.location_on,
//             'Address',
//             address,
//             () => _editField('address', 'Address', address, (v) => address = v),
//           ),

//           const _SectionTitle('Other Information'),

//           _tile(
//             Icons.email,
//             'Email',
//             email,
//             () => _editField('email', 'Email', email, (v) => email = v),
//           ),

//           _tile(
//             Icons.info,
//             'About Business',
//             about,
//             () =>
//                 _editField('about', 'About Business', about, (v) => about = v),
//           ),

//           _tile(
//             Icons.person,
//             'Contact Person',
//             contactPerson,
//             () => _editField(
//               'contactPerson',
//               'Contact Person',
//               contactPerson,
//               (v) => contactPerson = v,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tile(IconData icon, String title, String value, VoidCallback onTap) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.green),
//         title: Text(title),
//         subtitle: Text(value),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 12),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'edit_field_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'dart:convert';
import 'package:frontend/services/api_service.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  // final ScreenshotController screenshotController = ScreenshotController();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final settingsBox = Hive.box('settings');
  File? logoFile;

  String businessName = 'My Business';
  String mobile = '+91 98765 43210';
  String gst = 'Not Added';
  String businessType = 'Retail';
  String category = 'General Store';
  String address = 'Add address';
  String email = 'Add email';
  String about = 'Add details';
  String contactPerson = 'Owner';

  /// MOBILE CLEAN
  String cleanMobileNumber(String mobile) {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }

  Future<void> shareBusinessCard() async {
    try {
      final controller = ScreenshotController();

      final image = await controller.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(
                          Icons.store,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        businessName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "📞 $mobile",
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        "📍 $address",
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        "📧 $email",
                        style: const TextStyle(color: Colors.black),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "SmartBahi",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/business_card.png');

      await file.writeAsBytes(image);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  /// LOAD PROFILE
  Future<void> loadProfile() async {
    try {
      final cleanMobile = cleanMobileNumber(mobile);

      final res = await ApiService.getProfile(cleanMobile);

      if (res == null || res["data"] == null) return;

      final data = res["data"];

      setState(() {
        businessName = data["businessName"]?.toString() ?? businessName;
        gst = data["gst"]?.toString() ?? gst;
        businessType = data["businessType"]?.toString() ?? businessType;
        category = data["category"]?.toString() ?? category;
        address = data["address"]?.toString() ?? address;
        email = data["email"]?.toString() ?? email;
        about = data["about"]?.toString() ?? about;
        contactPerson = data["contactPerson"]?.toString() ?? contactPerson;
      });
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }

  /// SAVE PROFILE
  Future<void> saveProfile() async {
    try {
      final cleanMobile = cleanMobileNumber(mobile);

      await ApiService.updateProfile({
        "mobile": cleanMobile,
        "businessName": businessName,
        "gst": gst,
        "businessType": businessType,
        "category": category,
        "address": address,
        "email": email,
        "about": about,
        "contactPerson": contactPerson,
      });
    } catch (e) {
      debugPrint("Profile save error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    businessName = settingsBox.get('businessName', defaultValue: businessName);
    mobile = settingsBox.get('mobile', defaultValue: mobile);
    gst = settingsBox.get('gst', defaultValue: gst);
    businessType = settingsBox.get('businessType', defaultValue: businessType);
    category = settingsBox.get('category', defaultValue: category);
    address = settingsBox.get('address', defaultValue: address);
    email = settingsBox.get('email', defaultValue: email);
    about = settingsBox.get('about', defaultValue: about);
    contactPerson = settingsBox.get(
      'contactPerson',
      defaultValue: contactPerson,
    );

    final path = settingsBox.get('logo');
    if (path != null && !kIsWeb) {
      logoFile = File(path);
    }

    Future.microtask(() => loadProfile());
  }

  Future<void> pickLogo() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (image == null) return;

    settingsBox.put('logo', image.path);

    String? base64Image;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      base64Image = base64Encode(bytes);
      setState(() {});
    } else {
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      base64Image = base64Encode(bytes);
      setState(() => logoFile = file);
    }

    final provider = context.read<CustomerProvider>();

    provider.updateBusinessProfile(
      name: businessName,
      phone: mobile,
      base64Image: base64Image,
    );
  }

  Future<void> _editField(
    String key,
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditFieldScreen(title: title, initialValue: currentValue),
      ),
    );

    if (result != null) {
      setState(() {
        onSave(result);
        settingsBox.put(key, result);
      });

      final provider = context.read<CustomerProvider>();

      provider.updateBusinessProfile(name: businessName, phone: mobile);

      await saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoPath = settingsBox.get('logo');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickLogo,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.green.shade100,
                      backgroundImage: logoFile != null
                          ? FileImage(logoFile!)
                          : (logoPath != null && kIsWeb)
                          ? NetworkImage(logoPath)
                          : null,
                      child: logoFile == null && logoPath == null
                          ? const Icon(
                              Icons.store,
                              size: 40,
                              color: Colors.green,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    businessName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(mobile, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: shareBusinessCard,
                    icon: const Icon(Icons.share),
                    label: const Text("Share Business Card"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C2752),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('Business Information'),

          _tile(
            Icons.store,
            'Business Name',
            businessName,
            () => _editField(
              'businessName',
              'Business Name',
              businessName,
              (v) => businessName = v,
            ),
          ),

          _tile(
            Icons.phone,
            'Mobile Number',
            mobile,
            () => _editField(
              'mobile',
              'Mobile Number',
              mobile,
              (v) => mobile = v,
            ),
          ),

          _tile(
            Icons.receipt,
            'GST Number',
            gst,
            () => _editField('gst', 'GST Number', gst, (v) => gst = v),
          ),

          _tile(
            Icons.business,
            'Business Type',
            businessType,
            () => _editField(
              'businessType',
              'Business Type',
              businessType,
              (v) => businessType = v,
            ),
          ),

          _tile(
            Icons.category,
            'Category',
            category,
            () => _editField(
              'category',
              'Category',
              category,
              (v) => category = v,
            ),
          ),

          _tile(
            Icons.location_on,
            'Address',
            address,
            () => _editField('address', 'Address', address, (v) => address = v),
          ),

          const _SectionTitle('Other Information'),

          _tile(
            Icons.email,
            'Email',
            email,
            () => _editField('email', 'Email', email, (v) => email = v),
          ),

          _tile(
            Icons.info,
            'About Business',
            about,
            () =>
                _editField('about', 'About Business', about, (v) => about = v),
          ),

          _tile(
            Icons.person,
            'Contact Person',
            contactPerson,
            () => _editField(
              'contactPerson',
              'Contact Person',
              contactPerson,
              (v) => contactPerson = v,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
