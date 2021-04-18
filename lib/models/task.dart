import 'package:flamer/models/repetition_type.dart';
import 'package:flamer/models/tag.dart';

class Task {

  int? _id;
  String? _name;
  bool _done;
  Tag _tag;
  DateTime? _date;
  RepetitionType _repetition;

  Task({
    name,
    done = false,
    tag,
    date,
    repetition = RepetitionType.none
  }) : _name = name, _done = done, _tag = tag, _date = date, _repetition = repetition;

  int? get id => _id;

  String? get name => _name;
  set name(String? value) => _name = value;

  bool get done => _done;
  set done(bool value) => _done = value;

  Tag get tag => _tag;
  set tag(Tag value) => _tag = value;

  DateTime? get date => _date;
  set date(DateTime? value) => _date = value;

  RepetitionType get repetition => _repetition;
  set repetition(RepetitionType value) => _repetition = value;
}