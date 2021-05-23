// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flamer/utils/dark_theme_preference.dart';
import 'package:flamer/utils/title_updater_impl.dart';
import 'package:flutter/material.dart';

class TitleUpdaterWeb implements TitleUpdater {

  void updateTitleBar(ThemeMode actualThemeMode) {
    // Actualizar según el tema de la aplicación
    var element = document.querySelector('meta[name="theme-color"]');
    if (actualThemeMode == ThemeMode.dark)
      element?.setAttribute('content', '#191919');
    else if (actualThemeMode == ThemeMode.light)
      element?.setAttribute('content', '#890E4F');
    else {
      // Si está seleccionada la configuracion del sistema
      if (window.matchMedia('(prefers-color-scheme: dark)').matches)
        element?.setAttribute('content', '#191919');
      else
        element?.setAttribute('content', '#890E4F');
    }

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (event) {
      actualThemeMode = DarkThemeProvider.getCurrent(); // Refrescar tema actual.

      if (actualThemeMode == ThemeMode.system) {
        if (window.matchMedia('(prefers-color-scheme: dark)').matches)
          element?.setAttribute('content', '#191919');
        else
          element?.setAttribute('content', '#890E4F');
      }
    });
  }
}

TitleUpdater getTitleUpdater() => TitleUpdaterWeb();