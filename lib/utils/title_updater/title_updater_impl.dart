import 'title_updater_stub.dart'
  if (dart.library.io) 'title_updater_android.dart'
  if (dart.library.html) 'title_updater_web.dart';
import 'package:flutter/material.dart';

/// Clase abstracta para actualizar el color del tema HTML en web.
abstract class TitleUpdater {

  /// Registro de la función constructora sobre la plataforma.
  factory TitleUpdater() => getTitleUpdater();

  /// Actualiza el tema HTML visible en la barra de título en base a un
  /// [actualThemeMode] en Web.
  void updateTitleBar(ThemeMode actualThemeMode) {}
}