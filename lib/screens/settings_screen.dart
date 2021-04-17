import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _themeValue = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes"),
        backgroundColor: Colors.pink.shade900,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tema'),
            subtitle: Text('Claro'),
            leading: Icon(Icons.brightness_6),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return  AlertDialog(
                      title: Text('Tema'),
                      titlePadding: EdgeInsets.all(20.0),
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                                ListBody(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Auto',
                                      ),
                                      leading: Radio(
                                        value: 1,
                                        groupValue: _themeValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _themeValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Claro',
                                      ),
                                      leading: Radio(
                                        value: 2,
                                        groupValue: _themeValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _themeValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Oscuro',
                                      ),
                                      leading: Radio(
                                        value: 3,
                                        groupValue: _themeValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _themeValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 1.0,
                                ),
                              ],
                            );
                          }
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
          Divider(),
          ListTile(
            title: Text('Acerca de'),
            leading: Icon(Icons.info),
            onTap: () async {
              await launch("https://github.com/ant04x/Flamer");
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}