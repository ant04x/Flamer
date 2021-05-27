import 'package:firebase_auth/firebase_auth.dart';

import 'auth_impl.dart';
import 'package:flutter/material.dart';

class AuthWeb implements Auth {

  @override
  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {

    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(githubProvider);
  }
}

Auth getAuth() => AuthWeb();