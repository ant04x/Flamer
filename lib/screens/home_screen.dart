import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flamer/screens/settings_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';
import 'package:flamer/screens/task_screen.dart';
import 'package:flamer/utils/auth/auth_impl.dart';
import 'package:flamer/utils/connection.dart';
import 'package:flamer/utils/messaging/messaging_impl.dart';
import 'package:flamer/widgets/components/tag_widget.dart';
import 'package:flamer/widgets/components/task_widget.dart';
import 'package:flamer/widgets/dialogs/tag_dialog.dart';
import 'package:flamer/widgets/dialogs/search_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

/// Pantalla de menú inical con un [title] para
/// mostrar en la barra de tareas y un [_user] para administrar [Task]s.
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.title, required User user}) : _user = user, super(key: key);

  /// Usuario para administrar las tareas.
  final User _user;
  /// Título de la pantalla.
  final String? title;

  /// Crea el estado del widget.
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Estado de [HomeScreen].
class _HomeScreenState extends State<HomeScreen> {

  /// [User] actual de la applicación.
  late User _user;
  /// Variable refrescante de estado, indica si el usuario [_isSigningOut].
  bool _isSigningOut = false;
  /// [Key] del [Tag] seleccionado.
  Key? _selectedKey;
  /// Instancia de Firestore.
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  /// Referencia de Firestore al [Tag] seleccionado.
  DocumentReference? selTag;
  /// Referencia de Firebase a la colección de [Tag]s del [user] actual.
  late CollectionReference tags;
  /// Referencia de Firebase a la colección de [Task]s del [user] actual.
  late CollectionReference tasks;

  /// Inicializa los valores del estado de [HomeScreen].
  @override
  void initState() {
    _user = widget._user;
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');
    tasks = FirebaseFirestore.instance.collection('tasks/').doc('${widget._user.uid}').collection('tasks/');
    super.initState();
  }

  /// Construye el widget [HomeScreen] para el [context] actual.
  @override
  Widget build(BuildContext context) {
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
            /// Al abrirse el cajón, oscurecer la barra de estado para no perder
            /// visibilidad.
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
                    /// Abre el cajón al presionarse.
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
                    /// Al presionarse abre el diálogo de búsqueda.
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
              /// Pestaña de TODOS
              StreamBuilder<QuerySnapshot>(
                  stream: _selectedKey == null
                      ? tasks.orderBy('created', descending: true).snapshots()
                      : tasks.where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    Future.delayed(Duration.zero, () async {
                      updateDestination();
                    });
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
                          /// Al abrir una tarea lanzar la pantalla de tareas.
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          /// Al mantener presionado y dar en "aceptar",
                          /// eliminar la tarea.
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
                  stream: _selectedKey == null
                      ? tasks.where('done', isEqualTo: false).orderBy('created', descending: true).snapshots()
                      : tasks.where('done', isEqualTo: false).where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    Future.delayed(Duration.zero, () async {
                      updateDestination();
                    });
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
                          /// Al abrir una tarea lanzar la pantalla de tareas.
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          /// Al mantener presionado y dar en "aceptar",
                          /// eliminar la tarea.
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
                  stream: _selectedKey == null
                      ? tasks.where('done', isEqualTo: true).orderBy('created', descending: true).snapshots()
                      : tasks.where('done', isEqualTo: true).where('tag', isEqualTo: selTag).orderBy('created', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                    Future.delayed(Duration.zero, () async {
                      updateDestination();
                    });
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
                          /// Al abrir una tarea lanzar la pantalla de tareas.
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskScreen(user: _user, doc: snapshot.data!.docs[index]))
                          );
                        },
                        onDelete: () {
                          /// Al mantener presionado y dar en "aceptar",
                          /// eliminar la tarea.
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
                      accountName: Text(_user.displayName != null ? _user.displayName! : _user.email!, style: textTheme.headline6),
                      accountEmail: _user.displayName != null ? Text(_user.email!, style: textTheme.caption) : null,
                      currentAccountPicture: _user.photoURL != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(_user.photoURL!),
                      )
                          : CircleAvatar(
                        child: Text(_nameToInitials(_user.displayName!)),
                        backgroundColor: Colors.deepOrange,
                      ),
                      onDetailsPressed: () async {
                        Navigator.pop(context);
                        late AlertDialog alert;
                        await check().then((connected) {
                          /// Si está conectado a Internet preguntar por cerrar
                          /// sesión, si no, informar de que es necesario.
                          if (connected)
                            alert = AlertDialog(
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
                                    await Messaging().stop(_user.uid);
                                    setState(() {
                                      _isSigningOut = false;
                                    });
                                    await Auth.signOut(context: context);
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
                          else
                            alert = AlertDialog(
                              title: Text('Sin Conexión'),
                              content: Text('Para poder cerrar sesión es necesario que te conectes a Internet.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('ACEPTAR'),
                                ),
                              ],
                            );
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
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
                      selected: _selectedKey == null,
                      // Al hacer tab establecer nuevo tag
                      onTap: () {
                        /// Al dar en la etiqueta automática quita los filtros
                        /// de la consulta.
                        setState(() {
                          _selectedKey = null;
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
                          updateDestination();
                        });
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => TagWidget(
                            key: Key(snapshot.data!.docs[index].id),
                            context: context,
                            doc: snapshot.data!.docs[index],
                            onTab: () {
                              /// Al dar en una etiqueta mostrar el tareas del
                              /// filtro seleccionado.
                              selectDestination(Key(snapshot.data!.docs[index].id), snapshot.data!.docs[index].reference);
                            },
                            onEdit: () {
                              /// Al dar en el deplegable en "editar", abrir la
                              /// pantalla de edición.
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
                            /// Al dar en el desplegable en "eliminar", abrir
                            /// diálogo de confirmación y eliminar.
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
                                            /// Cancela la eliminación.
                                            Navigator.pop(context);
                                          },
                                          child: Text('CANCELAR'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            /// Ejecuta la eliminación.
                                            setState(() {
                                              _selectedKey = null;
                                              selTag = null;
                                            });
                                            Navigator.pop(context);
                                            tags.doc(snapshot.data!.docs[index].id).delete();
                                          },
                                          child: Text('ACEPTAR'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            selected: _selectedKey == Key(snapshot.data!.docs[index].id),
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
                        /// Abre la pantalla para crear una tarea.
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
                          /// Abre la pantalla de configuración de la aplicación.
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
              /// Al presionar crear una tarea.
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

  /// Cambia la selección de los Tag según la [key] y la [ref] del [Tag] a
  /// seleccionar.
  void selectDestination(Key key, DocumentReference? ref) {
    setState(() {
      _selectedKey = key;
      selTag = ref;
    });
    Navigator.pop(context);
  }

  /// Actualiza el Tag seleccionado de no existir x haber sido eliminado en otro
  /// dispositivo.
  void updateDestination() {
    if (selTag != null) {
      tags.doc(selTag!.id).get().then((doc) {
        if (!doc.exists)
          setState(() {
            _selectedKey = null;
            selTag = null;
          });
      });
    }
  }

  /// Obtiene las iniciales de un [displayName].
  String _nameToInitials(String displayName) {
    var names = displayName.split(' ').getRange(0, 2);
    var result = '';
    names.forEach((element) { result += String.fromCharCode(element.runes.first); });
    return result.toUpperCase();
  }
}
