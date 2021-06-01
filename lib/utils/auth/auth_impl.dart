import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/home_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';
import 'auth_stub.dart'
  if (dart.library.io) 'auth_android.dart'
  if (dart.library.html) 'auth_web.dart';
import 'package:flutter/material.dart';

/// Clase abstracta para autenticar al usuario de la app en Github.
abstract class Auth {

  /// Registro de la función constructora sobre la plataforma.
  factory Auth() => getAuth();

  /// Devuelve las credenciales del usuario a acceder mediante el [context]
  /// actual.
  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {}

  /// Cierra sesión en Github de modo multiplataforma.
  static Future<UserCredential?> signOut({required BuildContext context}) async {

    /// Intentar cerrar sesión.
    try {

      await FirebaseAuth.instance.signOut();

    /// En caso de error mostrar un mensaje.
    } catch (e) {

      final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
      scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Error signing out. Try again.'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
            ),
          )
      );
    }
  }

  /// Inicializa Firebase y abre [HomeScreen] si el usuario ya había accedido
  /// mediante el [context] actual.
  static Future<void> initializeFirebase({ required BuildContext context }) async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }
  }

  /// Inicializa Firebase y abre [HomeScreen] si el usuario ya había accedido
  /// mediante el [context] actual, si no se devuelve a [SignInScreen].
  static Future<void> accessFirebase({ required BuildContext context }) async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignInScreen(user: user)
        ),
      );
    }
  }
}