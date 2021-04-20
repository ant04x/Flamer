import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateTagDialog extends StatefulWidget {
  CreateTagDialog({Key? key, required User user}) : _user = user, super(key: key);

  final User _user;
  @override
  _CreateTagDialogState createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  int? _iconValue = 0;
  final myController = TextEditingController();
  late CollectionReference tags;

  @override
  void initState() {
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade900,
        title: Text('Crear Etiqueta'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                addTag(myController.text);
                Navigator.of(context).pop();
              },
              child: Text("GUARDAR"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16, left: 4, top: 16, bottom: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 0),
              icon: const Icon(Icons.tag_faces),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  AlertDialog(
                        title: Text('Icono'),
                        titlePadding: EdgeInsets.all(20.0),
                        insetPadding: EdgeInsets.symmetric(vertical: 200),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListBody(
                                        children: [
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('List item 1'),
                                            leading: Icon(Icons.label),
                                            trailing: Radio(
                                              value: 1,
                                              groupValue: _iconValue,
                                              onChanged: (dynamic value) {
                                                setState() {
                                                  _iconValue = value;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1.0,
                            ),
                          ],
                        ),
                        actions: [
                          Divider(),
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(); },
                            child: Text('CANCELAR'),
                          ),
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(); },
                            child: Text('ACEPTAR'),
                          ),
                        ],
                      );
                    }
                );
              },
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                controller: myController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Título',
                  labelStyle: TextStyle(
                    color: Colors.deepOrange,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTag(String name) {
    return tags.add({
      'icon': 'tag',
      'name': name
    });
  }
}