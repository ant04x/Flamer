import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/utils/flamer_credentials.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:github_sign_in/github_sign_in.dart';

import 'auth_impl.dart';
import 'package:flutter/material.dart';

class AuthAndroid implements Auth {

  @override
  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GitHubSignIn githubSignIn = GitHubSignIn(
        clientId: FlamerCredentials.clientID,
        clientSecret: FlamerCredentials.clientSecret,
        redirectUrl: FlamerCredentials.redirectURL
    );

    final result = await githubSignIn.signIn(context);

    final githubAuthCredential = GithubAuthProvider.credential(result.token);

    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }
}

Auth getAuth() => AuthAndroid();