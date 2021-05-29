import 'package:flamer/utils/auth/auth_impl.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Auth.accessFirebase(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}