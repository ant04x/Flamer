import 'package:flamer/utils/title_updater/title_updater_impl.dart';
import 'package:flutter/material.dart';

class TitleUpdaterAndroid implements TitleUpdater {

  void updateTitleBar(ThemeMode actualThemeMode) {
    print('==>> ACCION ANDROID <<==');
  }
}

TitleUpdater getTitleUpdater() => TitleUpdaterAndroid();