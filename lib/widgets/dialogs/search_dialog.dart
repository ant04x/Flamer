import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  bool? _task1 = false;

  bool _task2 = false;

  bool _task3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 22),
                  child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink.shade900),
                        ),
                      )
                  ),
                )
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tarea 1'),
            trailing: Checkbox(
              value: _task1,
              onChanged: (value) {
                setState(() {
                  _task1 = value;
                });
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}