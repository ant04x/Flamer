import 'package:flamer/utils/authentication.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    return FutureBuilder(
      key: scaffoldMessengerKey,
      future: Authentication.accessFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          /*scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Error initializing Firebase'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () => scaffoldMessengerKey.currentState!.hideCurrentSnackBar(),
                ),
              )
          );*/
          print('ERROR ACCEDIENDO A DISPOSITIVO REGISTRADO.');
          return CircularProgressIndicator();
        }
        // SplashScreen
        return Scaffold(
          // key: scaffoldMessengerKey,
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/icon-flamer.png",
                    width: 125,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}