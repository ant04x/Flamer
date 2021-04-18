import 'package:firebase_auth/firebase_auth.dart';
import 'package:flamer/utils/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

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
      floatingActionButton: FutureBuilder(
        future: Authentication.initializeFirebase(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
            scaffoldMessengerKey.currentState!.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Error initializing Firebase'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
                  ),
                )
            );
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return FloatingActionButton.extended(
              backgroundColor: Colors.pink.shade900,
              foregroundColor: Colors.white,
              onPressed: () async {
                await Authentication.signInWithGoogle(context: context);
                setState(() {});
              },
              icon: Icon(MdiIcons.google),
              label: Text('ACCEDER'),
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}