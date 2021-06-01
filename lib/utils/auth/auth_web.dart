import 'package:firebase_auth/firebase_auth.dart';

import 'auth_impl.dart';
import 'package:flutter/material.dart';

/// Implementación de la clase [Auth] para Web.
class AuthWeb implements Auth {

  /// Devuelve las credenciales del usuario a acceder mediante el [context]
  /// actual en Web.
  @override
  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(githubProvider);
  }
}

/// Función para la implementación del Factory de [Auth].
Auth getAuth() => AuthWeb();