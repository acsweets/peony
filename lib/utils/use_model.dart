import 'package:flutter/material.dart';

class UseModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool first = true;

  ThemeMode get themeMode => _themeMode;

  void changeTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changeInitState() {
    first = false;
    notifyListeners();
  }
}
