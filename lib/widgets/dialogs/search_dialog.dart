import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/task_screen.dart';
import 'package:flamer/widgets/components/task_widget.dart';
import 'package:flutter/material.dart';

/// Díalogo de pantalla completa para buscar tareas.
class SearchDialog extends StatefulWidget {

  SearchDialog({
    Key? key,
    required CollectionReference tasks,
    required User user
  }) : _tasks = tasks, _user = user, super(key: key);

  /// Colección de todas las tareas.
  final CollectionReference _tasks;
  /// Usuario actual administrador de las tareas.
  final User _user;

  /// Crea el estado del widget.
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

/// Estado de [SearchDialog].
class _SearchDialogState extends State<SearchDialog> {

  /// Consulta directa de tareas.
  late Stream<QuerySnapshot> _searchedTasks;

  /// Inicializa los valores del estado de [SearchDialog] para establecer el
  /// filtro por nombre por orden de creación.
  @override
  void initState() {
    _searchedTasks = widget._tasks.orderBy('created', descending: false).snapshots();
    super.initState();
  }

  /// Construye el widget [SearchDialog] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    /// Carga del tema actual para personalizar la barra de búsqueda en caso  de
    /// ser tema oscuro.
    ThemeData currentTheme = Theme.of(context);
    Brightness currentBrightness = currentTheme.brightness;
    return Theme(
        data: currentTheme.copyWith(
          appBarTheme: currentBrightness == Brightness.light
          ? currentTheme.appBarTheme.copyWith(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.grey.shade800),
              foregroundColor: Colors.black,
              brightness: Brightness.light,
            )
          : currentTheme.appBarTheme
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 22),
                      child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            /// Actualización de la consulta para mostrar las
                            /// tareas con ese nombre.
                            setState(() {
                              _searchedTasks = widget._tasks
                                  .where('name', isEqualTo: value)
                                  .orderBy('created', descending: true)
                                  .snapshots();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Buscar',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.pink.shade900
                                      : Colors.deepOrange.shade200
                              ),
                            ),
                          )
                      ),
                    )
                ),
              ],
            ),
            // backgroundColor: Colors.white,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _searchedTasks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
                return ListView.separated(
                  shrinkWrap: true,
                  key: PageStorageKey('SearchScreen'),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => TaskWidget(
                    context: context,
                    col: widget._tasks,
                    doc: snapshot.data!.docs[index],
                    onEdit: () {
                      /// Al dar para editar, abrir pantalla de edición de
                      /// tareas.
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskScreen(user: widget._user, doc: snapshot.data!.docs[index]))
                      );
                    },
                    onDelete: () {
                      /// Al dar en eliminar, suprimir la tarea de la base de datos.
                      Navigator.of(context).pop();
                      widget._tasks.doc(snapshot.data!.docs[index].id).delete();
                    },
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              }
          ),
        ),
    );
  }
}