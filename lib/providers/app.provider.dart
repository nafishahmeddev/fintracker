import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _theme = "system";

  String get theme => _theme;

  set theme(String value) {
    _theme = value;
    notifyListeners();
  }

  ThemeMode getTheme() {
    switch (_theme) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}