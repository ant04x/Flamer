import 'package:flamer/screens/sign_in_screen.dart';
import 'package:flamer/utils/auth/auth_impl.dart';
import 'package:flutter/material.dart';

/// Pantalla de carga para cargar recursos en la nube al abrir la app.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Estado e [SignInScreen].
class _SplashScreenState extends State<SplashScreen> {

  /// Inicializa los valores del estado de [SignInScreen].
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Auth.accessFirebase(context: context);
    });
    super.initState();
  }

  /// Construye el widget [SplashScreen] para el [context] actual.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/icon-flamer.png",
                width: 125,
              ),
            ),
          ),
        ],
      ),
    );
  }
}