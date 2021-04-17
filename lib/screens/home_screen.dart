import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/settings_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';
import 'package:flamer/screens/task_screen.dart';
import 'package:flamer/utils/authentication.dart';
import 'package:flamer/widgets/dialogs/create_tag_dialog.dart';
import 'package:flamer/widgets/dialogs/search_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.title, required User user}) : _user = user, super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User _user;
  final String? title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  bool _isSigningOut = false;

  int _counter = 0;
  bool? _task1 = false;
  bool? _task2 = false;
  bool? _task3 = false;
  int _selectedDestination = 0;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchDialog())
                  );
                },
              ),
            ),
          ],
          title: Text('Tareas'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink.shade900,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'TODO', icon: Icon(Icons.list_alt)),
              Tab(text: 'PENDIENTE', icon: Icon(Icons.access_time)),
              Tab(text: 'HECHO', icon: Icon(Icons.done_all)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
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
                ListTile(
                  title: Text('Tarea 2'),
                  trailing: Checkbox(
                    value: _task2,
                    onChanged: (value) {
                      setState(() {
                        _task2 = value;
                      });
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Tarea 3'),
                  trailing: Checkbox(
                    value: _task3,
                    onChanged: (value) {
                      setState(() {
                        _task3 = value;
                      });
                    },
                  ),
                ),
                Divider(),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text('Tarea 3'),
                  trailing: Checkbox(
                    value: _task3,
                    onChanged: (value) {
                      setState(() {
                        _task3 = value;
                      });
                    },
                  ),
                ),
                Divider(),
              ],
            ),
            ListView(
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
                ListTile(
                  title: Text('Tarea 2'),
                  trailing: Checkbox(
                    value: _task2,
                    onChanged: (value) {
                      setState(() {
                        _task2 = value;
                      });
                    },
                  ),
                ),
                Divider(),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
                  arrowColor: Colors.black,
                  accountName: Text(_user.displayName!, style: textTheme.headline6),
                  accountEmail: Text(_user.email!, style: textTheme.caption),
                  currentAccountPicture: _user.photoURL != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(_user.photoURL!),
                  )
                      : CircleAvatar(
                    child: Text(_nameToInitials(_user.displayName!)),
                    backgroundColor: Colors.deepOrange,
                  ),
                  onDetailsPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  AlertDialog(
                            title: Text('Cerrar Sesión'),
                            content: Text('Para administrar de nuevo tus tareas deberás iniciar sesión después con esta u otra cuenta. ¿Estás seguro de que quieres cerrar sesión?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('CANCELAR'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _isSigningOut = true;
                                  });
                                  await Authentication.signOut(context: context);
                                  setState(() {
                                    _isSigningOut = false;
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => SignInScreen()
                                      )
                                  );
                                },
                                child: Text('ACEPTAR'),
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Etiquetas',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.all_inbox),
                  title: Text('Tareas'),
                  selected: _selectedDestination == 0,
                  onTap: () => selectDestination(0),
                ),
                ListTile(
                  leading: Icon(Icons.lightbulb),
                  title: Text('PSP'),
                  selected: _selectedDestination == 1,
                  onTap: () => selectDestination(1),
                ),
                ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: Text('ADA'),
                  selected: _selectedDestination == 2,
                  onTap: () => selectDestination(2),
                ),
                ListTile(
                  leading: Icon(Icons.desktop_windows),
                  title: Text('PMDM'),
                  selected: _selectedDestination == 3,
                  onTap: () => selectDestination(3),
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('SGE'),
                  selected: _selectedDestination == 4,
                  onTap: () => selectDestination(4),
                ),
                ListTile(
                  leading: Icon(Icons.web_asset),
                  title: Text('DIN'),
                  selected: _selectedDestination == 5,
                  onTap: () => selectDestination(5),
                ),
                ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text('ING'),
                  selected: _selectedDestination == 6,
                  onTap: () => selectDestination(6),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Acciones',
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.tag),
                  title: Text('Crear Etiqueta'),
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CreateTagDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Ajustes'),
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsScreen())
                      );
                    }
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.pink.shade900,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskScreen())
            );
          },
          icon: Icon(Icons.add),
          label: Text('TAREA'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
    Navigator.pop(context);
  }

  String _nameToInitials(String displayName) {
    var names = displayName.split(' ').getRange(0, 2);
    var result = '';
    names.forEach((element) { result += String.fromCharCode(element.runes.first); });
    return result.toUpperCase();
  }
}