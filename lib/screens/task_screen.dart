import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/models/task.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {

  TaskScreen({Key? key, required User user, DocumentSnapshot? doc}) : _user = user, _doc = doc, super(key: key);

  final User _user;
  final DocumentSnapshot? _doc;

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late bool done;
  String tagName = 'Todo';
  DocumentReference? tag;
  DocumentSnapshot? tagSnapshot;
  String repetitionTask = RepetitionType.none;
  DateTime? remind;

  late CollectionReference tasks;
  late CollectionReference tags;

  late final myController;

  @override
  void initState() {
    tasks = FirebaseFirestore.instance.collection('tasks/').doc('${widget._user.uid}').collection('tasks/');
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');

    if (widget._doc == null) {
      done = false;
      myController = TextEditingController();
    } else {
      done = widget._doc!['done'];
      myController = TextEditingController(text: widget._doc!['name']);
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

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Brightness currentBrightness = currentTheme.brightness;
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
                    controller: myController,
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
                      setState(() => tagSnapshot = null);
                    },
                    icon: Icon(Icons.close),
                  )
                      : null,
                ),
                onSelected: (value) {
                  setState(() {
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
              subtitle: repetitionTask != RepetitionType.none ? Text(RepetitionType.visualList[repetitionTask]!) : null,
              leading: Icon(Icons.repeat),
              trailing: repetitionTask != RepetitionType.none
                  ? IconButton(
                onPressed: () {
                  setState(() => repetitionTask = RepetitionType.none);
                },
                icon: Icon(Icons.close),
              )
                  : null,
            ),
            itemBuilder: (context) {
              return RepetitionType.visualList.keys.map((type) => PopupMenuItem<String>(
                  value: type,
                  child: Text('${RepetitionType.visualList[type]}')
              )).toList();
            },
            onSelected: (value) {
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
                setState(() {
                  remind = null;
                  repetitionTask = RepetitionType.none;
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
          Navigator.pop(context);
          if (widget._doc == null) {
            addTask(
              myController.text,
              done,
              remind == null
                  ? null
                  : Timestamp.fromDate(remind!),
              repetitionTask,
              tagSnapshot,
              remind == null
                  ? false
                  : true,
            );
          } else {
            updateTask(
              myController.text,
              done,
              remind == null
                  ? null
                  : Timestamp.fromDate(remind!),
              repetitionTask,
              tagSnapshot,
            );
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('GUARDAR'),
      ),
    );
  }

  Future<void> addTask(String name, bool done, Timestamp? date, String repetition, DocumentSnapshot? tag, bool scheduled) {
    return tasks.add({
      'name': name,
      'done': done,
      'date': date,
      'repetition': repetitionTask,
      'tag': tag?.reference,
      'scheduled': scheduled
    });
  }

  Future<DocumentSnapshot> getDocumentFromReference(DocumentReference ref) async {
    return await ref.get();
  }

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

class RepetitionType {
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
