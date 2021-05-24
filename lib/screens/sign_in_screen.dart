import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flamer/utils/authentication.dart';
import 'package:flamer/utils/messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key, required User? user}) : _user = user, super(key: key);

  final User? _user;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Authentication.initializeFirebase(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/todo-draw.svg",
                  fit: BoxFit.scaleDown,
                  placeholderBuilder: (context) => Container(height: 500, child: Center(child: CircularProgressIndicator(),),),
                  width: 500,
                ),
                Text(
                  'Empieza a usar Flamer para que no se te olvide nada de la lista de la compra, del trabajo o de cualquier otra cosa.',
                  style: textTheme.headline6!.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink.shade900,
        foregroundColor: Colors.white,
        onPressed: () async {
          User? user = await Authentication.signInWithGoogle(context: context);
          // await Messaging.subscribeNotifications(user);
          NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
          if (settings.authorizationStatus != AuthorizationStatus.authorized) {
            await FirebaseMessaging.instance.requestPermission();
          }
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            await FirebaseMessaging.instance.getToken().then((token) {
              if (token != null) {
                Messaging.initMessagingManager(user!.uid);
                Messaging.registerDevice(token);
              }
            });
          }
          if (user != null) {
            print('Notificaciones inicializadas.');
            setState(() {});
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: user,
                ),
              ),
            );
          }
        },
        icon: Icon(MdiIcons.google),
        label: Text('ACCEDER'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}