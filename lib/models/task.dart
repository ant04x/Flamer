import 'package:flamer/models/repetition_type.dart';

class Task {

  String _name;
  bool _done = false;
  DateTime? _date = DateTime.now();
  RepetitionType _repetition = RepetitionType.none;

  Task({
    required name,
    done,
    date,
    repetition
  }) : _name = name, _done = done, _date = date, _repetition = repetition;

  String get name => _name;
  set name(String value) => _name = value;

  bool get done => _done;
  set done(bool value) => _done = value;

  DateTime? get date => _date;
  set date(DateTime? value) => _date = value;

  RepetitionType get repetition => _repetition;
  set repetition(RepetitionType value) => _repetition = value;
}