import 'package:flutter/material.dart';

/// ⭐ GLOBAL TEMPLATE ENUM (पूरे app में यही रहेगा)
enum BillTemplate { normal, prime }

class BillTemplateProvider extends ChangeNotifier {
  BillTemplate _selectedTemplate = BillTemplate.normal;

  BillTemplate get selectedTemplate => _selectedTemplate;

  void setTemplate(BillTemplate template) {
    _selectedTemplate = template;
    notifyListeners();
  }
}
