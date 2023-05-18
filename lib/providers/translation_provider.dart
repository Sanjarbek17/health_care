import 'package:flutter/material.dart';

class Translate with ChangeNotifier {
  bool isRussian = true;

  toggleLanguage() {
    isRussian = !isRussian;
    notifyListeners();
  }
}
