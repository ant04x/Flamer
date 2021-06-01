import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Widget para la representación de una etiqueta.
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

  /// Contexto actual donde mostrar la etiqueta.
  final BuildContext context;
  /// Captura de la etiqueta a mostrar.
  final DocumentSnapshot doc;
  /// Si la etiqueta esta seleccionado.
  final bool selected;
  /// Acción al dar sobre la etiqueta.
  final void Function()? onTab;
  /// Acción al dar sobre editar.
  final void Function()? onEdit;
  /// Acción al dar sobre eliminar.
  final void Function()? onDelete;

  /// Crea el estado del widget.
  @override
  _TagWidgetState createState() => _TagWidgetState();
}

/// Estado de [TagWidget].
class _TagWidgetState extends State<TagWidget> {

  /// Construye el widget [TagWidget] para el [context] actual.
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
