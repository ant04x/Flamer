import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

/// Pantalla de edición de [Task]s.
class TaskScreen extends StatefulWidget {
  
  TaskScreen({Key? key, required User user, DocumentSnapshot? doc, DocumentReference? tag}) : _user = user, _doc = doc, _tag = tag, super(key: key);

  final User _user;
  final DocumentSnapshot? _doc;
  final DocumentReference? _tag;

  /// Crea el estado del widget.
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

/// Estado de [TaskScreen].
class _TaskScreenState extends State<TaskScreen> {

  /// Si la tarea esta hecha.
  late bool done;
  /// Nombre de la etiqueta.
  String tagName = 'Todo';
  /// Referencia de la etiqueta a la que pertenece.
  DocumentReference? tag;
  /// Instantanea de la etiqueta a la que pertenece.
  DocumentSnapshot? tagSnapshot;
  /// Tipo de repetición.
  String repetitionTask = RepetitionTypeMapper.none;
  /// Fecha para el recordatorio.
  DateTime? remind;

  /// Referencia a la coleccion de tareas.
  late CollectionReference tasks;
  /// Referencia a la colección de etiquetas.
  late CollectionReference tags;
  /// Controlador del campo de texto de nombre.
  late final nameController;

  /// Inicializa los valores del estado de [TaskScreen].
  @override
  void initState() {
    tasks = FirebaseFirestore.instance.collection('tasks/').doc('${widget._user.uid}').collection('tasks/');
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');
    
    /// Dependiendo si es una edición o una creación.
    if (widget._doc == null) {
      done = false;
      nameController = TextEditingController();
      tag = widget._tag;
      if (tag != null) {
        getDocumentFromReference(tag!).then((value) {
          setState(() {
            tagSnapshot = value;
          });
        });
      }
    } else {
      done = widget._doc!['done'];
      nameController = TextEditingController(text: widget._doc!['name']);
      tag = widget._doc!['tag'];
      if (tag != null) {
        getDocumentFromReference(tag!).then((value) {
          setState(() {
            tagSnapshot = value;
          });
        });
      }
      if (widget._doc!['repetition'] != null) repetitionTask = widget._doc!['repetition'];
      remind = widget._doc!['date'] != null ? DateTime.fromMicrosecondsSinceEpoch(widget._doc!['date'].microsecondsSinceEpoch) : null;
    }
    super.initState();
  }

  /// Construye el widget [TaskScreen] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Nombre de la Tarea',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Checkbox(
                    onChanged: (bool? value) {
                      /// Actualizar el valor de si esta hecho.
                      setState(() {
                        done = value == null ? false : value;
                      });
                    },
                    value: done,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          StreamBuilder<QuerySnapshot>(
            stream: tags.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return PopupMenuButton<DocumentSnapshot>(
                itemBuilder: (context) {
                  /// Generar desplegable en base a las etiquetas existentes.
                  return snapshot.data!.docs.map((item) => PopupMenuItem(
                    value: item,
                    child: ListTile(
                      leading: Icon(MdiIcons.fromString(item['icon'])),
                      title: Text(item['name']),
                    ),
                  )).toList();
                },
                child: ListTile(
                  title: Text('Etiqueta'),
                  subtitle: tagSnapshot != null
                      ? Text(tagSnapshot!['name'])
                      : null,
                  leading: Icon(MdiIcons.tag),
                  trailing: tagSnapshot != null
                      ? IconButton(
                    onPressed: () {
                      /// Limpiar la selección.
                      setState(() => tagSnapshot = null);
                    },
                    icon: Icon(Icons.close),
                  )
                      : null,
                ),
                onSelected: (value) {
                  setState(() {
                    /// Establecer nuevo valor para la etiqueta.
                    tagSnapshot = value;
                  });
                },
              );
            },
          ),
          Divider(),
          PopupMenuButton<String>(
            child: ListTile(
              title: Text('Repetir'),
              subtitle: repetitionTask != RepetitionTypeMapper.none ? Text(RepetitionTypeMapper.visualList[repetitionTask]!) : null,
              leading: Icon(Icons.repeat),
              trailing: repetitionTask != RepetitionTypeMapper.none
                  ? IconButton(
                onPressed: () {
                  /// Establecer nuevo valor para la etiqueta.
                  setState(() => repetitionTask = RepetitionTypeMapper.none);
                },
                icon: Icon(Icons.close),
              )
                  : null,
            ),
            itemBuilder: (context) {
              return RepetitionTypeMapper.visualList.keys.map((type) => PopupMenuItem<String>(
                  value: type,
                  child: Text('${RepetitionTypeMapper.visualList[type]}')
              )).toList();
            },
            onSelected: (value) {
              /// Actualizar el valor de repetición y configurar tarea.
              setState(() {
                repetitionTask = value;
                if (remind == null)
                  remind = DateTime.now().add(Duration(days: 1));
              });
            },
          ),
          Divider(),
          ListTile(
            title: Text('Aviso'),
            subtitle: remind != null
                ? Text(remind.toString())
                : null,
            trailing: remind != null
                ? IconButton(
              onPressed: () {
                /// Actualizar el valor de aviso y configurar tarea.
                setState(() {
                  remind = null;
                  repetitionTask = RepetitionTypeMapper.none;
                });
              },
              icon: Icon(Icons.close),
            )
                : null,
            leading: Icon(Icons.calendar_today),
            onTap: () async {

              DateTime? dateBase = await showDatePicker(
                context: context,
                initialDate: remind == null ? DateTime.now().add(Duration(days: 1)) : remind!,
                firstDate: DateTime.now(),
                lastDate: DateTime(2040, 12),
                helpText: 'Día del aviso',
              );
              if (dateBase == null) return;

              TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: remind == null ? TimeOfDay(hour: 7, minute: 0) : TimeOfDay(hour: remind!.hour, minute: remind!.minute),
                  helpText: 'Hora del aviso'
              );
              if (time == null) return;

              setState(() {
                remind = DateTime(
                    dateBase.year,
                    dateBase.month,
                    dateBase.day,
                    time.hour,
                    time.minute
                );
              });
            },
          ),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /// Al presionar guardar valores en la tarea.
          if (nameController.text != '') {
            Navigator.pop(context);
            if (widget._doc == null) {
              addTask(
                nameController.text,
                done,
                remind == null
                    ? null
                    : Timestamp.fromDate(remind!),
                repetitionTask,
                tagSnapshot,
                remind == null
                    ? false
                    : true,
                Timestamp.now()
              );
            } else {
              updateTask(
                nameController.text,
                done,
                remind == null
                    ? null
                    : Timestamp.fromDate(remind!),
                repetitionTask,
                tagSnapshot,
              );
            }
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('GUARDAR'),
      ),
    );
  }

  /// Añade una tarea con su [name] o título, si se está [done],
  /// la [date] de completado, tipo de [repetition], el [tag] al que pertenece,
  /// si está [scheduled] y la fecha cuando fueron [created]. 
  Future<void> addTask(String name, bool done, Timestamp? date, String repetition, DocumentSnapshot? tag, bool scheduled, Timestamp? created) {
    return tasks.add({
      'name': name,
      'done': done,
      'date': date,
      'repetition': repetitionTask,
      'tag': tag?.reference,
      'scheduled': scheduled,
      'created': created
    });
  }

  /// Obtiene el documento de la [ref] de forma asíncrona.
  Future<DocumentSnapshot> getDocumentFromReference(DocumentReference ref) async {
    return await ref.get();
  }

  /// Actualiza la tarea con su [name] o título, si se está [done], la [date] de
  /// completado, tipo de [repetition], el [tag] al que pertenece. 
  Future<void> updateTask(String name, bool done, Timestamp? date, String repetition, DocumentSnapshot? tag) {

    bool scheduled = false;
    if (date != null && date.millisecondsSinceEpoch > Timestamp.now().millisecondsSinceEpoch)
      scheduled = true;

    return widget._doc!.reference.update({
      'name': name,
      'done': done,
      'date': date,
      'repetition': repetitionTask,
      'tag': tag?.reference,
      'scheduled': scheduled
    });
  }
}

/// Clase de mapeo estático para mostrar en pantalla los valores bien.
class RepetitionTypeMapper {
  static const String none = 'none';
  static const String daily = 'daily';
  static const String workdays = 'workdays';
  static const String weekly = 'weekly';
  static const String monthly = 'monthly';
  static const String annually = 'annually';
  static const Map<String, String> visualList = {
    'daily': 'A diario',
    'workdays': 'Días laborales',
    'weekly': 'Semanalmante',
    'monthly': 'Mensualmente',
    'annually': 'Anualmente',
  };
}
