import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flamer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: SignInScreen()
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/todo-draw.svg",
                  fit: BoxFit.scaleDown,
                  placeholderBuilder: (context) => Container(height: 500, child: Center(child: CircularProgressIndicator(),),),
                  width: 500,
                ),
                Text(
                  'Empieza a usar Flamer para que no se te olvide nada de la lista de la compra, del trabajo o de cualquier otra cosa.',
                  style: textTheme.headline6!.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: Authentication.initializeFirebase(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
            scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Error initializing Firebase'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
                  ),
                )
            );
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            bool _isSigningIn = false;
            return FloatingActionButton.extended(
              backgroundColor: Colors.pink.shade900,
              foregroundColor: Colors.white,
              onPressed: () async {
                setState(() => _isSigningIn = true);

                User? user = await Authentication.signInWithGoogle(context: context);

                setState(() => _isSigningIn = false);

                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        user: user,
                        title: "Tareas",
                      ),
                    ),
                  );
                }
              },
              icon: Icon(MdiIcons.google),
              label: Text('ACCEDER'),
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title, required User user}) : _user = user, super(key: key);

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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


class ErrorScreen extends StatefulWidget {
  ErrorScreen({Key? key, this.error}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Object? error;
  
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error, color: Colors.red,)
        ],
      ),
    );
  }
}


class Authentication {

  static Future<FirebaseApp> initializeFirebase({ required BuildContext context }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {

        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

      } on FirebaseAuthException catch (e) {

        final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
        if (e.code == 'account-exists-with-different-credential') {
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('The account already exists with a different credential.'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
              ),
            )
          );
        } else if (e.code == 'invalid-credential') {
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Error occurred while accessing credentials. Try again.'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
              ),
            )
          );
        }
      } catch (e) {

        final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
        scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Error occurred using Google Sign-In. Try again.'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
              ),
            )
        );
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {

      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

    } catch (e) {

      final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Error signing out. Try again.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
          ),
        )
      );
    }
  }
}