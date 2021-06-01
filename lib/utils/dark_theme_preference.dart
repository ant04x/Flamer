import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modos de temas disponibles.
enum MyThemeMode {
  LIGHT,
  DARK,
  AUTO,
}

/// Proveedor de preferencias seleccionada.
class DarkThemePreference {

  static const THEME_STATUS = "THEMESTATUS";

  /// Establece el modo según el [index]
  setDarkTheme(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(THEME_STATUS, index);
  }

  /// Devuelve el modo del tema seleccionado.
  Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME_STATUS) ?? 0;
  }
}

/// Implementación de la clase abstracta [ChangeNotifier].
class DarkThemeProvider with ChangeNotifier {

  /// Preferencia del modo de temas.
  static DarkThemePreference darkThemePreference = DarkThemePreference();
  /// Indice del modo de temas.
  static int _darkTheme = 0;

  /// Devuelve la preferencia según el índice actual.
  static ThemeMode getCurrent() {
    if (_darkTheme == 0)
      return ThemeMode.system;
    else if (_darkTheme == 1)
      return ThemeMode.light;
    else
      return ThemeMode.dark;
  }

  /// Modo de tema vigente.
  int get darkTheme => _darkTheme;

  /// Establece un nuevo modo de tema vigente.
  set darkTheme(int value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  /// Devuelve el modo de tema según el índice correspondiente de [myThemeMode].
  static ThemeMode themeMode(int myThemeMode) {
    if (myThemeMode == 0)
      return ThemeMode.system;
    else if (myThemeMode == 1)
      return ThemeMode.light;
    else
      return ThemeMode.dark;
  }
}