import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Widget para la representación de una tarea.
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

  /// Contexto actual donde mostrar la tarea.
  final BuildContext context;
  /// Colección de tareas contenedora.
  final CollectionReference col;
  /// Captura de la tarea a mostrar.
  final DocumentSnapshot doc;
  /// Acción al dar sobre la etiqueta.
  final void Function()? onTab;
  /// Acción al dar sobre el botón de editar.
  final void Function()? onEdit;
  /// Acción al dar sobre el botón de eliminar.
  final void Function()? onDelete;

  /// Crea elestado del widget.
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

/// Estado de [TaskWidget].
class _TaskWidgetState extends State<TaskWidget> {

  /// Construye el widget [TaskWidget] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.doc['name']),
      trailing: Checkbox(
        value: widget.doc['done'],
        onChanged: (value) {
          /// Al cambiar el estado, actualizarlo en Firebase.
          if (value == null) {
            updateDoneTask(widget.col, widget.doc, false);
          } else {
            updateDoneTask(widget.col, widget.doc, value);
          }
        },
      ),
      onTap: widget.onEdit,
      onLongPress: () {
        /// Al mantener presionado, abrir diálogo para la confirmación.
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

  /// Actualiza el valor [done] del [doc] sobre la [col]
  Future<void> updateDoneTask(CollectionReference col, DocumentSnapshot doc, bool done) {
    return col.doc(doc.id).update({
      'done': done
    });
  }
}
