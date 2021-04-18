import 'package:flamer/models/task.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Tag {

  IconData _icon = MdiIcons.tag;
  String _name;
  List<Task> _tasks = <Task>[];

  Tag({
    required icon,
    required name,
  }) : _icon = icon, _name = name;
  
  IconData get icon => _icon;
  set icon(IconData newIcon) => _icon = newIcon;

  String get name => _name;
  set name(String value) => _name = value;

  List<Task> get tasks => _tasks;
  set tasks(List<Task> value) => _tasks = value;
}