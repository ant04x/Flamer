import 'package:flamer/utils/title_updater/title_updater_impl.dart';
import 'package:flutter/material.dart';

/// Implementación de la clase [TitleUpdater] para Android.
class TitleUpdaterAndroid implements TitleUpdater {

  /// Actualiza el tema HTML visible en la barra de título en base a un
  /// [actualThemeMode] en Android (Vacío).
  void updateTitleBar(ThemeMode actualThemeMode) {
    print('==>> ACCION ANDROID <<==');
  }
}

/// Función para la implementación del Factory de [TitleUpdater].
TitleUpdater getTitleUpdater() => TitleUpdaterAndroid();