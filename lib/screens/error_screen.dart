import 'package:flutter/material.dart';

/// Pantalla de error para mostrar en caso de por ejemplo tener un [error].
class ErrorScreen extends StatefulWidget {
  ErrorScreen({Key? key, this.error}) : super(key: key);

  /// Objeto contenedor del error a mostrar.
  final Object? error;

  /// Crea el estado del widget.
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

/// Estado de [ErrorScreen].
class _ErrorScreenState extends State<ErrorScreen> {

  /// Construye el widget [ErrorScreen] para el [context] seleccionado.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error, color: Colors.red,),
          Text(widget.error.toString()),
        ],
      ),
    );
  }
}