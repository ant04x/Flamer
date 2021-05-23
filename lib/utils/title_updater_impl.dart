import 'title_updater_stub.dart'
  if (dart.library.io) 'title_updater.dart'
  if (dart.library.html) 'title_updater_web.dart';

import 'package:flutter/material.dart';

abstract class TitleUpdater {

  factory TitleUpdater() => getTitleUpdater();

  void updateTitleBar(ThemeMode actualThemeMode) {}
}