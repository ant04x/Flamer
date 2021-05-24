import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flamer/models/task.dart';
import 'package:flamer/screens/settings_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';
import 'package:flamer/screens/task_screen.dart';
import 'package:flamer/utils/authentication.dart';
import 'package:flamer/utils/dark_theme_preference.dart';
import 'package:flamer/utils/messaging.dart';
import 'package:flamer/widgets/dialogs/tag_dialog.dart';
import 'package:flamer/widgets/dialogs/search_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
  // bool? _task1 = false;
  int _selectedDestination = -1;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference? selTag;
  late CollectionReference tags;
  late CollectionReference tasks;

  @override
  void initState() {
    _user = widget._user;
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');
    tasks = FirebaseFirestore.instance.collection('tasks/').doc('${widget._user.uid}').collection('tasks/');
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
    ThemeData currentTheme = Theme.of(context);
    Brightness currentBrightness = currentTheme.brightness;
    return Theme(
      data: currentTheme.copyWith(
        appBarTheme: currentBrightness == Brightness.light
        ? currentTheme.appBarTheme.copyWith(
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            backgroundColor: Colors.pink.shade900,
          )
        : currentTheme.appBarTheme,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          onDrawerChanged: (open) {
            if (open) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.black38,
              ));
            } else {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ));
            }
          },
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
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
                        MaterialPageRoute(builder: (context) => SearchDialog(user: _user, tasks: tasks,))
                    );
                  },
                ),
              ),
            ],
            title: Text(widget.title == null ? 'Tareas' : widget.title!),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(text: 'TODO', icon: Icon(Icons.list_alt)),
                Tab(text: 'PENDIENTE', icon: Icon(Icons.access_time)),
                Tab(text: 'HECHO', icon: Icon(Icons.done_all)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // ALL
              StreamBuilder<QuerySnapshot>(
                  stream: _selectedDestination == -1
                      ? tasks.orderBy('created', descending: true).snapshots()
                      : tasks.where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 88),
                      shrinkWrap: true,
                      key: PageStorageKey('TabAll'),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => TaskWidget(
                        context: context,
                        col: tasks,
                        doc: snapshot.data!.docs[index],
                        onEdit: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          Navigator.of(context).pop();
                          tasks.doc(snapshot.data!.docs[index].id).delete();
                        },
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    );
                  }
              ),
              // PENDIENTE
              StreamBuilder<QuerySnapshot>(
                  stream: _selectedDestination == -1
                      ? tasks.where('done', isEqualTo: false).orderBy('created', descending: true).snapshots()
                      : tasks.where('done', isEqualTo: false).where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 88),
                      shrinkWrap: true,
                      key: PageStorageKey('TabPending'),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => TaskWidget(
                        context: context,
                        col: tasks,
                        doc: snapshot.data!.docs[index],
                        onEdit: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          Navigator.of(context).pop();
                          tasks.doc(snapshot.data!.docs[index].id).delete();
                        },
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    );
                  }
              ),
              // HECHO
              StreamBuilder<QuerySnapshot>(
                  stream: _selectedDestination == -1
                      ? tasks.where('done', isEqualTo: true).orderBy('created', descending: true).snapshots()
                      : tasks.where('done', isEqualTo: true).where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 88),
                      shrinkWrap: true,
                      key: PageStorageKey('TabDone'),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => TaskWidget(
                        context: context,
                        col: tasks,
                        doc: snapshot.data!.docs[index],
                        onEdit: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          Navigator.of(context).pop();
                          tasks.doc(snapshot.data!.docs[index].id).delete();
                        },
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    );
                  }
              ),
            ],
          ),
          drawer: Drawer(
            child: Container(
              color: theme.brightness == Brightness.dark
                  ? currentTheme.appBarTheme.backgroundColor
                  : currentTheme.canvasColor,
              child: SafeArea(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? currentTheme.appBarTheme.backgroundColor
                              : currentTheme.canvasColor,
                      ),
                      arrowColor: theme.iconTheme.color != null ? theme.iconTheme.color! : Colors.white,
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
                                      NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
                                      if (!kIsWeb || settings.authorizationStatus == AuthorizationStatus.authorized) {
                                        await FirebaseMessaging.instance.getToken().then((token) async {
                                          if (token != null) {
                                            await Messaging.initMessagingManager(_user.uid);
                                            await Messaging.removeDevice(token);
                                          }
                                        });
                                      }
                                      setState(() {
                                        _isSigningOut = false;
                                      });
                                      await Authentication.signOut(context: context);
                                      // await Messaging.unsubscribeNotifications(_user);
                                      print('Notificaciones cerradas');
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(user: null,)
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
                      title: Text('Todo'),
                      selected: _selectedDestination == -1,
                      // Al hacer tab establecer nuevo tag
                      onTap: () {
                        setState(() {
                          _selectedDestination = -1;
                          selTag = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: tags.orderBy('name', descending: false).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                        Future.delayed(Duration.zero, () async {
                          updateDestination(snapshot.data!.docs.length);
                        });
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => TagWidget(
                            context: context,
                            doc: snapshot.data!.docs[index],
                            onTab: () {
                              // Fluttertoast.showToast(msg: "Cambio $_selectedDestination");
                              selectDestination(index, snapshot.data!.docs[index].reference);
                            },
                            onEdit: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => TagDialog(
                                      user: widget._user,
                                      doc: snapshot.data!.docs[index]
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            onDelete: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return  AlertDialog(
                                      title: Text('¿Borrar ${snapshot.data!.docs[index]['name']}?'),
                                      content: Text('Se eliminará permanentemente esta etiqueta y las tareas contenidas se desetiquetarán.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('CANCELAR'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // El pop lo hace ya selectDestination
                                            selectDestination(index - 1, snapshot.data!.docs[index - 1].reference);
                                            tags.doc(snapshot.data!.docs[index].id).delete();
                                          },
                                          child: Text('ACEPTAR'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            selected: _selectedDestination == index,
                          ),
                        );
                      },
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
                      leading: Icon(MdiIcons.tagPlus),
                      title: Text('Crear Etiqueta'),
                      selected: false,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => TagDialog(user: widget._user,),
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
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    if (selTag != null)
                      return TaskScreen(user: _user, tag: selTag,);
                    else
                      return TaskScreen(user: _user,);
                  })
              );
            },
            icon: Icon(Icons.add),
            label: Text('TAREA'),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  void selectDestination(int index, DocumentReference ref) {
    setState(() {
      _selectedDestination = index;
      selTag = ref;
    });
    Navigator.pop(context);
  }

  void updateDestination(int length) {
    if (_selectedDestination >= length)
      setState(() {
        _selectedDestination = -1;
        selTag = null;
      });
  }

  String _nameToInitials(String displayName) {
    var names = displayName.split(' ').getRange(0, 2);
    var result = '';
    names.forEach((element) { result += String.fromCharCode(element.runes.first); });
    return result.toUpperCase();
  }
}

class TaskWidget extends StatefulWidget {
  TaskWidget({
    Key? key,
    required this.context,
    required this.col,
    required this.doc,
    this.onTab,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  final BuildContext context;
  final CollectionReference col;
  final DocumentSnapshot doc;
  final void Function()? onTab;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.doc['name']),
      trailing: Checkbox(
        value: widget.doc['done'],
        onChanged: (value) {
          if (value == null) {
            updateDoneTask(widget.col, widget.doc, false);
          } else {
            updateDoneTask(widget.col, widget.doc, value);
          }
        },
      ),
      onTap: widget.onEdit,
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return  AlertDialog(
                title: Text('¿Borrar ${widget.doc['name']}?'),
                content: Text('Se eliminará permanentemente de tu lista de tareas y etiquetas.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCELAR'),
                  ),
                  TextButton(
                    onPressed: widget.onDelete,
                    child: Text('ACEPTAR'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Future<void> updateDoneTask(CollectionReference col, DocumentSnapshot doc, bool done) {
    return col.doc(doc.id).update({
      'done': done
    });
  }
}


class TagWidget extends StatefulWidget {

  TagWidget({
    Key? key,
    required this.context,
    required this.doc,
    this.selected = false,
    this.onTab,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final BuildContext context;
  final DocumentSnapshot doc;
  final bool selected;
  final void Function()? onTab;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(MdiIcons.fromString(widget.doc['icon'])),
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
              onTap: widget.onEdit,
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar'),
              onTap: widget.onDelete,
            ),
          ),
        ],
      ),
      title: Text(widget.doc['name']),
      selected: widget.selected,
      // Al hacer tab establecer nuevo tag
      onTap: widget.onTab,
    );
  }
}
