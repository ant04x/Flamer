import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/models/task.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {

  TaskScreen({Key? key, required User user, DocumentSnapshot? doc, DocumentSnapshot? parent}) : _user = user, _doc = doc, _parent = parent, super(key: key);

  final User _user;
  final DocumentSnapshot? _doc;
  final DocumentSnapshot? _parent;

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late bool done;
  String tagName = 'Todo';
  String repetitionTask = RepetitionType.none;
  DateTime? remind;

  late CollectionReference tasks;

  late final myController;

  @override
  void initState() {
    tasks = FirebaseFirestore.instance.collection('tasks/').doc('${widget._user.uid}').collection('tasks/');

    if (widget._doc == null) {
      done = false;
      myController = TextEditingController();
    } else {
      done = widget._doc!['done'];
      myController = TextEditingController(text: widget._doc!['name']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea'),
        backgroundColor: Colors.pink.shade900,
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
                      labelStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
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
          ListTile(
            title: Text('Etiqueta'),
            subtitle: widget._parent != null
                ? Text(widget._parent!['name'])
                : tagName != 'Todo' ? Text(tagName) : null ,
            leading: Icon(MdiIcons.tag),
          ),
          Divider(),
          ListTile(
            title: Text('Repetir'),
            subtitle: widget._parent != null
                ? Text(widget._parent!['repetition'])
                : repetitionTask != RepetitionType.none ? Text(repetitionTask) : null ,
            leading: Icon(Icons.repeat),
          ),
          Divider(),
          ListTile(
            title: Text('Aviso'),
            subtitle: widget._parent != null
                ? Text(widget._parent!['date'])
                : remind != null ? Text(remind.toString()) : null,
            leading: Icon(Icons.calendar_today),
          ),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          addTask(
            myController.text,
            done,
            remind == null
                ? null
                : Timestamp.fromDate(remind!),
            repetitionTask,
            widget._parent,
          );
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('GUARDAR'),
      ),
    );
  }

  Future<void> addTask(String name, bool done, Timestamp? date, String repetition, DocumentSnapshot? tag) {
    return tasks.add({
      'name': name,
      'done': done,
      'date': date,
      'repetition': repetitionTask,
      'tag': tag?.reference
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
}
