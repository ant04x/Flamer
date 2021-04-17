import 'package:flutter/material.dart';

class CreateTagDialog extends StatefulWidget {

  @override
  _CreateTagDialogState createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  int? _iconValue = 0;

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
                // Respond to button press
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
}