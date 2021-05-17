import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MyThemeMode {
  LIGHT,
  DARK,
  AUTO,
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(THEME_STATUS, value);
  }

  Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME_STATUS) ?? 0;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  int _darkTheme = 0;

  int get darkTheme => _darkTheme;

  set darkTheme(int value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  static ThemeMode themeMode(int myThemeMode) {
    if (myThemeMode == 0)
      return ThemeMode.system;
    else if (myThemeMode == 1)
      return ThemeMode.light;
    else
      return ThemeMode.dark;
  }
}