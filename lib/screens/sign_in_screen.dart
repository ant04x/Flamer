import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/utils/auth/auth_impl.dart';
import 'package:flamer/utils/messaging/messaging_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
      Auth.initializeFirebase(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    ThemeData currentTheme = Theme.of(context);
    Brightness currentBrightness = currentTheme.brightness;
    Messaging().showDialogIfNotSupported(
        context,
        (BuildContext context) {
          return  AlertDialog(
            title: Text('Notifiaciones no soportadas'),
            content: Text('Tu navegador no soporta el estándar notificaciones usado por Flamer. Si quieres diponer de estas, busca en tu tienda de apps la aplicación Flamer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ACEPTAR'),
              ),
            ],
          );
        }
    );
    return Scaffold(
      backgroundColor: currentBrightness == Brightness.light
          ? Colors.white
          : Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 88, left: 32, right: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: Image(image: AssetImage('assets/todo-draw.png')),
                ),
                Flexible(
                  child: AutoSizeText(
                    'Empieza a usar Flamer para que no se te olvide nada de la lista de la compra, del trabajo o de cualquier otra cosa.',
                    style: textTheme.headline6!.copyWith(height: 1.5),
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          User? user;

          await Auth().signInWithGitHub(context: context).then((value) {
            if (value != null) {
              user = value.user;
            }
          });
          // await Messaging.subscribeNotifications(user);
          await Messaging().start(user!.uid);
          if (user != null) {
            print('Notificaciones inicializadas.');
            setState(() {});
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: user!,
                ),
              ),
            );
          }
        },
        icon: Icon(MdiIcons.github),
        label: Text('ACCEDER'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}