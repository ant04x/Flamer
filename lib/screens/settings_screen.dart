import 'package:flamer/utils/dark_theme_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Pantalla de configuración e información de la aplicación.
class SettingsScreen extends StatefulWidget {

  /// Crea el estado del widget.
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

/// Estado de [SettingsScreen].
class _SettingsScreenState extends State<SettingsScreen> {

  /// Indice del tema seleccionado.
  int? _themeValue = 1;
  /// Indice del tema establecido.
  int themeSet = 1;
  /// Selección de temas por defecto.
  List<String> themes = [
    'Auto',
    'Claro',
    'Oscuro'
  ];

  /// Inicializa los valores del estado de [SettingsScreen].
  @override
  void initState() {
    DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
    themeSet = themeChangeProvider.darkTheme + 1;
    super.initState();
  }

  /// Construye el widget [SettingsScreen] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tema'),
            subtitle: Text(themes[themeSet - 1]),
            leading: Icon(Icons.brightness_6),
            onTap: () {
              /// Abre un diálogo para establecer el tema de la app.
              setState(() {
                _themeValue = themeSet;
              });
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
                          /// Si no se acepta, el valor actual se mantiene.
                          onPressed: () { Navigator.of(context).pop(); },
                          child: Text('CANCELAR'),
                        ),
                        TextButton(
                          /// Si se acepta el valor cambia por el seleccionado.
                          onPressed: () {
                            setState(() {
                              themeSet = _themeValue!;
                            });
                            themeChange.darkTheme = themeSet - 1;
                            Navigator.of(context).pop();
                          },
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
              /// Abrir el repositorio de GitHub.
              await launch("https://github.com/ant04x/Flamer");
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}