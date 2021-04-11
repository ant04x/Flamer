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
        primarySwatch: Colors.pink,
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
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
}
