import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: MyHomePage(title: 'Tareas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _task1 = false;
  bool _task2 = false;
  bool _task3 = false;
  int _selectedDestination = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
              child: Icon(Icons.search),
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
                    accountName: Text('Antonio Izquierdo', style: textTheme.headline6),
                    accountEmail: Text('ant04x@gmail.com', style: textTheme.caption),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
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
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Ajustes'),
                  selected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.pink.shade900,
          foregroundColor: Colors.white,
          onPressed: () {
            // Respond to button press
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
}
