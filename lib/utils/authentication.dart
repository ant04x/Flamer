import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/screens/home_screen.dart';
import 'package:flamer/screens/sign_in_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Authentication {

  // static Future<FirebaseApp> cached;

  static Future<FirebaseApp> accessFirebase({ required BuildContext context }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => SignInScreen()
        ),
      );
    }

    return firebaseApp;
  }

  static Future<FirebaseApp> initializeFirebase({ required BuildContext context }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {

        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

      } on FirebaseAuthException catch (e) {

        final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
        if (e.code == 'account-exists-with-different-credential') {
          scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('The account already exists with a different credential.'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
                ),
              )
          );
        } else if (e.code == 'invalid-credential') {
          scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Error occurred while accessing credentials. Try again.'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
                ),
              )
          );
        }
      } catch (e) {

        final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
        scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Error occurred using Google Sign-In. Try again.'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
              ),
            )
        );
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {

      await googleSignIn.signOut();
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
}