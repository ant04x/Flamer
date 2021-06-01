import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/utils/flamer_credentials.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:github_sign_in/github_sign_in.dart';
import 'auth_impl.dart';
import 'package:flutter/material.dart';

/// Implementación de la clase [Auth] para Android.
class AuthAndroid implements Auth {

  /// Devuelve las credenciales del usuario a acceder mediante el [context]
  /// actual en Android.
  @override
  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {
    /// Instancia de Firebase.
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    /// Inicialización del servidor Github Sign In.
    final GitHubSignIn githubSignIn = GitHubSignIn(
        clientId: FlamerCredentials.clientID,
        clientSecret: FlamerCredentials.clientSecret,
        redirectUrl: FlamerCredentials.redirectURL
    );

    /// Abrir ventana para obtener las credenciales.
    final result = await githubSignIn.signIn(context);
    final githubAuthCredential = GithubAuthProvider.credential(result.token);
    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }
}

/// Función para la implementación del Factory de [Auth].
Auth getAuth() => AuthAndroid();