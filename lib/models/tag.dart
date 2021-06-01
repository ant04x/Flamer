import 'package:flamer/models/task.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Representación de etiquetas para agrupar [Task]s, conteniendo un [icon] y un
/// [name] correspondiente para ser mostrados y guardados en Firebase.
class Tag {

  /// Icono de la etiqueta.
  IconData _icon = MdiIcons.tag;
  /// Nombre identificativo de la etiqueta.
  String _name;
  /// Lista de [Task]s agrupadas en la etiqueta.
  List<Task> _tasks = <Task>[];

  /// Crea un [Tag] con un [icon] y un [name] para mostrarse en la interfaz.
  Tag({
    required icon,
    required name,
  }) : _icon = icon, _name = name;

  /// Obtiene el valor de [icon] del [Tag].
  IconData get icon => _icon;
  /// Establece el valor de [icon] del [Tag].
  set icon(IconData newIcon) => _icon = newIcon;

  /// Obtiene el valor de [name] del [Tag].
  String get name => _name;
  /// Establece el valor de [name] del [Tag].
  set name(String value) => _name = value;

  /// Obtiene el valor de [tasks] del [Tag].
  List<Task> get tasks => _tasks;
  /// Establece el valor de [tasks] del [Tag].
  set tasks(List<Task> value) => _tasks = value;
}