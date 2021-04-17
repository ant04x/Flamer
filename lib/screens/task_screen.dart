import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  bool? done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarea"),
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
                        done = value;
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
            subtitle: Text('ADA'),
            leading: Icon(MdiIcons.tag),
          ),
          Divider(),
          ListTile(
            title: Text('Repetir'),
            subtitle: Text('Diariamente'),
            leading: Icon(Icons.repeat),
          ),
          Divider(),
          ListTile(
            title: Text('Aviso'),
            subtitle: Text('13 de Junio de 2021'),
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
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('GUARDAR'),
      ),
    );
  }
}
