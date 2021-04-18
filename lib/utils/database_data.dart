import 'package:flamer/models/tag.dart';

class DatabaseData {

  static List<Tag> _tags = <Tag>[];

  static List<Tag> get tags => _tags;
  static set tags(List<Tag> value) => _tags = value;
}