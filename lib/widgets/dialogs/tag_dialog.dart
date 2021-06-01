import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Díalogo de pantalla completa para editar etiquetas.
class TagDialog extends StatefulWidget {

  TagDialog({
    Key? key,
    required User user,
    DocumentSnapshot? doc
  }) : _user = user, _doc = doc, super(key: key);

  /// Usuario editor de las tareas.
  final User _user;
  /// Captura de la etiqueta a editar.
  final DocumentSnapshot? _doc;

  /// Crea el estado del widget.
  @override
  _TagDialogState createState() => _TagDialogState();
}

/// Estado de [TagDialog].
class _TagDialogState extends State<TagDialog> {

  /// Valor del icono a seleccionar.
  late int _iconValue;
  /// Valor del icono actual.
  late int _iconValueBack;
  /// Icono seleccionado.
  late Icon tagIcon;
  /// Controlador de texto del nombre de la etiqueta.
  final myController = TextEditingController();
  /// Lista de iconos seleccionables.
  late final List<String> mapIcons;
  /// Colección de etiquetas.
  late CollectionReference tags;
  /// Controlador del scroll para la lista de iconos.
  late ScrollController _controller;

  /// Inicializa los valores del estado de [TagDialog] dependiendo si es edición
  /// o creación.
  @override
  void initState() {
    _controller = ScrollController();
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');
    mapIcons = MdiIcons.getIconsName();
    if (widget._doc == null) {
      tagIcon = Icon(MdiIcons.fromString(mapIcons[5278]));
      _iconValue = 5278;
    } else {
      tagIcon = Icon(MdiIcons.fromString(widget._doc!['icon']));
      _iconValue = mapIcons.indexOf(widget._doc!['icon']);
      myController.text = widget._doc!['name'];
    }
    _iconValueBack = _iconValue;

    super.initState();
  }

  /// Limpia todos los valores introducidos del widget.
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  /// Construye el widget [TagDialog] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etiqueta'),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16, left: 4, top: 16, bottom: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 0),
              icon: tagIcon,
              onPressed: () {
                /// Muestra un diálogo para seleccionar el icono.
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  AlertDialog(
                        title: Text('Icono'),
                        titlePadding: EdgeInsets.all(20.0),
                        insetPadding: EdgeInsets.symmetric(vertical: 4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                            child: Container(
                              width: double.maxFinite * 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                                    ),
                                    child: DraggableScrollbar.rrect(
                                      heightScrollThumb: 20.0,
                                      controller: _controller,
                                      child: ListView.builder(
                                        controller: _controller,
                                        itemExtent: 50.0,
                                        itemCount: mapIcons.length,
                                        itemBuilder: (context, index) => TagIconTile(
                                          index: index,
                                          doc: mapIcons[index],
                                          onChanged: (dynamic value) {
                                            /// Guarda el icono seleccionado.
                                            setState(() {
                                              _iconValue = value;
                                            });
                                          },
                                          groupValue: _iconValue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                            }
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              /// Reestablece el valor original del icono.
                              Navigator.of(context).pop();
                              setState(() {
                                _iconValue = _iconValueBack;
                              });
                            },
                            child: Text('CANCELAR'),
                          ),
                          TextButton(
                            onPressed: () {
                              /// Guarda el nuevo valor del icono para su
                              /// aplicación.
                              Navigator.of(context).pop();
                              setState(() {
                                _iconValueBack = _iconValue;
                                print('VALUE => $_iconValueBack');
                                tagIcon = Icon(MdiIcons.fromString(mapIcons[_iconValue]));
                              });
                            },
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
                controller: myController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Título',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /// Guarda o actualiza la etiqueta con sus nuevos valores.
          if (myController.text.isNotEmpty) {

            if (widget._doc == null)
              addTag(myController.text, mapIcons[_iconValueBack]);
            else
              editTag(myController.text, mapIcons[_iconValueBack]);

            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.cloud_upload),
        label: Text('GUARDAR'),
      ),
    );
  }

  /// Añade la etiqueta con su [name] y [icon] a la colección.
  Future<void> addTag(String name, String icon) {
    return tags.add({
      'icon': icon,
      'name': name
    });
  }

  /// Actualiza la etiqueta con su [name] y [icon].
  Future<void> editTag(String name, String icon) {
    return tags.doc(widget._doc!.id).update({
      'icon': icon,
      'name': name
    });
  }
}

/// Representación de lista de iconos para etiqueta.
class TagIconTile extends StatefulWidget {
  TagIconTile({
    Key? key,
    required this.doc,
    required this.index,
    required this.groupValue,
    this.onChanged,
  }) : super(key: key);

  /// Nombre identificativo del icono.
  final String doc;
  /// Indice del icono a seleccionar.
  final int index;
  /// Identificador del grupo de radius.
  final Object? groupValue;
  /// Acción al cambiar de selección.
  final void Function(Object?)? onChanged;

  /// Crea el estado del widget.
  @override
  _TagIconTileState createState() => _TagIconTileState();
}

/// Estado de [TagDialog]
class _TagIconTileState extends State<TagIconTile> {

  /// Construye el widget [TagDialog] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.doc),
      leading: Icon(MdiIcons.fromString(widget.doc)),
      trailing: Radio(
        value: widget.index,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
