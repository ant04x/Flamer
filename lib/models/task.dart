import 'package:flamer/models/repetition_type.dart';
import 'package:flamer/models/tag.dart';

/// Representación de tareas para guardar en Firebase, conteniendo un [name], si
/// esta [done], el [tag] al que puede pertenecer, la [date] y el tipo de
/// [repetition].
class Task {

  /// Número de identificación de la tarea.
  int? _id;
  /// Nombre o título de la tarea.
  String? _name;
  /// Si la tarea está completa o no.
  bool _done;
  /// Devuelve el [Tag] en el que la tarea está agrupada.
  Tag _tag;
  /// Fecha en la que se recordaría la tarea.
  DateTime? _date;
  /// Tipo de repetición para una tarea con fecha de cumplimiento.
  RepetitionType _repetition;

  /// Crea una [Task] con un [name], si está [done], el [tag] al que pertenece,
  /// [date] previsto para su cumplimiento, y tipo de [repetition].
  Task({
    name,
    done = false,
    tag,
    date,
    repetition = RepetitionType.none
  }) : _name = name, _done = done, _tag = tag, _date = date, _repetition = repetition;

  /// Obtiene el número identificador de Firebase de la tarea.
  int? get id => _id;

  /// Obtiene el nombre de la tarea.
  String? get name => _name;
  /// Establece el valor a el [nombre] de la tarea.
  set name(String? value) => _name = value;

  /// Obtiene si la tarea está [done] o no.
  bool get done => _done;
  /// Establece si la tarea está [done] o no.
  set done(bool value) => _done = value;

  /// Obtiene la [tag] en la que está agrupada la tarea.
  Tag get tag => _tag;
  /// Establece el valor de la [tag] en la que está agrupada la tarea.
  set tag(Tag value) => _tag = value;

  /// Obtiene la [date] en la que la tarea debe recordarse.
  DateTime? get date => _date;
  /// Establece el valor de la [date] en la que la tarea debe recordarse.
  set date(DateTime? value) => _date = value;

  /// Obtiene la [repetition] del recordatorio de calendario.
  RepetitionType get repetition => _repetition;
  /// Establece el valor de la [repetition] del recordatorio de calendario.
  set repetition(RepetitionType value) => _repetition = value;
}