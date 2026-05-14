import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class AppText {
  static Map<String, Map<String, String>> _data = {
    "en": {
      "settings": "Settings",
      "language": "Language",
      "change_mobile": "Change Mobile Number",
      "backup_photos": "Backup Photos",
      "restore_photos": "Restore Photos",
      "security": "Data Security Checkup",
      "app_lock": "App Lock / PIN",
      "sign_out": "Sign Out",
      "account": "Account",
      "profile": "Profile",
      "help": "Help",
      "stock": "Stock",
      "bills": "Bills",
      "multi_device": "Multi Device",
      "reminder": "Reminder",
      "my_plan": "My Plan",
      "ledger": "Ledger",
    },

    "hi": {
      "settings": "सेटिंग्स",
      "language": "भाषा",
      "change_mobile": "मोबाइल नंबर बदलें",
      "backup_photos": "फोटो बैकअप",
      "restore_photos": "फोटो पुनर्स्थापित करें",
      "security": "डेटा सुरक्षा जांच",
      "app_lock": "ऐप लॉक / पिन",
      "sign_out": "लॉग आउट",
      "account": "खाता",
      "profile": "प्रोफ़ाइल",
      "help": "मदद",
      "stock": "स्टॉक",
      "bills": "बिल्स",
      "multi_device": "मल्टी डिवाइस",
      "reminder": "रिमाइंडर",
      "my_plan": "मेरा प्लान",
      "ledger": "लेजर",
    },
  };

  static String of(BuildContext context, String key) {
    final lang = Provider.of<LanguageProvider>(context).locale.languageCode;
    return _data[lang]?[key] ?? key;
  }
}
