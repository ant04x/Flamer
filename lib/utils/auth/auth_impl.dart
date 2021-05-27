import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/home_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';

import 'auth_stub.dart'
if (dart.library.io) 'auth.dart'
if (dart.library.html) 'auth_web.dart';

import 'package:flutter/material.dart';

abstract class Auth {

  factory Auth() => getAuth();

  Future<UserCredential?> signInWithGitHub({required BuildContext context}) async {}

  static Future<UserCredential?> signOut({required BuildContext context}) async {
    // final GitHubSignIn googleSignIn = GitHubSignInResult();

    try {

      // await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

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
}